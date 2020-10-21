
SELECT 
 --*
 [name]
,[schema_id]
,[parent_object_id]
,[type_desc]
,[create_date]
,[modify_date]
FROM sys.objects
WHERE schema_id = SCHEMA_ID('targets')
and [type_desc] = 'USER_TABLE'
--name like '%MDx%'
order by type_desc, name;



/*

SELECT 
 --*
 [name]
--,[object_id]
--,[principal_id]
,[schema_id]
,[parent_object_id]
--,[type]
,[type_desc]
,[create_date]
,[modify_date]
--,[is_ms_shipped]
--,[is_published]
--,[is_schema_published]
FROM sys.objects
WHERE schema_id = SCHEMA_ID('targets')
--and [type_desc] = 'USER_TABLE'
--name like '%MDx%'
order by type_desc, name;

*/



 
