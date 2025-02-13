SELECT
    mes_ano_emissao,
    subquery.client_city AS cidade,
    SUM(subquery.total_valor_liquido) AS total_valor_liquido
FROM (
    SELECT
        DATE_FORMAT(notas.out_date, '%Y-%m') AS mes_ano_emissao,
        notas.client_city,
        notas.document_number,
        SUM(DISTINCT notas.total_amount_liquid) AS total_valor_liquido
    FROM 
        invoice_notes AS notas
    INNER JOIN 
        people AS p ON p.id = notas.client_id
    LEFT JOIN 
        contracts AS c ON c.client_id = p.id
    WHERE 
        date(notas.out_date) BETWEEN '2024-02-01' AND '2024-02-29'
        AND notas.financial_operation_id IN (1,15,25,26,34,46,63,65)
        AND notas."status" NOT IN (4,5,3,9,10)
        AND notas.id NOT IN (975130)
    GROUP BY 
        DATE_FORMAT(notas.out_date, '%Y-%m'), notas.client_city, notas.document_number
) AS subquery
GROUP BY 
    mes_ano_emissao, subquery.client_city;