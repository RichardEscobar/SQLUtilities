/*****	Script: SQL Server CPU Utilization report from last N minutes *****/
/*****	Support: SQL Server 2008 and Above *****/
/*****	Tested On: SQL Server 2008 R2 and 2014 *****/
/*****	Output: 
	SQLServer_CPU_Utilization: % CPU utilized from SQL Server Process
	System_Idle_Process: % CPU Idle - Not serving to any process 
	Other_Process_CPU_Utilization: % CPU utilized by processes otherthan SQL Server
	Event_Time: Time when these values captured
*****/
 
DECLARE @ts BIGINT;
DECLARE @lastNmin TINYINT;
SET @lastNmin = 10;
SELECT @ts =(SELECT cpu_ticks/(cpu_ticks/ms_ticks) FROM sys.dm_os_sys_info); 
SELECT TOP(@lastNmin)
		SQLProcessUtilization AS [SQLServer_CPU_Utilization], 
		SystemIdle AS [System_Idle_Process], 
		100 - SystemIdle - SQLProcessUtilization AS [Other_Process_CPU_Utilization], 
		DATEADD(ms,-1 *(@ts - [timestamp]),GETDATE())AS [Event_Time] 
FROM (SELECT record.value('(./Record/@id)[1]','int')AS record_id, 
record.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]','int')AS [SystemIdle], 
record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]','int')AS [SQLProcessUtilization], 
[timestamp]      
FROM (SELECT[timestamp], convert(xml, record) AS [record]             
FROM sys.dm_os_ring_buffers             
WHERE ring_buffer_type =N'RING_BUFFER_SCHEDULER_MONITOR'AND record LIKE'%%')AS x )AS y 
ORDER BY record_id DESC; 

--=========================================================================================================================--

1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
/*****	Script: Database Wise CPU Utilization report *****/
/*****	Support: SQL Server 2008 and Above *****/
/*****	TestedOn: SQL Server 2008 R2 and 2014 *****/
/*****	Output: 
SNO: Serial Number
DBName: Databse Name 
CPU_Time(Ms): CPU Time in Milliseconds
CPUPercent: Let’s say this instance is using 50% CPU and one of the database is      using 80%. It means the actual CPU usage from the database is calculated as: (80 / 100) * 50 = 40 %
*****/
WITH DB_CPU AS
(SELECT	DatabaseID, 
		DB_Name(DatabaseID)AS [DatabaseName], 
		SUM(total_worker_time)AS [CPU_Time(Ms)] 
FROM	sys.dm_exec_query_stats AS qs 
CROSS APPLY(SELECT	CONVERT(int, value)AS [DatabaseID]  
			FROM	sys.dm_exec_plan_attributes(qs.plan_handle)  
			WHERE	attribute =N'dbid')AS epa GROUP BY DatabaseID) 
SELECT	ROW_NUMBER()OVER(ORDER BY [CPU_Time(Ms)] DESC)AS [SNO], 
	DatabaseName AS [DBName], [CPU_Time(Ms)], 
	CAST([CPU_Time(Ms)] * 1.0 /SUM([CPU_Time(Ms)]) OVER()* 100.0 AS DECIMAL(5, 2))AS [CPUPercent] 
FROM	DB_CPU 
WHERE	DatabaseID > 4 -- system databases 
	AND DatabaseID <> 32767 -- ResourceDB 
ORDER BY SNO OPTION(RECOMPILE); 
