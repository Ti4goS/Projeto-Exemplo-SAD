create or alter procedure sp_fato_venda(@data_carga datetime)
as
begin
	DECLARE @DATA_VENDA DATETIME 
	DECLARE @COD_LOJA INT
	DECLARE @COD_PRODUTO INT
	DECLARE @COD_TIPO_PAGAMENTO INT
	DECLARE @COD_VENDA INT
	DECLARE @VOLUME NUMERIC(10,2)
	DECLARE @VALOR NUMERIC(10,2)

	DECLARE @ID_TEMPO BIGINT
	DECLARE @ID_LOJA INT
	DECLARE @ID_PRODUTO INT
	DECLARE @ID_TIPO_PAGAMENTO INT
    DECLARE @ID_VIO_VENDA INT


    DECLARE CUR CURSOR FOR
    SELECT DATA_VENDA, COD_LOJA,COD_PRODUTO,COD_TIPO_PAGAMENTO,COD_VENDA,VOLUME,VALOR
    FROM TB_AUX_VENDA
    WHERE DATA_CARGA = @data_carga

    OPEN CUR
    FETCH NEXT FROM CUR INTO @DATA_VENDA, @COD_LOJA, @COD_PRODUTO, @COD_TIPO_PAGAMENTO, @COD_VENDA, @VOLUME, @VALOR

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @ID_TEMPO = NULL
        SET @ID_LOJA = NULL
        SET @ID_PRODUTO = NULL
        SET @ID_TIPO_PAGAMENTO = NULL
        SET @ID_VIO_VENDA = NULL

        SELECT @ID_TEMPO = ID_TEMPO 
		FROM DIM_TEMPO 
		WHERE DATA = @DATA_VENDA AND NIVEL = 'DIA'

        IF @ID_TEMPO IS NULL
        BEGIN
            INSERT INTO TB_VIO_VENDA (DATA_CARGA,DATA_VENDA,COD_LOJA,COD_PRODUTO,COD_TIPO_PAGAMENTO,COD_VENDA,VOLUME,VALOR,DT_ERRO, VIOLACAO)
            VALUES (@data_carga, @DATA_VENDA, @COD_LOJA, @COD_PRODUTO, @COD_TIPO_PAGAMENTO, @COD_VENDA, @VOLUME, @VALOR, GETDATE(), 'DATA INVÁLIDA')
        END


        SELECT @ID_LOJA = ID_LOJA
        FROM DIM_LOJA
        WHERE COD_LOJA = @COD_LOJA

        IF @ID_LOJA IS NULL
        BEGIN
            IF EXISTS (SELECT * FROM TB_VIO_VENDA WHERE COD_VENDA = @COD_VENDA) AND @COD_VENDA IS NOT NULL
            BEGIN
                SELECT 
                    @ID_VIO_VENDA = ID_VIOLACAO 
                FROM 
                    TB_VIO_VENDA 
                WHERE 
                    COD_VENDA = @COD_VENDA

                UPDATE
                    TB_VIO_VENDA
                SET 
                    VIOLACAO = VIOLACAO + ', LOJA INVÁLIDA'
                WHERE
                    ID_VIOLACAO = @ID_VIO_VENDA
            END
            ELSE
            BEGIN
                INSERT INTO TB_VIO_VENDA (DATA_CARGA,DATA_VENDA,COD_LOJA,COD_PRODUTO,COD_TIPO_PAGAMENTO,COD_VENDA,VOLUME,VALOR,DT_ERRO, VIOLACAO)
                VALUES (@data_carga, @DATA_VENDA, @COD_LOJA, @COD_PRODUTO, @COD_TIPO_PAGAMENTO, @COD_VENDA, @VOLUME, @VALOR, GETDATE(), 'LOJA INVÁLIDA')
            END
        END


        SELECT @ID_PRODUTO = ID_PRODUTO
        FROM DIM_PRODUTO
        WHERE COD_PRODUTO = @COD_PRODUTO

        IF @ID_PRODUTO IS NULL
        BEGIN
            IF EXISTS (SELECT * FROM TB_VIO_VENDA WHERE COD_VENDA = @COD_VENDA) AND @COD_VENDA IS NOT NULL
            BEGIN
                SELECT 
                    @ID_VIO_VENDA = ID_VIOLACAO 
                FROM 
                    TB_VIO_VENDA 
                WHERE 
                    COD_VENDA = @COD_VENDA

                UPDATE 
                    TB_VIO_VENDA
                SET 
                    VIOLACAO = VIOLACAO + ', PRODUTO INVÁLIDO'
                WHERE
                    ID_VIOLACAO = @ID_VIO_VENDA
            END
            ELSE
            BEGIN
                INSERT INTO TB_VIO_VENDA (DATA_CARGA,DATA_VENDA,COD_LOJA,COD_PRODUTO,COD_TIPO_PAGAMENTO,COD_VENDA,VOLUME,VALOR,DT_ERRO, VIOLACAO)
                VALUES (@data_carga, @DATA_VENDA, @COD_LOJA, @COD_PRODUTO, @COD_TIPO_PAGAMENTO, @COD_VENDA, @VOLUME, @VALOR, GETDATE(), 'PRODUTO INVÁLIDO')
            END
        END


        SELECT @ID_TIPO_PAGAMENTO = ID_TIPO_PAGAMENTO
        FROM DIM_TIPO_PAGAMENTO
        WHERE COD_TIPO_PAGAMENTO = @COD_TIPO_PAGAMENTO

        IF @ID_TIPO_PAGAMENTO IS NULL
        BEGIN
            IF EXISTS (SELECT * FROM TB_VIO_VENDA WHERE COD_VENDA = @COD_VENDA) AND @COD_VENDA IS NOT NULL
            BEGIN
                SELECT 
                    @ID_VIO_VENDA = ID_VIOLACAO 
                FROM 
                    TB_VIO_VENDA 
                WHERE 
                    COD_VENDA = @COD_VENDA

                UPDATE
                    TB_VIO_VENDA
                SET 
                    VIOLACAO = VIOLACAO + ', TIPO DE PAGAMENTO INVÁLIDO'
                WHERE
                    ID_VIOLACAO = @ID_VIO_VENDA
            END
            ELSE
            BEGIN
                INSERT INTO TB_VIO_VENDA (DATA_CARGA,DATA_VENDA,COD_LOJA,COD_PRODUTO,COD_TIPO_PAGAMENTO,COD_VENDA,VOLUME,VALOR,DT_ERRO, VIOLACAO)
                VALUES (@data_carga, @DATA_VENDA, @COD_LOJA, @COD_PRODUTO, @COD_TIPO_PAGAMENTO, @COD_VENDA, @VOLUME, @VALOR, GETDATE(), 'TIPO DE PAGAMENTO INVÁLIDO')
            END
        END


        IF EXISTS (SELECT * FROM FATO_VENDA WHERE COD_VENDA = @COD_VENDA) AND @COD_VENDA IS NOT NULL
        BEGIN
            UPDATE FATO_VENDA
            SET 
                ID_TEMPO = @ID_TEMPO,
                ID_LOJA = @ID_LOJA,
                ID_PRODUTO = @ID_PRODUTO,
                ID_TIPO_PAGAMENTO = @ID_TIPO_PAGAMENTO,
                COD_VENDA = @COD_VENDA,
                VOLUME = @VOLUME,
                VALOR = @VALOR
            WHERE
                COD_VENDA = @COD_VENDA
        END
        ELSE
        BEGIN
            INSERT INTO FATO_VENDA (ID_TEMPO,ID_LOJA,ID_PRODUTO,ID_TIPO_PAGAMENTO,COD_VENDA,VOLUME,VALOR,QUANTIDADE)
            VALUES (@ID_TEMPO, @ID_LOJA, @ID_PRODUTO, @ID_TIPO_PAGAMENTO,@COD_VENDA,@VOLUME,@VALOR,1)
        END
        
        FETCH NEXT FROM CUR INTO @DATA_VENDA, @COD_LOJA, @COD_PRODUTO, @COD_TIPO_PAGAMENTO, @COD_VENDA, @VOLUME, @VALOR
    END

    CLOSE CUR
    DEALLOCATE CUR
    
end

exec sp_fato_venda '20240321'

select * from FATO_VENDA

select * from TB_VIO_VENDA

--DELETE FROM TB_VIO_VENDA
