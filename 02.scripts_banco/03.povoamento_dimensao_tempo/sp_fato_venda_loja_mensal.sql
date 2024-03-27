CREATE PROCEDURE sp_fato_venda_loja_mensal
AS
BEGIN
    BEGIN TRY
        -- Dropa a tabela se existir
        IF OBJECT_ID('FATO_VENDA_LOJA_MENSAL', 'U') IS NOT NULL
            DROP TABLE FATO_VENDA_LOJA_MENSAL;

        -- criando novamente a tabela
        CREATE TABLE FATO_VENDA_LOJA_MENSAL (
            ID_TEMPO    BIGINT          NOT NULL,
            ID_LOJA     INT             NOT NULL,
            VOLUME      NUMERIC(10,2)   NOT NULL,
            VALOR       NUMERIC(10,2)   NOT NULL,
            QUANTIDADE  INT             NOT NULL,
            CONSTRAINT FK_DIM_LOJA FOREIGN KEY (ID_LOJA) REFERENCES DIM_LOJA (ID_LOJA),
            CONSTRAINT FK_TEMPO FOREIGN KEY (ID_TEMPO) REFERENCES DIM_TEMPO (ID_TEMPO)
        );

        -- Inserir dados na tabela agregada
        INSERT INTO FATO_VENDA_LOJA_MENSAL (ID_TEMPO, ID_LOJA, VOLUME, VALOR, QUANTIDADE)
        SELECT
            t.ID_TEMPO,
            v.ID_LOJA,
            SUM(v.volume) AS VOLUME,
            SUM(v.valor) AS VALOR,
            SUM(v.quantidade) AS QUANTIDADE
        FROM
            VENDA v
        INNER JOIN
            DIM_TEMPO t ON v.data_venda = t.DATA
        GROUP BY
            t.ID_TEMPO,
            v.ID_LOJA;
        
        PRINT 'Carga concluída com sucesso.';
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH
END;
