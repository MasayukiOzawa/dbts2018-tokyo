/* ***************************************************************
DMV �ɂ�铝�v���̃q�X�g�O�����̕\��	(DBCC SHOW_STATISTICS WITH HISTOGRAM �� DMV ��)
Support Platform : SQL Server 2016 SP1 CU2 �ȍ~
*************************************************************** */
SELECT
	s.name,
	s.auto_created,
	sh.step_number,
	sh.range_high_key,
	sh.range_rows
FROM
	sys.stats s
	CROSS APPLY
	sys.dm_db_stats_histogram(s.object_id , s.stats_id) AS sh
WHERE
	s.object_id = OBJECT_ID('LINEITEM')
ORDER BY
	s.stats_id, 
	sh.step_number ASC
