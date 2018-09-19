/* **************************************************************
スケジューラーの情報の取得
Support Platform : SQL Server 2008 以降

NUMA ノード情報の取得
Support Platform : SQL Server 2016 以降 (2016 以降は Soft-Numa がデフォルトで有効)
*************************************************************** */
SET NOCOUNT ON 
GO 
 
SELECT 
	GETDATE() AS DATE,  
	[parent_node_id],  
	[scheduler_id],  
	[cpu_id],  
	[status],  
	[is_online],  
	[is_idle],  
	[preemptive_switches_count],  
	[context_switches_count],  
	[idle_switches_count],  
	[current_tasks_count],  
	[runnable_tasks_count],  
	[current_workers_count],  
	[active_workers_count],  
	[work_queue_count],  
	[pending_disk_io_count],  
	[load_factor],  
	[yield_count],  
	[last_timer_activity],  
	[failed_to_create_worker] 
FROM 
	[sys].[dm_os_schedulers] 
WHERE
	status = 'VISIBLE ONLINE'
OPTION (RECOMPILE)
GO

-- NUMA ノード単位での情報の取得
SELECT
	*
FROM
	sys.dm_os_nodes
