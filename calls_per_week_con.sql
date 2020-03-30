SELECT COUNT(*) AS calls, week(datestamp) AS week
FROM call_log 
WHERE datestamp > '2020-01-01' AND callcenter <> 'AdvantaCC' AND disposition = 1
 GROUP BY week