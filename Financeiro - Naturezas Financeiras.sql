SELECT 

fn."code" AS cod_natureza,
fn.title AS descricao_natureza,
CASE 
	WHEN fn."signal" = 1 THEN 'credito'
	WHEN fn."signal" = 2 THEN 'debito'
	WHEN fn."signal" = 3 THEN 'transitorio'
	ELSE 'outro' -- ou qualquer valor padrão que faça sentido
END AS sinal_natureza,
CASE 
	WHEN fn."active" = TRUE THEN 'Ativo'
	WHEN fn."active" = FALSE THEN 'Inativo'
	ELSE 'outro'
END AS status


FROM financers_natures AS fn

