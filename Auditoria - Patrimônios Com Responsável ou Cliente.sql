SELECT DISTINCT ON (pat.id)
            COALESCE(p2.name, p.name) AS cliente,
            pat.title AS tipo,
            pat.serial_number AS numero_serial,
            pat.tag_number AS numero_patrimonio,
            pt.title AS tipo_patrimonio,
            cc.contract_number AS numero_contrato,
            ac.user AS pppoe
        FROM patrimonies AS pat
        JOIN patrimony_packing_list_items AS ppli ON ppli.patrimony_id = pat.id
        JOIN patrimony_packing_lists AS ppl ON ppl.id = ppli.patrimony_packing_list_id
        LEFT JOIN people AS p ON p.id = pat.person_id
        JOIN patrimony_types AS pt ON pt.id = pat.patrimony_type_id
        LEFT JOIN contract_service_tags AS ctag ON ctag.id = ppl.contract_service_tag_id
        LEFT JOIN contracts AS cc ON cc.id = ctag.contract_id
        LEFT JOIN people AS p2 ON p2.id = cc.client_id
        LEFT JOIN authentication_contracts AS ac ON ac.contract_id = cc.id
        WHERE 
            ppli.returned = 0
            AND pat.service_product_id IS NOT NULL 
            AND ppli.returned_date IS NULL 
            AND pat.service_product_id = 10378
            AND cc.contract_number IS NOT NULL 
            