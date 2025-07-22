
SELECT
a.responsible_id,
r.tags,
  trim((regexp_split_to_array(r.description,'<br>' ))[ array_upper(regexp_split_to_array(r.description,'<br>'),1) ])AS apenas_o_nome

FROM reports AS r 
JOIN assignments AS a ON a.id = r.assignment_id
--JOIN assignment_incidents AS ai
  --ON ai.protocol = regexp_replace(r.tags, '\D', '', 'g')::integer



WHERE  


a.assignment_type = 'RAUX'
AND DATE (a.created) BETWEEN '2025-06-20' AND '2025-07-21'
AND r.tags = '3047624'