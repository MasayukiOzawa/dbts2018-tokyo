/* ***************************************************************
パフォーマンスモニターの情報の取得
SQL Server on Linux ではこの情報を活用することがポイント
Page 系の項目については、 8KB ページの確保数となるため、8KB乗算しサイズに変換
Support Platform : SQL Server 2008 以降

https://blogs.msdn.microsoft.com/psssql/2013/09/23/interpreting-the-counter-values-from-sys-dm_os_performance_counters/
https://github.com/Microsoft/mssql-monitoring
http://localhost:3000/

*************************************************************** */
SELECT
	*
FROM
	sys.dm_os_performance_counters
GO

-- メモリの使用状況の取得
SELECT
	*
FROM
	sys.dm_os_performance_counters
WHERE
	object_name  LIKE '%Memory Manager%'
GO

-- プランキャッシュの使用状況の取得
SELECT
	*
FROM
	sys.dm_os_performance_counters
WHERE
	object_name  LIKE '%Plan Cache%'
GO
