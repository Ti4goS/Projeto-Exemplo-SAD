-- Script para povoar a dimensão tempo

create or alter procedure sp_dim_tempo (@dt_inicial datetime, @dt_final datetime)
as
begin
    set nocount on
    set language brazilian
    while (@dt_inicial < @dt_final)
	begin
	   if exists (select 1 from dim_tempo 
	              where data = @dt_inicial)
		   continue
	   insert into dim_tempo
	   select 
	         data = @dt_inicial,
			 dia = datepart(dd,@dt_inicial),
			 dia_semana = datename(dw,@dt_inicial),
			 fim_semana = case 
			    when datepart(dw,@dt_inicial) in (1,7) THEN 'SIM'
			    else 'NAO'
			 end,
			 mes = datepart(mm,@dt_inicial),
			 nome_mes = datename(Month,@dt_inicial),
			 trimestre = datepart(qq, @dt_inicial),
			 nome_trimestre = trim(str(datepart(qq,@dt_inicial))) + 'º Trimestre/' +
                              trim(str(datepart(yy,@dt_inicial))),
			 semestre = case 
			            when datepart(mm,@dt_inicial) <=6 THEN 1
				          else 2
			            end,
			 nome_semestre = case
			                  when datepart(mm,@dt_inicial) <=6 THEN
				                   '1º Semestre/' +  trim(str(datepart(yy,@dt_inicial)))
				              else '2º Semestre/' +  trim(str(datepart(yy,@dt_inicial)))
			                  end,
			 ano = datepart(yy,@dt_inicial)
			 
			 set @dt_inicial = @dt_inicial + 1
	end
end

-- Testes

-- truncate table dim_tempo

exec sp_dim_tempo '20230101', '20230701'

select * from dim_tempo