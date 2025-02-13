SELECT DISTINCT
c.id AS num_contrato,
p.name AS cliente,
(SELECT tt.name FROM tx_types AS tt WHERE tt.id = p.type_tx_id) AS tipo_cliente,
p.tx_id AS cpf,
(SELECT cet.title FROM contract_event_types AS cet WHERE ce.contract_event_type_id = cet.id) AS tipo_reativacao,
CASE WHEN ce.created = '0001-01-01 00:00:00' THEN ce.date WHEN ce.created != '0001-01-01 00:00:00' THEN ce.created END AS dia_reativacao

FROM contracts AS c
INNER JOIN people AS p ON c.client_id = p.id
LEFT JOIN contract_items AS con ON c.id = con.contract_id
INNER JOIN contract_events AS ce ON c.id = ce.contract_id
INNER JOIN contract_event_types AS cet ON cet.id = ce.contract_event_type_id

WHERE date(ce.created) BETWEEN '2023-01-01' AND '2023-04-19'
--cast(date_trunc('month', current_date-INTERVAL '100 month') as date) AND DATE(curdate())
AND ce.contract_event_type_id IN (204,205,106)