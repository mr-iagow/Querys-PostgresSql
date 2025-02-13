SELECT DISTINCT ON (cev.id)
cev.month_year AS competencia,
cev.description AS descricao,
cev.contract_id AS contrato,
CASE
WHEN cev.type  = 1  THEN 'Acrescimo'
WHEN cev.type  = 2  THEN 'Desconto'
END AS tipo_eventual,
c.amount AS valor_plano,
cev.total_amount AS valor_eventual,
CASE
WHEN  cev.invoiced = TRUE THEN 'Faturado'
WHEN  cev.invoiced = FALSE THEN 'Nao_faturado'
END AS status_eventual,
p.city AS cidade,
(SELECT cp.description FROM companies_places AS cp WHERE  c.company_place_id = cp.id) AS LOCAL,
cev.justification AS justificativa,
CASE
	WHEN cev.created_by = 3  THEN 'VOALLE'
	WHEN cev.created_by <> 3  THEN (SELECT v.name FROM v_users AS v WHERE cev.created_by = v.id)
END AS Responsavel_eventual


FROM contract_eventual_values AS cev

INNER JOIN
	contracts AS c ON cev.contract_id = c.id
INNER JOIN
	people AS p ON c.client_id = p.id


WHERE cev.month_year = '2023-01-01'
AND cev.deleted = FALSE
AND cev.invoiced = TRUE
AND cev.type  = 2 
