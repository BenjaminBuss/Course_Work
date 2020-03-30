SELECT AVG(attempts) FROM (
SELECT COUNT(*) AS attempts, job_id FROM job_log 
WHERE flow_id IN (SELECT id FROM default_job_flow WHERE action_type = 'call') 
	AND datestamp > '2020-01-01' AND status <> 'call back' 
GROUP BY job_id) AS sub
WHERE attempts < 9