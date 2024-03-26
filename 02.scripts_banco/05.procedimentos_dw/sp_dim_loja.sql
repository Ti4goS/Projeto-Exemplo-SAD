create or alter procedure sp_dim_loja(@data_carga datetime)
as
begin
	
end



-- Teste

exec sp_dim_loja '20230321'

select * from dim_loja