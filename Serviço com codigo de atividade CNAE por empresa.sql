SELECT 
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = spcp.company_place_id) AS empresa,
sp.title AS servico,
sp.service_code_provided AS cod_lista_serv,
spcp.activity_code AS cod_ativ_local,
spcp.issqn AS aliquota_issqn



FROM service_products AS sp
JOIN service_products_company_places AS spcp ON spcp.service_product_id = sp.id 


WHERE  
sp.active = TRUE
AND sp.service_code_provided IS NOT NULL 

ORDER BY sp.title asc