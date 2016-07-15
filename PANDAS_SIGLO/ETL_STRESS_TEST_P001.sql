/* Formatted on 12/11/2013 14:44:34 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducción Total o Parcial. */
BEGIN
	DBMS_SCHEDULER.DROP_JOB (job_name => 'ETL_STRESS_TEST_P001');
END;

ALTER SESSION SET TIME_ZONE = 'Europe/Madrid';

BEGIN
	DBMS_SCHEDULER.create_job (
		job_name => 'ETL_STRESS_TEST_P001',
		job_type => 'PLSQL_BLOCK',
		job_action => 'BEGIN send_to_sp2013_textfile_v2(reportId => ''A0A6253D4CA29DD57030D68E934D3EFA'', projectName=>''SIGLO_DESARROLLO''); END;',
		start_date => CURRENT_TIMESTAMP /*hay que hacerlo así por el tema del cambio de hora en verano*/
																	 ,
		repeat_interval => 'freq=minutely; interval=10; byhour=7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23',
		end_date => NULL,
		enabled => TRUE,
		comments => 'Carga de ficheros de texto a Sharepoint 2013 corp');
END;