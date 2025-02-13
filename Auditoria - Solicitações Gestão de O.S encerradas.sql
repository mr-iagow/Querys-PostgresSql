WITH relato_data AS (
    SELECT 
        rp.assignment_id,
        rp.final_date,
        DATE(FIRST_VALUE(rp.final_date) OVER (
            PARTITION BY rp.assignment_id
            ORDER BY rp.assignment_id ASC
            RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        )) AS data_primeiro_relato_encerramento,
        (SELECT v.name FROM v_users AS v WHERE v.id = rp.created_by) AS relatado_por
    FROM 
        reports AS rp
    WHERE 
        rp.progress >= 100
)

SELECT DISTINCT ON (ai.protocol)
    ai.protocol AS protocolo,
    p.name as cliente,
    (SELECT it.title FROM incident_types AS it WHERE ai.incident_type_id = it.id) AS tipo_solicitacao,
    (SELECT v.name FROM people AS v WHERE v.id = a.responsible_id) AS atendente,
    DATE(a.created) AS data_abertura,
    DATE(a.conclusion_date) AS data_encerramento,
    r.data_primeiro_relato_encerramento,
    relatado_por AS primeiro_atendente

   from assignments AS a 
   JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
   left JOIN people AS p ON p.id = a.requestor_id
   left JOIN people_addresses AS pa ON pa.person_id = p.id
   left JOIN relato_data AS r ON r.assignment_id = ai.assignment_id

WHERE 
    ai.team_id IN (1003)
    AND ai.incident_status_id IN (4)
    AND DATE (a.conclusion_date) BETWEEN '2024-07-01' AND '2024-07-15'
    