# Padronização de Nomenclatura (Mnemônicos)

Este documento define as regras estritas de abreviação (3 letras) para o projeto CEAP no schema `dw`.

## 1. Tipos de Dados (Prefixos)
Define o início do nome da coluna, indicando o tipo de dado armazenado.

| Mnemônico | Significado | Exemplo |
| :--- | :--- | :--- |
| **srk** | Surrogate Key (PK) | `srk_dpt` |
| **cod** | Código Original (Business Key) | `cod_ide` |
| **nom** | Nome / Descrição | `nom_par` |
| **dat** | Data | `dat_emi` |
| **vlr** | Valor Monetário | `vlr_liq` |
| **sgl** | Sigla | `sgl_est` |
| **num** | Número Inteiro / Contagem | `num_ano` |
| **txt** | Texto Longo | `txt_obs` |

## 2. Entidades (Contexto Principal)
Define o assunto macro da tabela. Compõe o nome da tabela (`dim_XXX`).

| Mnemônico | Significado | Contexto |
| :--- | :--- | :--- |
| **dw** | Data Warehouse | Nome do Schema |
| **fat** | Fato | Tabela de Métricas |
| **dim** | Dimensão | Tabela Descritiva |
| **rmb** | Reembolso | O gasto (Fato) |
| **dpt** | Deputado | O parlamentar |
| **prt** | Partido | A agremiação política |
| **frn** | Fornecedor | Empresa/Pessoa que recebeu |
| **cat** | Categoria | Tipo de despesa |
| **loc** | Localização | Dados geográficos |
| **tmp** | Tempo | Calendário |

## 3. Qualificadores (Sufixos)
Define o detalhe específico da coluna. Usado para completar o nome (`nom_XXX`, `num_XXX`).

| Mnemônico | Significado | Exemplo de Uso |
| :--- | :--- | :--- |
| **reg** | Região | `nom_reg` (Nome da Região) |
| **est** | Estado | `sgl_est` (Sigla do Estado) |
| **cri** | Criação / Fundação | `dat_cri` (Data de Criação) |
| **par** | Parlamentar | `nom_par` (Nome Parlamentar) |
| **doc** | Documento (NF/CPF/CNPJ) | `cod_doc` (Código Documento) |
| **liq** | Líquido | `vlr_liq` (Valor Líquido) |
| **nas** | Nascimento | `dat_nas` (Data Nascimento) |
| **leg** | Legislatura | `num_leg` (Número Legislatura) |
| **cmp** | Completa | `dat_cmp` (Data Completa) |
| **ano** | Ano | `num_ano` (Número do Ano) |
| **mes** | Mês | `num_mes` (Número do Mês) |
| **dia** | Dia | `num_dia` (Número do Dia) |
| **tri** | Trimestre | `num_tri` (Número do Trimestre) |
| **sem** | Semestre | `num_sem` (Número do Semestre) |