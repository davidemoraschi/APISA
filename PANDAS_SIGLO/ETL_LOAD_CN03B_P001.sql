/* Formatted on 27/01/2014 18:25:32 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducción Total o Parcial. */
BEGIN
	DBMS_SCHEDULER.DROP_JOB (job_name => 'ETL_LOAD_CN03B_P001');
END;

ALTER SESSION SET TIME_ZONE = 'Europe/Madrid';

BEGIN
	DBMS_SCHEDULER.create_job (job_name => 'ETL_LOAD_CN03B_P001'
														,job_type => 'PLSQL_BLOCK'
														,job_action => 'BEGIN MSTR_SIGLO.ETL_LOAD_CN03B.P_001; END;'
														,start_date => CURRENT_TIMESTAMP /*hay que hacerlo así por el tema del cambio de hora en verano*/
														,repeat_interval => 'freq=daily; byhour=02; byminute=44; bysecond=44'
														,end_date => NULL
														,enabled => TRUE
														,comments => 'Carga de indicador CN03B desde replica de SIGLO');
END;