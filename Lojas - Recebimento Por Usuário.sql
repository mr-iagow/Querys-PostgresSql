-- Recebimentos por usuário (baixado = NÃO) — mesmo critério do CRE – Recebimentos do Voalle
-- Período: data de recebimento | Usuário: quem registrou a baixa (created_by)
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
JOIN users                      AS u   ON u.id   = fatr.created_by
LEFT JOIN payment_forms         AS pf  ON pf.id  = fatr.payment_form_id
WHERE fat.deleted       = FALSE
  AND fat.type          = 2          -- título a receber
  AND fat.bill_title_id IS NULL      -- fora de renegociação
  AND fat.title_loss    = 0          -- não está em perda
  AND fatr.deleted      = FALSE
  AND fatr.finished     = FALSE      -- baixado = NÃO
  AND fn.signal         = 1          -- natureza de receita
  AND fatr.receipt_date BETWEEN '2026-08-18' AND '2026-11-18'
  AND fatr.created_by IN (
      1087,  -- JEFFERSON OLIVEIRA DIAS
      893,   -- LUANA DE SOUSA MONTEIRO
      78,    -- LUNARA CUNHA DE FREITAS DOS ANJOS
      222,   -- VANESSA DA COSTA ABREU
      649,   -- ALISSON RODRIGO LIMA TEIXEIRA
      76,    -- BEATRIZ FREIRE ABREU
      75,    -- GIZELI DOS SANTOS VERCOSA
      489,   -- DIONELIA DE OLIVEIRA FREITAS DANTAS
      1130,  -- ANA GABRIELLY ALVES MENEZES
      570,   -- THALITA RODRIGUES DA SILVA SANTOS
      1074,  -- FRANCISCA SAMARA DUARTE CRUZ
      712,   -- CRISLANE ALMEIDA MATOS
      1303,  -- MARIA JULIANA VIDAL MELO
      1305,  -- VITÓRIA MACIEL BATISTA
      1196,  -- MARIA CLARA ALBUQUERQUE PIMENTEL FORTE
      1099,  -- ANDRESSA MAGALHÃES MARTINS
      1097,  -- FABIANE BARBOSA TEIXEIRA
      1068,  -- VITORIA RODRIGUES PINHEIRO BRAGA
      1110,  -- CAMILE SUZANE OLIVEIRA LIMA
      1184,  -- LENA BARBARA DA SILVA FERREIRA
      346,   -- MARIA THALYA BATISTA FERREIRA GADELHA
      196,   -- DANIELE MARTINS BATISTA
      72,    -- HELAYNE ELLEN DE PAULO ARAÚJO
      1171,  -- RENATA LINS BIA DA SILVA
      832,   -- CARLA LARISSA SILVA DO NASCIMENTO
      85,    -- ANA LÍDIA DA COSTA SANTOS FERREIRA
      83,    -- GLEICIANE PEIXOTO DA GUIA
      531,   -- ANTONIO ROMARIO NUNES DA SILVA
      1259,  -- THAYNARA DE OLIVEIRA ALENCAR
      1258,  -- DEBORA DA SILVA FERREIRA
      1100,  -- JOSENIA MARIA PACHECO MAGALHÃES
      1045   -- ARNALDO LOPES PEREIRA
  )
ORDER BY u.name, fatr.receipt_date, fat.title;
