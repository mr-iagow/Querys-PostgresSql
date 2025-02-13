SELECT DISTINCT ON (ai.protocol)
ai.protocol AS protocolo,
DATE (a.conclusion_date) AS data_encerramento,
a.description AS relato_abertura,
LAST_VALUE(r.description) OVER (PARTITION BY a.id ORDER BY r.created ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS relato_encerramento,
    (ai.final_checklist::jsonb)->'0_'->>'label' AS chek_1,
        CASE 
            WHEN (ai.final_checklist::jsonb)->'0_'->>'value' = '1' THEN 'sim'
            WHEN (ai.final_checklist::jsonb)->'0_'->>'value' = '0' THEN 'Nao'
        END AS resposta,
            (ai.final_checklist::jsonb)->'1_'->>'label' AS chek_2,
        CASE 
            WHEN (ai.final_checklist::jsonb)->'1_'->>'value' = '1' THEN 'sim'
            WHEN (ai.final_checklist::jsonb)->'1_'->>'value' = '0' THEN 'Nao'
        END AS resposta,
            (ai.final_checklist::jsonb)->'2_'->>'label' AS chek_3,
        CASE 
            WHEN (ai.final_checklist::jsonb)->'2_'->>'value' = '1' THEN 'sim'
            WHEN (ai.final_checklist::jsonb)->'2_'->>'value' = '0' THEN 'Nao'
        END AS resposta,
            (ai.final_checklist::jsonb)->'3_'->>'label' AS chek_4,
        CASE 
            WHEN (ai.final_checklist::jsonb)->'3_'->>'value' = '1' THEN 'sim'
            WHEN (ai.final_checklist::jsonb)->'3_'->>'value' = '0' THEN 'Nao'
        END AS resposta,
            (ai.final_checklist::jsonb)->'4_'->>'label' AS chek_5,
        CASE 
            WHEN (ai.final_checklist::jsonb)->'4_'->>'value' = '1' THEN 'sim'
            WHEN (ai.final_checklist::jsonb)->'4_'->>'value' = '0' THEN 'Nao'
        END AS resposta,
            (ai.final_checklist::jsonb)->'5_'->>'label' AS chek_6,
        CASE 
            WHEN (ai.final_checklist::jsonb)->'5_'->>'value' = '1' THEN 'sim'
            WHEN (ai.final_checklist::jsonb)->'5_'->>'value' = '0' THEN 'Nao'
        END AS resposta,
            (ai.final_checklist::jsonb)->'6_'->>'label' AS chek_7,
        CASE 
            WHEN (ai.final_checklist::jsonb)->'6_'->>'value' = '1' THEN 'sim'
            WHEN (ai.final_checklist::jsonb)->'6_'->>'value' = '0' THEN 'Nao'
        END AS resposta,
            (ai.final_checklist::jsonb)->'7_'->>'label' AS chek_8,
        CASE 
            WHEN (ai.final_checklist::jsonb)->'7_'->>'value' = '1' THEN 'sim'
            WHEN (ai.final_checklist::jsonb)->'7_'->>'value' = '0' THEN 'Nao'
        END AS resposta,
            (ai.final_checklist::jsonb)->'8_'->>'label' AS chek_9,
        CASE 
            WHEN (ai.final_checklist::jsonb)->'8_'->>'value' = '1' THEN 'sim'
            WHEN (ai.final_checklist::jsonb)->'8_'->>'value' = '0' THEN 'Nao'
        END AS resposta,
            (ai.final_checklist::jsonb)->'9_'->>'label' AS chek_10,
        CASE 
            WHEN (ai.final_checklist::jsonb)->'9_'->>'value' = '1' THEN 'sim'
            WHEN (ai.final_checklist::jsonb)->'9_'->>'value' = '0' THEN 'Nao'
        END AS resposta,
            (ai.final_checklist::jsonb)->'10_'->>'label' AS chek_11,
				(ai.final_checklist::jsonb)->'10_'->>'value' AS resposta,
            (ai.final_checklist::jsonb)->'11_'->>'label' AS chek_12,
            (ai.final_checklist::jsonb)->'11_'->>'value' AS resposta,
            (ai.final_checklist::jsonb)->'12_'->>'label' AS chek_13,
				(ai.final_checklist::jsonb)->'12_'->>'value' AS resposta,
            (ai.final_checklist::jsonb)->'13_'->>'label' AS chek_14,
            (ai.final_checklist::jsonb)->'13_'->>'value' AS resposta
   

FROM assignments AS a
JOIN  assignment_incidents AS ai ON ai.assignment_id = a.id
JOIN reports AS r ON r.assignment_id = a.id
WHERE 
    DATE (a.conclusion_date) BETWEEN '2025-01-01' AND '2025-01-16'
    AND ai.incident_type_id = 2215 --AUDITORIA DE QUALIDADE DE LOJAS
	 AND ai.protocol != '2818220'
