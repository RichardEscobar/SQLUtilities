USE [2766_SalesMgmtRptg_Private];  
GO  
  
-- Create test table and index.  
CREATE TABLE [MSIL3390].[t_lock]  
    (  
    c1 int, c2 int  
    );  
GO  
  
CREATE INDEX t_lock_ci on [MSIL3390].[t_lock](c1);  
GO  
  
-- Insert values into test table  
INSERT INTO [MSIL3390].[t_lock] VALUES (1,1);  
INSERT INTO [MSIL3390].[t_lock] VALUES (2,2);  
INSERT INTO [MSIL3390].[t_lock] VALUES (3,3);  
INSERT INTO [MSIL3390].[t_lock] VALUES (4,4);  
INSERT INTO [MSIL3390].[t_lock] VALUES (5,5);  
INSERT INTO [MSIL3390].[t_lock] VALUES (6,6);  
GO  

SELECT * FROM [MSIL3390].[t_lock];
GO
  
-- Session 1  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;  
  
BEGIN TRAN  
    SELECT c1  
        FROM [MSIL3390].[t_lock]  
        WITH(holdlock, rowlock);  
  
-- Session 2  
BEGIN TRAN  
    UPDATE [MSIL3390].[t_lock] SET c1 = 10



	SELECT resource_type, resource_associated_entity_id,  
    request_status, request_mode,request_session_id,  
    resource_description   
    FROM sys.dm_tran_locks  
    WHERE resource_database_id = db_id() --<dbid>

	sp_who2

	SELECT object_name(object_id), *  
    FROM sys.partitions  
    WHERE hobt_id='139016868'

	SELECT   
        t1.resource_type,  
        t1.resource_database_id,  
        t1.resource_associated_entity_id,  
        t1.request_mode,  
        t1.request_session_id,  
        t2.blocking_session_id  
    FROM sys.dm_tran_locks as t1  
    INNER JOIN sys.dm_os_waiting_tasks as t2  
        ON t1.lock_owner_address = t2.resource_address;

		-- Session 1  
	ROLLBACK;  
	GO  
  
	-- Session 2  
	ROLLBACK;  
	GO


	SELECT STasks.session_id, SThreads.os_thread_id  
    FROM sys.dm_os_tasks AS STasks  
    INNER JOIN sys.dm_os_threads AS SThreads  
        ON STasks.worker_address = SThreads.worker_address  
    WHERE STasks.session_id IS NOT NULL  
    ORDER BY STasks.session_id;  
GO

	DROP TABLE [MSIL3390].[t_lock]

	sp_lock



