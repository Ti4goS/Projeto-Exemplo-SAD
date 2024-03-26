create or alter procedure sp_oltp_loja(@data_carga datetime)
as
begin

end


-- Teste

exec sp_oltp_loja '20230321'

select * from tb_aux_loja
