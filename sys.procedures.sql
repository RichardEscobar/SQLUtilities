SELECT SCHEMA_NAME(schema_id) AS schema_name  
    ,name AS procedure_name   
	,type_desc  
    ,create_date  
    ,modify_date  
FROM sys.procedures
where SCHEMA_NAME(schema_id) not in ('dbo')
order by schema_id, name;  
GO  