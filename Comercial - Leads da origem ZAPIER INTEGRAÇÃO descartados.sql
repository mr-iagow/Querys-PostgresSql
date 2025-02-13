SELECT 

*

FROM v_crm_discarted_leads AS cdl
JOIN people_crm_informations AS pci ON pci.person_id = cdl.people_id 

WHERE 
DATE(pci.crm_discard_date) BETWEEN '2024-06-01' AND '2024-06-19'
--cdl.people_id = 127595
--AND pci.crm_contact_origin_id = 3
AND pci.created_by = 681