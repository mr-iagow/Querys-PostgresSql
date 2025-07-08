SELECT DISTINCT ON (ai.protocol)

ai.protocol 	AS protocolo,
p.name 			AS cliente,
p.code_city_id,
p.cell_phone_1 AS celular_1,
p.cell_phone_2 AS celular_2,
p.phone 			AS telefone,
it.title 		AS tipo_solicitacao,
ins.title 		AS status_solicitacao,
a.final_date 	AS prazo,
a.created 		AS data_abertura

FROM assignments 				AS a
JOIN assignment_incidents 	AS ai ON ai.assignment_id = a.id
JOIN people 					AS p ON p.id = ai.client_id
JOIN incident_types 			AS it ON it.id = ai.incident_type_id
JOIN incident_status 		AS ins ON ins.id = ai.incident_status_id

WHERE 

p.code_city_id IN (2303931)
AND ai.team_id = 1003
AND DATE (a.created) BETWEEN '$data01' AND '$data02'
