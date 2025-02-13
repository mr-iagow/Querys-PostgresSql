SELECT DISTINCT ON (ai.protocol)

(SELECT p.name FROM people AS p WHERE p.id = a.requestor_id) AS cliente,
(SELECT p2.name FROM people AS p2 WHERE p2.id = a.responsible_id) AS atendente,
(SELECT sc.title from solicitation_classifications AS sc WHERE sc.id = ai.solicitation_classification_id) AS contexto,
(SELECT sp.title from solicitation_problems AS sp WHERE sp.id = ai.solicitation_problem_id) AS problema,
DATE (a.created) AS data_abertura,
DATE (a.conclusion_date) AS data_encerramento,
	CASE 
	WHEN DATE (a.conclusion_date) <= DATE (a.final_date) THEN 'Não' 
	WHEN DATE (a.conclusion_date) > DATE (a.final_date) THEN 'Sim' 
	END AS em_atraso,
	CASE 
		WHEN DATE (a.conclusion_date) > DATE (a.final_date) THEN datediff(DATE(a.conclusion_date),DATE(a.final_date)) 
		WHEN DATE (a.conclusion_date) < DATE (a.final_date) THEN NULL 
	END AS dias_atraso

FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id

WHERE 
DATE (a.conclusion_date) BETWEEN '2024-04-01' AND '2024-04-17'
AND ai.incident_type_id = 1787
AND ai.incident_status_id = 4
