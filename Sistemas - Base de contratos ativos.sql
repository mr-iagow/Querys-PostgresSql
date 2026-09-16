SELECT DISTINCT ON (ct.id)
    ctt.title AS tipo_contrato,
    ct.id AS id_contrato,
    p.id AS id_cliente,
    ct.v_status AS status_contrato,
    fo.title AS operacao_principal,
    fo2.title AS operacao_secundaria,
    CASE p.csll_deducted
        WHEN 2 THEN 'Retém sempre'
        WHEN 1 THEN 'Normal'
        WHEN 0 THEN 'Sem retenção'
        ELSE 'Não definido'
    END AS PIS_COFINS_CSLL,
    CASE p.retains_income_tax
        WHEN 2 THEN 'Normal'
        WHEN 1 THEN 'Reter Sempre'
        WHEN 0 THEN 'Sem retenção'
        ELSE 'Não definido'
    END AS Retem_IR,
    CASE p.taxes_municipality
   	  WHEN 1 THEN 'Tributa Municipio'
   	  ELSE 'Nao Tributa Municipio'
    END AS tributa_no_municipio,
    CASE p.taxes_issqn
        WHEN TRUE THEN 'Sim'
        ELSE 'Nao'
    END AS tributa_issqn,
    CASE p.resp_retains
        WHEN TRUE THEN 'Sim'
        ELSE 'Nao'
    END AS prestador_responsavel_retencao
    
FROM contracts AS ct
LEFT JOIN people AS p ON p.id = ct.client_id
JOIN contract_types AS ctt ON ctt.id = ct.contract_type_id
LEFT JOIN people_addresses AS pa ON pa.person_id = ct.client_id
LEFT JOIN financial_operations AS fo ON fo.id = ct.operation_id
LEFT JOIN financial_operations AS fo2 ON fo2.id = ct.second_financial_operation_id
WHERE ct.v_status NOT IN ('Cancelado', 'Encerrado')
  AND ct.deleted = FALSE
  --AND (fo.id IN (1,104) OR fo2.id IN (1,104))
  --AND ct.id = 17349 