SELECT TOP (10)
 SUBSTRING(qt.TEXT, (qs.statement_start_offset/2)+1,
 ((CASE qs.statement_end_offset
	WHEN -1 THEN DATALENGTH(qt.TEXT)
	ELSE qs.statement_end_offset
   END - qs.statement_start_offset)/2)+1),
 qt.Query,
 qs.execution_count,
 qs.total_logical_reads, 
 qs.last_logical_reads,
 qs.total_logical_writes,
 qs.last_logical_writes,
 qs.total_worker_time,
 qs.last_worker_time,
 qs.total_elapsed_time/1000000 total_elapsed_time_in_S,
 qs.last_elapsed_time/1000000 last_elapsed_time_in_S,
 qs.last_execution_time,
 qp.query_plan
FROM sys.dm_exec_query_stats AS qs
 --CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt
 CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) AS qp
 CROSS APPLY (
    SELECT db_name(dbid) AS DatabaseName
        ,object_id(objectid) AS ObjName
		,text
        ,ISNULL((
                SELECT TEXT AS [processing-instruction(definition)]
                FROM sys.dm_exec_sql_text(qs.sql_handle)
                FOR XML PATH('')
                    ,TYPE
                ), '') AS Query

    FROM sys.dm_exec_sql_text(qs.sql_handle) ) AS qt
ORDER BY qs.total_logical_reads DESC;