SELECT 
(SELECT t.title FROM teams AS t WHERE t.id = it.team_id) AS equipe_vinculada,
it.title AS tipo_solicitacao,
it."code" AS cod_tipo_solicitacao,
CASE 
	WHEN it.billing = 0 THEN 'Não Permite'
	WHEN it.billing = 1 THEN 'Obrigatório'
	WHEN it.billing = 2 THEN 'Opcional'
END AS tipo_faturamento

FROM incident_types AS it 

WHERE 

--it.title LIKE '%DNET%'
--AND it."code" = '14.55'
it.team_id IN (1003,1091)
OR
it.billing = 1