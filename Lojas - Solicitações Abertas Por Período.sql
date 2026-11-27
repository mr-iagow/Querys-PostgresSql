SELECT
    ai.protocol                                   AS protocolo,
    cli.name                                      AS cliente,
    cli.phone 												  AS telefone,
    cli.cell_phone_1 									  AS celular_1,
    cli.cell_phone_2 									  AS celular_1,
    it.title                                      AS tipo_solicitacao,
    to_char(a.created, 'DD/MM/YYYY')              AS data_abertura,
    CASE EXTRACT(ISODOW FROM a.created)
        WHEN 1 THEN 'Segunda' WHEN 2 THEN 'Terça'  WHEN 3 THEN 'Quarta'
        WHEN 4 THEN 'Quinta'  WHEN 5 THEN 'Sexta'  WHEN 6 THEN 'Sábado'
        ELSE 'Domingo'
    END                                           AS dia_semana,
    to_char(a.created, 'HH24:MI:SS')              AS hora_abertura,
    criador.name                                  AS responsavel_abertura,
    t.title                                       AS equipe,
    isi.title                                     AS status,
    ct.title                                      AS tipo_contrato,
    -- empresa do contrato; sem contrato, a empresa da própria solicitação
    COALESCE(cpc.description, cpa.description)    AS empresa
FROM assignments a
JOIN assignment_incidents ai          ON ai.assignment_id = a.id
LEFT JOIN people cli                  ON cli.id = ai.client_id
LEFT JOIN v_users criador             ON criador.id = a.created_by
LEFT JOIN incident_types it           ON it.id = ai.incident_type_id
LEFT JOIN teams t                     ON t.id = ai.team_id
LEFT JOIN incident_status isi         ON isi.id = ai.incident_status_id
LEFT JOIN contract_service_tags cst   ON cst.id = ai.contract_service_tag_id
LEFT JOIN contracts c                 ON c.id = cst.contract_id
LEFT JOIN contract_types ct           ON ct.id = c.contract_type_id
LEFT JOIN companies_places cpc        ON cpc.id = c.company_place_id
LEFT JOIN companies_places cpa        ON cpa.id = a.company_place_id
WHERE ai.team_id IN (1, 1144, 1148)
  AND a.created >= DATE '2026-08-26'
  AND a.created <  DATE '2026-11-26' + INTERVAL '1 day'
ORDER BY t.title, a.created DESC;
