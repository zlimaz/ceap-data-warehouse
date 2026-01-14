# Dicionário de Dados - Cota Parlamentar

**Arquivo Fonte:** `deputies_dataset.csv` (Camada Bronze/Raw)
**Descrição:** Consolidação de reembolsos e dados cadastrais dos deputados.

| Nome da Coluna | Tipo Original | Descrição e Ação na Camada Silver |
| :--- | :--- | :--- |
| **bugged_date** | Texto | Coluna de controle de erros de data. **Ação:** Será removida no ETL. |
| **receipt_date** | Texto/Date | A data real da emissão do recibo. **Ação:** Converter para `DATE` no Postgres. |
| **deputy_id** | Inteiro | Identificador único do parlamentar. |
| **political_party** | Texto | Sigla do partido (ex: PT, PL). **Ação:** Usado para criar a coluna `data_criacao_partido`. |
| **state_code** | Texto | UF do estado (ex: SP, DF). |
| **deputy_name** | Texto | Nome do parlamentar. |
| **receipt_social_security_number** | Texto | CNPJ ou CPF do estabelecimento fornecedor. |
| **receipt_description** | Texto | Categoria da despesa (ex: Combustíveis, Telefonia). |
| **establishment_name** | Texto | Nome da empresa que recebeu o pagamento. |
| **receipt_value** | Numérico | Valor do reembolso. **Ação:** Coluna principal da Tabela Fato. |

## Arquivo Auxiliar: `dirty_deputies_v2.csv`
Usado apenas para enriquecimento cadastral (Dimensão Partido).
* **party_regdate:** Data de registro do partido no TSE (Usado para enriquecer a tabela principal).
* **party_ideology:** Ideologia do partido.