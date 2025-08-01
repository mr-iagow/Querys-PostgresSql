SELECT 

ht.trackid AS protocolo,
case 
	when ht.`status` = 0 then 'novo'
	when ht.`status` = 1 then 'aguardando_resposta'
	when ht.`status` = 2 then 'respondido'
 	when ht.`status` = 3 then 'resolvido'
	when ht.`status` = 4 then 'em_progresso'
	when ht.`status` = 5 then 'em_espera'
	when ht.`status` = 6 then 'cancelado'
END AS status_protocolo,
(SELECT hc.name FROM hesk_categories AS hc WHERE hc.id = ht.category) AS tipo_solicitacao,
ht.name AS aberto_por,
ht.email AS email_colaborador,
ht.subject AS assunto,
DATE (ht.dt) AS data_abertura,
ht.custom51 AS plano_escolho,
ht.custom52 AS nome_colaborador,
FROM_UNIXTIME (ht.custom53) AS data_nascimento_beneficiario,
ht.custom54 AS sexo_beneficiario,
ht.custom55 AS nome_mae_beneficiario,
ht.custom56 AS nome_pai_beneficiario,
ht.custom57 AS cpf_beneficiario,
ht.custom58 AS rg_beneficiario,
ht.custom59 AS orgao_emissor,
ht.custom60 AS estado_civil_beneficiario,
ht.custom61 AS municipio_beneficiario,
ht.custom62 AS bairro_beneficiario,
ht.custom63 AS cpf_beneficiario,
ht.custom64 AS email_beneficiario,
ht.custom65 AS contato_beneficiario,
ht.custom66 AS telefone_beneficiario,
ht.custom104 AS grau_parentesco_dependente,
ht.custom68 AS nome_completo_dependente,
FROM_UNIXTIME (ht.custom69) AS data_nascimento_dependente,
ht.custom70 AS sexo_dependente,
ht.custom71 AS nome_mae_dependente,
ht.custom72 AS nome_pai_dependente,
ht.custom73 AS cpf_dependente,
ht.custom74 AS rg_dependente,
ht.custom75 AS contato_dependente


FROM hesk_tickets AS ht


WHERE 

ht.category = 79
AND DATE (ht.dt) BETWEEN '$data01' AND '$data02'