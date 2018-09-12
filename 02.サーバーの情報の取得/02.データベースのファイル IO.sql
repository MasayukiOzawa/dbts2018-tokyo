/* ***************************************************************
データベースファイル単位の I/O 状況の取得
Support Platform : SQL Server 2008 以降
*************************************************************** */
SELECT
	GETDATE() AS [DateTime],
	DB_NAME(mf.database_id) AS DatabaseName, 
	mf.name, 
	mf.physical_name, 
	fs.num_of_reads,
	fs.io_stall_read_ms,
	fs.num_of_bytes_read, 
	fs.num_of_writes, 
	fs.io_stall_write_ms,
	fs.num_of_bytes_written, 
	fs.size_on_disk_bytes
FROM
	sys.dm_io_virtual_file_stats(NULL, NULL) fs
	LEFT JOIN
	sys.master_files mf  WITH (NOLOCK)
	ON
	fs.database_id = mf.database_id
	AND
	fs.file_id = mf.file_id
OPTION (RECOMPILE)		
