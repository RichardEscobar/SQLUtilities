use [2766_SalesMgmtRptg_Private]
go

USE master;  
GO  

sp_who

sp_who2

EXEC sp_who 'DIR\shyam.v.narayan';  --only this user
GO


USE master;  
GO  
EXEC sp_who 'active';  
GO


USE master;  
GO  
EXEC sp_who '247' --specifies the process_id;  
GO

/*
declare @tempTable table (SPID INT,Status VARCHAR(255),
Login VARCHAR(255),HostName VARCHAR(255),
BlkBy VARCHAR(255),DBName VARCHAR(255),
Command VARCHAR(255),CPUTime INT,
DiskIO INT,LastBatch VARCHAR(255),
ProgramName VARCHAR(255),SPID2 INT,
REQUESTID INT);

INSERT INTO @tempTable EXEC sp_who2

select * from @tempTable 
where [status] = 'Sleeping' 
and [DBName] not in ('Master','msdb')  
order by [Login],[CPUTime],[LastBatch] DESC


*/