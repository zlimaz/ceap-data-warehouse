-- Script DDL.sql
-- Estrutura: Star Schema (1 Fato, 6 Dimensões)
-- Padrão de Mnemônicos: 3 letras (dw, fat, dim, srk, cod, nom...)

-- Criação do Schema
CREATE SCHEMA IF NOT EXISTS dw;

-- Criação das tabelas dimensão

-- Dimensão tempo (Calendário)
DROP TABLE IF EXISTS dw.dim_tmp CASCADE;
CREATE TABLE dw.dim_tmp (
    srk_tmp BIGSERIAL PRIMARY KEY,    
    dat_cmp DATE UNIQUE,             
    num_ano INT,                      
    num_mes INT,                      
    nom_mes VARCHAR(20),              
    num_dia INT,                     
    num_tri INT,                     
    num_sem INT                       
);

-- Dimensão Localização (Estado e Região)
DROP TABLE IF EXISTS dw.dim_loc CASCADE;
CREATE TABLE dw.dim_loc (
    srk_loc BIGSERIAL PRIMARY KEY,
    sgl_est CHAR(2),                  
    nom_reg VARCHAR(50)               
);

-- Dimensão Partido (Agremiação Política)
DROP TABLE IF EXISTS dw.dim_prt CASCADE;
CREATE TABLE dw.dim_prt (
    srk_prt BIGSERIAL PRIMARY KEY,
    sgl_prt VARCHAR(50),             
    nom_prt VARCHAR(255),             
    dat_cri DATE                     
);

-- Dimensão Categoria (Tipo de Despesa Unificada)
DROP TABLE IF EXISTS dw.dim_cat CASCADE;
CREATE TABLE dw.dim_cat (
    srk_cat BIGSERIAL PRIMARY KEY,
    nom_cat VARCHAR(255)              
);

-- Dimensão Fornecedor (Quem recebeu)
DROP TABLE IF EXISTS dw.dim_frn CASCADE;
CREATE TABLE dw.dim_frn (
    srk_frn BIGSERIAL PRIMARY KEY,
    cod_doc VARCHAR(50),              -- CNPJ ou CPF (Business Key)
    nom_frn VARCHAR(255)             
);

-- Dimensão Deputado (Dados Pessoais)
DROP TABLE IF EXISTS dw.dim_dpt CASCADE;
CREATE TABLE dw.dim_dpt (
    srk_dpt BIGSERIAL PRIMARY KEY,
    cod_ide INT,                      
    nom_par VARCHAR(255),             
    num_leg VARCHAR(50)             
);

-- Criação Tabela Fato
-- 

-- Fato Reembolso (Métricas)
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
    vlr_liq NUMERIC(12, 2),          
    cod_doc VARCHAR(100)              
);

-- índices (Para o Power BI)

CREATE INDEX idx_fat_dpt ON dw.fat_rmb(srk_dpt);
CREATE INDEX idx_fat_tmp ON dw.fat_rmb(srk_tmp);
CREATE INDEX idx_fat_cat ON dw.fat_rmb(srk_cat);
CREATE INDEX idx_fat_loc ON dw.fat_rmb(srk_loc);
CREATE INDEX idx_fat_prt ON dw.fat_rmb(srk_prt);