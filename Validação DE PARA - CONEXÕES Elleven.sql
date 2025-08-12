SELECT 

adl.title AS address_list,
act.title AS concentrador,
ac.city AS cidade_conexao,
ac.neighborhood AS bairro_conexao,
ac.postal_code AS cep_conexao,
ac."reference" AS referencia_conexão,
ac.street AS rua_conexao,
ac.street_number AS numero_rua_conexao,
CASE 
	WHEN ac.equipment_type = 1 THEN 'Mikrotik'
	WHEN ac.equipment_type = 2 THEN 'Ubiquit'
	WHEN ac.equipment_type = 3 THEN 'Intelbras'
	WHEN ac.equipment_type = 4 THEN 'Parks'
	WHEN ac.equipment_type = 5 THEN 'Huawei'
	WHEN ac.equipment_type = 6 THEN 'FiberHome'
	WHEN ac.equipment_type = 7 THEN 'Zte'
	WHEN ac.equipment_type = 8 THEN 'Datacom'
	WHEN ac.equipment_type = 9 THEN 'Digistar'
	WHEN ac.equipment_type = 10 THEN 'Nokia'
	WHEN ac.equipment_type = 11 THEN 'Gigatelco'
	WHEN ac.equipment_type = 12 THEN 'Raisecom'
	WHEN ac.equipment_type = 0 THEN 'Não Informado'
END AS tipo_equipamento,
acp.title AS ponto_de_acesso,
ac.equipment_port AS porta_web,
CASE
	WHEN ac.connection_type = 1 THEN 'pppoe'
	WHEN ac.connection_type = 2 THEN 'outro'
END AS tipo_conexao,
CASE 
	WHEN ac.ip_type = 1 THEN 'fixo'
	WHEN ac.ip_type = 2 THEN 'ce'
	WHEN ac.ip_type = 3 THEN 'pool'
END AS tipo_ip,
ac.user AS usuario_pppoe,
ac.password AS senha_pppoe

FROM authentication_contracts AS ac
JOIN authentication_address_lists AS adl ON adl.id = ac.authentication_address_list_id
JOIN authentication_concentrators AS act ON act.id = ac.authentication_concentrator_id
JOIN authentication_access_points AS acp ON acp.id = ac.authentication_access_point_id 

WHERE 

ac.user = 'franciscoiagoo'