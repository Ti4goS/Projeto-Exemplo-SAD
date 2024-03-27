-- Script para povoar a dimensão tempo
CREATE OR ALTER PROCEDURE SP_DIM_TEMPO
@dt_inicial DATE,
@dt_final DATE
AS
BEGIN
	DECLARE @NIVEL VARCHAR(8), @DIA_SEMANA VARCHAR(50), @FIM_SEMANA VARCHAR(3), @NOME_MES VARCHAR(100), @TRIMESTRE DECIMAL(10,2), @NOME_TRIMESTRE VARCHAR(100), @SEMESTRE DECIMAL(10,2), @NOME_SEMESTRE VARCHAR(100)

	WHILE (@dt_inicial != @dt_final)
	BEGIN
		-- NOME DO DIA DA SEMANA
		SET @DIA_SEMANA = DATENAME(dw, @dt_inicial)

		-- SE É UM FIM DE SEMANA OU NÃO
		IF @DIA_SEMANA = 'Sexta-Feira' or @DIA_SEMANA = 'Sábado' or @DIA_SEMANA = 'Domingo'
		BEGIN
			SET @FIM_SEMANA = 'SIM'
		END
		ELSE
		BEGIN
			SET @FIM_SEMANA = 'NAO'
		END

		-- NOME DO MÊS
		SET @NOME_MES = DATENAME(MONTH, @dt_inicial)

		-- NÚMERO DO TRIMESTRE
		SET @TRIMESTRE = MONTH(@dt_inicial)
		SET @TRIMESTRE = CEILING(@TRIMESTRE / 3)

		-- NOME DO TRIMESTRE
		IF @TRIMESTRE = 1
		BEGIN
			SET @NOME_TRIMESTRE = 'Primeiro'
		END

		ELSE IF @TRIMESTRE = 2
		BEGIN
			SET @NOME_TRIMESTRE = 'Segundo'
		END

		ELSE IF @TRIMESTRE = 3
		BEGIN
			SET @NOME_TRIMESTRE = 'Terceiro'
		END

		ELSE IF @TRIMESTRE = 4
		BEGIN
			SET @NOME_TRIMESTRE = 'Quarto'
		END

		-- NÚMERO DO SEMESTRE
		SET @SEMESTRE = MONTH(@dt_inicial)
		SET @SEMESTRE = CEILING(@SEMESTRE / 6)

		-- NOME DO SEMESTRE
		IF @SEMESTRE = 1
		BEGIN
			SET @NOME_SEMESTRE = 'Primeiro'
		END

		ELSE IF @SEMESTRE = 2
		BEGIN
			SET @NOME_SEMESTRE = 'Segundo'
		END

		INSERT INTO DIM_TEMPO VALUES ('DIA', @dt_inicial, DAY(@dt_inicial), @DIA_SEMANA, NULL, NULL, 'NAO', MONTH(@dt_inicial), @NOME_MES, @TRIMESTRE, @NOME_TRIMESTRE, @SEMESTRE, @NOME_SEMESTRE, YEAR(@dt_inicial))

		SET @dt_inicial = DATEADD(DAY, 1, @dt_inicial)
	END
END
-- Testes

-- truncate table dim_tempo

exec sp_dim_tempo '20230101', '20230701'

select * from dim_tempo