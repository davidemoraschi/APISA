/* Formatted on 19/11/2013 13:07:13 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducción Total o Parcial. */
BEGIN
	DBMS_SCHEDULER.DROP_JOB (job_name => 'ETL_LOAD_GA02B_P001');
END;

ALTER SESSION SET TIME_ZONE = 'Europe/Madrid';

BEGIN
	DBMS_SCHEDULER.create_job (job_name => 'ETL_LOAD_GA02B_P001',
														 job_type => 'PLSQL_BLOCK',
														 job_action => 'BEGIN MSTR_SIGLO.ETL_LOAD_GA02B.P_001; END;',
														 start_date => CURRENT_TIMESTAMP /*hay que hacerlo así por el tema del cambio de hora en verano*/
																														,
														 repeat_interval => 'freq=daily; byhour=02; byminute=22; bysecond=22',
														 end_date => NULL,
														 enabled => TRUE,
														 comments => 'Carga de indicador GA02B desde replica de SIGLO');
END;