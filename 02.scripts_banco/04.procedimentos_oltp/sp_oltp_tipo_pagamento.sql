create or alter procedure sp_oltp_tipo_pagamento(@data_carga datetime)
as
begin

end



-- Teste

exec sp_oltp_tipo_pagamento '20230321'

select * from tb_aux_tipo_pagamento