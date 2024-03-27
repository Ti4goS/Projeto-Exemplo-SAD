create or alter procedure sp_oltp_venda(@data_carga datetime, @data_inicial datetime, @data_final datetime)
as
begin
    DELETE FROM TB_AUX_VENDA
    WHERE @data_carga = DATA_CARGA;

    INSERT INTO TB_AUX_VENDA 
    SELECT 
        @data_carga, 
        DATA_VENDA, 
        COD_LOJA, 
        COD_PRODUTO, 
        COD_TIPO_PAGAMENTO, 
        COD_VENDA, 
        VOLUME, 
        VALOR
    FROM 
        TB_VENDA
    WHERE 
        DATA_VENDA BETWEEN @data_inicial AND @data_final;
end



-- Teste

exec sp_oltp_venda '20230321', '20240101', '20240327'

select * from tb_aux_venda