/* ***************************************************************
OS の種別 / リリースバージョンを取得
Support Platform : SQL Server 2017 以降
*************************************************************** */
SELECT 
	* 
FROM 
	sys.dm_os_host_info;

/* ***************************************************************
 サービスの情報
Support Platform : SQL Server 2008 以降 
(瞬時初期化については、2012 SP4 / 2016 SP1 / 2017 以降)
*************************************************************** */
SELECT 
	servicename ,
	startup_type_desc
	status_desc,
	service_account,
	filename,
	is_clustered,
	instant_file_initialization_enabled
FROM 
	sys.dm_server_services;


/* ***************************************************************
OS の情報の取得
Support Platform : SQL Server 2008 以降 
*************************************************************** */
SELECT 
	virtual_machine_type_desc,
	container_type_desc,
	cpu_count,
	hyperthread_ratio,
	socket_count,
	cores_per_socket,
	numa_node_count,
	scheduler_count,
	softnuma_configuration_desc,
	max_workers_count,
	FORMAT(physical_memory_kb, '#,0') AS physical_memory_kb,
	FORMAT(committed_kb, '#,0') AS committed_kb,
	sql_memory_model_desc
FROM 
	sys.dm_os_sys_info;