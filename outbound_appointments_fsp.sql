SELECT COUNT(*)
FROM callcenter 
WHERE contact_id IN (
	SELECT contact_id 
	FROM jobs 
    WHERE job_id IN (
		SELECT job_id 
        FROM job_log 
        WHERE datestamp >= '2020-01-01' AND datestamp < ' 2020-03-01' AND action = 'Call 1'))

#	AND contact_id IN( SELECT contact_id FROM jobs WHERE job_id IN(SELECT job_id FROM job_log WHERE flow_id IN (SELECT id FROM default_job_flow WHERE action_type = 'call') 
#	AND datestamp > '2020-01-01' AND status <> 'call back' ))