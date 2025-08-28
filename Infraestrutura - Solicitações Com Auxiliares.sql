SELECT
r.tags AS protocolo,
p."name" AS tecnico_responsalvel,
t.title AS equipe_colaborador,
trim(
   regexp_replace(
   regexp_replace(r."description", '.*<br>-{5,}<br>\s*', ''), 
      '<[^>]*>', '', 'g')) AS auxiliar_reportado

      
FROM reports AS r
JOIN assignments AS a ON a.id = r.assignment_id
JOIN people AS p ON p.id = a.responsible_id
JOIN v_users AS v ON v.tx_id = p.tx_id
JOIN teams AS t ON t.id = v.team_id


WHERE
  DATE (r.created) BETWEEN '2025-07-01' AND '2025-07-31'
  AND r.title LIKE '%Auxilio no atendimento%'
  AND r.tags != '3106917'
  AND t.id IN (4,1038,1060,1061,1062,1073)
ORDER BY r.tags
