SELECT DISTINCT ON (c.id)
c.id,
c.description,
acco.user,
caa.activation_date,
c.created,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = c.company_place_id) AS empresa,
(SELECT cet.title from contract_event_types AS cet where cet.id = ce.contract_event_type_id) AS evento,
DATE (ce.date) AS data_evento


FROM contracts AS c
INNER JOIN contract_events AS ce ON ce.id = c.contract_event_id
left join authentication_contract_connection_occurrences AS acco ON acco.contract_id = c.id
left JOIN contract_assignment_activations AS caa ON caa.contract_id = c.id


WHERE 
c.v_status IN  ('Cancelado', 'Encerrado')
/*AND ce.contract_event_type_id IN (194,189,180,200,193,201,187,191,190,186,185)*/
AND caa.activation_date IS NULL
AND c.created > '2021-01-28'
AND acco.user IS NOT NULL 