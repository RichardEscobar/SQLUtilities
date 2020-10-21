SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		richard.t.escobar
-- Create date: 10/06/2020
-- Description:	Procedure to filter sp_who2
--status	nchar(30)	Process status. The possible values are:
			--dormant. SQL Server is resetting the session.
			--running. The session is running one or more batches. When Multiple Active Result Sets (MARS) is enabled, a session can run multiple batches. For more information, see Using Multiple Active Result Sets (MARS).
			--background. The session is running a background task, such as deadlock detection
			--rollback. The session has a transaction rollback in process
			--pending. The session is waiting for a worker thread to become available.
			--runnable. The session's task is in the runnable queue of a scheduler while waiting to get a time quantum.
			--spinloop. The session's task is waiting for a spinlock to become free.
			--suspended. The session is waiting for an event, such as I/O, to complete.
-- =============================================
CREATE PROCEDURE [MSIL3390].[SP_WHOU]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	declare @tempTable table (
	                          [SPID]        INT,
	                          [Status]      VARCHAR(255),
	                          [Login]       VARCHAR(255),
							  [HostName]    VARCHAR(255),
	                          [BlkBy]       VARCHAR(255),
							  [DBName]      VARCHAR(255),
	                          [Command]     VARCHAR(255),
							  [CPUTime]     INT,
	                          [DiskIO]      INT,
							  [LastBatch]   VARCHAR(255),
	                          [ProgramName] VARCHAR(255),SPID2 INT,
	                          [REQUESTID]   INT
							  );

	INSERT INTO @tempTable  EXEC sp_who2

	select * from @tempTable

END
GO
