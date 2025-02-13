SELECT DISTINCT on (pa.product_acquisition_request_id)

pa.product_acquisition_request_id AS numero_pedido,
(SELECT pn.name FROM people AS pn WHERE pn.id = p.supplier_id) AS fornecedor,
p.total_request AS total_pedido,
p.date AS data_criacao,
p.observation AS descricao_pedido,
CASE 
WHEN p."status" = 2 THEN 'Aguardando aprovacao'
WHEN p."status" = 9 THEN 'Rejeitado'
WHEN p."status" = 3 THEN 'Aprovado'
WHEN p."status" = 4 THEN 'Aguardando Entrega'
WHEN p."status" = 5 THEN 'Recebido'
END AS status_pedido,
SUBSTRING(p.observation, 'CENTRO DE CUSTO: (.*?)\n') AS centro_custo,
SUBSTRING(p.observation, 'FORMA DE PAGAMENTO: (.*?)\n') AS forma_pagamento,
(SELECT v.name FROM people AS v WHERE v.id = p.approver_id) AS aprovador,
(SELECT pp.name FROM v_users AS pp where pp.id = p.modified_by) AS deletado_por,
 p.deleted AS deletado

FROM product_acquisition_request_items  AS pa
LEFT JOIN product_acquisition_requests AS p  ON p.id = pa.product_acquisition_request_id

--WHERE DATE (p.date) BETWEEN '2024-04-01' AND '2024-04-04' 
--AND p.deleted = FALSE 