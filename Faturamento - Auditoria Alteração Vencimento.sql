SELECT DISTINCT ON (ai.protocol,cev.id)
p.name AS cliente,
it.title AS tipo_solicitacao,
c.contract_number AS numero_contrato,
c.amount AS valor_contrato,
ai.protocol AS protocolo,
a.description AS relato_abertura,
v.name AS responsavel_abertura,
DATE (a.created) AS data_abertura,
DATE (a.conclusion_date) AS data_encerramento,
pp.name AS responsavel_encerramento,
ins.title AS status_solicitacao,
REGEXP_REPLACE(cet_filtrado."description", '.* Vencimento (\d+) para .*', '\1')  AS vencimento_antigo,
REGEXP_REPLACE(cet_filtrado."description", '.* para Vencimento (\d+).*', '\1')   AS vencimento_novo,
cet_filtrado.title AS tipo_evento,
cet_filtrado.id AS tipo_evento_id,
CASE 
	WHEN cet_filtrado.id IN (15, 16)
   	AND DATE(cet_filtrado.created) >= DATE(a.conclusion_date)
   	THEN 'Sim'
      ELSE 'Não'
END AS tem_evento_pos_encerramento_solicitacao,
(SELECT v.name FROM v_users AS v WHERE v.id = cev.created_by) AS usuario_criador_eventual,
cev.total_amount AS valor_eventual,
cev.description AS descricao_eventual,
cev.justification AS justificativa_eventual,
LAST_VALUE(frt.title) OVER (PARTITION BY p.id ORDER BY frt.created ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ultima_fatura_gerada,
LAST_VALUE(frt.expiration_date) OVER (PARTITION BY p.id ORDER BY frt.created ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS vencimento_ultima_fatura_gerada,
LAST_VALUE(frt.document_amount) OVER (PARTITION BY p.id ORDER BY frt.created ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS valo_ultima_fatura_gerada

FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
JOIN incident_types AS it ON it.id = ai.incident_type_id
LEFT JOIN contract_service_tags cst ON cst.id = ai.contract_service_tag_id
JOIN contracts c ON c.id = cst.contract_id
JOIN people AS p ON p.id = a.requestor_id
JOIN incident_status AS ins ON ins.id = ai.incident_status_id
JOIN people AS pp ON pp.id = a.responsible_id
JOIN v_users AS v ON v.id = a.created_by
LEFT JOIN (
    SELECT ce.contract_id, ce.description, ce.created, cet.title, cet.id
    FROM contract_events ce
    JOIN contract_event_types cet 
        ON cet.id = ce.contract_event_type_id
    WHERE cet.id IN (15, 16)
) AS cet_filtrado 
    ON cet_filtrado.contract_id = c.id
LEFT JOIN contract_eventual_values AS cev ON cev.contract_id = c.id AND cev.deleted = FALSE AND DATE (cev.created) >= DATE (a.conclusion_date)
LEFT JOIN financial_receivable_titles AS frt ON frt.client_id = p.id AND frt.title LIKE '%FAT%'


WHERE
    it.id IN (2102, 53, 1976, 1977)
    AND DATE(a.conclusion_date) BETWEEN '2026-03-20' AND '2026-03-23'