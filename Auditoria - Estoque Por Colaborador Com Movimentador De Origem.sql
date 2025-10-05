SELECT DISTINCT ON (pat.id)
    p.name            AS responsavel,
    pat.title         AS tipo,
    pat.serial_number AS numero_serial,
    pat.tag_number    AS numero_patrimonio,
    pt.title          AS tipo_patrimonio,
    mov.movimentado_por_origem,
    mov.time_title    AS time_titulo
FROM patrimonies AS pat
JOIN patrimony_packing_list_items AS ppli ON ppli.patrimony_id = pat.id
JOIN patrimony_packing_lists AS ppl        ON ppl.id = ppli.patrimony_packing_list_id
JOIN people AS p                            ON p.id = pat.person_id
JOIN patrimony_types AS pt                  ON pt.id = pat.patrimony_type_id
LEFT JOIN (
    SELECT DISTINCT ON (pato.patrimony_id)
        pato.patrimony_id,
        v.name        AS movimentado_por_origem,
        t.title       AS time_title
    FROM patrimony_occurrences AS pato
    JOIN v_users AS v   ON v.id = pato.created_by
    LEFT JOIN teams AS t ON t.id = v.team_id       
    WHERE pato.occurrence_type = 5
    ORDER BY pato.patrimony_id, pato.id DESC     
) mov ON mov.patrimony_id = pat.id
WHERE
    ppli.returned = 0
    AND pat.service_product_id IS NOT NULL
    AND ppli.returned_date IS NULL
    AND p.name ILIKE '%ABIMAEL DE ALMEIDA VIDAL%'
ORDER BY pat.id
