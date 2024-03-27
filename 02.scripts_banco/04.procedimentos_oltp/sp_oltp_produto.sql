create or alter procedure sp_oltp_produto(@data_carga datetime)
as
begin
	DELETE FROM TB_AUX_PRODUTO
	WHERE @data_carga = DATA_CARGA

	INSERT INTO TB_AUX_PRODUTO
	SELECT 
		@data_carga,
		p.COD_PRODUTO,
		p.PRODUTO,
		p.COD_CATEGORIA,
		c.CATEGORIA 
	FROM 
		TB_PRODUTO p
	INNER JOIN
		TB_CATEGORIA c ON p.COD_CATEGORIA = c.COD_CATEGORIA 
end


-- Teste

exec sp_oltp_produto '20240324'

select * from tb_aux_produto