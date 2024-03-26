create or alter procedure sp_oltp_tipo_pagamento(@data_carga datetime)
as
begin
DELETE FROM TB_AUX_TIPO_PAGAMENTO
	WHERE @data_carga = DATA_CARGA

	INSERT INTO TB_AUX_TIPO_PAGAMENTO
	SELECT @data_carga, COD_TIPO_PAGAMENTO,TIPO_PAGAMENTO
	FROM TB_TIPO_PAGAMENTO
end



-- Teste

exec sp_oltp_tipo_pagamento '20230321'

select * from tb_aux_tipo_pagamento