--=================================================--
--author: richard.t.escobar
--desc:    list unused tables... kind of...
--created: 10/21/2020
--=================================================--

-- Create CTE for the unused tables, which are the tables from the sys.all_objects and 
-- not in the sys.dm_db_index_usage_stats table
/*
	if exists(select is_local, role_desc from sys.dm_hadr_availability_replica_states where role = 1 and role_desc = 'PRIMARY') begin
	print 'This server [' + upper(@@servername) + '] is the primary.' end
	else
	print 'This server [' + upper(@@servername) + '] is NOT the primary.'

	VLN105711
	VD108039
	VD119348
	

	
*/

USE [2766_SalesDW]
go

; with UnUsedTables (TableName , TotalRowCount, CreatedDate , LastModifiedDate ) 
AS ( 
  SELECT DBTable.name AS TableName
     ,PS.row_count AS TotalRowCount
     ,DBTable.create_date AS CreatedDate
     ,DBTable.modify_date AS LastModifiedDate
  FROM sys.all_objects  DBTable 
     JOIN sys.dm_db_partition_stats PS ON OBJECT_NAME(PS.object_id)=DBTable.name
  WHERE DBTable.type ='U' 
     AND NOT EXISTS (
	                 SELECT OBJECT_ID  
                     FROM sys.dm_db_index_usage_stats
                     WHERE OBJECT_ID = DBTable.object_id 
					 )
)
-- Select data from the CTE
SELECT TableName , TotalRowCount, CreatedDate , LastModifiedDate 
FROM UnUsedTables
ORDER BY TotalRowCount ASC
