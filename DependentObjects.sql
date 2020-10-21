--====================================================================--
	-- A tip for you EXEC [2766_SalesDW].dbo.searchObject <contains> /* where contains is a column, table, object name */ 
	-- A sample:
	
	
	exec [2766_SalesDW].dbo.searchObject 'opportunity_vw'
	 
	--SP should return every table, sp or view that uses it, or may be related to it
	 
	--Saludos/Regards,
	

	/*
	
	USE [2766_SalesDW]
GO

/****** Object:  StoredProcedure [dbo].[SearchObject]    Script Date: 9/1/2020 11:09:16 AM ******/
DROP PROCEDURE [dbo].[SearchObject]
GO

/****** Object:  StoredProcedure [dbo].[SearchObject]    Script Date: 9/1/2020 11:09:16 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*
b.vinicoff
2018/10/23

this sp should help when looking for object dependencies accross the databases
basically, type a column/table/sp/view name,
and it should return every table, sp or view that uses it, or may be related to it


usage
	exec dbo.searchObject 'opportunity_vw'
	exec dbo.searchObject 'totalcurrentnetrevenueglobalamt'

*/
CREATE PROCEDURE [dbo].[SearchObject]
	@contains	NVARCHAR(MAX)

AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @baseQuery	NVARCHAR(MAX);
	DECLARE @metadataQuery NVARCHAR(MAX);
	DECLARE @exec		NVARCHAR(MAX);
	DECLARE @searchFor	NVARCHAR(MAX);
	
--escape ''\'' is used to search inside sp/view definitions for objects with _ in their name
	SET @searchFor = REPLACE(@contains, '_', '\_')

--create the generic query, or return "error" message
	IF (@searchFor IS NOT NULL AND @searchFor <> '') 
		BEGIN

			CREATE TABLE #temp (
				DatabaseName 	NVARCHAR(50)
				, ObjectType	NVARCHAR(150)
				, ObjectName	NVARCHAR(MAX)
				, Content		NVARCHAR(MAX)
			)
--public db
				SET @baseQuery = N'
USE [database_placeholder]

INSERT INTO #temp
(DatabaseName, ObjectType, ObjectName, Content)

SELECT ''[database_placeholder]'' AS DatabaseName
	, table_type AS ObjectType
	, table_schema + ''.'' + table_name AS ObjectName
	, '''' AS Content
FROM information_schema.tables
WHERE table_name LIKE ''%' + @searchFor + '%'' ESCAPE ''\''
	AND table_type = ''Base Table''
	AND table_schema <> ''Backup''

UNION

SELECT ''[database_placeholder]'' AS DatabaseName
	, ''Column'' AS ObjectType
	, table_schema + ''.'' + table_name AS ObjectName
	, column_name AS Content
FROM information_schema.columns
WHERE column_name LIKE ''%' + @searchFor + '%'' ESCAPE ''\''
	AND table_schema <> ''Backup''

UNION

SELECT ''[database_placeholder]'' AS DatabaseName
	, ''View'' AS ObjectType
	, s.Name + ''.'' + p.Name AS ObjectName
	, OBJECT_DEFINITION(OBJECT_ID) AS Content
FROM sys.views p
INNER JOIN sys.schemas s
	ON p.schema_id = s.schema_id
WHERE OBJECT_DEFINITION(p.OBJECT_ID) LIKE ''%' + @searchFor + '%'' ESCAPE ''\''
	AND s.name <> ''Backup''

UNION

SELECT ''[database_placeholder]'' AS DatabaseName
	, ''SP'' AS ObjectType
	, s.Name + ''.'' + p.Name AS ObjectName
	, OBJECT_DEFINITION(OBJECT_ID) AS Content
FROM sys.procedures p
INNER JOIN sys.schemas s
	ON p.schema_id = s.schema_id
WHERE OBJECT_DEFINITION(p.OBJECT_ID) LIKE ''%' + @searchFor + '%'' ESCAPE ''\''
	AND s.name <> ''Backup''
;

'

SET @metadataQuery = 'INSERT INTO #temp
(DatabaseName, ObjectType, ObjectName, Content)

SELECT ''[2766_SalesDW]'' AS DatabaseName
	, ''Source Table Query Metadata'' AS ObjectType
	, ''Table Mapping - '' + ltrim(rtrim(str(tm.tableMappingId))) + '': '' + sourceSchema.ObjectNm + ''.'' + sourceTable.ObjectNm 
		+ '' to '' 
		+ destinationSchema.ObjectNm + ''.'' + destinationTable.ObjectNm AS ObjectName
	, q.queryText AS Content
FROM [2766_SalesDW].ETL.SourceTableQueryMetadata q WITH (NOLOCK)
INNER JOIN [2766_SalesDW].ETL.TableMappingMetadata tm WITH (NOLOCK)
	ON q.tableMappingId = tm.tableMappingId
INNER JOIN [2766_SalesDW].ETL.ObjectMetadata sourceTable WITH (NOLOCK)
	ON tm.sourceTableId = sourceTable.ObjectId
INNER JOIN [2766_SalesDW].ETL.ObjectMetadata sourceSchema WITH (NOLOCK)
	ON sourceTable.ObjectParentId = sourceSchema.ObjectId
INNER JOIN [2766_SalesDW].ETL.ObjectMetadata destinationTable WITH (NOLOCK)
	ON tm.DestinationTableId = destinationTable.ObjectId
INNER JOIN [2766_SalesDW].ETL.ObjectMetadata destinationSchema WITH (NOLOCK)
	ON destinationTable.ObjectParentId = destinationSchema.ObjectId

WHERE q.QueryText LIKE ''%' + @searchFor + '%'' ESCAPE ''\''

UNION

SELECT ''[2766_SalesDW]'' AS DatabaseName
	, ''Lookup Transformation Metadata'' AS ObjectType
	, ''Table Mapping - '' + ltrim(rtrim(str(tm.tableMappingId))) + '': '' + sourceSchema.ObjectNm + ''.'' + sourceTable.ObjectNm 
		+ '' to '' 
		+ destinationSchema.ObjectNm + ''.'' + destinationTable.ObjectNm AS ObjectName
	, q.LookupQuery AS Content
FROM [2766_SalesDW].ETL.LookupTransformationMetadata q WITH (NOLOCK)
INNER JOIN [2766_SalesDW].ETL.TableMappingMetadata tm WITH (NOLOCK)
	ON q.tableMappingId = tm.tableMappingId
INNER JOIN [2766_SalesDW].ETL.ObjectMetadata sourceTable WITH (NOLOCK)
	ON tm.sourceTableId = sourceTable.ObjectId
INNER JOIN [2766_SalesDW].ETL.ObjectMetadata sourceSchema WITH (NOLOCK)
	ON sourceTable.ObjectParentId = sourceSchema.ObjectId
INNER JOIN [2766_SalesDW].ETL.ObjectMetadata destinationTable WITH (NOLOCK)
	ON tm.DestinationTableId = destinationTable.ObjectId
INNER JOIN [2766_SalesDW].ETL.ObjectMetadata destinationSchema WITH (NOLOCK)
	ON destinationTable.ObjectParentId = destinationSchema.ObjectId

WHERE q.LookupQuery LIKE ''%' + @searchFor + '%'' ESCAPE ''\''

'

			SET @exec = REPLACE(@baseQuery, '[database_placeholder]', '[2766_SalesMgmtRptg_Public]')
			EXEC (@exec)
			
			SET @exec = REPLACE(@baseQuery, '[database_placeholder]', '[2766_SalesDW]')
			EXEC (@exec)
			
			SET @exec = REPLACE(@baseQuery, '[database_placeholder]', '[2766_SalesMgmtRptg_Private]')
			EXEC (@exec)
			
			SET @exec = @metadataQuery
			EXEC (@exec)
			
			SELECT *
			FROM #temp
			ORDER BY DatabaseName, ObjectType, ObjectName
			;
			
			DROP TABLE #temp;
		END
	ELSE BEGIN
		SELECT 'Type a table or column name to search for'
	END





GO


	
	*/