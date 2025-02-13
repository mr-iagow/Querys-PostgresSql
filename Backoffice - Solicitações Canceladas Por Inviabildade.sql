WITH Motivos AS (
    SELECT DISTINCT ON (cst.contract_id)
			(SELECT p.name FROM people AS p WHERE p.id = a.requestor_id) AS cliente,
			(SELECT p.cell_phone_1 FROM people AS p WHERE p.id = a.requestor_id) AS celular_1,
			(SELECT p.phone FROM people AS p WHERE p.id = a.requestor_id) AS telefone,
			(SELECT pp.city FROM people AS pp WHERE pp.id = c.client_id) AS cidade_cliente,
			(SELECT pp.street FROM people AS pp WHERE pp.id = c.client_id) AS rua_cliente,
			(SELECT pp.number FROM people AS pp WHERE pp.id = c.client_id) AS numero_casa_client,
			(SELECT pp.neighborhood FROM people AS pp WHERE pp.id = c.client_id) AS bairro_cliente,
			ai.protocol AS protocolo,
			DATE(a.created) AS data_abertura_os,
			DATE(a.conclusion_date) AS data_cancelamento_os,
        TRIM(REPLACE(SUBSTRING_INDEX(SUBSTRING_INDEX(UPPER(LAST_VALUE(r.description) OVER (
            PARTITION BY cst.contract_id 
            ORDER BY r.created 
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        )), '||', 1), '<P>', -1), '</P>', '')) AS motivo_cancelamento
        
    FROM assignments AS a
    JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
    LEFT JOIN contract_service_tags AS cst ON cst.id = ai.contract_service_tag_id
    JOIN contracts AS c ON c.id = cst.contract_id
    JOIN v_users AS v ON v.id = a.created_by
    LEFT JOIN people AS pp ON pp.id = a.created_by
    JOIN reports AS r ON r.assignment_id = a.id
    LEFT JOIN person_people_groups AS ppg ON ppg.person_id = c.seller_1_id
    WHERE
        DATE(a.created) BETWEEN '$abertura1' AND '$abertura2'
        AND ai.team_id = 1003
        AND ai.incident_status_id = 8
        AND r.progress >= 200
)
SELECT *
FROM Motivos
WHERE motivo_cancelamento LIKE '%INVIA%';
