DECLARE
 @dbName nvarchar(30)=N'some db';

SELECT 
 CONCAT( OBJECT_SCHEMA_NAME(S.object_id, DB_ID(@dbName)),'.', OBJECT_NAME(S.object_id, DB_ID(@dbName)) )  AS table_name,
 I.name AS index_name,
 s.user_seeks + s.user_scans + s.user_lookups AS "user_reads",
 S.user_seeks,
 S.user_scans,
 S.user_lookups,
 s.user_updates
FROM sys.dm_db_index_usage_stats AS S
 INNER JOIN sys.indexes AS I
		 ON S.object_id = I.object_id
		AND S.index_id = I.index_id
WHERE S.database_id = DB_ID(@dbName)

ORDER BY table_name DESC;
