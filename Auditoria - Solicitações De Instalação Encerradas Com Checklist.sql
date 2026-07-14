SELECT DISTINCT ON (ai.assignment_id)
ai.protocol AS protocolo,
p.id AS cod_pessoa,
p.name AS nome_cliente,
pa.city AS cidade,
pa.neighborhood AS bairro,
pa.latitude,
pa.longitude,
itt.title AS tipo_solicitacao,
ins.title AS status_solicitacao,
DATE(a.created) AS data_abertura,
DATE(a.final_date) AS data_prazo,
CASE
   WHEN DATE(a.conclusion_date) <= DATE(a.final_date) THEN 'Não'
	WHEN DATE(a.conclusion_date) > DATE(a.final_date) THEN 'Sim'
END AS em_atraso,
pp2.name AS responsavel,
  CASE 
  WHEN SPLIT_PART(SPLIT_PART(ai.final_checklist, '"value":"', 2), '"', 1) = '1' THEN 'Sim'
  WHEN SPLIT_PART(SPLIT_PART(ai.final_checklist, '"value":"', 2), '"', 1) = '0' THEN 'Não'
  ELSE SPLIT_PART(SPLIT_PART(ai.final_checklist, '"value":"', 2), '"', 1)
  END AS endereco_correto,
  SPLIT_PART(SPLIT_PART(ai.final_checklist, '"value":"', 3),  '"', 1) AS numero_caixa,
  SPLIT_PART(SPLIT_PART(ai.final_checklist, '"value":"', 4),  '"', 1) AS numero_porta,
  CASE 
  WHEN SPLIT_PART(SPLIT_PART(ai.final_checklist, '"value":"', 5), '"', 1) = '1' THEN 'Sim'
  WHEN SPLIT_PART(SPLIT_PART(ai.final_checklist, '"value":"', 5), '"', 1) = '0' THEN 'Não'
  ELSE SPLIT_PART(SPLIT_PART(ai.final_checklist, '"value":"', 5), '"', 1)
  END AS verificacao_de_caixa,
  SPLIT_PART(SPLIT_PART(ai.final_checklist, '"value":"', 6),  '"', 1) AS sinal_da_cto,
  SPLIT_PART(SPLIT_PART(ai.final_checklist, '"value":"', 7),  '"', 1) AS sinal_do_cliente,
  SPLIT_PART(SPLIT_PART(ai.final_checklist, '"value":"', 8),  '"', 1) AS conector_verde,
  SPLIT_PART(SPLIT_PART(ai.final_checklist, '"value":"', 9),  '"', 1) AS conector_azul,
  SPLIT_PART(SPLIT_PART(ai.final_checklist, '"value":"', 10), '"', 1) AS fixa_fio,
  SPLIT_PART(SPLIT_PART(ai.final_checklist, '"value":"', 11), '"', 1) AS canaleta,
  SPLIT_PART(SPLIT_PART(ai.final_checklist, '"value":"', 12), '"', 1) AS esticador,
  SPLIT_PART(SPLIT_PART(ai.final_checklist, '"value":"', 13), '"', 1) AS adesivo_conector,
  SPLIT_PART(SPLIT_PART(ai.final_checklist, '"value":"', 14), '"', 1) AS rj45,
  SPLIT_PART(SPLIT_PART(ai.final_checklist, '"value":"', 15), '"', 1) AS cabo_de_rede,
  SPLIT_PART(SPLIT_PART(ai.final_checklist, '"value":"', 16), '"', 1) AS ont_mac,
  SPLIT_PART(SPLIT_PART(ai.final_checklist, '"value":"', 17), '"', 1) AS onu_mac,
  SPLIT_PART(SPLIT_PART(ai.final_checklist, '"value":"', 18), '"', 1) AS roteador_mac,
  SPLIT_PART(SPLIT_PART(ai.final_checklist, '"value":"', 19), '"', 1) AS drop_cabo_inicial,
  SPLIT_PART(SPLIT_PART(ai.final_checklist, '"value":"', 20), '"', 1) AS drop_cabo_final,
  SPLIT_PART(SPLIT_PART(ai.final_checklist, '"value":"', 21), '"', 1) AS drop_metragem,
  CASE 
  WHEN SPLIT_PART(SPLIT_PART(ai.final_checklist, '"value":"', 22), '"', 1) = '1' THEN 'Sim'
  WHEN SPLIT_PART(SPLIT_PART(ai.final_checklist, '"value":"', 22), '"', 1) = '0' THEN 'Não'
  ELSE SPLIT_PART(SPLIT_PART(ai.final_checklist, '"value":"', 22), '"', 1)
  END AS teve_faturamento,
  SPLIT_PART(SPLIT_PART(ai.final_checklist, '"value":"', 23), '"', 1) AS valor_se_houver,
  SPLIT_PART(SPLIT_PART(ai.final_checklist, '"value":"', 24), '"', 1) AS servico,
cat.title AS cat_1,
t.title AS equipe_solicitacao,
CASE WHEN a.reopen = 1 THEN 'sim' ELSE 'não' END AS solicitacao_poossui_alguma_reabertura

FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
JOIN people AS p ON p.id = a.requestor_id
JOIN incident_status AS ins ON ins.id = ai.incident_status_id
JOIN incident_types AS itt ON itt.id = ai.incident_type_id
LEFT JOIN people AS pp2 ON pp2.id = a.responsible_id
LEFT JOIN v_users AS origem ON origem.id = a.created_by
LEFT JOIN contract_service_tags AS ctag ON ctag.id = ai.contract_service_tag_id
LEFT JOIN contracts AS cc ON cc.id = ctag.contract_id
LEFT JOIN people_addresses AS pa ON pa.id = cc.people_address_id
LEFT JOIN solicitation_category_matrices AS ssc ON ssc.id = ai.solicitation_category_matrix_id
LEFT JOIN solicitation_service_categories AS cat ON cat.id = ssc.service_category_id_1
JOIN teams AS t ON t.id = ai.team_id
WHERE ai.team_id IN (1003, 1098, 1091, 1145, 1149)
    AND a.conclusion_date >= '2026-07-01'
    AND a.conclusion_date <= '2026-07-15'
    AND ai.incident_status_id != '8'
    AND itt.id IN (2175,1970,1971,2534,2535,2536,1901,1899,1900,2331,1005,1006,2482,2500,2498,2380,2379,2388,2389,2390,2391,2332,2288,2271)
ORDER BY ai.assignment_id