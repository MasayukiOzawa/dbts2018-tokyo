/* ***************************************************************
�N�G�� �R���p�C���̃������Q�[�g�E�F�C�̎擾
Support Platform : SQL Server 2016 �ȍ~

https://blogs.msdn.microsoft.com/sql_server_team/multi-fold-increase-in-throughput-for-big-gateway-query-compiles-in-sql-server/
*************************************************************** */
SELECT 
	* 
FROM 
	sys.dm_exec_query_optimizer_memory_gateways 