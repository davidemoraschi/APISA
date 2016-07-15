/* Formatted on 03/06/2013 12:52:45 (QP5 v5.163.1008.3004) */
BEGIN
   DBMS_SCHEDULER.DROP_JOB (job_name => 'ETL_UTIL_CHECK_CONSU_P001');
END;

ALTER SESSION SET TIME_ZONE = 'Europe/Madrid';

BEGIN
   DBMS_SCHEDULER.create_job (
      job_name          => 'ETL_UTIL_CHECK_CONSU_P001',
      job_type          => 'PLSQL_BLOCK',
      job_action        => 'BEGIN ETL_UTIL_CHECK_CONSU; END;',
      start_date        => CURRENT_TIMESTAMP                      /*hay que hacerlo así por el tema del cambio de hora en verano*/
                                            ,
      repeat_interval   => 'freq=daily; byhour=08; byminute=30; bysecond=00',
      end_date          => NULL,
      enabled           => TRUE,
      comments          => 'Carga de datos de AGD desde replica de producción');
END;