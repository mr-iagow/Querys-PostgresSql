SELECT
  cp."description"                                   AS empresa,
  ct.contract_number                                 AS numero_contrato,
  ct.v_status                                        AS status_contrato,
  p.id                                               AS id_cliente,
  p."name"                                           AS cliente_razao_social,
  pa.city                                            AS cidade,
  pa.neighborhood                                    AS bairro,
  pa.street                                          AS rua,
  pa."number"                                        AS numero_casa,
  pa.postal_code                                     AS cep,
  ct.amount                                          AS valor_contrato,
  STRING_AGG(DISTINCT sp.title, ', ')                AS plano,
  COALESCE(MIN(caa.activation_date), MIN(DATE(ct.created))) AS data_adesao,
  CASE
    WHEN MAX(pu.final) IS NULL OR MAX(pu.final) <= DATE '2025-09-01'
      THEN 'sem_fidelidade'
    ELSE 'com_fidelidade'
  END                                                AS status_fidelidade
FROM contracts AS ct
JOIN people AS p                       ON p.id = ct.client_id
LEFT JOIN people_addresses AS pa       ON pa.id = ct.people_address_id
JOIN companies_places AS cp            ON cp.id = ct.company_place_id
JOIN contract_items AS ci              ON ci.contract_id = ct.id AND ci.deleted = FALSE
JOIN service_products AS sp            ON sp.id = ci.service_product_id
LEFT JOIN contract_assignment_activations AS caa ON caa.contract_id = ct.id
LEFT JOIN people_uploads AS pu         ON pu.people_id = p.id
WHERE ct.v_status <> 'Cancelado'
  AND p.type_tx_id = 1
  AND ct.contract_type_id NOT IN (6,7,8,9,27)
  AND sp.huawei_profile_name IS NOT NULL
GROUP BY
  ct.id,
  cp."description",
  ct.contract_number,
  ct.v_status,
  p.id,
  p."name",
  pa.city,
  pa.neighborhood,
  pa.street,
  pa."number",
  pa.postal_code,
  ct.amount;
