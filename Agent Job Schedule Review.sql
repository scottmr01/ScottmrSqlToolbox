SELECT
 s.name job_name
,s.enabled job_enabled
,sch.name schedule_name
,sch.freq_recurrence_factor
,CASE WHEN freq_type = 4 THEN 'Daily'
	  WHEN freq_type = 8 THEN 'Weekly'
	  WHEN freq_type = 16 THEN 'Monthly'
	  WHEN freq_type = 64 THEN 'Agent Startup'
 END AS "frequency"
,sch.freq_type
,CASE WHEN freq_type = 4  THEN CONCAT( 'every ', cast (freq_interval AS varchar(3)), ' day(s)' )
	  WHEN freq_type = 16 THEN CONCAT( 'every ', cast (freq_interval AS varchar(3)), ' day of each month' )
	  WHEN freq_type = 8  THEN replace(	 CASE WHEN freq_interval&1 = 1 THEN 'Sunday, ' ELSE '' END
										+CASE WHEN freq_interval&2 = 2 THEN 'Monday, ' ELSE '' END
										+CASE WHEN freq_interval&4 = 4 THEN 'Tuesday, ' ELSE '' END
										+CASE WHEN freq_interval&8 = 8 THEN 'Wednesday, ' ELSE '' END
										+CASE WHEN freq_interval&16 = 16 THEN 'Thursday, ' ELSE '' END
										+CASE WHEN freq_interval&32 = 32 THEN 'Friday, ' ELSE '' END
										+CASE WHEN freq_interval&64 = 64 THEN 'Saturday, ' ELSE '' END
										,', '
										,''	)
 END AS "Days"
,CASE
	WHEN freq_subday_type = 2 THEN ' every ' + cast(freq_subday_interval AS varchar(7)) + ' seconds' + ' starting at ' + stuff(stuff(RIGHT(replicate('0', 6) +  cast(active_start_time AS varchar(6)), 6), 3, 0, ':'), 6, 0, ':')
	WHEN freq_subday_type = 4 THEN ' every ' + cast(freq_subday_interval AS varchar(7)) + ' minutes' + ' starting at ' + stuff(stuff(RIGHT(replicate('0', 6) +  cast(active_start_time AS varchar(6)), 6), 3, 0, ':'), 6, 0, ':')
	WHEN freq_subday_type = 8 THEN ' every ' + cast(freq_subday_interval AS varchar(7)) + ' hours'   + ' starting at ' + stuff(stuff(RIGHT(replicate('0', 6) +  cast(active_start_time AS varchar(6)), 6), 3, 0, ':'), 6, 0, ':')
	ELSE ' starting at ' +stuff(stuff(RIGHT(replicate('0', 6) +  cast(active_start_time AS varchar(6)), 6), 3, 0, ':'), 6, 0, ':')
 END AS "time"
FROM msdb.dbo.sysjobs AS s
	INNER JOIN msdb.dbo.sysjobschedules AS sjs
			ON s.job_id = sjs.job_id
	INNER JOIN msdb.dbo.sysschedules AS sch
			ON sjs.schedule_id = sch.schedule_id

ORDER BY time DESC;
