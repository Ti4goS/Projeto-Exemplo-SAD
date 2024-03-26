create or alter procedure sp_dim_produto(@data_carga datetime)
as
begin
   
end


-- Teste

exec sp_dim_produto '20230321'

select * from dim_produto