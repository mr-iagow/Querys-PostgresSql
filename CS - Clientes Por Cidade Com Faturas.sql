SELECT DISTINCT ON (ct.contract_number)
  ct.contract_number AS numero_contrato,
  pa.city AS cidade,
  COALESCE(TO_CHAR(ct.cancellation_date, 'DD/MM/YYYY'), 'Contrato Ativo') AS cancelamento,
  COALESCE(DATE(caa.activation_date), DATE(ct.created)) AS data_ativacao,
  ct.v_status AS status_contrato,
  CASE 
    WHEN ct.cancellation_date IS NOT NULL THEN canc_evt.title 
  END AS evento_cancelamento,
  p.name AS cliente,
  p.cell_phone_1 AS celular1, 
  p.cell_phone_2 AS celular2,
  p.phone AS telefone,
  ct.amount AS valor_contrato,
  COALESCE(contr.qtd_boletos_pagos, 0) AS qtd_boletos_pagos
FROM contracts AS ct
JOIN people AS p ON p.id = ct.client_id 
LEFT JOIN people_addresses AS pa ON pa.id = ct.people_address_id
LEFT JOIN contract_assignment_activations AS caa ON caa.contract_id = ct.id

-- evento de cancelamento (mais recente que contenha "can" de cancelado)
LEFT JOIN LATERAL (
  SELECT cet.title
  FROM contract_events ce2
  JOIN contract_event_types cet ON cet.id = ce2.contract_event_type_id
  WHERE ce2.contract_id = ct.id
    AND cet.title ILIKE '%can%'
  ORDER BY ce2.id DESC
  LIMIT 1
) AS canc_evt ON TRUE

-- total de boletos pagos (receipt_date não nulo) por CONTRATO
LEFT JOIN (
  SELECT
    frt.contract_id,
    COUNT(*) FILTER (WHERE frtt.receipt_date IS NOT NULL) AS qtd_boletos_pagos
  FROM financial_receivable_titles AS frt
  JOIN financial_receipt_titles AS frtt ON frtt.financial_receivable_title_id = frt.id
  JOIN contracts AS ct ON ct.id = frt.contract_id
  JOIN contract_service_tags AS ctag ON ctag.id = ct.id
  JOIN people AS ppp ON ppp.id = frt.client_id
  WHERE frt.title LIKE '%FAT%'
    AND frt.finished = FALSE
    AND frt.deleted = FALSE
  GROUP BY frt.contract_id
) AS contr
  ON contr.contract_id = ct.id


WHERE pa.code_city_id = 2610004 AND p."name" NOT LIKE '%Teste%' AND p."name" NOT LIKE '%TESTE%' 
ORDER BY ct.contract_number, ct.cancellation_date DESC NULLS LAST ;
