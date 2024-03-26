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

    DECLARE CUR CURSOR FOR
    SELECT DATA_VENDA, COD_LOJA,COD_PRODUTO,COD_TIPO_PAGAMENTO,COD_VENDA,VOLUME,VALOR
    FROM TB_AUX_VENDA
    WHERE DATA_CARGA = @data_carga

    OPEN CUR
    FETCH NEXT CUR INTO @DATA_VENDA, @COD_LOJA, @COD_PRODUTO, @COD_TIPO_PAGAMENTO, @COD_VENDA, @VOLUME, @VALOR

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @ID_TEMPO = NULL
        SET @ID_LOJA = NULL
        SET @ID_PRODUTO = NULL
        SET @ID_TIPO_PAGAMENTO = NULL

        SELECT @ID_TEMPO = ID_TEMPO 
		FROM DIM_TEMPO 
		WHERE DATA = @DATA_VENDA

        SELECT @ID_LOJA = ID_LOJA
        FROM DIM_LOJA
        WHERE COD_LOJA = @COD_LOJA

        SELECT @ID_PRODUTO = ID_PRODUTO
        FROM DIM_PRODUTO
        WHERE COD_PRODUTO = @COD_PRODUTO

        SELECT @ID_TIPO_PAGAMENTO = ID_TIPO_PAGAMENTO
        FROM DIM_TIPO_PAGAMENTO
        WHERE COD_TIPO_PAGAMENTO = @COD_TIPO_PAGAMENTO

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
        
        FETCH NEXT CUR INTO @DATA_VENDA, @COD_LOJA, @COD_PRODUTO, @COD_TIPO_PAGAMENTO, @COD_VENDA, @VOLUME, @VALOR
    END
    CLOSE CUR
    DEALLOCATE CUR
end