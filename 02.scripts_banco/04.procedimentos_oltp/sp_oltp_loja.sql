create or alter procedure sp_oltp_loja(@data_carga datetime)
as
begin
	DELETE FROM TB_AUX_LOJA
	WHERE @data_carga = DATA_CARGA

	INSERT INTO TB_AUX_LOJA
	SELECT @data_carga, COD_LOJA ,LOJA ,CIDADE ,ESTADO ,SIGLA_ESTADO 
	FROM TB_LOJA
end

EXEC sp_oltp_loja '20240324'

SELECT * FROM TB_AUX_LOJA