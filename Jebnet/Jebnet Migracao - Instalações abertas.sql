SELECT DISTINCT ON (os.numero_ordem_servico)
ct.nome_razaosocial AS nome_cliente,
ss.descricao AS descrico_status_servico,
os.data_cadastro AS data_abertura,
sv.descricao AS plano,
cs.data_aceito,
serv.data_habilitacao,
ost.descricao AS tipo_solicitacao,
os.numero_ordem_servico,
os.descricao_abertura,
os.descricao_servico,
os.descricao_fechamento,
os."status" AS status_solicitacao,
os.status_fechamento,
os.data_inicio_executado,
os.data_termino_executado

FROM ordem_servico AS os 
JOIN tipo_ordem_servico AS ost ON ost.id_tipo_ordem_servico = os.id_tipo_ordem_servico
LEFT JOIN cliente_servico_contrato AS cs ON cs.id_cliente_servico = os.id_cliente_servico
LEFT JOIN cliente_servico_autenticacao AS csa ON csa.id_cliente_servico = cs.id_cliente_servico
LEFT JOIN cliente_servico AS serv ON serv.id_cliente_servico = os.id_cliente_servico
JOIN servico_status AS ss ON ss.id_servico_status = serv.id_servico_status
LEFT JOIN cliente AS ct ON ct.id_cliente = serv.id_cliente
LEFT JOIN servico AS sv ON sv.id_servico = serv.id_servico

WHERE 

os.id_tipo_ordem_servico IN (4,171,172,173)
AND DATE (os.data_cadastro) BETWEEN '2025-01-01' AND '2025-07-17'