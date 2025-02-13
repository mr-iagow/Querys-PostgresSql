SELECT 

sp.id AS id_servico,
sp."code" AS cod_erp,
sp.title AS servico,
sp.selling_price AS valor_venda


FROM service_products AS sp

WHERE

sp.title LIKE '%DNET%'
AND sp.huawei_profile_name IS NULL
AND sp.vendible = TRUE
AND sp.title NOT LIKE '%ADESI%'