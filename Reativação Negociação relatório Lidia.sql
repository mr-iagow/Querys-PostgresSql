SELECT DISTINCT ON (ai.protocol)
		p.id AS cod_cliente,
		c.id AS id_contrato,
		ai.protocol AS protocolo,
		p.name AS cliente,
		(SELECT it.title FROM incident_types AS it WHERE  it.id = ai.incident_type_id) AS tipo_solicitacao,
		(SELECT ins.title FROM incident_status AS ins WHERE ins.id = ai.incident_status_id) AS status_solicitacao,
		(SELECT vu.name FROM v_users AS vu where vu.id = a.created_by) AS usuario_de_abertura,
		a.created AS data_abertura,
		a.conclusion_date AS data_encerramento,
		(SELECT sc.title from solicitation_classifications AS sc WHERE sc.id = ai.solicitation_classification_id) AS contexto_solicitacao,
		(SELECT sp.title FROM solicitation_problems AS sp WHERE sp.id = ai.solicitation_problem_id) AS problema_solicitacao
FROM assignments AS a 
		JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
		JOIN people AS p ON p.id = a.requestor_id
		JOIN contracts AS c ON c.client_id = p.id
WHERE ai.incident_type_id = 1708
		AND DATE (a.created) BETWEEN '2023-07-01' AND '2023-07-31'