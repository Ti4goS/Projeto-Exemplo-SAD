create or alter procedure sp_oltp_produto(@data_carga datetime)
as
begin
DELETE FROM TB_AUX_PRODUTO
	WHERE @data_carga = DATA_CARGA

	INSERT INTO TB_AUX_PRODUTO
	SELECT @data_carga, DATA_CARGA,COD_PRODUTO,PRODUTO,COD_CATEGORIA,CATEGORIA 
	FROM TB_PRODUTO
end


-- Teste

exec sp_oltp_produto '20230321'

select * from tb_aux_produto