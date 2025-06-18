SELECT DISTINCT ON (ai.protocol)
it.title AS tipo_solicitacao,
ai.protocol AS protocolo,
CASE WHEN cet.id IN (184,214) THEN 'Involuntario' ELSE 'Voluntário' END AS tipo_cancelamento,
p."name" AS cliente,
ins.title AS status,
DATE (a.created) AS data_abertura,
DATE (a.conclusion_date) AS data_encerramento,
pa.city AS cidade,
pa.neighborhood AS bairro,
pa.street AS rua,
pa."number" AS numero


FROM incident_types AS it
JOIN assignment_incidents AS ai ON ai.incident_type_id = it.id
JOIN assignments AS a ON a.id = ai.assignment_id
JOIN people AS p ON p.id = ai.client_id
JOIN incident_status AS ins ON ins.id = ai.incident_status_id
JOIN people_addresses AS pa ON pa.person_id = p.id
LEFT JOIN contracts AS c ON c.client_id = p.id
INNER JOIN contract_events AS ce ON c.id = ce.contract_id
INNER JOIN contract_event_types AS cet ON cet.id = ce.contract_event_type_id AND cet.id IN (110,154,156,157,158,159,163,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,186,190,192,195,196,197,198,199,200,201,202,203,225,226,243,246,251,261,296,311,310,309,308,307,306,305,304,316,315,314,313,312,320,319,318,317,324,323,322,321,330,328,327,326,325,329,214)


WHERE 

it.id IN (1015,1271,1291,1972,2065)
AND DATE (a.created) BETWEEN '2025-01-01' AND '2025-05-31'