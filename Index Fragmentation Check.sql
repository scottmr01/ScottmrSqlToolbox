DECLARE
  @db_id smallint
 ,@object_id int;

SET @db_id = DB_ID(N'SOME DB NAME');
SET @object_id = OBJECT_ID(N'SOME TABLE NAME')

SELECT ixs.index_id
 ,ix.name
 ,ixs.index_type_desc
 ,ixs.page_count
 ,ixs.avg_page_space_used_in_percent
 ,ixs.fragment_count
 ,ixs.avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(@db_id,@object_id,null,null,'Detailed') AS ixs
 INNER JOIN sys.indexes AS ix
		 ON ixs.index_id = ix.index_id
		AND ixs.object_id = ix.object_id;
