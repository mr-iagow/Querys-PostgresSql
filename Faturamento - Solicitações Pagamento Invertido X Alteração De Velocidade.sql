SELECT
  ai.protocol AS protocolo_pagamento_invertudo,
  it.title AS solicitacao,
  DATE(a.created) AS data_abertura_pagamento_invertido,
  DATE(a.conclusion_date) AS data_encerramento_pagamento_invertido,
  up.protocol AS protocolo_upgrade,
  up.tipo_solicitacao AS tipo_solicitacao_upgrade,
  up.data_abertura AS data_abertura_upgrade,
  up.data_encerramento AS data_encerramento_upgrade,
  p.name AS cliente,
  c.contract_number AS numero_contrato,
  cp.description AS empresa
  
FROM assignments a
JOIN assignment_incidents ai ON ai.assignment_id = a.id
JOIN people p ON p.id = ai.client_id
JOIN incident_types it ON it.id = ai.incident_type_id
LEFT JOIN contract_service_tags ctag ON ctag.id = ai.contract_service_tag_id
LEFT JOIN contracts c ON c.id = ctag.contract_id
JOIN companies_places cp ON cp.id = c.company_place_id

JOIN LATERAL (
  SELECT
    ai2.protocol            AS protocol,
    it2.title               AS tipo_solicitacao,
    DATE(a2.created)        AS data_abertura,
    DATE(a2.conclusion_date)AS data_encerramento
  FROM assignments a2
  JOIN assignment_incidents ai2 ON ai2.assignment_id = a2.id
  JOIN incident_types it2       ON it2.id = ai2.incident_type_id
  WHERE ai2.client_id = p.id
        AND (
         it2.title ILIKE '%UPGRADE%'
      OR it2.title ILIKE '%DOWNGRADE%'
      OR it2.title ILIKE '%AJUSTE%'
    )
    AND a2.created > a.created
  ORDER BY a2.created ASC
  LIMIT 1
) up ON TRUE

WHERE it.id = 58
  AND DATE(a.created) >= DATE '2025-10-30'
  AND DATE(a.created) <  DATE '2026-01-13'
ORDER BY a.created DESC
