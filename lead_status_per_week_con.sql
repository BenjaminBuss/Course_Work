SELECT COUNT(*), week(datestamp) AS week FROM (
SELECT contacts.*, contact_lead.datestamp, contact_lead.source_id, contact_lead.lead_type
            FROM contacts, contact_lead
            WHERE contacts.contact_id = contact_lead.contact_id and contact_lead.datestamp >= '2020-01-01' 
            and contacts.account_type_id = 1 AND lead_status = 4 AND brand_id <> 44 ) AS sub
GROUP BY week