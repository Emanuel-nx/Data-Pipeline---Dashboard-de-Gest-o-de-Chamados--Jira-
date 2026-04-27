/* PROJETO: DASHBOARD OPERACIONAL JIRA
   OBJETIVO: CRIAÇÃO DA ESTRUTURA DE BANCO DE DADOS (ELT)
*/

CREATE DATABASE IF NOT EXISTS analise_suporte;
USE analise_suporte;

-- ======================================================
-- PASSO 1: CRIAÇÃO DA TABELA DE ESTÁGIO (STAGING)
-- ======================================================
-- Usamos VARCHAR para todas as datas para evitar erros de importação
-- causados pelo formato ISO (com 'T' e offset '-0300') do Jira.

DROP TABLE IF EXISTS stg_tickets_jira;

CREATE TABLE stg_tickets_jira (
    TIPO_ITEM VARCHAR(255),
    CHAVE VARCHAR(50) PRIMARY KEY,
    TITULO TEXT,
    PROJETO VARCHAR(255),
    TIPO_DE_SOLICITACAO VARCHAR(255),
    CATEGORIA VARCHAR(255),
    PRIORIDADE VARCHAR(50),
    APP VARCHAR(255),
    RESPONSAVEL VARCHAR(255),
    RELATOR VARCHAR(255),
    STATUS VARCHAR(50),
    RESOLUCAO VARCHAR(50),
    SATISFACAO_DO_CLIENTE VARCHAR(50),
    CRIADO VARCHAR(100),              -- Ex: 2026-04-24T07:46:57-0300
    TIME_UPDATED VARCHAR(100),
    RESOLVIDO VARCHAR(100),           -- Ex: 2026-04-25T10:00:00-0300
    TEMPO_ATE_RESOLUCAO VARCHAR(100),
    ULTIMO_STATUS_ORIGEM VARCHAR(100),
    ULTIMO_STATUS_DESTINO VARCHAR(100),
    DATA_TRANSICAO_STATUS VARCHAR(100),
    HISTORICO_STATUS TEXT
);

-- ======================================================
-- PASSO 2: CRIAÇÃO DA VIEW DE NEGÓCIO (TRANSFORMAÇÃO)
-- ======================================================
-- Aqui aplicamos a lógica de limpeza:
-- 1. REPLACE: Troca o 'T' por espaço.
-- 2. LEFT: Pega os primeiros 19 caracteres (ignora o fuso horário -0300).
-- 3. STR_TO_DATE: Converte o texto resultante em DATETIME real.

CREATE OR REPLACE VIEW v_tickets_limpos AS
SELECT 
    TIPO_ITEM,
    CHAVE,
    TITULO,
    PROJETO,
    TIPO_DE_SOLICITACAO,
    CATEGORIA,
    PRIORIDADE,
    APP,
    RESPONSAVEL,
    RELATOR,
    STATUS,
    RESOLUCAO,
    SATISFACAO_DO_CLIENTE,
    -- 1. Data de Criação
    STR_TO_DATE(LEFT(REPLACE(NULLIF(TRIM(CRIADO), ''), 'T', ' '), 19), '%Y-%m-%d %H:%i:%s') AS DATA_CRIACAO,
    
    -- 2. Data de Resolução
    STR_TO_DATE(LEFT(REPLACE(NULLIF(TRIM(RESOLVIDO), ''), 'T', ' '), 19), '%Y-%m-%d %H:%i:%s') AS DATA_RESOLUCAO,
    
    -- 3. Data de Transição (Adicionada a vírgula aqui)
    STR_TO_DATE(LEFT(REPLACE(NULLIF(TRIM(DATA_TRANSICAO_STATUS), ''), 'T', ' '), 19), '%Y-%m-%d %H:%i:%s') AS DATA_TRANSICAO_DE_STATUS,
    
    -- 4. Cálculo de horas (Adicionada a vírgula aqui)
    TIMESTAMPDIFF(HOUR, 
        STR_TO_DATE(LEFT(REPLACE(NULLIF(TRIM(CRIADO), ''), 'T', ' '), 19), '%Y-%m-%d %H:%i:%s'),
        STR_TO_DATE(LEFT(REPLACE(NULLIF(TRIM(RESOLVIDO), ''), 'T', ' '), 19), '%Y-%m-%d %H:%i:%s')
    ) AS HORAS_PARA_RESOLVER,
    
    -- 5. Demais colunas (Vírgula antes de TEMPO_ATE_RESOLUCAO)
    TEMPO_ATE_RESOLUCAO,
    ULTIMO_STATUS_ORIGEM,
    ULTIMO_STATUS_DESTINO,
    HISTORICO_STATUS
FROM stg_tickets_jira;
