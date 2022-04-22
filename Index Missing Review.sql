SELECT
  (user_seeks + user_scans) * avg_total_user_cost * (avg_user_impact * .01) AS "indexImprovement"
 ,id.statement
 ,id.equality_columns
 ,id.inequality_columns
 ,id.included_columns
FROM sys.dm_db_missing_index_group_stats AS igs
 INNER JOIN sys.dm_db_missing_index_groups AS ig
		 ON igs.group_handle = ig.index_handle
 INNER JOIN sys.dm_db_missing_index_details as id
		 ON ig.index_handle = id.index_handle

