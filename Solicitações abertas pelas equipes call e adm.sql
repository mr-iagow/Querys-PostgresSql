SELECT DISTINCT ON (ai.protocol)
p.id AS cod_pessoa,
ai.protocol AS protocolo,
p.city AS cidade,
p.neighborhood AS bairro,
a.created AS data_abertura,
a.conclusion_date AS data_encerramento,
(SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_solicitacao,
a.description AS descricao_solicitacao,
(SELECT v.name FROM v_users AS v WHERE v.id = a.created_by) aberto_por,
(SELECT v.name FROM v_users AS v WHERE v.id = a.modified_by) encerrado_por,
(SELECT t.title FROM teams AS t WHERE t.id = ai.origin_team_id) AS equipe_abertura,
(SELECT t.title FROM teams AS t WHERE t.id = ai.team_id)AS equipe_encerramento,
(SELECT ist.title FROM incident_status AS ist WHERE ist.id = ai.incident_status_id) AS status_solicitacao

FROM assignments AS a
inner JOIN
	assignment_incidents AS ai ON a.id = ai.assignment_id
inner JOIN
	people AS p ON p.id = ai.client_id
inner JOIN
	reports AS r ON a.id = r.assignment_id
inner JOIN 
	teams AS t ON t.id = ai.team_id

WHERE 
	DATE(a.created) BETWEEN '2022-12-20' AND '2023-01-02'
	AND ai.team_id = 1003
	/*AND ai.origin_team_id <> 1043
	AND ai.origin_team_id <> 2*/
	AND ai.origin_team_id NOT IN (1043,2,1050,1051,1070,1065,1010,1004,1030,1069)
	/*AND ai.origin_team_id <> 1003*/
	/*AND ai.origin_team_id IN (1039,1037,1040,1006)*/