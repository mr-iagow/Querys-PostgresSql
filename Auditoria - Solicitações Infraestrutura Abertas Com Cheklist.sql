SELECT DISTINCT ON (ai.protocol)
ai.protocol AS protocolo,
ins.title as status_solicitacao,
it.title AS tipo_solicitacao,
v.name AS aberto_por,
DATE (a.created) AS data_abertura,
DATE (a.conclusion_date) AS data_encerramento,
(SELECT p.name FROM people AS p WHERE p.id = a.responsible_id ) AS tecnico_responsavel,
a.description AS relato_abertura,
   		   (ai.final_checklist::jsonb)->'0_'->>'label' AS chek_1,
				(ai.final_checklist::jsonb)->'0_'->>'value' AS resposta_1,
            (ai.final_checklist::jsonb)->'1_'->>'label' AS chek_2,
			   CASE 
            WHEN (ai.final_checklist::jsonb)->'1_'->>'value' = '1' THEN 'sim'
            WHEN (ai.final_checklist::jsonb)->'1_'->>'value' = '0' THEN 'Nao'
       		END AS resposta_2,
            (ai.beginning_checklist::jsonb)->'0_'->>'label' AS chek_3,
				(ai.beginning_checklist::jsonb)->'0_'->>'value' AS resposta_3
   
FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
LEFT JOIN reports AS r ON r.assignment_id = a.id
JOIN incident_status as ins on ins.id = ai.incident_status_id
JOIN incident_types AS it ON it.id = ai.incident_type_id
JOIN v_users AS v ON v.id = a.created_by

WHERE 
    DATE (a.created) BETWEEN '2025-07-01' AND '2025-10-30'
    AND ai.team_id = 4 