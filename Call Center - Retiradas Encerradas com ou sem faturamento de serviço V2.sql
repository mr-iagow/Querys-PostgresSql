SELECT DISTINCT ON (ai.protocol)

ai.protocol AS protocolo,
p.name AS cliente,
p.id,
p.cell_phone_1 AS celular_1,
p.cell_phone_2 AS celular_2,
p.phone AS telefone,
pa.street AS rua,
pa.number AS numero_Casa,
pa.address_complement AS complemento,
pa.neighborhood AS bairro,
pa.city AS cidade,
pa.state AS estado,
pa.postal_code AS cep,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = a.company_place_id) AS empresa_solicitacao,
(SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_solicitacao,
(SELECT v.name FROM people AS v WHERE v.id = a.responsible_id) AS responsavel_encerramento,
DATE (a.conclusion_date) AS data_encerramento,
(SELECT ins.title FROM incident_status AS ins WHERE ins.id = ai.incident_status_id) AS status_solicitacao,
(SELECT clas.title FROM solicitation_classifications AS clas WHERE clas.id =  ai.solicitation_classification_id) AS contexto,
(SELECT pr.title FROM solicitation_problems AS pr WHERE pr.id = ai.solicitation_problem_id) AS problema,
sr.id,
CASE WHEN 
	sr.id IS NULL THEN 'Não'
	ELSE 'Sim'
END AS faturado_pela_solicitacao,
CASE 
	WHEN frt.finished = TRUE THEN 'sim'
	ELSE 'Não'
	END  AS baixado,
	CASE 
	WHEN frt.deleted = TRUE THEN 'sim'
	ELSE 'Não'
	END  AS deletado,
frt.title AS fatura_gerada,
frt.title_amount AS valor_fatura_gerada,
(SELECT fn.title FROM financers_natures AS fn WHERE fn.id = frt.financer_nature_id) AS natureza_fatura_gerada,

LAST_VALUE(r.description) OVER (PARTITION BY a.id ORDER BY r.created ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS relato_encerramento

FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id 
JOIN people AS p ON p.id = a.requestor_id
left JOIN sale_requests AS sr ON sr.client_id = p.id AND sr.financer_nature_id = 199
LEFT JOIN contracts AS c ON c.id = p.id
left JOIN contract_service_tags AS ctag ON ctag.contract_id = c.id
LEFT JOIN reports AS r ON r.assignment_id = a.id
LEFT JOIN people_addresses AS pa ON pa.person_id = p.id
left JOIN financial_receivable_titles AS frt ON frt.client_id = p.id AND frt.financer_nature_id IN (199, 127) --OR frt.financer_nature_id = 127 --AND frt.deleted = FALSE AND frt.finished = false


WHERE 

ai.incident_type_id IN (1291,1015) --onde 1291 é retirada inadimplencia e 1015 retirada normal
AND ai.incident_status_id = 4
AND a.conclusion_date BETWEEN '2024-09-01' AND '2024-09-10'
