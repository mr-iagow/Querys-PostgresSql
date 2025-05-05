SELECT DISTINCT ON (a.id)

	pp.name AS cliente,
	pp.phone AS telefone,
	pp.cell_phone_1 AS celular1,
	pp.cell_phone_2 AS celular2,
	pa.city AS cidade,
	pp.neighborhood AS bairro,
	ins.title AS insignia,
	DATE (a.conclusion_date) AS data_encerramento,
	cp.description AS empresa

FROM 
	assignments AS a
	JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
	JOIN incident_types AS it ON it.id = ai.incident_type_id
	JOIN people AS pp ON pp.id = a.requestor_id 
	JOIN people_addresses AS pa ON pa.person_id = pp.id
	left JOIN insignias AS ins ON ins.id = pp.insignia_id
	LEFT JOIN contracts AS ct ON ct.client_id = pp.id
	LEFT JOIN companies_places AS cp ON cp.id = ct.company_place_id

WHERE
	DATE(a.conclusion_date) BETWEEN CURRENT_DATE - INTERVAL '1 day' AND CURRENT_DATE
	AND  it.id IN (2175,1970,1971,1901,1899,1900)
	AND ai.incident_status_id = 4