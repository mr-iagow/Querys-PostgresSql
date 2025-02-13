SELECT DISTINCT ON (c.id)                                     
c.id AS cod_contrato,                                         
p.id AS cod_cliente,  
(SELECT sp.title FROM service_products AS sp WHERE sp.id = ci.service_product_id) AS plano, 
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = c.company_place_id) AS local_contrato,                                 
P.cell_phone_1 AS numero_01,                                  
p.phone AS numero_02,                                         
p.name AS nome,                                               
c.v_status AS status_contrato,                                
c.created,                                                    
p.city AS cidade,                                             
p.neighborhood AS bairro,                                     
c.amount AS valor_contrato,                                   
pat.title                                       
                                                              
                                                              
FROM contracts AS c                                           
LEFT JOIN                                                     
	authentication_contracts  AS ci ON c.id = ci.contract_id   
INNER JOIN                                                    
	people AS p ON c.client_id = p.id                          
LEFT JOIN                                                     
	people_uploads AS pu ON pu.people_id = p.id   
LEFT JOIN
	patrimonies AS pat ON pat.contract_id = c.id             
                                                              
	                                                           
                                                              
WHERE                                                         
	c.v_stage ='Aprovado'                                      
	 AND c.v_status  IN  ('Normal','Bloqueio Financeiro')                                        
	 AND c.contract_type_id <> 13                              
	 AND p.type_tx_id <>1                                       
	 AND c.created <= '2022-04-14'                             
    AND p.type_tx_id <> 1                                       
	 AND c.company_place_id NOT IN  (3,11,12) 
	 --AND pat.patrimony_type_id <> 1
	                            
	                     
	                                                           
                                                                              
GROUP BY (1,2,3,4,5,6,7,8,9,10,ci.service_product_id),pat.title         
                                                              
HAVING MAX (pu.final) <='2024-08-01' OR MAX (pu.final) IS NULL