WITH solicitacoes_retencao AS (
    SELECT
      ai.protocol                      AS protocolo,
      p.name                           AS cliente,
      v.name                           AS operador_abertura,
      a.created::date                  AS data_abertura,
      a.conclusion_date::date          AS data_encerramento,
      ss.title                         AS retencao
   FROM assignments AS a
   JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
   LEFT JOIN solicitation_category_matrices AS ssc ON ssc.id = ai.solicitation_category_matrix_id
   LEFT JOIN solicitation_service_categories AS ss  ON ss.id = ssc.service_category_id_3 
	JOIN people AS p ON p.id = ai.client_id 
	JOIN v_users AS v ON v.id = a.created_by WHERE ss.title IS NOT NULL AND ai.incident_type_id = 1059
  ),
  base_com_primeiro AS (
    SELECT
      protocolo,
      cliente,
      operador_abertura,
      data_abertura,
      data_encerramento,
      retencao,
      MIN(data_abertura) OVER (PARTITION BY cliente) AS primeiro_protocolo
      
    FROM solicitacoes_retencao
  ),
  dentro_30_dias AS (
    SELECT *, COUNT(*) OVER (PARTITION BY cliente, primeiro_protocolo) AS total_retencao
    
    FROM base_com_primeiro
    WHERE data_abertura
    BETWEEN primeiro_protocolo
    AND (primeiro_protocolo + INTERVAL '30 days')
  )

SELECT
  protocolo AS protocolo,
  cliente AS cliente,
  operador_abertura AS operador_abertura,
  data_abertura  AS data_abertura,
  data_encerramento AS data_encerramento,
  retencao AS motivo_retencao
  
FROM dentro_30_dias
WHERE total_retencao > 1
ORDER BY cliente, data_abertura;
