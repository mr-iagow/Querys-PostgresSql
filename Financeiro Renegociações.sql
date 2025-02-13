SELECT  DISTINCT ON (fat1.id)
p.name AS nome,
DATE (fat1.date) AS data_negociacao,
(SELECT com.description FROM companies_places AS com WHERE fat1.company_place_id = com.id) AS empresa,
fat1.total_amount_renegotiated AS valor_original,
fat1.total_amount_generated AS valor_novo,
fat1.renegotiation_diff AS desconto_acrescimo,
  CASE
    WHEN fat1.total_amount_generated < fat1.total_amount_renegotiated THEN
      ROUND((fat1.total_amount_generated - fat1.total_amount_renegotiated) / fat1.total_amount_renegotiated * 100)::INTEGER
    WHEN fat1.total_amount_generated > fat1.total_amount_renegotiated THEN
      ROUND((fat1.total_amount_generated - fat1.total_amount_renegotiated) / fat1.total_amount_renegotiated * 100)::INTEGER
    ELSE
      0
  END AS percentual_desconto,
(SELECT CASE  WHEN ren.type = 0  THEN  MAX (ren.expiration_date) END AS TESTE  FROM financial_renegotiation_titles AS ren  INNER JOIN financial_renegotiations AS fat ON fat.id = ren.financial_renegotiation_id WHERE fat.client_id = fat1.client_id AND ren.financial_renegotiation_id = fat1.id GROUP BY ren.type,ren.type LIMIT 1) AS vencimento_original,
fat1.total_titles_renegotiated AS titulos_renegociados,
fat2.title AS titulo_gerado,
fat2.parcel AS parcela,
max(fat.expiration_date) AS vencimento_novo,
CASE WHEN fat2.balance = 0 THEN 'Pago' WHEN fat.balance != 0 THEN 'Em aberto' END AS status_pgt,
(SELECT vu.name FROM v_users AS vu WHERE fat1.created_by = vu.id) usuario_renegociacao,
CASE WHEN fat1.deleted = TRUE THEN 'Sim' ELSE 'Não' END AS excluido



FROM financial_renegotiations AS fat1
INNER JOIN financial_renegotiation_titles AS fat ON fat.financial_renegotiation_id = fat1.id	
INNER JOIN financial_receivable_titles AS fat2 ON fat2.id = fat.financial_receivable_title_id
INNER JOIN people AS p ON fat1.client_id = p.id

WHERE
fat.type = 1
AND fat2.renegotiated = FALSE
AND date(fat1.date) BETWEEN '$renegociacao01' AND '$renegociacao02'
GROUP BY fat1.id, 1,2,3,4,5,6,8,9,10,11,13,14,15