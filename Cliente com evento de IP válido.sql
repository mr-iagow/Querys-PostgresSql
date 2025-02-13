SELECT DISTINCT ON (ac.contract_id)

ac.contract_id AS id_contrato,
ac.user AS pppoe,
ace.created AS data_modificacao,
aip.ip AS IP,
(SELECT v.name FROM v_users AS v where v.id = ace.created_by) AS modificado_por

FROM authentication_contracts AS ac
left JOIN authentication_contract_events AS ace ON ace.authentication_contract_id = ac.id
LEFT JOIN authentication_ips AS aip ON aip.id = ac.ip_authentication_id


WHERE 
-- ac.user = 'jardins.max'
-- AND 
ace.description LIKE '%para "168.196%'
AND DATE (ace.created) >= '2023-07-28'
-- AND ace.created_by = 258