SELECT 

ct.contract_number AS numero_contrato,
ct.v_status AS status_contrato,
p.id AS cod_cliente,
p."name" AS nome_razao_social,
p.name_2 AS nome_razao_social_2,
CASE 
        WHEN LENGTH(p.tx_id ::text) <= 11 THEN 
            FORMAT('%s.%s.%s-%s',
                SUBSTRING(LPAD(p.tx_id ::text, 11, '0') FROM 1 FOR 3),
                SUBSTRING(LPAD(p.tx_id ::text, 11, '0') FROM 4 FOR 3),
                SUBSTRING(LPAD(p.tx_id ::text, 11, '0') FROM 7 FOR 3),
                SUBSTRING(LPAD(p.tx_id ::text, 11, '0') FROM 10 FOR 2)
            )
        ELSE
            FORMAT('%s.%s.%s/%s-%s',
                SUBSTRING(LPAD(p.tx_id ::text, 14, '0') FROM 1 FOR 2),
                SUBSTRING(LPAD(p.tx_id ::text, 14, '0') FROM 3 FOR 3),
                SUBSTRING(LPAD(p.tx_id ::text, 14, '0') FROM 6 FOR 3),
                SUBSTRING(LPAD(p.tx_id ::text, 14, '0') FROM 9 FOR 4),
                SUBSTRING(LPAD(p.tx_id ::text, 14, '0') FROM 13 FOR 2)
            )
    END AS cpf_cnpj_formatado,

CASE WHEN p.type_tx_id = 1 THEN 'CNPJ' ELSE 'CPF' END AS tipo_cliente

FROM contracts AS ct
JOIN people AS p ON p.id = ct.client_id 

WHERE 

ct.contract_type_id IN (24,25,26,27)