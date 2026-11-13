/* =====================================================================
   REAJUSTE - QUERY 1: SÓ OBSERVAÇÕES DO CONTRATO (traz só os elegíveis)
   ---------------------------------------------------------------------
   Universo:
     - contrato não excluído
     - status fora de Cancelado / Encerrado / Cortesia / Demonstração
     - tipo de contrato que NÃO seja "Órgãos Públicos"

   Regra:
     Lê TODOS os pares de datas de fidelidade da observação ("início - fim",
     formatos dd/mm/aaaa ou dd.mm.aa, separados por "-", "->", "a", "até", "&")
     e usa o de INÍCIO MAIS RECENTE.
     Fica FORA se essa fidelidade começou nos últimos 12 meses ou ainda não terminou.
     Contrato sem nenhuma data de fidelidade na observação = elegível.
   ===================================================================== */
WITH param AS (
    SELECT d AS data_ref,
           (d - interval '12 months')::date AS janela_ini
    FROM (SELECT CURRENT_DATE AS d) x          -- <<< ou DATE '2026-11-30' para fixar a data
),

cand AS (
    SELECT c.*
    FROM contracts c
    JOIN contract_types ct ON ct.id = c.contract_type_id
    WHERE c.deleted = FALSE
      AND c.v_status NOT IN ('Cancelado', 'Encerrado', 'Cortesia', 'Demonstração')
      AND ct.title !~* 'rg[aã]os?\s+p[uú]blic'
),

/* todos os pares de datas da observação */
fid_pares AS (
    SELECT c.id AS contract_id,
           CASE WHEN m[2]::int BETWEEN 1 AND 12 AND m[1]::int BETWEEN 1 AND 31
                     AND (CASE WHEN m[3]::int < 100 THEN 2000 + m[3]::int ELSE m[3]::int END) BETWEEN 1995 AND 2100
                THEN make_date(CASE WHEN m[3]::int < 100 THEN 2000 + m[3]::int ELSE m[3]::int END, m[2]::int, 1) + (m[1]::int - 1)
           END AS ini,
           CASE WHEN m[5]::int BETWEEN 1 AND 12 AND m[4]::int BETWEEN 1 AND 31
                     AND (CASE WHEN m[6]::int < 100 THEN 2000 + m[6]::int ELSE m[6]::int END) BETWEEN 1995 AND 2100
                THEN make_date(CASE WHEN m[6]::int < 100 THEN 2000 + m[6]::int ELSE m[6]::int END, m[5]::int, 1) + (m[4]::int - 1)
           END AS fim
    FROM cand c
    CROSS JOIN LATERAL regexp_matches(
        c.observation,
        '(\d{1,2})[/.](\d{1,2})[/.](\d{2,4})\s*(?:-+\s*>?|>|até|ate|à|a|&|ao)\s*(\d{1,2})[/.](\d{1,2})[/.](\d{2,4})',
        'gi'
    ) AS m
),

/* fidelidade mais recente (maior data de início); ignora pares inválidos/digitação */
fid AS (
    SELECT DISTINCT ON (fp.contract_id)
           fp.contract_id, fp.ini AS fid_inicio, fp.fim AS fid_fim
    FROM fid_pares fp
    CROSS JOIN param p
    WHERE fp.ini IS NOT NULL AND fp.fim IS NOT NULL
      AND fp.fim > fp.ini
      AND fp.ini <= p.data_ref + interval '1 year'
    ORDER BY fp.contract_id, fp.ini DESC
),

/* serviços ativos do contrato: plano de internet primeiro, depois os demais pelo maior valor.
   Ignora os itens de composição (desdobramento do próprio plano), que duplicavam
   o serviço na mesma célula e dobravam o valor. */
itens AS (
    SELECT ci.contract_id,
           array_agg(COALESCE(sp.title, ci.description) ORDER BY (COALESCE(sp.title, ci.description) ~* '\d+\s*(MB|GB|MEGA)' AND COALESCE(sp.title, ci.description) !~* 'REPETIDOR') DESC, ci.total_amount DESC, ci.id) AS nomes,
           array_agg(COALESCE(sp.code, ci.service_product_id::text) ORDER BY (COALESCE(sp.title, ci.description) ~* '\d+\s*(MB|GB|MEGA)' AND COALESCE(sp.title, ci.description) !~* 'REPETIDOR') DESC, ci.total_amount DESC, ci.id) AS codigos,
           count(*)            AS qtd,
           sum(ci.total_amount) AS valor_itens
    FROM contract_items ci
    JOIN cand c ON c.id = ci.contract_id
    LEFT JOIN service_products sp ON sp.id = ci.service_product_id
    WHERE ci.deleted = FALSE
      AND COALESCE(ci.is_composition, FALSE) = FALSE
    GROUP BY ci.contract_id
),

conx AS (
    SELECT DISTINCT ON (ac.contract_id)
           ac.contract_id, ac.state, ac.city, ac.neighborhood
    FROM authentication_contracts ac
    JOIN cand c ON c.id = ac.contract_id
    ORDER BY ac.contract_id, ac.active DESC NULLS LAST, ac.id
)

SELECT
    /* --- Contrato --- */
    b.id                                   AS contrato,
    b.contract_number                      AS numero_contrato,
    b.description                          AS descricao_contrato,
    ct.title                               AS tipo_contrato,
    b.v_status                             AS status_contrato,
    /* --- Cliente --- */
    pe.name                                AS cliente,
    pe.tx_id                               AS cpf_cnpj,
    /* --- Serviço / valores --- */
    it.qtd                                 AS qtd_servicos,
    it.nomes[1]                            AS servico_1,
    it.codigos[1]                          AS codigo_servico_1,
    it.nomes[2]                            AS servico_2,
    it.codigos[2]                          AS codigo_servico_2,
    it.nomes[3]                            AS servico_3,
    it.codigos[3]                          AS codigo_servico_3,
    it.nomes[4]                            AS servico_4,
    it.codigos[4]                          AS codigo_servico_4,
    it.nomes[5]                            AS servico_5,
    it.codigos[5]                          AS codigo_servico_5,
    CASE WHEN it.qtd > 5 THEN array_to_string(it.nomes[6:], ' | ') END   AS demais_servicos,
    CASE WHEN it.qtd > 5 THEN array_to_string(it.codigos[6:], ' | ') END AS demais_codigos,
    b.amount                               AS valor_contrato,
    it.valor_itens                         AS valor_itens_ativos,
    /* --- Locais --- */
    cpv.code || ' - ' || cpv.description   AS local_venda,
    cpf.code || ' - ' || cpf.description   AS local_faturamento,
    /* --- Faturamento --- */
    b.v_invoice_type                       AS tipo_faturamento,
    CASE WHEN b.special_billing THEN 'Sim' ELSE 'Não' END AS faturamento_especial,
    sbt.title                              AS tipo_faturamento_especial,
    to_char(b.billing_final_date, 'MM/YYYY') AS mes_ultima_parcela,
    GREATEST(0, (EXTRACT(YEAR FROM age(b.billing_final_date, p.data_ref)) * 12
               + EXTRACT(MONTH FROM age(b.billing_final_date, p.data_ref)))::int) AS parcelas_restantes,
    CASE b.expiration_docket WHEN 0 THEN 'Mês Atual' WHEN 1 THEN 'Mês Seguinte' ELSE b.expiration_docket::text END AS vencimento_boleto,
    cdc.title                              AS ciclo_faturamento,
    fct.title                              AS tipo_cobranca,
    b.collection_day                       AS dia_vencimento,
    b.billing_day                          AS dia_faturamento,
    /* --- Endereço do contrato --- */
    pa.state                               AS uf_contrato,
    pa.city                                AS municipio_contrato,
    pa.neighborhood                        AS bairro_contrato,
    /* --- Conexão --- */
    CASE WHEN cx.contract_id IS NOT NULL THEN 'Sim' ELSE 'Não' END AS possui_conexao,
    cx.state                               AS uf_conexao,
    cx.city                                AS municipio_conexao,
    cx.neighborhood                        AS bairro_conexao,
    /* --- Datas --- */
    b.date                                 AS data_inclusao,
    b.approval_date                        AS data_aprovacao,
    b.beginning_date                       AS vigencia_de,
    b.final_date                           AS vigencia_ate,
    /* --- Reajuste --- */
    COALESCE(ai.title, b.adjustment_index) AS indice_reajuste,
    b.next_adjustment_date                 AS proximo_reajuste,
    /* --- Fidelidade (observação) --- */
    f.fid_inicio                           AS fidelidade_mais_recente_inicio,
    f.fid_fim                              AS fidelidade_mais_recente_fim,
    b.observation                          AS observacoes
FROM cand b
CROSS JOIN param p
JOIN contract_types ct                     ON ct.id  = b.contract_type_id
LEFT JOIN fid f                            ON f.contract_id = b.id
LEFT JOIN people pe                        ON pe.id  = b.client_id
LEFT JOIN itens it                         ON it.contract_id = b.id
LEFT JOIN companies_places cpv             ON cpv.id = b.company_place_id
LEFT JOIN companies_places cpf             ON cpf.id = COALESCE(b.invoice_company_place_id, b.company_place_id)
LEFT JOIN special_billing_types sbt        ON sbt.id = b.special_billing_type_id
LEFT JOIN contract_date_configurations cdc ON cdc.id = b.contract_date_configuration_id
LEFT JOIN financial_collection_types fct   ON fct.id = b.financial_collection_type_id
LEFT JOIN people_addresses pa              ON pa.id  = b.people_address_id
LEFT JOIN conx cx                          ON cx.contract_id = b.id
LEFT JOIN adjustment_indices ai            ON ai.id  = b.adjustment_indice_id
WHERE NOT (COALESCE(f.fid_inicio >= p.janela_ini, FALSE) OR COALESCE(f.fid_fim > p.data_ref, FALSE))
ORDER BY b.id
