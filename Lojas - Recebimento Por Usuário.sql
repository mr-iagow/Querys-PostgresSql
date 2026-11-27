-- Recebimentos em DINHEIRO (baixado = NÃO) — todos os usuários
-- Mesmo critério do CRE – Recebimentos do Voalle
SELECT
    u.name                                   AS usuario,
    fat.title                                AS fatura,
    pf.title                                 AS forma_pagamento,
    fat.expiration_date                      AS data_vencimento,
    fatr.receipt_date                        AS data_recebimento,
    CASE EXTRACT(DOW FROM fatr.receipt_date)
        WHEN 0 THEN 'Domingo'
        WHEN 1 THEN 'Segunda-feira'
        WHEN 2 THEN 'Terça-feira'
        WHEN 3 THEN 'Quarta-feira'
        WHEN 4 THEN 'Quinta-feira'
        WHEN 5 THEN 'Sexta-feira'
        WHEN 6 THEN 'Sábado'
    END                                      AS dia_semana,
    (fatr.amount + fatr.fine_amount + fatr.increase_amount - fatr.discount_value) AS total_recebido
FROM financial_receipt_titles AS fatr
JOIN financial_receivable_titles AS fat ON fat.id = fatr.financial_receivable_title_id
JOIN financers_natures          AS fn  ON fn.id  = fat.financer_nature_id
LEFT JOIN users                 AS u   ON u.id   = fatr.created_by
JOIN payment_forms              AS pf  ON pf.id  = fatr.payment_form_id
WHERE fat.deleted       = FALSE
  AND fat.type          = 2          -- título a receber
  AND fat.bill_title_id IS NULL      -- fora de renegociação
  AND fat.title_loss    = 0          -- não está em perda
  AND fatr.deleted      = FALSE
  AND fatr.finished     = FALSE      -- baixado = NÃO
  AND fn.signal         = 1          -- natureza de receita
  AND fatr.payment_form_id = 1       -- Dinheiro
  AND fatr.receipt_date BETWEEN '2026-08-18' AND '2026-11-18'
ORDER BY fatr.receipt_date, fat.title;
