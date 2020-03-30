SELECT COUNT(*) AS calls, date(datestamp) AS day
FROM call_log 
WHERE datestamp > '2020-01-01' AND callcenter <> 'AdvantaCC'
 GROUP BY day
 ORDER BY day
 