WITH produtos AS (
    SELECT unnest(ARRAY[349, 343, 3242, 341, 336, 361]) AS id
),
notas AS (
    SELECT inv.*
    FROM invoice_notes inv
    WHERE inv.product_acquisition_request_id IS NOT NULL
      AND DATE(inv.entry_date) BETWEEN '2026-01-01' AND '2026-11-05'
),
linhas AS (
    -- itens do pedido (fonte principal)
    SELECT n.id AS inv_id, pari.service_product_id AS prod_id,
           pari.units AS quantidade, pari.unit_amount AS val_unitario, 'Pedido'::text AS origem
    FROM notas n
    JOIN product_acquisition_request_items pari ON pari.product_acquisition_request_id = n.product_acquisition_request_id
    WHERE pari.service_product_id IN (SELECT id FROM produtos)
    UNION ALL
    -- produto recebido na nota mas cadastrado com outro código no pedido
    SELECT n.id, it.service_product_id, SUM(it.units), it.unit_amount, 'Nota'
    FROM notas n
    JOIN invoice_note_items it ON it.invoice_note_id = n.id
    WHERE it.service_product_id IN (SELECT id FROM produtos)
      AND NOT EXISTS (SELECT 1 FROM product_acquisition_request_items x
                      WHERE x.product_acquisition_request_id = n.product_acquisition_request_id
                        AND x.service_product_id = it.service_product_id)
    GROUP BY n.id, it.service_product_id, it.unit_amount
)
SELECT inv.product_acquisition_request_id AS numero_pedido,
       inv.document_number                AS dcto,
       cp.description                     AS local,
       sp.title                           AS produto_descricao,
       CASE WHEN pv.qtd > 0 THEN pv.qtd ELSE pa.qtd END AS numero_parcelas,
       COALESCE(pv.primeira, pa.primeira) AS data_primeira_parcela,
       fn.title                           AS nat_financeira,
       inv.entry_date::date               AS entrada,
       inv.issue_date::date               AS emissao,
       l.val_unitario,
       l.quantidade,
       p.name                             AS fornecedor,
       inv.total_amount_gross             AS total_nota,
       COALESCE(pv.soma, pa.soma)         AS soma_parcelas,
       CONCAT_WS(' / ',
         CASE WHEN l.origem = 'Nota' THEN 'Produto consta só na nota (no pedido está com outro código)' END,
         CASE WHEN pv.qtd = 0 AND pa.qtd > 0 THEN 'Títulos lançados manualmente, sem vínculo com a nota' END,
         CASE WHEN ABS(COALESCE(pv.soma, pa.soma, 0) - inv.total_amount_gross) > 1
              THEN 'Soma das parcelas difere do total da nota (devolução/desconto/troca)' END
       ) AS observacao
FROM linhas l
JOIN invoice_notes inv          ON inv.id = l.inv_id
JOIN service_products sp        ON sp.id = l.prod_id
JOIN companies_places cp        ON cp.id = inv.company_place_id
LEFT JOIN people p              ON p.id = inv.supplier_id
LEFT JOIN financers_natures fn  ON fn.id = inv.financer_nature_id
-- parcelas vinculadas à nota (Pedido > Recebido - DCTO > Parcelas)
LEFT JOIN LATERAL (
    SELECT COUNT(*) AS qtd, MIN(t.expiration_date)::date AS primeira, SUM(t.title_amount) AS soma
    FROM financial_payable_titles t
    WHERE t.invoice_note_id = inv.id AND NOT COALESCE(t.deleted, false)
) pv ON true
-- fallback: títulos do mesmo fornecedor com o número do documento, sem vínculo
LEFT JOIN LATERAL (
    SELECT COUNT(*) AS qtd, MIN(t.expiration_date)::date AS primeira, SUM(t.title_amount) AS soma
    FROM financial_payable_titles t
    WHERE pv.qtd = 0
      AND t.invoice_note_id IS NULL
      AND t.supplier_id = inv.supplier_id
      AND t.title = inv.document_number::text
      AND NOT COALESCE(t.deleted, false)
) pa ON true
ORDER BY inv.entry_date, inv.product_acquisition_request_id, sp.title;
