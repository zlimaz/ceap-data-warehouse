-- ============================================================================
-- SCRIPT DE CONSULTAS OLAP - PERGUNTAS DE NEGÓCIO
-- Objetivo: Extrair insights estratégicos do Data Warehouse (Schema dw)
-- ============================================================================

-- 1. TOP 10 DEPUTADOS MAIS GASTADORES (GERAL)
-- Objetivo: Identificar os outliers absolutos de gasto na cota parlamentar.
SELECT 
    d.nom_par AS deputado,
    p.sgl_prt AS partido,
    l.sgl_est AS estado,
    SUM(f.vlr_liq) AS total_gasto
FROM dw.fat_rmb f
JOIN dw.dim_dpt d ON f.srk_dpt = d.srk_dpt
JOIN dw.dim_prt p ON f.srk_prt = p.srk_prt
JOIN dw.dim_loc l ON f.srk_loc = l.srk_loc
GROUP BY d.nom_par, p.sgl_prt, l.sgl_est
ORDER BY total_gasto DESC
LIMIT 10;

-- 2. RANKING DE GASTOS TOTAIS POR PARTIDO
-- Objetivo: Identificar quais bancadas consomem mais recursos públicos (Volume Total).
SELECT 
    p.sgl_prt AS partido,
    COUNT(DISTINCT d.srk_dpt) AS qtd_deputados,
    SUM(f.vlr_liq) AS total_gasto
FROM dw.fat_rmb f
JOIN dw.dim_prt p ON f.srk_prt = p.srk_prt
JOIN dw.dim_dpt d ON f.srk_dpt = d.srk_dpt
GROUP BY p.sgl_prt
ORDER BY total_gasto DESC;

-- 3. GASTO MÉDIO POR DEPUTADO EM CADA PARTIDO (PER CAPITA)
-- Objetivo: Métrica de justiça. Qual partido é "mais caro" por cabeça, independente do tamanho da bancada.
SELECT 
    p.sgl_prt AS partido,
    ROUND(SUM(f.vlr_liq) / NULLIF(COUNT(DISTINCT f.srk_dpt), 0), 2) AS gasto_medio_por_deputado
FROM dw.fat_rmb f
JOIN dw.dim_prt p ON f.srk_prt = p.srk_prt
GROUP BY p.sgl_prt
ORDER BY gasto_medio_por_deputado DESC;

-- 4. RANKING DE GASTOS POR ESTADO (UF)
-- Objetivo: Comparar o custo parlamentar por unidade federativa.
SELECT 
    l.sgl_est AS estado,
    l.nom_reg AS regiao,
    SUM(f.vlr_liq) AS total_gasto
FROM dw.fat_rmb f
JOIN dw.dim_loc l ON f.srk_loc = l.srk_loc
GROUP BY l.sgl_est, l.nom_reg
ORDER BY total_gasto DESC;

-- 5. AS 5 CATEGORIAS DE DESPESA MAIS CARAS
-- Objetivo: Entender para onde vai o dinheiro (Combustível? Passagens? Divulgação?).
SELECT 
    c.nom_cat AS categoria,
    SUM(f.vlr_liq) AS total_gasto,
    COUNT(*) AS qtd_notas_fiscais
FROM dw.fat_rmb f
JOIN dw.dim_cat c ON f.srk_cat = c.srk_cat
GROUP BY c.nom_cat
ORDER BY total_gasto DESC
LIMIT 5;

-- 6. (CTE) TOP FORNECEDORES: QUEM MAIS RECEBEU VERBA?
-- Objetivo: Identificar empresas que concentram os recebimentos (Ex: Cias Aéreas).
WITH RankingFornecedores AS (
    SELECT 
        fr.nom_frn AS fornecedor,
        fr.cod_doc AS cnpj_cpf,
        SUM(f.vlr_liq) AS total_recebido
    FROM dw.fat_rmb f
    JOIN dw.dim_frn fr ON f.srk_frn = fr.srk_frn
    GROUP BY fr.nom_frn, fr.cod_doc
)
SELECT * FROM RankingFornecedores
ORDER BY total_recebido DESC
LIMIT 10;

-- 7. (CTE) DEPUTADOS QUE GASTAM ACIMA DA MÉDIA NACIONAL
-- Objetivo: Identificar parlamentares que fogem do padrão de gasto "normal".
WITH MediaGasto AS (
    SELECT AVG(total_deputado) AS media_geral
    FROM (
        SELECT SUM(vlr_liq) AS total_deputado 
        FROM dw.fat_rmb 
        GROUP BY srk_dpt
    ) sub
),
GastoDeputados AS (
    SELECT 
        d.nom_par, 
        SUM(f.vlr_liq) AS total_gasto
    FROM dw.fat_rmb f
    JOIN dw.dim_dpt d ON f.srk_dpt = d.srk_dpt
    GROUP BY d.nom_par
)
SELECT 
    gd.nom_par,
    gd.total_gasto,
    mg.media_geral,
    (gd.total_gasto - mg.media_geral) AS valor_acima_da_media
FROM GastoDeputados gd, MediaGasto mg
WHERE gd.total_gasto > mg.media_geral
ORDER BY valor_acima_da_media DESC
LIMIT 20;

-- 8. ANÁLISE MACRO: GASTOS POR REGIÃO GEOGRÁFICA
-- Objetivo: Validar o enriquecimento de dados (Coluna Região criada no ETL).
SELECT 
    l.nom_reg AS regiao,
    SUM(f.vlr_liq) AS total_gasto,
    ROUND((SUM(f.vlr_liq) * 100.0 / (SELECT SUM(vlr_liq) FROM dw.fat_rmb)), 2) AS pct_do_total
FROM dw.fat_rmb f
JOIN dw.dim_loc l ON f.srk_loc = l.srk_loc
GROUP BY l.nom_reg
ORDER BY total_gasto DESC;

-- 9. EVOLUÇÃO TEMPORAL: GASTO POR ANO
-- Objetivo: Analisar a tendência de crescimento ou redução de custos ao longo do tempo.
SELECT 
    t.num_ano AS ano,
    SUM(f.vlr_liq) AS total_ano
FROM dw.fat_rmb f
JOIN dw.dim_tmp t ON f.srk_tmp = t.srk_tmp
GROUP BY t.num_ano
ORDER BY t.num_ano;

-- 10. DETALHAMENTO: GASTOS EM FINAIS DE SEMANA
-- Objetivo: Auditoria simples. Identificar volume de gastos feitos em dias não úteis (Sáb/Dom).
-- Requer que o dia da semana tenha sido extraído ou calculado via função.
SELECT 
    CASE 
        WHEN EXTRACT(DOW FROM t.dat_cmp) IN (0, 6) THEN 'Final de Semana'
        ELSE 'Dia Útil'
    END AS tipo_dia,
    COUNT(*) AS qtd_transacoes,
    SUM(f.vlr_liq) AS total_gasto
FROM dw.fat_rmb f
JOIN dw.dim_tmp t ON f.srk_tmp = t.srk_tmp
GROUP BY 
    CASE 
        WHEN EXTRACT(DOW FROM t.dat_cmp) IN (0, 6) THEN 'Final de Semana'
        ELSE 'Dia Útil'
    END
ORDER BY total_gasto DESC;