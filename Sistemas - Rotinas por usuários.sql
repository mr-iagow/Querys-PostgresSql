SELECT DISTINCT ON (v.id)
prof.code AS cod_perfil,
v.name,
prof.name AS perfil,
mc.module_id,
(SELECT modu.name FROM modules AS modu WHERE modu.id = mc.module_id) AS modulo,
control.id AS control_id,
control.name AS permissao,
control.controller,
act.id AS act_id,
act.action AS acao,
(CONCAT((SELECT modu.name FROM modules AS modu WHERE modu.id = mc.module_id),' >',control.name, ' >')) AS concate

FROM profiles AS prof
inner JOIN profiles_permissions AS pp ON pp.profile_id = prof.id
inner JOIN controllers AS control ON control.id = pp.controller
inner JOIN actions AS act ON act.id = pp.action
inner JOIN modules_controllers AS mc ON mc.controller = control.id
JOIN v_users AS v ON v.profile_id = prof.id

WHERE --prof.name = 'Gestão de O.S - Suporte + Materiais' 
--AND 
prof.active = TRUE 
and control.id = 483
AND v."active" = TRUE 