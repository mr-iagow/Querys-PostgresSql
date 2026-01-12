SELECT DISTINCT ON (ai.protocol)
ai.protocol AS protocolo,
ctag.service_tag AS etiqueta_protocolo,
it.title AS tipo_solicitacao,
c.v_status AS status_contrato,
pp."name" AS aberto_por,
p.name AS cliente,
DATE (a.created) AS data_abetura,
DATE (a.conclusion_date) AS data_encerramento,
COALESCE(
  (
    CASE
      WHEN ai.beginning_checklist IS NOT NULL
       AND ai.beginning_checklist <> ''
       AND pg_input_is_valid(ai.beginning_checklist, 'jsonb')
      THEN (ai.beginning_checklist::jsonb -> '0_' ->> 'label')
      ELSE NULL
    END
  ),
  'Sem checklist'
) AS chek_1,
COALESCE(
  (
    CASE
      WHEN ai.beginning_checklist IS NOT NULL
       AND ai.beginning_checklist <> ''
       AND pg_input_is_valid(ai.beginning_checklist, 'jsonb')
      THEN (ai.beginning_checklist::jsonb -> '0_' ->> 'value')
      ELSE NULL
    END
  ),
  'Sem resposta'
) AS resposta_1


FROM assignments AS a 
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id 
JOIN incident_types AS it ON it.id = ai.incident_type_id
JOIN people AS p ON p.id = ai.client_id
JOIN v_users AS pp ON pp.id = a.created_by
left JOIN contract_service_tags AS ctag ON ctag.id = ai.contract_service_tag_id
left JOIN contracts AS c ON c.id = ctag.contract_id
JOIN incident_status AS ins ON ins.id = ai.incident_status_id

WHERE 
ai.incident_type_id IN (2379, 2391, 2389, 2388, 2390, 2380, 2500, 2498, 2482)
AND DATE (a.created) BETWEEN '$data01' AND '$data02'