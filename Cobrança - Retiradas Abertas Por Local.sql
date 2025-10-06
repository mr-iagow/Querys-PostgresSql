SELECT DISTINCT ON (ai.protocol)
cp."description" AS empresa,
p.id AS cod_cliente,
it.title AS tipo_solicitacao,
ai.protocol AS protocolo,
LAST_VALUE(rp.description) OVER (PARTITION BY a.id ORDER BY rp.created ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ultimo_relato,
(SELECT p.name FROM people AS p WHERE p.id = a.responsible_id ) AS responsavel_encerramento,
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
LEFT JOIN companies_places AS cp ON cp.id = c.company_place_id
LEFT JOIN reports AS rp ON rp.assignment_id = a.id

WHERE 

it.id IN (1015,1271,1291,1972,2065)
AND cp.id = 10 -- LOCAL EMX (Palmares)
--AND p."name" != 'RAFAEL LIMA BARROS'
