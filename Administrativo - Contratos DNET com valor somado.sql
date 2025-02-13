SELECT 
cp.description AS empresa,
COUNT (*) AS quantidade_contrato,
SUM (ct.amount) AS valor_contratos

FROM contracts AS ct
JOIN companies_places AS cp on cp.id = ct.company_place_id

WHERE 

ct.company_place_id = 12
AND ct.v_status != 'Cancelado'
AND ct.v_stage = 'Aprovado'

GROUP BY 1