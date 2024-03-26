create or alter procedure sp_oltp_venda(@data_carga datetime, @data_inicial datetime, @data_final datetime)
as
begin

end



-- Teste

exec sp_oltp_venda '20230321', '20230101', '20230701'

select * from tb_aux_venda