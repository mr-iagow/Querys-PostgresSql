SELECT DISTINCT ON (frt.title)
p.name AS cliente,
frt.title AS titulo,
fn.title AS natureza_financeira,
fo.title AS operacao_financeira,
frt.complement as complemento,
frt.title_amount AS valor_titulo,
frt.original_expiration_date AS data_original_vencimento,
frt.expiration_date AS data_vencimento,
CASE 
  WHEN frt.deleted = TRUE THEN 'Título Cancelado'
  WHEN frt2.receipt_date IS NULL THEN 'Em Aberto'
  ELSE TO_CHAR(frt2.receipt_date, 'DD/MM/YYYY')
END AS recebimento,
CASE WHEN frt.deleted = FALSE THEN 'Nao' ELSE 'Sim' END AS deletado,
frto."description" AS evento,
v."name" AS deletado_por,
CASE WHEN frt.finished = TRUE THEN 'Sim' ELSE 'Nao' END AS baixado


FROM financial_receivable_titles AS frt
LEFT JOIN people AS p ON p.id = frt.client_id
LEFT JOIN contracts AS ct ON ct.client_id = frt.client_id
LEFT JOIN financial_receipt_titles AS frt2 ON frt2.financial_receivable_title_id = frt.id
LEFT JOIN financial_receivable_title_occurrences AS frto ON frto.financial_receivable_title_id = frt.id AND frto.financial_title_occurrence_type_id = 28
LEFT JOIN v_users AS v ON v.id = frto.created_by
LEFT JOIN financers_natures AS fn ON fn.id = frt.financer_nature_id
LEFT JOIN financial_operations AS fo ON fo.id = frt.financial_operation_id


WHERE frt.title LIKE '%FAT%'
AND frt.expiration_date BETWEEN '2026-04-01' AND '2026-04-30'
AND ct.contract_type_id IN (24,25,26,27,30,32,34,46,55)
--and FRT.TITLE = 'FAT250916152726518'