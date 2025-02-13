SELECT DISTINCT ON (ct.id)

ct.id AS id_contrato,
p.name AS cliente,
ct.v_stage AS estagio_contrato,
ct.v_status AS status_contrato,
(SELECT cti.title FROM contract_types AS cti WHERE cti.id = ct.contract_type_id) AS tipo_contrato,
CASE WHEN 
	ct.automatic_blocking = FALSE THEN 'bloqueio inativo'
	ELSE 'bloqueio ativo'
END AS bloqueio

FROM contracts AS ct
JOIN people AS p ON p.id = ct.client_id

WHERE

ct.automatic_blocking = FALSE 
