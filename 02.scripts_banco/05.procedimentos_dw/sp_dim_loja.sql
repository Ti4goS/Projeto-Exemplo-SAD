create or alter procedure sp_dim_loja(@data_carga datetime)
as
begin
	DECLARE @COD_LOJA INT
	DECLARE @LOJA VARCHAR(100)
	DECLARE @CIDADE VARCHAR(100)
	DECLARE @ESTADO VARCHAR(100)
	DECLARE @SIGLA_ESTADO VARCHAR(2)

    DECLARE CUR CURSOR FOR
    SELECT COD_LOJA, LOJA, CIDADE, ESTADO, SIGLA_ESTADO 
    FROM TB_AUX_LOJA 
	WHERE DATA_CARGA = @data_carga;

    OPEN CUR 
    FETCH NEXT FROM CUR INTO @COD_LOJA, @LOJA, @CIDADE, @ESTADO, @SIGLA_ESTADO

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF NOT EXISTS (SELECT * FROM DIM_LOJA WHERE COD_LOJA = @COD_LOJA) AND @COD_LOJA IS NOT NULL
        BEGIN
            INSERT INTO DIM_LOJA (COD_LOJA,LOJA,CIDADE,ESTADO,SIGLA_ESTADO)
            VALUES (@COD_LOJA, @LOJA, @CIDADE, @ESTADO, @SIGLA_ESTADO)
        END
        FETCH NEXT FROM CUR INTO @COD_LOJA, @LOJA, @CIDADE, @ESTADO, @SIGLA_ESTADO
    END
    CLOSE CUR;
    DEALLOCATE CUR;
end


-- Teste

exec sp_dim_loja '20230321'

select * from dim_loja

