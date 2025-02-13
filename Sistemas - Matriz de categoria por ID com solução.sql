SELECT 
scm."code" cod_erp,
scm.active AS status_matriz,
(SELECT ss.title FROM solicitation_service_categories AS ss WHERE ss.id = scm.service_category_id_1) AS cat_1,
(SELECT ss.title FROM solicitation_service_categories AS ss WHERE ss.id = scm.service_category_id_2) AS cat_2,
(SELECT ss.title FROM solicitation_service_categories AS ss WHERE ss.id = scm.service_category_id_3) AS cat_3,
(SELECT ss.title FROM solicitation_service_categories AS ss WHERE ss.id = scm.service_category_id_4) AS cat_4,
(SELECT ss.title FROM solicitation_service_categories AS ss WHERE ss.id = scm.service_category_id_5) AS cat_5,
(SELECT ss.title FROM solicitation_solutions AS ss WHERE ss.id = sm.solicitation_solution_id) AS solucoes_vinculadas


FROM solicitation_category_matrices AS scm
left JOIN solicitation_category_matrix_solutions AS sm ON sm.solicitation_category_matrix_id = scm.id


WHERE 

scm."code" IN ( 'df8cb2d4', 'bbefaa26', 'd37e29f3', '6f22e529', '75a97a3a', '073001f2', '27a8b1cb', '82d8774f', '939366fd', '7c60e51f')
--scm.service_category_id_3 IN (7,628) --MATRIZES DE CANCLAMENTO
and scm.active = true