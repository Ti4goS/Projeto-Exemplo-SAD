create or alter procedure sp_oltp_loja(@data_carga datetime)
as
begin
	DELETE FROM TB_AUX_LOJA
	WHERE @data_carga = DATA_CARGA

	INSERT INTO TB_AUX_LOJA
	SELECT 
		@data_carga, 
		j.COD_LOJA, 
		j.NM_LOJA,
		c.CIDADE, 
		e.ESTADO,
		e.SIGLA 
	FROM 
		TB_LOJA j
	INNER JOIN 
		TB_CIDADE c ON j.COD_CIDADE = c.COD_CIDADE
	INNER JOIN 
		TB_ESTADO e ON c.COD_ESTADO = e.COD_ESTADO 
	
end

EXEC sp_oltp_loja '20240324'

SELECT * FROM TB_AUX_LOJA