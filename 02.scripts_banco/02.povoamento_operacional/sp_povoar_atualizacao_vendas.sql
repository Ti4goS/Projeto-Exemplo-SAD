create or alter procedure sp_povoar_atualizacao_vendas (@dt_inicial datetime, @dt_final datetime)
as
begin
    set nocount on
    declare @max_vendas_combustivel int = 50, 
	        @min_vendas_combustivel int = 30,
	        @max_vendas_lubrificante int = 25,
			@min_vendas_lubrificante int = 10,
			@total_vendas_dia_combustivel int,
			@total_vendas_dia_lubrificantes int,
			@contador_vendas int = 0,
			@semente float
			
    select @semente = rand(10)
	while (@dt_inicial < @dt_final)
	begin
	   
	   set @total_vendas_dia_combustivel = 
	               (select dbo.fn_aleatorio(rand(), @max_vendas_combustivel,@min_vendas_combustivel))
	   set @contador_vendas = 0
	   print 'total venda gasolina:' + str(@total_vendas_dia_combustivel)
	   while (@contador_vendas < @total_vendas_dia_combustivel)
	      begin
		     exec sp_insert_venda_produto @dt_inicial, 'GASOLINA'
		     set @contador_vendas = @contador_vendas + 1
		  end
	   
	   set @total_vendas_dia_combustivel = 
	               (select dbo.fn_aleatorio(rand(), @max_vendas_combustivel,@min_vendas_combustivel))
	   set @contador_vendas = 0
	   print 'total venda etanol:' + str(@total_vendas_dia_combustivel)
	   while (@contador_vendas < @total_vendas_dia_combustivel)
	      begin
		     exec sp_insert_venda_produto @dt_inicial, 'ETANOL'
		     set @contador_vendas = @contador_vendas + 1
		  end

	   set @total_vendas_dia_combustivel = 
	               (select dbo.fn_aleatorio(rand(), @max_vendas_combustivel,@min_vendas_combustivel))
	   set @contador_vendas = 0
	   print 'total venda diesel:' + str(@total_vendas_dia_combustivel)
	   while (@contador_vendas < @total_vendas_dia_combustivel)
	      begin
		     exec sp_insert_venda_produto @dt_inicial, 'DIESEL'
		     set @contador_vendas = @contador_vendas + 1
		  end


	   set @total_vendas_dia_lubrificantes = 
	                      (select dbo.fn_aleatorio(rand(), @max_vendas_lubrificante,@min_vendas_lubrificante))
	   set @contador_vendas = 0
	   print 'total venda lubrificante:' + str(@total_vendas_dia_lubrificantes)
	   while (@contador_vendas < @total_vendas_dia_lubrificantes)
	      begin
		     exec sp_insert_venda_produto @dt_inicial, 'LUBRIFICANTE'
		     set @contador_vendas = @contador_vendas + 1
		  end
	   
	   set @dt_inicial = @dt_inicial + 1
	end 
end

exec sp_povoar_atualizacao_vendas '20230101', '20230701'