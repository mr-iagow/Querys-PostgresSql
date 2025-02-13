SELECT DISTINCT ON (c.id,ap.id,asp.id)
(SELECT p.name FROM people AS p WHERE p.id = c.client_id) AS cliente,
(SELECT aac.title FROM authentication_access_points AS aac WHERE aac.id = ac.authentication_access_point_id) AS ponto_de_acesso,
ac.slot_olt AS slot_olt,
ac.port_olt AS porta_olt,
ap.title AS splitter,
ap.out_ports AS quantidade_portas,
asp.port AS porta_utilizada,
ap.lat AS latitude_caixa,
ap.lng AS longitude_caixa,
ac.lat AS latitude_conexao,
ac.lng AS longitude_conexao
  		  		
FROM authentication_splitters AS ap
JOIN authentication_splitter_ports AS asp ON asp.authentication_splitter_id = ap.id
LEFT JOIN authentication_contracts AS ac on ac.id = asp.authentication_contract_id
LEFT JOIN  contracts AS c ON c.id = ac.contract_id
left JOIN people_addresses AS pa ON pa.person_id = c.client_id

--WHERE c.client_id = 152978