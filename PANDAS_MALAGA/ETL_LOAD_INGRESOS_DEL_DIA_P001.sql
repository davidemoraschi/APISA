/* Formatted on 4/25/2014 9:24:37 (QP5 v5.163.1008.3004) */
BEGIN
   DBMS_SCHEDULER.DROP_JOB (job_name => 'ETL_LOAD_INGRESOS_DEL_DIA_P001');
END;

ALTER SESSION SET TIME_ZONE = 'Europe/Madrid';

BEGIN
   DBMS_SCHEDULER.create_job (
      job_name          => 'ETL_LOAD_INGRESOS_DEL_DIA_P001',
      job_type          => 'PLSQL_BLOCK',
      job_action        => 'BEGIN ETL_LOAD_INGRESOS_DEL_DIA.P_001; END;',
      start_date        => CURRENT_TIMESTAMP /*hay que hacerlo as� por el tema del cambio de hora en verano*/
                                            ,
      repeat_interval   => 'freq=daily; byhour=06; byminute=15; bysecond=45',
      end_date          => NULL,
      enabled           => TRUE,
      comments          => 'Carga de ingresos del d�a a partir de la r�plica');
END;