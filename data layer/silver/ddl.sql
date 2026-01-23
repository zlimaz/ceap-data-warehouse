CREATE SCHEMA IF NOT EXISTS silver;

DROP TABLE IF EXISTS silver.tb_reembolso;

CREATE TABLE silver.tb_reembolso (
  silver_id BIGSERIAL PRIMARY KEY,
  receipt_date DATE NOT NULL,
  deputy_id INT,
  deputy_name VARCHAR(255) NOT NULL,
  state_code CHAR(2) NOT NULL,
  political_party VARCHAR(50),
  party_regdate DATE,
  party_ideology VARCHAR(100),
  receipt_social_security_number VARCHAR(20),
  receipt_description VARCHAR(255),
  establishment_name VARCHAR(255),
  receipt_value NUMERIC(12,2) NOT NULL
);

COMMENT ON TABLE silver.tb_reembolso IS 'Camada SILVER: tabela única com reembolsos limpos e enriquecidos (V2).';
COMMENT ON COLUMN silver.tb_reembolso.silver_id IS 'PK técnica (gerada).';
COMMENT ON COLUMN silver.tb_reembolso.receipt_date IS 'Data de emissão do recibo (convertida para DATE no ETL).';
COMMENT ON COLUMN silver.tb_reembolso.deputy_id IS 'Identificador do parlamentar.';
COMMENT ON COLUMN silver.tb_reembolso.deputy_name IS 'Nome do parlamentar.';
COMMENT ON COLUMN silver.tb_reembolso.state_code IS 'UF do parlamentar (2 letras).';
COMMENT ON COLUMN silver.tb_reembolso.political_party IS 'Sigla do partido (ex: PT, PL).';
COMMENT ON COLUMN silver.tb_reembolso.party_regdate IS 'Data de registro do partido no TSE (V2).';
COMMENT ON COLUMN silver.tb_reembolso.party_ideology IS 'Ideologia do partido (V2).';
COMMENT ON COLUMN silver.tb_reembolso.receipt_social_security_number IS 'CPF/CNPJ do fornecedor (texto).';
COMMENT ON COLUMN silver.tb_reembolso.receipt_description IS 'Categoria/descrição da despesa.';
COMMENT ON COLUMN silver.tb_reembolso.establishment_name IS 'Nome do estabelecimento.';
COMMENT ON COLUMN silver.tb_reembolso.receipt_value IS 'Valor do reembolso (R$).';
