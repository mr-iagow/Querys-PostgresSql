SELECT 

(SELECT aal.title FROM authentication_address_lists AS aal WHERE aal.id = ct.authentication_address_list_id) AS address_list,
(SELECT ac.title FROM authentication_concentrators AS ac WHERE ac.id = ct.authentication_concentrator_id) AS concentrador,
ct.street AS rua_conexao,
ct.street_number AS numero_rua_conexao,
ct.neighborhood AS bairro_conexao,
ct.city AS cidade_conexao,
ct.postal_code AS cep_conexao,
ct.complement AS complemento,
ct.audition_info,
CASE 
	WHEN ct.equipment_type = 1 THEN 'Mikrotik'
	WHEN ct.equipment_type = 2 THEN 'Ubiquit'
	WHEN ct.equipment_type = 3 THEN 'Intelbras'
	WHEN ct.equipment_type = 4 THEN 'Parks'
	WHEN ct.equipment_type = 5 THEN 'Huawei'
	WHEN ct.equipment_type = 6 THEN 'FiberHome'
	WHEN ct.equipment_type = 7 THEN 'Zte'
	WHEN ct.equipment_type = 8 THEN 'Datacom'
	WHEN ct.equipment_type = 9 THEN 'Digistar'
	WHEN ct.equipment_type = 10 THEN 'Nokia'
	WHEN ct.equipment_type = 11 THEN 'Gigatelco'
	WHEN ct.equipment_type = 12 THEN 'Raisecom'
	WHEN ct.equipment_type = 0 THEN 'Não Informado'
END AS tipo_equipamento,	
(SELECT acp.title FROM authentication_access_points AS acp WHERE acp.id = ct.authentication_access_point_id) AS ponto_de_acesso,
ct.equipment_port AS porta_web,
CASE
	WHEN ct.connection_type = 1 THEN 'pppoe'
	WHEN ct.connection_type = 2 THEN 'outro'
END AS tipo_conexao,
CASE 
	WHEN ct.ip_type = 1 THEN 'fixo'
	WHEN ct.ip_type = 2 THEN 'ce'
	WHEN ct.ip_type = 3 THEN 'pool'
END AS tipo_ip,
aip.ip AS IP,
ct.user AS pppoe,
ct.password AS senha_pppoe

FROM contracts AS cc
JOIN authentication_contracts AS ct ON ct.contract_id = cc.id
LEFT JOIN authentication_ips AS aip ON aip.id = ct.ip_authentication_id

WHERE cc.company_place_id = 12
--AND ct.user = 'fzidara0704'