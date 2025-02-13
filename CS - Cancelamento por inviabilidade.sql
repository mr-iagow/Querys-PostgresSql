SELECT DISTINCT ON (ai.contract_service_tag_id)
 
ai.protocol AS protocolo,
(SELECT v.name FROM v_users AS v WHERE v.id = a.created_by) AS operador_abertura

from contract_events AS ce
JOIN contracts AS c ON c.id = ce.contract_id
JOIN contract_service_tags AS ctag ON ctag.contract_id = c.id 
JOIN assignments AS a ON a.requestor_id = ctag.client_id 
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id


WHERE 
DATE (ce.created) BETWEEN '$cancelamento01' AND '$cancelamento02'
and ai.incident_type_id = 1442
and ce.contract_event_type_id = 198
