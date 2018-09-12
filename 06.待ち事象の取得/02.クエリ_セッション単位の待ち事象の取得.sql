/* ***************************************************************
実行プランの待ち事象の取得 
Support Platform : SQL Server 2016 SP1 以降

セッション単位の WaitStats の取得
Support Platform : SQL Server 2016 以降
*************************************************************** */

USE [tpch]
GO

-- dbts2018
SELECT L_RETURNFLAG, L_LINESTATUS, SUM(L_QUANTITY) AS SUM_QTY,
 SUM(L_EXTENDEDPRICE) AS SUM_BASE_PRICE, SUM(L_EXTENDEDPRICE*(1-L_DISCOUNT)) AS SUM_DISC_PRICE,
 SUM(L_EXTENDEDPRICE*(1-L_DISCOUNT)*(1+L_TAX)) AS SUM_CHARGE, AVG(L_QUANTITY) AS AVG_QTY,
 AVG(L_EXTENDEDPRICE) AS AVG_PRICE, AVG(L_DISCOUNT) AS AVG_DISC, COUNT(*) AS COUNT_ORDER
FROM LINEITEM
WHERE L_SHIPDATE <= dateadd(dd, -90, cast('1998-12-01' as datetime))
GROUP BY L_RETURNFLAG, L_LINESTATUS
ORDER BY L_RETURNFLAG,L_LINESTATUS
GO
-- 40 秒程度、実行に時間がかかる
-- 実行プランから WaitStats を取得

-- セッション単位の待ち事象の取得
SELECT
	*
FROM
	sys.dm_exec_session_wait_stats
WHERE
	session_id = @@SPID
