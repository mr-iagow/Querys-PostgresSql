SELECT DISTINCT ON (c.id)
    ac.contract_id,
   		(SELECT p.name FROM people AS p WHERE p.id = c.client_id) AS cliente,
   		c.v_status AS status_contrato,
   		(SELECT serv.title FROM service_products AS serv WHERE serv.id = ac.service_product_id) AS plano,
   		(SELECT autc.title FROM authentication_concentrators AS autc WHERE autc.id = ac.authentication_concentrator_id) AS concentrador,
   		(SELECT aac.title FROM authentication_access_points AS aac WHERE aac.id = ac.authentication_access_point_id) AS ponto_de_acesso,
   		pa.latitude as latitude_cliente,
   		pa.longitude AS longitude_cliente,
    ac.slot_olt AS slot_olt,
    ac.port_olt AS porta_olt,
    ap.title AS splitter,
    ap.out_ports AS quantidade_portas,
    asp.port AS porta_utilizada,
    ap.lat AS latitude_caixa,
    ap.lng AS longitude_caixa,
    ac.lat AS latitude_conexao,
    ac.lng AS longitude_conexao

FROM authentication_contracts AS ac
LEFT JOIN authentication_splitter_ports AS asp ON asp.authentication_contract_id = ac.id
LEFT JOIN authentication_splitters AS ap ON ap.id = asp.authentication_splitter_id
JOIN contracts AS c ON c.id = ac.contract_id
LEFT JOIN service_products AS sp ON sp.id = ac.service_product_id
JOIN people_addresses AS pa ON pa.person_id = c.client_id


WHERE sp.huawei_profile_name = '700M_STANDARD'