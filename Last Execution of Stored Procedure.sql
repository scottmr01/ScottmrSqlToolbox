SELECT o.name, 
       s.last_execution_time,
       s.type_desc,
       s.execution_count
FROM sys.dm_exec_procedure_stats AS s 
INNER JOIN sys.objects AS o
		ON s.object_id = o.object_id 
WHERE DB_NAME(s.database_id) = N'some db'  --Database Name
  AND S.type_desc = N'SQL_STORED_PROCEDURE'
--AND o.name LIKE ('%procedurename%')  --Object Name

ORDER BY O.name;