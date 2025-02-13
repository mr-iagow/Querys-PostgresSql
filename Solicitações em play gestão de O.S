WITH play AS (
    SELECT
        p.id AS id_pessoa,
        a.title AS "Tarefa",
        TO_CHAR(r.beginning_date, 'DD/MM/YYYY') AS "Inicio",
        TO_CHAR((now() - r.beginning_date), 'HH24:MI:SS') AS "Tempo_Play"
    FROM erp.assignments a
    LEFT JOIN erp.people AS p ON p.id = a.responsible_id
    JOIN erp.reports AS r ON r.id = a.in_execution
    JOIN v_users AS u ON u.id = p.user_id
    WHERE
        a.progress < 100
        AND a.deleted = FALSE
        AND a.in_execution IS NOT NULL
        AND u.active = TRUE
        AND u.deleted = FALSE
        AND p.collaborator = TRUE
        AND u.id IS NOT NULL
),
relatos AS (
    SELECT
        p.name,
        p.id AS id_pessoa,
        TO_CHAR(
            concat((SUM(r.seconds_worked))::TEXT, ' second')::interval,
            'HH24:MI:SS'
        ) AS "horas",
        count(r.id) AS relatos,
        count(DISTINCT(a.id)) AS atividades
    FROM erp.reports r
    LEFT JOIN erp.assignments AS a ON r.assignment_id = a.id
    LEFT JOIN erp.people AS p ON p.id = r.person_id
    JOIN v_users AS u ON u.id = p.user_id
    WHERE
        r.final_date IS NOT NULL
        AND date(r.final_date) = current_date
        AND p.collaborator = TRUE
        AND u.active = TRUE
        AND u.deleted = FALSE
        AND u.id IS NOT NULL
    GROUP BY p.id
)
SELECT
    b.v_name AS "Pessoa",
    MAX(CASE WHEN c."Tarefa" IS NOT NULL THEN 'Sim' ELSE 'Não' END) AS "PLAY",
    MAX(CASE WHEN c."Tarefa" IS NOT NULL THEN c."Tarefa" ELSE '-' END) AS "Atividade",
    MAX(CASE WHEN c."Tempo_Play" IS NOT NULL THEN c."Tempo_Play" ELSE '-' END) AS "Tempo",
    MAX(d.horas) AS "Horas",
    MAX(d.relatos) AS "Relatos",
    MAX(d.atividades) AS "Atividades"
FROM erp.people_teams AS a
JOIN erp.people AS b ON a.person_id = b.id
LEFT JOIN play AS c ON b.id = c.id_pessoa
LEFT JOIN relatos AS d ON b.id = d.id_pessoa
JOIN v_users AS e ON b.user_id = e.id
WHERE
    b.deleted = FALSE
    AND b.collaborator = TRUE
    AND e.deleted = FALSE
    AND e.active = TRUE
    AND e.team_id = 1003
    AND b.id NOT IN (196,74926,88638,73592,109019,110048,26240,118,69656,69658,73591,78147)
    --clausa acima retira os integrantes da equipe interna atual da gestão de o.s
GROUP BY b.id, b.v_name;
