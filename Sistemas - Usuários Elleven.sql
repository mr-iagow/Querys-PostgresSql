SELECT 

v."name" AS nome_colaborador,
v.tx_id AS cpf_colaborador,
CASE WHEN v."active" = TRUE THEN 'sim' ELSE 'nao' END AS usuario_ativo

FROM v_users AS v

WHERE v.deleted = FALSE 
AND v."name" NOT ILIKE '%FIELD%'
AND v."name" NOT ILIKE '%teste%'
AND v.login NOT ILIKE '%teste%'
AND v.name NOT ILIKE '%ESTOQUE%'
AND v."name" NOT ILIKE '%integra%'
AND v."name" NOT ILIKE '%ultrab%'
AND v."name" NOT ILIKE '%jarbis%'
AND v."name" NOT ILIKE '%zapisp%'
AND v."name" NOT ILIKE '%ROTEIRIZADOR%'
AND v."name" NOT ILIKE '%agendame%'
AND v."name" NOT ILIKE '%aprend%'
AND v."name" NOT ILIKE '%bellun%'
AND v."name" NOT ILIKE '%Bot Controladoria%'