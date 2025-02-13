SELECT 
		p.name AS cliente,
		ai.protocol AS protocolo,
		(SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_solicitacao,
		(SELECT v.name FROM v_users AS v where v.id = a.created_by) AS responsavel_abertura,
			DATE (a.created) AS data_abertura,
		date(a.final_date) AS data_prazo,
		date(a.conclusion_date) AS data_encerramento,
		(SELECT it.title FROM incident_status AS it WHERE it.id = ai.incident_status_id) AS status,
			CASE 
			WHEN DATE (a.conclusion_date) <= DATE (a.final_date) THEN 'Não' 
			WHEN DATE (a.conclusion_date) > DATE (a.final_date) THEN 'Sim' 
			END AS em_atraso,
		(SELECT v.name FROM people AS v WHERE v.id = a.responsible_id) AS responsavel_encerramento


FROM assignments AS a 
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
JOIN people AS p ON p.id = a.requestor_id

WHERE 
			ai.incident_type_id IN (1813,1617)
			and ai.incident_status_id <> 4