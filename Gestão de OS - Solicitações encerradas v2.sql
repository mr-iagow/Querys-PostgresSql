SELECT DISTINCT ON (ai.protocol)
(SELECT v.name FROM people AS v WHERE v.id = a.responsible_id) AS atendente,
(SELECT v.name FROM v_users AS v WHERE v.id = a.created_by) AS atendente_origem,
pa.neighborhood AS bairro_do_cliente,
(SELECT cs.title FROM catalog_services AS cs WHERE cs.id = ai.catalog_service_id) AS catalogo_de_servicos,
ai.final_checklist AS checklist_final,
ai.beginning_checklist AS checklist_inicial,
pa.city AS cidade_do_cliente,
p.name as cliente,
(SELECT sc.title from solicitation_classifications AS sc WHERE sc.id = ai.solicitation_classification_id) AS contexto,
a.responsible_id AS cod_atendente,
p.id AS cod_cliente,
(SELECT v.id FROM v_users AS v WHERE v.id = a.management_id) AS cod_gerente_equipe,
a.created_by AS cod_solicitante,
a.id AS codigo,
DATE (a.created) AS dt_abertura,
date(a.conclusion_date) AS dt_conclusao,
DATE (ai.feedback_date) AS dt_feedback,
DATE (ai.beginning_service_date) AS dt_incio_atendimento,
date(a.final_date) AS dt_prazo





FROM assignments AS a 
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
	left JOIN people AS p ON p.id = ai.client_id
	JOIN people_addresses AS pa ON pa.person_id = p.id

WHERE 
DATE (a.conclusion_date) BETWEEN '2024-03-27' AND '2024-03-27'
and ai.team_id IN (1003)
AND ai.incident_status_id IN (4)