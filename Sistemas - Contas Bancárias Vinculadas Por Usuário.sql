SELECT 
	vv."name" AS usuario,
    (item ->> 'accountId')::int  AS id_conta,
    ba.description AS conta
FROM user_permissions AS v
CROSS JOIN LATERAL jsonb_array_elements(v.account_permissions) AS item
JOIN bank_accounts AS ba ON ba.id = (item ->> 'accountId')::INT
LEFT JOIN v_users AS vv ON vv.id = v.user_id


WHERE ba.id IN (44,45,46,47,48,49,56,57,130,175,176,199,227,311)
ORDER BY v.id