create or alter procedure sp_dim_tipo_pagamento(@data_carga datetime)
as
begin
    DECLARE @COD_TIPO_PAGAMENTO INT
    DECLARE @TIPO_PAGAMENTO VARCHAR(100)

    DECLARE CUR CURSOR FOR
    SELECT COD_TIPO_PAGAMENTO, TIPO_PAGAMENTO
    FROM TB_AUX_TIPO_PAGAMENTO 
	WHERE DATA_CARGA = @data_carga;

    OPEN CUR 
    FETCH NEXT FROM CUR INTO @COD_TIPO_PAGAMENTO, @TIPO_PAGAMENTO

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF NOT EXISTS (SELECT * FROM DIM_TIPO_PAGAMENTO WHERE COD_TIPO_PAGAMENTO = @COD_TIPO_PAGAMENTO) AND @COD_TIPO_PAGAMENTO IS NOT NULL
        BEGIN
            INSERT INTO DIM_TIPO_PAGAMENTO (COD_TIPO_PAGAMENTO,TIPO_PAGAMENTO)
            VALUES (@COD_TIPO_PAGAMENTO, @TIPO_PAGAMENTO)
        END
        FETCH NEXT FROM CUR INTO @COD_TIPO_PAGAMENTO, @TIPO_PAGAMENTO
    END
    
    CLOSE CUR;
    DEALLOCATE CUR;
end



-- Teste

exec sp_dim_tipo_pagamento '20240324'

select * from dim_tipo_pagamento