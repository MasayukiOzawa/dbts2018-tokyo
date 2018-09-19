/* ***************************************************************
プランキャッシュのメモリ使用状況の取得
Support Platform : SQL Server 2008 以降
*************************************************************** */
SET NOCOUNT ON
GO
SELECT
	GETDATE() AS DATE, 
	[cacheobjtype], 
	[objtype], 
	COUNT(*) AS [Cache Count],
	SUM(CONVERT(bigint, usecounts)) AS [Total Use Counts], 
	SUM(CONVERT(bigint, [size_in_bytes])) / 1024 AS [size_in_bytes (KB)]
FROM 
	[sys].[dm_exec_cached_plans] WITH (NOLOCK)
GROUP BY
	[cacheobjtype],
	[objtype]
OPTION (RECOMPILE)

