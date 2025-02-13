SELECT 
	p.id AS id_cliente,
	p."name" AS nome_lead,
	p.cell_phone_1 AS celular_1,
	p.cell_phone_2 AS celular_2,
	p.email AS email,
	(SELECT v.name FROM people AS v WHERE v.id = pci.proprietary_id) AS responsavel,
	(SELECT v.name FROM v_users AS v WHERE v.id =  pci.created_by) AS criado_por,
	DATE(pci.created) AS data_criacao_lead,
	DATE (pci.modified) AS data_apropriacao,
	DATE (pci.crm_discard_date) AS data_descarte,
	cl.people_status_description AS status_lead,
	cl.people_crm_information_crm_discart_motive_title AS motivo_descarte

FROM 
	people_crm_informations AS pci
JOIN 
	people AS p ON p.id = pci.person_id
left JOIN 
	v_crm_leads AS cl ON cl.people_id = p.id

WHERE 
	DATE (pci.created) BETWEEN '$criacao1' AND '$criacao2'
	AND pci.crm_contact_origin_id = 3
	AND pci.created_by = 681