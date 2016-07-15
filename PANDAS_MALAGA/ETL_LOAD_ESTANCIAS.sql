/* Formatted on 03/04/2014 13:10:44 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducción Total o Parcial. */
BEGIN
	DBMS_SCHEDULER.DROP_JOB (job_name => 'ETL_LOAD_ESTANCIAS_P001');
END;

ALTER SESSION SET TIME_ZONE = 'Europe/Madrid';

BEGIN
	DBMS_SCHEDULER.create_job (job_name => 'ETL_LOAD_ESTANCIAS_P001'
														,job_type => 'PLSQL_BLOCK'
														,job_action => 'BEGIN ETL_LOAD_ESTANCIAS_V3.P_001; END;'
														,start_date => CURRENT_TIMESTAMP /*hay que hacerlo así por el tema del cambio de hora en verano*/
														,repeat_interval	 => 'freq=daily; byhour=08; byminute=30; bysecond=30'
														,end_date => NULL
														,enabled => TRUE
														,comments => 'Carga de traslados y estancias a partir de la réplica');
END;