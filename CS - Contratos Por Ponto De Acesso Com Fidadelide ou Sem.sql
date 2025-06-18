SELECT 
p."name" AS cliente,
(SELECT sp.title FROM service_products AS sp WHERE sp.id = ac.service_product_id) AS plano,
c.amount AS valor_plano,
cst.service_tag AS etiqueta_contrato,
CASE WHEN caa.activation_date IS NULL THEN DATE (c.created) ELSE caa.activation_date END AS data_ativacao,
curdate()  - c.beginning_date AS qtd_dias_contrato,
CASE 
    WHEN MAX(pu.final) >= CURDATE() THEN 'Com fidelidade' 
    ELSE 'Sem fidelidade' 
END AS fidadelidade

from authentication_contracts AS ac 
LEFT JOIN contracts AS c ON c.id = ac.contract_id
JOIN people AS p ON p.id = c.client_id
JOIN contract_service_tags AS cst ON cst.id = ac.service_tag_id
LEFT JOIN people_uploads AS pu ON pu.people_id = p.id AND pu.documentation_type_id = 8
left JOIN contract_assignment_activations AS caa ON caa.contract_id = c.id

WHERE 
ac.authentication_access_point_id IN(113,268) 
AND c.contract_type_id NOT IN (6)
AND c.v_status != 'Cancelado'

GROUP BY 1,2,3,4,5,6