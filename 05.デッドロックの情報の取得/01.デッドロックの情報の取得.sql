/* ***************************************************************
デッドロックの情報を後追いで取得
Support Platform : SQL Server 2008 以降
*************************************************************** */

-- デッドロックの発生用クエリ
use [tpch]
GO
DROP TABLE IF EXISTS DLTest
GO
CREATE TABLE DLTest(
	C1 int identity,
	C2 uniqueidentifier DEFAULT(NEWID()),
	CONSTRAINT PK_DLTEST  PRIMARY KEY CLUSTERED(C1)
)
GO
INSERT INTO DLTest DEFAULT VALUES
INSERT INTO DLTest DEFAULT VALUES
GO
/****************************************/
-- Session #1 で実行
/****************************************/
USE tpch
GO
BEGIN TRAN
SELECT * FROM DLTest WITH (UPDLOCK) WHERE C1 = 1
UPDATE DLTest SET C2 = NEWID() WHERE C1 = 2
-- ROLLBACK TRAN


/****************************************/
-- Session #2 で実行
/****************************************/
USE tpch
GO
BEGIN TRAN
SELECT * FROM DLTest WITH (UPDLOCK) WHERE C1 = 2
UPDATE DLTest SET C2 = NEWID() WHERE C1 = 1
-- ROLLBACK TRAN

/****************************************/
-- デッドロックの確認
/****************************************/
-- event_file から取得 (キャッシュがファイルにフラッシュされるまで、多少のタイムラグがある)
DECLARE @file nvarchar(max) = N'/var/opt/mssql/log/system_health*.xel'

SELECT
	DATEADD(hour,9 , xmldata.value('(/event/@timestamp)[1]', 'datetime')) AS timestamp,
	object_name,
	xmldata.value('(/event/data/value/deadlock/process-list//inputbuf)[1]', 'nvarchar(max)') AS blocking_process_1,
	xmldata.value('(/event/data/value/deadlock/process-list//inputbuf)[2]', 'nvarchar(max)') AS blocking_process_2,
	xmldata
FROM(
	SELECT
		object_name,
		CAST(event_data AS XML) AS xmldata
	FROM
		sys.fn_xe_file_target_read_file(@file, NULL, NULL, NULL)
	WHERE
		object_name IN('xml_deadlock_report')
) AS x
ORDER BY timestamp ASC
GO
