/* ***************************************************************
プランキャッシュからキャッシュされているクエリの情報を取得
Support Platform : SQL Server 2008 以降

実行プランの OptimizerStatsUsage からプラン生成に利用された統計情報を確認
Support Platform : SQL Server 2016 SP2 / SQL Server 2017 以降
*************************************************************** */
USE master
GO
SET NOCOUNT ON
GO


DECLARE @Tag varchar(100) = '-- dbts2018%'

SELECT TOP 300
	GETDATE() AS DATE,
	[total_elapsed_time] / [execution_count] / 1000.0 AS [Average Elapsed Time (ms)], 
	[total_worker_time]  / [execution_count] / 1000.0 AS [Average Worker Time (ms)], 
	[total_physical_reads] / [execution_count] AS [Average Physical Read Count], 
	[total_logical_reads] / [execution_count] AS [Average Logical Read Count], 
	[total_logical_writes]  / [execution_count] AS [Average Logical Write], 
	[total_elapsed_time] / 1000.0 AS [total_elapsed_time (ms)],
	[total_worker_time] / 1000.0  AS [total_worker_time (ms)],
	([total_elapsed_time] - [total_worker_time]) / 1000.0  AS [elapsed_worker_diff_time (ms)],
	[total_physical_reads] AS [total_physical_reads (page)],
	[total_logical_reads] AS [total_logical_reads (page)],
	[total_logical_writes] AS [total_logical_writes (page)],
	[execution_count], 
	[total_rows],
	[last_rows],
	[min_rows],
	[max_rows],
	[total_dop],
	[last_dop],
	[min_dop],
	[max_dop],
	[total_grant_kb],
	[last_grant_kb],
	[min_grant_kb],
	[max_grant_kb],
	[total_used_grant_kb],
	[last_used_grant_kb],
	[min_used_grant_kb],
	[max_used_grant_kb],
	[total_ideal_grant_kb],
	[last_ideal_grant_kb],
	[min_ideal_grant_kb],
	[max_ideal_grant_kb],
	[total_reserved_threads],
	[last_reserved_threads],
	[min_reserved_threads],
	[max_reserved_threads],
	[total_used_threads],
	[last_used_threads]
	[min_used_threads],
	[max_used_threads],
	[plan_generation_num],
	[creation_time],
	[last_execution_time],
	[query_hash],
	[query_plan_hash],
	DB_NAME(st.dbid) AS db_name,
	REPLACE(REPLACE(REPLACE(SUBSTRING(text, 
	([statement_start_offset] / 2) + 1, 
	((CASE [statement_end_offset]
	WHEN -1 THEN DATALENGTH(text)
	ELSE [statement_end_offset]
	END - [statement_start_offset]) / 2) + 1),CHAR(13), ' '), CHAR(10), ' '), CHAR(9), ' ') AS [stmt_text],
	REPLACE(REPLACE(REPLACE([text],CHAR(13), ''), CHAR(10), ' '), CHAR(9), ' ') AS [text]
	,query_plan
FROM
	[sys].[dm_exec_query_stats]
	CROSS APPLY 
	[sys].[dm_exec_sql_text]([sql_handle]) AS st
	CROSS APPLY
	[sys].[dm_exec_query_plan]([plan_handle])
WHERE
	text LIKE @Tag
OPTION (RECOMPILE)
