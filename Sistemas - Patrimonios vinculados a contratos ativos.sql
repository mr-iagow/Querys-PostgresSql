SELECT DISTINCT ON (c.id,pat.id)
ctag.service_tag AS etiqueta_contrato,
c.id AS id_contrato,
p.name AS cliente,
pat.title AS tipo_equipamento,
pat.serial_number  serial,
pat.tag_number numero_patrimonio,
c.v_status  status_contrato,
ac.mac AS mac_autenticada_erp

FROM contracts AS c
INNER JOIN people AS p ON p.id = c.client_id
JOIN patrimonies AS pat ON pat.contract_id = c.id
LEFT JOIN authentication_contracts AS ac ON ac.contract_id = c.id
LEFT JOIN contract_service_tags AS ctag ON ctag.contract_id = c.id

WHERE

c.v_status != 'Cancelado'
--AND c.id = 27399
--AND p.name = 'VALDECI MEDEIROS FREIRES'
