/* Formatted on 08/10/2012 9:19:08 (QP5 v5.163.1008.3004) */
BEGIN
   DBMS_SCHEDULER.DROP_JOB (job_name => 'ETL_LOAD_CONSU_EXTERNAS_P002');
END;

ALTER SESSION SET TIME_ZONE = 'Europe/Madrid';

BEGIN
   DBMS_SCHEDULER.create_job (
      job_name          => 'ETL_LOAD_CONSU_EXTERNAS_P002',
      job_type          => 'PLSQL_BLOCK',
      job_action        => 'BEGIN ETL_LOAD_CONSULTAS_EXTERNAS.P_002; END;',
      start_date        => CURRENT_TIMESTAMP /*hay que hacerlo así por el tema del cambio de hora en verano*/
                                            ,
      repeat_interval   => 'freq=daily; byhour=04; byminute=30; bysecond=00',
      end_date          => NULL,
      enabled           => TRUE,
      comments          => 'Carga de datos de CITAWEB desde la descarga del web service');
END;