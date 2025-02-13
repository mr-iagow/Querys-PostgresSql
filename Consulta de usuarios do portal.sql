SELECT 

pu.person_id AS id_cliente,
p.name AS cliente,
p.tx_id AS CPF,
pu.username AS usuario,
pu.active AS ativo_inativo,
pu.created AS data_criacao,
pu.last_portal_login AS data_ultimo_login_portal,
pu.last_app_login AS data_ultimo_login_app,
(SELECT v.name FROM v_users AS v where v.id = pu.created_by) AS usuario_criador

FROM person_users AS pu
JOIN people AS p  ON p.id = pu.person_id


