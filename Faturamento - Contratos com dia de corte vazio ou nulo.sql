SELECT 

ct.id id_contrato,
(SELECT p.name FROM people AS p WHERE p.id = ct.client_id) cliente,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = ct.company_place_id) empresa,
ct.cut_day dia_corte,
ct.collection_day data_vencimento,
ct.v_status status,
ct.v_stage estagio,
(SELECT cd.title FROM contract_date_configurations AS cd WHERE cd.id = ct.contract_date_configuration_id) AS ciclo_faturaento



FROM contracts AS ct


--WHERE ct.cut_day IS NULL 
WHERE 
ct.v_status != 'Cancelado' and ct.v_status != 'Encerrado'
AND ct.deleted = FALSE
--AND ct.id = 100
ORDER BY ct.id desc
