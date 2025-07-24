SELECT *
FROM (
  SELECT DISTINCT
    pat.title             AS tipo,
    pat.serial_number     AS serial_equipamento,
    pat.tag_number        AS numero_patrimonio,

    (
      SELECT v.name
      FROM v_users v
      WHERE v.id = (
        SELECT p5.created_by
        FROM patrimony_occurrences p5
        WHERE p5.patrimony_id    = pat.id
          AND p5.occurrence_type = 5
          AND p5.created < (
            SELECT MAX(p3.created)
            FROM patrimony_occurrences p3
            WHERE p3.patrimony_id    = pat.id
              AND p3.occurrence_type = 33
          )
        ORDER BY p5.created DESC
        LIMIT 1
      )
    )                       AS colaborador_origem,

    vcur.name               AS usuario_responsavel,
    pato.title              AS evento,
    pato.description      AS descricao_evento,
    pato.created            AS data_evento

  FROM patrimonies pat
  JOIN patrimony_occurrences pato
    ON pato.patrimony_id = pat.id
  JOIN v_users vcur
    ON vcur.id = pato.created_by

  WHERE
    --pat.serial_number       = 'ZTEGD42BEF8F'
     pato.occurrence_type = 33               -- só 33 aqui
    AND DATE(pato.created)  = '2025-05-06'
) AS sub
WHERE sub.usuario_responsavel <> sub.colaborador_origem;
