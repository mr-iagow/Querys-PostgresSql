SELECT --DISTINCT ON (prof.id)
prof.code AS cod_perfil,
prof.name AS perfil,
(SELECT modu.name FROM modules AS modu WHERE modu.id = mc.module_id) AS modulo,
control.name AS permissao,
act.action AS acao,
(CONCAT((SELECT modu.name FROM modules AS modu WHERE modu.id = mc.module_id),' >',control.name, ' >')) AS rotina_permitida,
v."name" AS user

FROM profiles AS prof
inner JOIN profiles_permissions AS pp ON pp.profile_id = prof.id
inner JOIN controllers AS control ON control.id = pp.controller
inner JOIN actions AS act ON act.id = pp.action
inner JOIN modules_controllers AS mc ON mc.controller = control.id
LEFT JOIN v_users AS v ON v.profile_id = prof.id

WHERE prof.active = TRUE
and control.id in (532,185,548,163)
--and control.id in (694)
--AND act.id = 1
AND v."active" = TRUE
AND v.id != 648