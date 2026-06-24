SELECT DISTINCT
 ai.protocol AS protocolo,
    cst.service_tag AS etiqueta_protocolo,
    c.contract_number AS numero_contrato,
    ct.title AS tipo_contrato,
    cp."description" AS empresa,
    ppp.name AS cliente,
    it.title AS tipo_solicitacao,
--t2.id,
    v.name AS usuario_abertura,
    t.title AS equipe_usuario
FROM assignments AS aa
JOIN assignment_incidents AS ai ON ai.assignment_id = aa.id
JOIN reports AS r_origem ON r_origem.assignment_id = aa.id 
    AND r_origem.created_by = aa.created_by
    AND r_origem.title = 'Atendimento solicitação'
JOIN reports AS r_volta ON r_volta.assignment_id = aa.id
    AND r_volta.created_by != aa.created_by
    AND r_volta.team_id = r_origem.team_id
    AND r_volta.title = 'Encaminhamento de Solicitação'
    AND r_volta.created > r_origem.created
LEFT JOIN v_users AS v ON v.id = aa.created_by
LEFT JOIN incident_types AS it ON it.id = ai.incident_type_id
LEFT JOIN people AS ppp ON ppp.id = aa.requestor_id
LEFT JOIN contract_service_tags AS cst ON cst.id = ai.contract_service_tag_id
LEFT JOIN contracts AS c ON c.id = cst.contract_id
LEFT JOIN contract_types AS ct ON ct.id = c.contract_type_id
LEFT JOIN companies_places AS cp ON cp.id = c.company_place_id
LEFT JOIN teams AS t ON t.id = v.team_id
LEFT JOIN incident_types AS ittt ON ittt.id = ai.incident_type_id
LEFT JOIN teams AS t2 ON t2.id = ai.team_id

WHERE 
    DATE(aa.created) BETWEEN '2026-05-01' AND '2026-06-19'
    	 AND v.team_id NOT IN (6)
	 --AND ai.team_id = 1004   
--ORDER BY aa.created DESC;
