USE  [2766_SalesDW] -- [2766_SalesMgmtRptg_Private]
GO

/* Set up variables to hold the current record we're working on */
Declare @Objectid   bigint;

TRUNCATE TABLE [MSIL3390].[dm_db_index_usage_stats]

DECLARE object_cursor CURSOR  for 
								select  object_id
								FROM sys.objects  
								WHERE [type_desc] = 'USER_TABLE'
								and SCHEMA_NAME(schema_id) = 'Price'
		
OPEN object_cursor  
FETCH NEXT FROM object_cursor into @Objectid;


--===================================================================--
WHILE @@FETCH_STATUS = 0
BEGIN 

 -- /* Do something with your ID and string */

		INSERT INTO [MSIL3390].[dm_db_index_usage_stats]
				   ([TableName]
				   ,[last_user_seek]
				   ,[last_user_scan]
				   ,[last_user_lookup]
				   ,[last_user_update])
		 SELECT    [TableName] = OBJECT_NAME(object_id),
				   last_user_seek,
				   last_user_scan,
				   last_user_lookup,
				   last_user_update
		FROM    sys.dm_db_index_usage_stats
		WHERE    database_id = DB_ID('2766_SalesMgmtRptg_Private')
		AND       object_id = @Objectid


	FETCH NEXT FROM object_cursor into @Objectid;
END

/* Clean up our work */
CLOSE object_cursor;
DEALLOCATE object_cursor;

select * from [MSIL3390].[dm_db_index_usage_stats]