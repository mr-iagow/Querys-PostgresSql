SELECT 
fat.id_fatura,
ct.cpf_cnpj,
ct.nome_razaosocial,
ss.descricao AS status_servico,
fc.descricao AS tipo_cobranca,
fat.numero_controle,
CASE WHEN fat.ativo = TRUE THEN 'fatura_ativa' ELSE 'fatura_inativa' END AS status_fatura,
cs.tipo_cobranca,
serv.descricao,
fat.nosso_numero_dv,
fat.valor,
fat.valor_pago,
fat.data_vencimento,
fat.linha_digitavel,
fat.codigo_barras



FROM fatura AS fat
JOIN forma_cobranca AS fc ON fc.id_forma_cobranca = fat.id_forma_cobranca
JOIN cliente_servico AS cs ON cs.id_cliente_servico = fat.id_cliente_servico
JOIN servico AS serv ON serv.id_servico = cs.id_servico
LEFT JOIN cliente AS ct ON ct.id_cliente = cs.id_cliente
JOIN servico_status AS ss ON ss.id_servico_status = cs.id_servico_status

WHERE 


fat.data_vencimento >= '2025-10-01'
AND fat.valor_pago IS NULL 
--AND fat.ativo = TRUE 
--AND fat.nosso_numero_dv = '27944530000859427'

ORDER BY ct.id_cliente