/* ***************************************************************
DB 単位のバッファキャッシュの使用状況の取得
Support Platform : SQL Server 2008 以降
*************************************************************** */
SET NOCOUNT ON
GO
SELECT 
	GETDATE() AS DATE, 
	CASE database_id 
		WHEN 32767 THEN 'ResourceDb' 
		ELSE db_name(database_id) 
	END AS [Database_name], 
	[is_in_bpool_extension],
	count(*) AS [Page Count], 
	count(*) * 8.0 AS [Page Size (KB)]
FROM
	[sys].[dm_os_buffer_descriptors] WITH (NOLOCK)
GROUP BY
	db_name(database_id), 
	[database_id],
	[is_in_bpool_extension]
ORDER BY 
	[database_id] ASC,
	[is_in_bpool_extension] ASC
OPTION (RECOMPILE)
