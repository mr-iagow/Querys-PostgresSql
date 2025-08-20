SELECT DISTINCT ON (ct.id)
  ct.contract_number AS numero_contrato,
  p."name"          AS nome_cliente,
  pa.neighborhood   AS bairro,
  pa.city           AS cidade,
  sp.title          AS plano,
  ct.amount         AS mensalidade,
  ct.v_status       AS status_contrato,
  CASE WHEN ct.v_status = 'Cancelado' THEN cet.title END AS evento_cancelamento,
  CASE WHEN caa.activation_date IS NULL
       THEN DATE(ct.created) ELSE DATE(caa.activation_date) END AS data_contratacao,
  ct.cancellation_date AS data_cancelamento
FROM contracts AS ct
JOIN people AS p               ON p.id = ct.client_id
JOIN people_addresses AS pa    ON pa.id = ct.people_address_id
JOIN contract_items AS ci      ON ci.contract_id = ct.id
                              AND ci.deleted = FALSE
                              AND ci.p_is_billable = TRUE
JOIN service_products AS sp    ON sp.id = ci.service_product_id
LEFT JOIN contract_assignment_activations AS caa
                               ON caa.contract_id = ct.id
LEFT JOIN contract_events AS ce
       ON ce.contract_id = ct.id
      AND ct.v_status = 'Cancelado'
LEFT JOIN contract_event_types AS cet
       ON cet.id = ce.contract_event_type_id
      AND (
           ce.contract_event_type_id IN (
             110,154,156,157,158,159,163,165,166,167,168,169,170,171,172,173,174,175,
             176,177,178,179,180,181,182,183,184,186,190,192,195,196,197,198,199,200,
             201,202,203,225,226,243,246,251,261,296,311,310,309,308,307,306,305,304,
             316,315,314,313,312,320,319,318,317,324,323,322,321,330,328,327,326,325,329,338,291
           )
           OR cet.title ILIKE '%Cancelamento%'
      )
WHERE ct.company_place_id = 12
  AND ct.deleted = FALSE
  AND p."name" NOT LIKE '%TESTE%'
  AND ct.id NOT IN (101378,101380)
-- AND sp.huawei_profile_name IS NOT NULL
ORDER BY
  ct.id,
  CASE
    WHEN ce.contract_event_type_id IN (
      110,154,156,157,158,159,163,165,166,167,168,169,170,171,172,173,174,175,
      176,177,178,179,180,181,182,183,184,186,190,192,195,196,197,198,199,200,
      201,202,203,225,226,243,246,251,261,296,311,310,309,308,307,306,305,304,
      316,315,314,313,312,320,319,318,317,324,323,322,321,330,328,327,326,325,329,338,291
    )
    OR cet.title ILIKE '%Cancelamento%' THEN 1 ELSE 0
  END DESC,
  ce.created DESC NULLS LAST,   -- se a coluna for created_at, troque aqui
  ce.id DESC;
