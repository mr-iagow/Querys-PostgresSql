SELECT 
c.id AS id_contrato,
p.name AS nomme,
p.tx_id AS cpf,
CASE
	WHEN c.generate_only_title = 0 THEN 'Não'
	WHEN c.generate_only_title <> 0 THEN 'Sim'
	END AS gerar
FROM contracts AS C
JOIN people AS p ON p.id = c.client_id

WHERE c.generate_only_title <> 0
AND c.v_status != 'Cancelado'