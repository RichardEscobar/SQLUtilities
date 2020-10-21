USE [2766_SalesMgmtRptg_Private]
GO

sp_who2

DECLARE @sqltext VARBINARY(128)
SELECT @sqltext = sql_handle
FROM sys.sysprocesses
WHERE spid = 169
SELECT TEXT
FROM sys.dm_exec_sql_text(@sqltext)
GO
