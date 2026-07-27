SELECT DISTINCT ON (ai.protocol)
ai.protocol AS protocolo,
isi.title AS status,
it.title AS tipo_solicitacao,
a.created AS data_abertura,
a.conclusion_date AS data_encerramento,
vv.name AS encerrado_por,
CASE
   WHEN EXTRACT(EPOCH FROM (a.conclusion_date - a.final_date)) < 0 THEN '-'
   ELSE ''
		END ||
   	FLOOR(ABS(EXTRACT(EPOCH FROM (a.conclusion_date - a.final_date))) / 86400)::int || 'd ' ||
   	LPAD(FLOOR(MOD(ABS(EXTRACT(EPOCH FROM (a.conclusion_date - a.final_date)))::numeric, 86400) / 3600)::int::text, 2, '0') || 'h ' ||
    	LPAD(FLOOR(MOD(ABS(EXTRACT(EPOCH FROM (a.conclusion_date - a.final_date)))::numeric, 3600) / 60)::int::text, 2, '0') || 'min'
    AS sla_atraso,
CASE 
	WHEN a.conclusion_date IS NOT NULL AND a.conclusion_date > a.final_date THEN 'Fora do prazo'
   WHEN a.conclusion_date IS NULL AND a.final_date < CURRENT_DATE THEN 'Fora do prazo'
   ELSE 'No Prazo'
END AS status_sla,
v.name AS aberto_por,
t.title AS equipe

FROM assignments AS a 
INNER JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
LEFT JOIN people AS p ON p.id = ai.client_id
JOIN incident_types AS it ON it.id = ai.incident_type_id
JOIN v_users AS v ON v.id = a.created_by
JOIN v_users AS vv ON vv.id = a.modified_by 
LEFT JOIN people AS pp ON pp.id = a.responsible_id
JOIN teams AS t ON t.id = ai.team_id 
JOIN incident_status AS isi ON isi.id = ai.incident_status_id

WHERE
    ai.team_id IN (4,1062,1061,1060)
     AND a.created >= '2026-07-01' 
     AND a.created <= '2026-07-10'
 ORDER BY ai.protocol