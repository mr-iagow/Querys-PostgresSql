SELECT 
    ai.protocol,
    split_part(split_part(ai.beginning_checklist, '"value":"', 2), '"', 1) AS fornecedor,
    split_part(split_part(ai.beginning_checklist, '"value":"', 3), '"', 1) AS cnpj_cpj,
    split_part(split_part(ai.beginning_checklist, '"value":"', 4), '"', 1) AS endereco_completo,
    split_part(split_part(ai.beginning_checklist, '"value":"', 5), '"', 1) AS telefone,
    split_part(split_part(ai.beginning_checklist, '"value":"', 6), '"', 1) AS email,
    split_part(split_part(ai.beginning_checklist, '"value":"', 7), '"', 1) AS emite,
    split_part(split_part(ai.beginning_checklist, '"value":"', 8), '"', 1) AS local_empresa_pagadora,
    split_part(split_part(ai.beginning_checklist, '"value":"', 9), '"', 1) AS forma_de_pagamento,
    split_part(split_part(ai.beginning_checklist, '"value":"', 10), '"', 1) AS dados_bancarios,
    split_part(split_part(ai.beginning_checklist, '"value":"', 11), '"', 1) AS valor,
    split_part(split_part(ai.beginning_checklist, '"value":"', 12), '"', 1) AS solicitante,
    split_part(split_part(ai.beginning_checklist, '"value":"', 13), '"', 1) AS motivo_da_solicitacao,
    split_part(split_part(ai.beginning_checklist, '"value":"', 14), '"', 1) AS centro_de_custo,
    split_part(split_part(ai.beginning_checklist, '"value":"', 15), '"', 1) AS data_de_pagamento,
    (SELECT p.name FROM people AS p where p.id = ai.client_id) AS cliente
FROM 
    assignments AS a 
JOIN 
    assignment_incidents AS ai ON ai.assignment_id = a.id
WHERE 
    ai.protocol = 2310660;
