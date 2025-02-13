SELECT 
c.id AS cod_contrato,
DATE (ce.created) AS data_evento,
(SELECT cet.title FROM contract_event_types AS cet WHERE cet.id = ce.contract_event_type_id) AS tipo_evento,
ce.description AS descricao_desbloqueio,
	CASE 
	WHEN ce.created_by = 0 THEN 'Voalle - Syntesis'
	WHEN ce.created_by <> 0 THEN (SELECT p.name FROM v_users AS p WHERE p.id = ce.created_by)
	END AS responsavel_desbloqueio,
p.city AS cidade



FROM contracts AS c 
inner JOIN contract_events AS ce ON ce.contract_id = c.id
inner JOIN people AS p ON p.id = c.client_id 

WHERE 
-- c.id = 3580
-- AND 
ce.contract_event_type_id IN (40,41)
AND date(ce.created) BETWEEN '01-01-2023' AND '31-01-2023'
