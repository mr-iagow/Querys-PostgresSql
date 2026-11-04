WITH equip AS (
    SELECT DISTINCT ON (pat.id)
        c.id AS contract_id, ctag.id AS tag_id, ctag.service_tag,
        p.name AS cliente, c.v_status,
        pat.title, pat.serial_number, pat.tag_number,
        ppl.id AS romaneio, ppl.date AS data_romaneio,
        ppli.out_invoice_note_id, ppli.out_date
    FROM contracts AS c
    INNER JOIN people                       AS p    ON p.id = c.client_id
    INNER JOIN contract_service_tags        AS ctag ON ctag.contract_id = c.id
    INNER JOIN patrimony_packing_lists      AS ppl  ON ppl.contract_service_tag_id = ctag.id
    INNER JOIN patrimony_packing_list_items AS ppli ON ppli.patrimony_packing_list_id = ppl.id
                                                   AND ppli.returned = 0
    INNER JOIN patrimonies                  AS pat  ON pat.id = ppli.patrimony_id
    WHERE c.v_status != 'Cancelado'
    ORDER BY pat.id, ppli.out_date DESC, ppli.id DESC
),
conexao AS (
    SELECT DISTINCT ON (e.contract_id, e.tag_id)
        e.contract_id, e.tag_id, ac.mac, ac."user" AS pppoe, t2.service_tag AS etiqueta_conexao
    FROM (SELECT DISTINCT contract_id, tag_id FROM equip) AS e
    INNER JOIN authentication_contracts AS ac ON ac.contract_id = e.contract_id
    LEFT  JOIN contract_service_tags    AS t2 ON t2.id = ac.service_tag_id
    ORDER BY e.contract_id, e.tag_id,
             (ac.service_tag_id = e.tag_id) DESC NULLS LAST,
             ac.id DESC
)
SELECT
    e.service_tag             AS etiqueta,
    con.etiqueta_conexao,
    e.contract_id             AS id_contrato,
    e.cliente,
    e.title                   AS tipo_objeto,
    e.serial_number           AS numero_serial,
    e.tag_number              AS pat,
    e.romaneio,
    DATE(e.data_romaneio)     AS data_romaneio,
    nf.document_number        AS nf_remessa,
    vu.name                   AS usuario_nf_remessa,
    DATE(e.out_date)          AS data_remessa,
    e.v_status                AS status_contrato,
    con.mac                   AS mac_autenticada_erp,
    con.pppoe
    
FROM equip AS e
LEFT JOIN invoice_notes AS nf  ON nf.id = e.out_invoice_note_id
LEFT JOIN v_users       AS vu  ON vu.id = nf.created_by
LEFT JOIN conexao       AS con ON con.contract_id = e.contract_id AND con.tag_id = e.tag_id

ORDER BY e.contract_id, e.service_tag, e.tag_number
