SELECT DISTINCT ON (ct.id)
  ct.contract_number AS numero_contrato,
  p.name AS cliente,
  ct.v_status AS status_contrato,
  ct.amount AS valor_contrato,
  sp.title AS plano_contrato
  
FROM contracts ct
JOIN people p ON p.id = ct.client_id
LEFT JOIN contract_items ci ON ci.contract_id = ct.id AND ci.deleted = FALSE
LEFT JOIN service_products sp ON sp.id = ci.service_product_id
WHERE
  ct.contract_type_id IN (35,36,37,38,39,45)
  AND ci.is_composition = TRUE
  AND NOT EXISTS (
    SELECT 1
    FROM financial_receivable_titles frt
    WHERE frt.client_id = ct.client_id
      AND frt.expiration_date >= DATE '2026-01-01'
      AND frt.expiration_date <  DATE '2026-02-01'
  )
ORDER BY ct.id, sp.title
