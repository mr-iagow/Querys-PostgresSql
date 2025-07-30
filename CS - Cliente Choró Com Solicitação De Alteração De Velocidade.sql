SELECT 
ai.protocol AS protocolo,
c.v_status AS status_contrato,
p."name" AS cliente,
it.title AS tipo_solicitacao,
a.created AS data_abertura,
DATE (a.created) AS data_abertura_sem_horario

FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
JOIN incident_types AS it ON it.id = ai.incident_type_id
JOIN people AS p ON p.id = ai.client_id
left JOIN contract_service_tags AS ctag ON ctag.id = ai.contract_service_tag_id
LEFT JOIN contracts AS c ON c.id = ctag.contract_id


WHERE

p.code_city_id in (2303931)
AND DATE (a.created) BETWEEN '2025-06-24' AND '2025-07-30'
AND it.id IN (2273,1604,2222,51,52, 1327, 2018, 2156, 2155, 2174, 2222, 2153, 2154, 2157, 2024, 2014, 2016, 1776, 1308, 1397, 1328, 1017, 1821, 1330, 2091, 2124, 2125, 1991, 1992, 1398, 1606, 1822, 2100, 2099, 2101, 1974, 1975, 1604, 1605, 52,51, 2100,1823, 2274,2273, 2275)