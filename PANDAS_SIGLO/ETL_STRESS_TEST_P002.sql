/* Formatted on 12/11/2013 21:41:37 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducción Total o Parcial. */
BEGIN
	DBMS_SCHEDULER.DROP_JOB (job_name => 'ETL_STRESS_TEST_P002');
END;

ALTER SESSION SET TIME_ZONE = 'Europe/Madrid';

BEGIN
	DBMS_SCHEDULER.create_job (
		job_name => 'ETL_STRESS_TEST_P002',
		job_type => 'PLSQL_BLOCK',
		--job_action => 'BEGIN send_to_SP2013_excelfile_v2(reportId => ''4DE847CD465AFDD5097459AC59F08F92'', projectName=>''SIGLO_DESARROLLO''); END;', 
		job_action => 'BEGIN send_to_SP2013_excelfile_v2(reportId => ''7B6EC0B64FEDD1D2B499A6AD959F463F'', projectName=>''SIGLO_DESARROLLO''); END;',
        --job_action => 'BEGIN send_to_SP2013_excelfile_v2(reportId => ''4DE847CD465AFDD5097459AC59F08F92'', projectName=>''SIGLO_DESARROLLO''); END;',
		start_date => CURRENT_TIMESTAMP /*hay que hacerlo así por el tema del cambio de hora en verano*/
																	 ,
		repeat_interval => 'freq=minutely; interval=10; byhour=7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23',
		end_date => NULL,
		enabled => TRUE,
		comments => 'Carga de ficheros de excel a Sharepoint 2013 corp');
END;