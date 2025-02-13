SELECT 

		pat.title AS veiculo,
		pat.description AS descricao,
		(SELECT pt.title FROM patrimony_types AS pt WHERE pt.id = pat.patrimony_type_id) AS tipo,
		(SELECT pm.title FROM patrimony_models AS pm WHERE pm.id = pat.patrimony_model_id) AS modelo,
		pat.board AS placa,
		pat.renavam,
		pat.year_manufacture AS ano_fabricacao,
		(SELECT p.name FROM people AS p WHERE p.id = pat.person_id) AS responsavel

FROM patrimonies AS pat 

WHERE 
pat.type_fuel IS NOT NULL 
and pat."active" = TRUE
AND pat.deleted = false