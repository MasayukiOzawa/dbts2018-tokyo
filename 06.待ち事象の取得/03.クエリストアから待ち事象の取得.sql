/* ***************************************************************
クエリストアから待ち事象の取得
Support Platform : SQL Server 2017 以降
*************************************************************** */

-- 特定クエリの情報を取得するために、実行プランの QueryHash を検索に使用
DECLARE @query_hash binary(8) = 0xB4A24E1213D92EE3

SELECT
	DATEADD(hour, 9, rsi.start_time) AS start_time,
/*
	DATEADD(hour, 9, rsi.end_time) AS end_time,
	DATEADD(hour, 9, rs.first_execution_time) AS first_execution_time,
	DATEADD(hour, 9, rs.last_execution_time) AS last_execution_time,
	DATEADD(hour, 9, p.initial_compile_start_time) AS initial_compile_start_time,
	DATEADD(hour, 9, p.last_compile_start_time) AS last_compile_start_time,
	DATEADD(hour, 9, p.last_execution_time) AS last_execution_time,
*/
	qt.query_sql_text,
	CAST (p.query_plan AS xml) AS query_plan,
	ws.wait_category_desc,
	ws.execution_type_desc,
	ws.total_query_wait_time_ms,
	ws.avg_query_wait_time_ms,
	ws.last_query_wait_time_ms,
	ws.min_query_wait_time_ms,
	ws.max_query_wait_time_ms,
	ws.stdev_query_wait_time_ms,
	p.engine_version,
	p.compatibility_level,
	rs.execution_type,
	rs.count_executions,
	rs.avg_duration,
	rs.last_duration,
	rs.min_duration,
	rs.max_duration,
	rs.stdev_duration,
	rs.avg_cpu_time,
	rs.last_cpu_time,
	rs.min_cpu_time,
	rs.max_cpu_time,
	rs.stdev_cpu_time,
	rs.avg_logical_io_reads,
	rs.last_logical_io_reads,
	rs.min_logical_io_reads,
	rs.max_logical_io_reads,
	rs.stdev_logical_io_reads,
	rs.avg_logical_io_writes,
	rs.last_logical_io_writes,
	rs.min_logical_io_writes,
	rs.max_logical_io_writes,
	rs.stdev_logical_io_writes,
	rs.avg_physical_io_reads,
	rs.last_physical_io_reads,
	rs.min_physical_io_reads,
	rs.max_physical_io_reads,
	rs.stdev_physical_io_reads,
	rs.avg_clr_time,
	rs.last_clr_time,
	rs.min_clr_time,
	rs.max_clr_time,
	rs.stdev_clr_time,
	rs.avg_dop,
	rs.last_dop,
	rs.min_dop,
	rs.max_dop,
	rs.stdev_dop,
	rs.avg_query_max_used_memory,
	rs.last_query_max_used_memory,
	rs.min_query_max_used_memory,
	rs.max_query_max_used_memory,
	rs.stdev_query_max_used_memory,
	rs.avg_rowcount,
	rs.last_rowcount,
	rs.min_rowcount,
	rs.max_rowcount,
	rs.stdev_rowcount,
	rs.avg_num_physical_io_reads,
	rs.last_num_physical_io_reads,
	rs.min_num_physical_io_reads,
	rs.max_num_physical_io_reads,
	rs.stdev_num_physical_io_reads,
	rs.avg_log_bytes_used,
	rs.last_log_bytes_used,
	rs.min_log_bytes_used,
	rs.max_log_bytes_used,
	rs.stdev_log_bytes_used,
	rs.avg_tempdb_space_used,
	rs.last_tempdb_space_used,
	rs.min_tempdb_space_used,
	rs.max_tempdb_space_used,
	rs.stdev_tempdb_space_used,
	p.avg_compile_duration,
	p.last_compile_duration, 
	p.plan_forcing_type_desc
FROM 
	sys.query_store_runtime_stats_interval AS rsi
	INNER JOIN
		sys.query_store_runtime_stats AS rs
		ON
		rs.runtime_stats_interval_id = rsi.runtime_stats_interval_id
	INNER JOIN
		sys.query_store_plan AS p
		ON
		p.query_id = rs.plan_id
	INNER JOIN
		sys.query_store_query AS q
		ON
		q.query_id = p.query_id
	INNER JOIN
		sys.query_store_query_text AS qt
	ON
		qt.query_text_id = q.query_text_id
	INNER JOIN
		sys.query_store_wait_stats AS ws
	ON
		ws.plan_id = rs.plan_id
		AND
		ws.runtime_stats_interval_id = rsi.runtime_stats_interval_id
WHERE
	rsi.start_time >= DATEADD(MINUTE, -50, GETUTCDATE())
	AND
	q.query_hash = @query_hash
