create or alter procedure sp_fato_venda(@data_carga datetime)
as
begin

end



-- Teste

exec sp_fato_venda '20230321'

select * from fato_venda