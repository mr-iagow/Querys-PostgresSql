SELECT DISTINCT ON (ai.protocol)
ai.protocol AS protocolo,
auc.title AS site_abertura,
a.title AS titulo_abertura,
(SELECT it.title FROM incident_types AS it WHERE ai.incident_type_id = it.id) AS tipo_solicitacao,
(SELECT ins.title FROM incident_status AS ins WHERE ai.incident_status_id = ins.id) AS status_solicitacao,
DATE (a.created) AS data_abertura,
DATE (a.final_date) AS data_prazo,
CASE WHEN curdate() > a.final_date THEN 'Sim' ELSE 'Nao' END AS em_atraso,
CASE 
    WHEN substring(ai.beginning_checklist, 1, 1) = '{' THEN
        (ai.beginning_checklist::json->'0_'->>'value')
END AS check_1,
CASE 
    WHEN substring(ai.beginning_checklist, 1, 1) = '{' THEN
        (ai.beginning_checklist::json->'1_'->>'value')
END AS check_2,
CASE 
    WHEN substring(ai.beginning_checklist, 1, 1) = '{' THEN
        (ai.beginning_checklist::json->'2_'->>'value')
END AS check_3,
CASE 
    WHEN substring(ai.beginning_checklist, 1, 1) = '{' THEN
        (ai.beginning_checklist::JSON->'3_'->>'value')
END AS check_4

FROM assignments AS a
INNER JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
LEFT JOIN people AS p ON p.id = ai.client_id
LEFT JOIN contracts AS c ON c.client_id = p.id
LEFT join solicitation_category_matrices AS ssc ON ssc.id = ai.solicitation_category_matrix_id
LEFT JOIN teams AS t ON t.id = ai.team_id
LEFT JOIN authentication_sites AS auc ON auc.id = ai.authentication_site_id

WHERE a.assignment_type = 'INCI' AND ai.incident_status_id IN (1,2,9,10,11,12,13,15,100) 
AND ai.team_id IN (4, 1060, 1061, 1062)