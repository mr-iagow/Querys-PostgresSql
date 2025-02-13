SELECT DISTINCT ON (ai.protocol)

		ai.protocol AS protocolo,
		p.name AS nome_cliente,
		(SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_solicitacao,
		(SELECT v.name FROM people AS v WHERE v.id = a.responsible_id) AS atendente,
		DATE (a.created) AS data_abertura,
		DATE (a.conclusion_date) AS data_encerramento,
		(SELECT ins.title FROM incident_status AS ins WHERE ins.id = ai.incident_status_id) AS status,
		CASE
		   WHEN a.conclusion_date  <=  a.final_date THEN 'sim'
		   WHEN  a.conclusion_date > a.final_date THEN 'nao'
		END feito_no_prazo,
		CASE 
			WHEN srm.id = 5 THEN 'sim'
			ELSE 'não'
		END AS reprazado

FROM assignments AS a
	JOIN assignment_incidents AS ai ON ai.assignment_id = a.id 
	JOIN people AS p ON p.id = a.requestor_id
	left JOIN assignment_person_routings AS apr ON apr.assignment_id = a.id
	left JOIN solicitation_routing_motives AS srm ON srm.id = apr.solicitation_routing_motive_id

WHERE

	ai.team_id = 1010
	AND DATE (a.conclusion_date) BETWEEN '$data01' AND '$data02'
	AND ai.incident_status_id = 4