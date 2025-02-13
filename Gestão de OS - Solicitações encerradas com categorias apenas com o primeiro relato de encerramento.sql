WITH relato_data AS (
    SELECT 
        rp.assignment_id,
        rp.final_date,
        DATE(FIRST_VALUE(rp.final_date) OVER (
            PARTITION BY rp.assignment_id
            ORDER BY rp.assignment_id ASC
            RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        )) AS data_primeiro_relato_encerramento
    FROM 
        reports AS rp
    WHERE 
        rp.progress >= 100
)

SELECT DISTINCT ON (ai.protocol)
    ai.protocol AS protocolo,
    (SELECT cp.description FROM companies_places AS cp WHERE cp.id = a.company_place_id) AS empresa,
    p.name as cliente,
    (SELECT it.title FROM incident_status AS it WHERE it.id = ai.incident_status_id) AS status_solicitacao,
    (SELECT sa.description FROM service_level_agreements AS sa WHERE sa.id = ai.service_level_agreement_id) AS situacao,
    (SELECT sat.title FROM service_level_agreement_types AS sat WHERE sat.id = ai.service_level_agreement_type_id) AS sla,
    (SELECT it.title FROM incident_types AS it WHERE ai.incident_type_id = it.id) AS tipo_Solicitacao,
    pa.street_type AS tipo_rua,
    pa.street AS rua,
    pa.city AS cidade,
    pa.neighborhood AS bairro,
    pa.number AS numero,
    pa.latitude AS latitude,
    pa.longitude AS longitude,
    (SELECT t.title FROM teams AS t WHERE t.id = ai.team_id) AS setor,
    (SELECT sa.title FROM sector_areas AS sa WHERE sa.id = ai.sector_area_id) AS setor_origem,
    (SELECT t.title FROM teams AS t WHERE t.id = ai.team_id) AS equipe,
    (SELECT v.name FROM people AS v WHERE v.id = a.responsible_id) AS atendente,
    (SELECT v.name FROM v_users AS v WHERE v.id = a.created_by) AS atendente_origem,
    DATE(a.created) AS data_abertura,
    DATE(a.final_date) AS data_prazo,
    DATE(a.conclusion_date) AS data_encerramento,
    r.data_primeiro_relato_encerramento,
    CASE 
        WHEN DATE(a.conclusion_date) <= DATE(a.final_date) THEN 'Não' 
        WHEN DATE(a.conclusion_date) > DATE(a.final_date) THEN 'Sim' 
    END AS em_atraso,
    CASE 
        WHEN DATE(a.conclusion_date) > DATE(a.final_date) THEN DATEDIFF(DATE(a.conclusion_date), DATE(a.final_date)) 
        WHEN DATE(a.conclusion_date) < DATE(a.final_date) THEN NULL 
    END AS dias_atraso,
    DATE(ai.date_to_start) AS data_incio_atendimento,
    (SELECT p.name FROM people AS p WHERE p.id = a.requestor_id) AS solicitante,
    (SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_solicitacao,
    (SELECT ss.title FROM solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_1) AS cat_1,
    (SELECT ss.title FROM solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_2) AS cat_2,
    (SELECT ss.title FROM solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_3) AS cat_3,
    (SELECT ss.title FROM solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_4) AS cat_4,
    (SELECT ss.title FROM solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_5) AS cat_5,
    SPLIT_PART(SPLIT_PART(ai.beginning_checklist, '$value', 3), '$aspa', 1) AS tecnico_original,
    SPLIT_PART(SPLIT_PART(ai.beginning_checklist, '$value', 2), '$aspa', 1) AS protocolo_original,
    a.rework AS retrabalho
FROM 
    assignments AS a 
    JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
    JOIN people AS p ON p.id = ai.client_id
    JOIN people_addresses AS pa ON pa.person_id = p.id
    LEFT JOIN solicitation_category_matrices AS ssc ON ssc.id = ai.solicitation_category_matrix_id
    JOIN relato_data AS r ON r.assignment_id = ai.assignment_id
WHERE 
    ai.team_id IN (1003)
    AND ai.incident_status_id IN (4)
    AND r.data_primeiro_relato_encerramento BETWEEN '$encerramento01' AND '$encerramento02'
