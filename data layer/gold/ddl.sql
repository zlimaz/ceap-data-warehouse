-- ============================================================================
-- SCRIPT DDL - CRIAÇÃO DO DATA WAREHOUSE (SCHEMA DW) - PROJETO CEAP
-- Estrutura: Star Schema (1 Fato, 6 Dimensões)
-- Padrão de Mnemônicos: 3 letras (dw, fat, dim, srk, cod, nom...)
-- ============================================================================

-- 1. Criação do Schema
CREATE SCHEMA IF NOT EXISTS dw;

-- ============================================================================
-- 2. CRIAÇÃO DAS TABELAS DIMENSÃO
-- ============================================================================

-- 2.1 DIMENSÃO TEMPO (Calendário)
DROP TABLE IF EXISTS dw.dim_tmp CASCADE;
CREATE TABLE dw.dim_tmp (
    srk_tmp BIGSERIAL PRIMARY KEY,    -- Chave Surrogada Sequencial
    dat_cmp DATE UNIQUE,              -- Data Completa (Business Key)
    num_ano INT,                      -- Ano
    num_mes INT,                      -- Mês (1-12)
    nom_mes VARCHAR(20),              -- Nome do Mês
    num_dia INT,                      -- Dia
    num_tri INT,                      -- Trimestre
    num_sem INT                       -- Semestre
);

-- 2.2 DIMENSÃO LOCALIZAÇÃO (Estado e Região)
DROP TABLE IF EXISTS dw.dim_loc CASCADE;
CREATE TABLE dw.dim_loc (
    srk_loc BIGSERIAL PRIMARY KEY,
    sgl_est CHAR(2),                  -- Sigla do Estado (SP, DF...)
    nom_reg VARCHAR(50)               -- Região (Norte, Sudeste...) - COLUNA NOVA!
);

-- 2.3 DIMENSÃO PARTIDO (Agremiação Política)
DROP TABLE IF EXISTS dw.dim_prt CASCADE;
CREATE TABLE dw.dim_prt (
    srk_prt BIGSERIAL PRIMARY KEY,
    sgl_prt VARCHAR(20),              -- Sigla (PT, PL...)
    nom_prt VARCHAR(255),             -- Nome Completo do Partido
    dat_cri DATE                      -- Data de Criação (Enriquecimento)
);

-- 2.4 DIMENSÃO CATEGORIA (Tipo de Despesa Unificada)
DROP TABLE IF EXISTS dw.dim_cat CASCADE;
CREATE TABLE dw.dim_cat (
    srk_cat BIGSERIAL PRIMARY KEY,
    nom_cat VARCHAR(255)              -- Nome já limpo (Taxi, Combustível)
);

-- 2.5 DIMENSÃO FORNECEDOR (Quem recebeu)
DROP TABLE IF EXISTS dw.dim_frn CASCADE;
CREATE TABLE dw.dim_frn (
    srk_frn BIGSERIAL PRIMARY KEY,
    cod_doc VARCHAR(50),              -- CNPJ ou CPF (Business Key)
    nom_frn VARCHAR(255)              -- Nome do Estabelecimento
);

-- 2.6 DIMENSÃO DEPUTADO (Dados Pessoais)
DROP TABLE IF EXISTS dw.dim_dpt CASCADE;
CREATE TABLE dw.dim_dpt (
    srk_dpt BIGSERIAL PRIMARY KEY,
    cod_ide INT,                      -- ID Original do CEAP
    nom_par VARCHAR(255),             -- Nome do Parlamentar
    num_leg VARCHAR(50)               -- Carteira Funcional / Legislatura
);

-- ============================================================================
-- 3. CRIAÇÃO DA TABELA FATO
-- ============================================================================

-- 3.1 FATO REEMBOLSO (Métricas)
DROP TABLE IF EXISTS dw.fat_rmb CASCADE;
CREATE TABLE dw.fat_rmb (
    srk_rmb BIGSERIAL PRIMARY KEY,
    
    -- Chaves Estrangeiras para as 6 Dimensões
    srk_tmp INT REFERENCES dw.dim_tmp(srk_tmp),
    srk_dpt INT REFERENCES dw.dim_dpt(srk_dpt),
    srk_prt INT REFERENCES dw.dim_prt(srk_prt),
    srk_loc INT REFERENCES dw.dim_loc(srk_loc),
    srk_cat INT REFERENCES dw.dim_cat(srk_cat),
    srk_frn INT REFERENCES dw.dim_frn(srk_frn),
    
    -- Métricas e Degenerate Dimensions
    vlr_liq NUMERIC(12, 2),           -- Valor do Reembolso
    cod_doc VARCHAR(100)              -- Número da Nota Fiscal (Degenerate Dim)
);

-- ============================================================================
-- 4. ÍNDICES (Para performance no Power BI)
-- ============================================================================
CREATE INDEX idx_fat_dpt ON dw.fat_rmb(srk_dpt);
CREATE INDEX idx_fat_tmp ON dw.fat_rmb(srk_tmp);
CREATE INDEX idx_fat_cat ON dw.fat_rmb(srk_cat);
CREATE INDEX idx_fat_loc ON dw.fat_rmb(srk_loc);
CREATE INDEX idx_fat_prt ON dw.fat_rmb(srk_prt);