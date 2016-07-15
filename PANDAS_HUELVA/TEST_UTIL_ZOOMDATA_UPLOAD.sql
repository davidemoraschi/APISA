/* Formatted on 03/06/2013 12:52:45 (QP5 v5.163.1008.3004) */
BEGIN
   DBMS_SCHEDULER.DROP_JOB (job_name => 'TEST_UTIL_ZOOMDATA_UPLOAD');
END;

ALTER SESSION SET TIME_ZONE = 'Europe/Madrid';

BEGIN
   DBMS_SCHEDULER.create_job (
      job_name          => 'TEST_UTIL_ZOOMDATA_UPLOAD',
      job_type          => 'PLSQL_BLOCK',
      job_action        => 'BEGIN ETL_UTL_TEST_ZOOMDATA; END;',
      start_date        => CURRENT_TIMESTAMP                      /*hay que hacerlo así por el tema del cambio de hora en verano*/
                                            ,
      repeat_interval   => 'freq=secondly; interval=5;',
      end_date          => NULL,
      enabled           => TRUE,
      comments          => 'Carga de datos en tiempo real a Zoomdata');
END;