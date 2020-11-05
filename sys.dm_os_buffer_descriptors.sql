--============================================--
--author:    richard.t.escobar
--desc:      When a data page is read from disk, the page is copied into the SQL Server buffer pool and cached for reuse. 
--           Each cached data page has one buffer descriptor. 
--           Buffer descriptors uniquely identify each data page that is currently cached in an instance of SQL Server. 
--           sys.dm_os_buffer_descriptors returns cached pages for all user and system databases. 
--           This includes pages that are associated with the Resource database.
--changes:
--============================================--
use [master]
go


SELECT
[DatabaseName] = CASE [database_id] WHEN 32767 THEN 'Resource DB' ELSE DB_NAME([database_id]) END,
COUNT_BIG(*) [16k Pages in Buffer],
COUNT_BIG(*)/128 [Buffer Size in MB]
--select top 10 * 
FROM sys.dm_os_buffer_descriptors
where [database_id] in (5,6,8)
GROUP BY [database_id]
ORDER BY [16k Pages in Buffer] DESC;



