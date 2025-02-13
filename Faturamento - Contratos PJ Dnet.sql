SELECT 

con.id AS id_contrato,
p.name AS cliente,
con.v_status AS status_contrato,
(SELECT ct.title FROM contract_types AS ct WHERE ct.id = con.contract_type_id) AS tipo_contrato,
con.collection_day AS vencimento_contrato

FROM contracts AS con

INNER JOIN people AS p ON p.id = con.client_id


WHERE 
	con.v_status NOT IN ('Cancelado')
	AND con.company_place_id = 12
	AND con.v_stage = 'Aprovado'
	AND p.type_tx_id <> 2