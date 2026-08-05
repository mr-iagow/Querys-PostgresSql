    SELECT
        par.id AS n_compra,
        sp.id AS produto_id,
        sp.title AS produto,
        pari.units AS quantidade,
        pari.unit_amount AS valor_unitario,
        par.total_request AS total_pedido,
        um.title AS medida,

        TRIM(
            SUBSTRING(
                par.observation 
                FROM 'DESTINO:\s*(.*?)(?:OPERAÇÃO DE ENTRADA)'
            )
        ) AS destino,

        TRIM(
            SUBSTRING(
                par.observation 
                FROM 'CENTRO DE CUSTO:\s*(.*?)(?:EMITE NOTA FISCAL)'
            )
        ) AS centro_de_custo,

        fornecedor.name AS fornecedor,
        cp.description AS empresa,
        DATE(par.date) AS data_solicitacao,
        DATE(par.approvation_date) AS data_aprovacao,

        CASE
            WHEN par.status = 1 THEN 'Inclusão'
            WHEN par.status = 4 THEN 'Aguardando Entrega'
            WHEN par.status = 5 THEN 'Recebido'
            WHEN par.status = 3 THEN 'Aprovado'
            WHEN par.status = 9 THEN 'Rejeitado'
            ELSE 'Aguardando Aprovação'
        END AS status,

        CASE 
            WHEN par.status = 9 THEN DATE(par.modified)
            ELSE NULL
        END AS data_recusa,

        CASE 
            WHEN par.status = 5 THEN DATE(par.modified)
            ELSE NULL
        END AS data_recebimento,

        comprador.name AS comprador,
        aprovador.name AS aprovador,
        iv.document_number AS nota_fiscal,
        fo.title AS operacao,
        fn.title AS natureza,
        par.observation AS observacao

    FROM product_acquisition_requests AS par

    LEFT JOIN product_acquisition_request_items AS pari 
        ON pari.product_acquisition_request_id = par.id

    JOIN service_products AS sp 
        ON sp.id = pari.service_product_id

    JOIN companies_places AS cp 
        ON cp.id = par.company_place_id

    LEFT JOIN invoice_notes AS iv 
        ON iv.product_acquisition_request_id = par.id

    LEFT JOIN financial_operations AS fo 
        ON fo.id = iv.financial_operation_id

    LEFT JOIN financers_natures AS fn 
        ON fn.id = iv.financer_nature_id

    LEFT JOIN units_measures AS um 
        ON um.id::bigint = sp.first_unit

    LEFT JOIN people AS fornecedor 
        ON fornecedor.id = par.supplier_id

    LEFT JOIN people AS aprovador 
        ON aprovador.id = par.approver_id

    LEFT JOIN v_users AS comprador 
        ON comprador.id = par.created_by

    WHERE
        par.deleted = FALSE
        --AND DATE(par.created) BETWEEN '' AND '$data02'
        AND fn.id = 231