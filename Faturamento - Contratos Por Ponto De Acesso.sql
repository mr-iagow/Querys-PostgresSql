SELECT DISTINCT ON (cst.service_tag)
p."name" AS cliente,
c.contract_number AS contrato,
cp."description" AS empresa,
c.v_status AS status_contrato,
(SELECT sp.title FROM service_products AS sp WHERE sp.id = ac.service_product_id) AS plano,
c.amount AS valor_contrato,
(SELECT fo.title FROM financial_operations AS fo WHERE fo.id = c.operation_id) AS operacao_contrato,
(SELECT fn.title FROM financers_natures AS fn WHERE fn.id = c.financer_nature_id) AS natureza_contrato,
cst.service_tag AS etiqueta_contrato

from authentication_contracts AS ac 
LEFT JOIN contracts AS c ON c.id = ac.contract_id
JOIN people AS p ON p.id = c.client_id
JOIN contract_service_tags AS cst ON cst.id = ac.service_tag_id
LEFT JOIN people_uploads AS pu ON pu.people_id = p.id AND pu.documentation_type_id = 8
left JOIN contract_assignment_activations AS caa ON caa.contract_id = c.id
JOIN companies_places AS cp ON cp.id = c.company_place_id

WHERE 
ac.authentication_access_point_id IN(113,268) 
--AND c.contract_type_id NOT IN (6)
AND c.v_status != 'Cancelado'

--GROUP BY 1,2,3,4,5,6