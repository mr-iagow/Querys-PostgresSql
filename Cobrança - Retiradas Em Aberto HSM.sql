SELECT DISTINCT ON (ai.assignment_id)
	
p.cell_phone_1 AS telefone,
p.name AS nome,
p.email,
pa.city AS cidade,
CASE 
	WHEN ai.incident_type_id = 1291 THEN 'involuntatio'
	WHEN ai.incident_type_id = 1015 THEN 'voluntario'
END AS tipo_retirada,
c.id AS id_contrato

FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
JOIN people AS p ON p.id = a.requestor_id
JOIN contracts AS c ON c.client_id = p.id
JOIN contract_service_tags AS ctag ON ctag.contract_id = c.id
JOIN people_addresses AS pa ON pa.person_id = p.id


WHERE

ai.incident_type_id IN (1291,1015) --onde 1291 é retirada inadimplencia e 1015 retirada normal
AND DATE (a.created) BETWEEN '$abertura01' AND '$abertura02' --Puxando apenas por data de abertura
AND ai.incident_status_id NOT IN (8,4) --Remove protocolos cancelados e encerrados