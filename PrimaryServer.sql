use [2766_SalesMgmtRptg_Private]
go

	--select * from [MSIL3390].[ServerAvailability] order by [Role]
	drop view [MSIL3390].[ServerAvailability]
	go

	create view [MSIL3390].[ServerAvailability]
	as
	select 
		[L].[is_local],	
        [R].[replica_server_name],	
		[L].[role],
		[L].[role_desc],
		Iif([L].[operational_state_desc] is null,'OFFLINE',[L].[operational_state_desc]) as [State],
		iif([L].[operational_state_desc] = 'ONLINE','Read-write','Read-Only') as [Usage],
	    [R].[endpoint_url]
	 from sys.dm_hadr_availability_replica_states [L] join  sys.availability_replicas [R]  on [L].[replica_id] = [R].[replica_id] and 	[L].[group_id] = [R].[group_id]
--	 order by [L].[Role]
	
	
	
	--if exists(select is_local, role_desc from sys.dm_hadr_availability_replica_states where role = 1 and role_desc = 'PRIMARY') begin
	--print 'This server [' + upper(@@servername) + '] is the primary.' end
	--else
	--print 'This server [' + upper(@@servername) + '] is NOT the primary.'
	

