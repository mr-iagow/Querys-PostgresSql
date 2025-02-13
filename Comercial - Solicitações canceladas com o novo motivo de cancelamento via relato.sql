SELECT DISTINCT ON (cst.contract_id)
    c.id AS id_contrato,
    (SELECT p.name FROM people AS p WHERE p.id = a.requestor_id) AS cliente,
    ai.protocol AS protocolo,
    DATE(a.created) AS data_abertura_os,
    (SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_solicitacao,
    (SELECT ins.title FROM incident_status AS ins WHERE ins.id = ai.incident_status_id) AS status,
    (select ppp.name from people AS ppp where ppp.id = C.seller_1_id) AS vendedor,
    CASE WHEN ppg.people_group_id IS NULL THEN NULL ELSE (SELECT pg.title FROM people_groups AS pg WHERE pg.id = ppg.people_group_id) END AS equipe,
    LAST_VALUE(UPPER(r.description)) OVER (PARTITION BY cst.contract_id ORDER BY r.created ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ultimo_relato,
    LAST_VALUE(DATE(r.created)) OVER (PARTITION BY cst.contract_id ORDER BY r.created ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS data_ultimo_relato,
    (select pp.name from people as pp where pp.id = a.responsible_id) responsavel,
     SUBSTRING_INDEX(SUBSTRING_INDEX(UPPER(LAST_VALUE(r.description) OVER (PARTITION BY cst.contract_id ORDER BY r.created ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)), '||', 1), '<P>', -1) AS teste,
      TRIM(REPLACE(SUBSTRING_INDEX(SUBSTRING_INDEX(UPPER(LAST_VALUE(r.description) OVER (PARTITION BY cst.contract_id ORDER BY r.created ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)), '||', 1), '<P>', -1), '</P>', '')) AS ultimo_relato

FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
LEFT JOIN contract_service_tags AS cst ON cst.id = ai.contract_service_tag_id
JOIN contracts AS c ON c.id = cst.contract_id
JOIN v_users AS v ON v.id = a.created_by
LEFT JOIN people AS pp ON pp.id = a.created_by
JOIN reports AS r ON r.assignment_id = a.id
LEFT JOIN person_people_groups AS ppg ON ppg.person_id = c.seller_1_id

WHERE
    ai.incident_type_id IN (21, 1006, 1005)
    AND DATE(a.created) BETWEEN '2024-04-15' AND '2024-04-20'
    AND ai.incident_status_id = 8
    AND r.progress >= 200
    --AND ai.protocol = 2327723;
