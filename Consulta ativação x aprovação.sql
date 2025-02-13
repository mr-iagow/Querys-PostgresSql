SELECT DISTINCT ON (c.id)
c.id AS id_contrato,
p.name AS cliente,
(SELECT cet.title FROM contract_event_types AS cet WHERE cet.id = ce.contract_event_type_id) AS evento,
TO_CHAR (ca.activation_date, 'DD/MM/YY') AS data_ativação,
TO_CHAR (ce.date, 'DD/MM/YY') AS data_aprovacao,
TO_CHAR (AGE (ce.date, ca.activation_date),'DD') AS dias,
CASE 
WHEN TO_CHAR (AGE (ce.date, ca.activation_date), 'DD') <='02' THEN 'No prazo'
WHEN TO_CHAR (AGE (ce.date, ca.activation_date), 'DD') >='03'  THEN 'Fora do prazo'
END AS status_sla

FROM
	contract_assignment_activations AS ca
INNER JOIN 
	contracts AS c ON ca.contract_id = c.id
INNER JOIN
	contract_events AS ce ON c.id = ce.contract_id
INNER JOIN
	people AS p ON c.client_id = p.id
	
WHERE
ce.deleted = false
AND ce.contract_event_type_id = 3
AND ce.date BETWEEN '2022-11-01 00:00:01' AND '2022-11-30 23:59:59' 

	
	

	
	
	/*GROUP BY (c.id, ca.contract_id, p.name,p.neighborhood, p.city, c.created,c.amount,ca.activation_date,c.v_status,fpt.title_amount,fpt.expiration_date,frt.receipt_date  )*/
	

