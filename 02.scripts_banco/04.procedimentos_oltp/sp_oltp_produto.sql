create or alter procedure sp_oltp_produto(@data_carga datetime)
as
begin

end


-- Teste

exec sp_oltp_produto '20230321'

select * from tb_aux_produto