create or alter procedure sp_dim_tipo_pagamento(@data_carga datetime)
as
begin
	
end



-- Teste

exec sp_dim_tipo_pagamento '20230321'

select * from dim_tipo_pagamento