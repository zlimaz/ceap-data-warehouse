# Projeto CEAP – Data Warehouse

**Disciplina:** Sistema Banco de Dados II (BD2)
**Professor:** Thiago
**Instituição:** Universidade de Brasília (UnB)

---

## Participantes do Projeto

* **Lucas Víctor** - 211063194
* **Miguel Arthur** - 211062320
---
## Visão Geral do Projeto

Este projeto tem como objetivo o desenvolvimento de um Data Warehouse para análise dos **reembolsos parlamentares da CEAP (Cota para o Exercício da Atividade Parlamentar)**, aplicando conceitos fundamentais de **ETL**, **modelagem dimensional**, **Star Schema** e boas práticas de nomenclatura (mnemônicos).

O Data Warehouse foi estruturado em três camadas principais (Raw, Silver e Gold), permitindo a evolução progressiva dos dados desde sua forma bruta até uma estrutura analítica otimizada para consultas e visualizações.

---

## Arquitetura do Data Warehouse

O projeto segue a arquitetura clássica de DW em camadas:

```
RAW  →  SILVER  →  GOLD
```

### Camada Raw

* Armazena os **dados brutos**, conforme obtidos das fontes originais.
* Nenhuma regra de negócio é aplicada.
* Objetivo: preservar a integridade dos dados originais.

### Camada Silver

* Responsável pela limpeza, padronização e enriquecimento dos dados.
* Tratamento de:

  * Tipos de dados
  * Padronização textual
  * Correção de categorias
  * Enriquecimento com dados partidários
* Implementada como **One Big Table** para facilitar análises intermediárias.

### Camada Gold

* Camada analítica final, estruturada em Star Schema.
* Contém:

  * **1 Tabela Fato**
  * **6 Tabelas Dimensão**
* Otimizada para consultas OLAP e ferramentas de BI.

---

## Modelagem Dimensional – Camada Gold

A camada Gold foi modelada segundo o padrão Star Schema, no qual:

* A tabela fato **FAT_RMB** fica no centro do modelo.
* Todas as dimensões se conectam diretamente à tabela fato.
* Não existem relacionamentos entre dimensões.

### Tabela Fato

* **FAT_RMB (Reembolso)**

  * Medida principal: `vlr_liq` (valor do reembolso)
  * Dimensão degenerada: `cod_doc` (nota fiscal)

### Tabelas Dimensão

* **DIM_DPT** – Deputado
* **DIM_PRT** – Partido
* **DIM_LOC** – Localização (Estado e Região)
* **DIM_CAT** – Categoria de Despesa
* **DIM_FRN** – Fornecedor
* **DIM_TMP** – Tempo

O DER da camada Gold foi construído de forma que visualmente represente uma estrela, conforme esperado em modelos dimensionais.

---

## Granularidade

> **Grão da tabela fato:**
> Cada registro da tabela FAT_RMB representa um reembolso individual, associado exatamente a:

* um deputado,
* um partido,
* uma localização,
* uma categoria de despesa,
* um fornecedor,
* e uma data específica.

---

## Padronização de Nomenclatura (Mnemônicos)

O projeto adota um padrão rigoroso de mnemônicos com 3 letras, aplicado de forma consistente em todas as camadas, especialmente na Gold.

Exemplos:

* `srk_` → Surrogate Key
* `dim_` → Dimensão
* `fat_` → Fato
* `vlr_` → Valor
* `nom_` → Nome
* `dat_` → Data

O documento completo de mnemônicos está disponível em:

```
data layer/gold/mnemonico.md
data layer/gold/mnemonico.pdf
```

---

## Processos ETL

Os processos de ETL foram desenvolvidos em **Python**, utilizando **Pandas** e **SQLAlchemy**.

### ETL Raw → Silver

Arquivo:

```
transformer/etl_raw_to_silver.ipynb
```

Responsável por:

* Leitura dos CSVs brutos
* Limpeza de dados inconsistentes
* Padronização textual
* Correção de categorias
* Enriquecimento com dados partidários
* Carga na tabela `silver.tb_reembolso`

### ETL Silver → Gold

Arquivo:

```
transformer/etl_silver_to_gold.ipynb
```

Responsável por:

* Popular as dimensões
* Gerar surrogate keys
* Resolver chaves estrangeiras
* Popular a tabela fato `dw.fat_rmb`

---

## Estrutura de Pastas do Projeto

```
data layer/
├── raw/
│   ├── dados_brutos.csv
│   ├── deputies_dataset.csv
│   ├── dirty_deputies_v2.csv
│   ├── dicionario_de_dados.*
│   └── analytics.ipynb
│
├── silver/
│   ├── modelagem/
│   ├── analytics.ipynb
│   └── ddl.sql
│
├── gold/
│   ├── modelagem/
│   ├── consultas.sql
│   ├── ddl.sql
│   ├── mnemonico.md
│   └── mnemonico.pdf
│
├── transformer/
│   ├── etl_raw_to_silver.ipynb
│   └── etl_silver_to_gold.ipynb
│   
│
├── docker-compose.yml
├── dockerfile
├── requirements.txt
└── README.md
```

---

## Infraestrutura

O ambiente é executado via **Docker**, com:

* PostgreSQL
* Execução local via `docker-compose`

Arquivo principal:

```
docker-compose.yml
```

---

## Considerações Finais

Este projeto consolida, de forma prática, os principais conceitos de **Data Warehousing**, **ETL**, **modelagem dimensional** e **boas práticas de projeto de dados**, estando totalmente alinhado aos critérios acadêmicos da disciplina de Sistema Banco de Dados II.

A camada Gold foi cuidadosamente modelada para **evidenciar enriquecimento de dados**, **uso correto de Star Schema** e **consistência semântica**, atendendo às exigências de avaliação do professor.

