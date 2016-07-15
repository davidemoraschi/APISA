/* Formatted on 08/10/2012 9:19:08 (QP5 v5.163.1008.3004) */
BEGIN
   DBMS_SCHEDULER.DROP_JOB (job_name => 'ETL_LOAD_CONSU_EXTERNAS_P001');
END;

ALTER SESSION SET TIME_ZONE = 'Europe/Madrid';

BEGIN
   DBMS_SCHEDULER.create_job (
      job_name          => 'ETL_LOAD_CONSU_EXTERNAS_P001',
      job_type          => 'PLSQL_BLOCK',
      job_action        => 'BEGIN ETL_LOAD_CONSULTAS_EXTERNAS.P_001; END;',
      start_date        => CURRENT_TIMESTAMP /*hay que hacerlo as� por el tema del cambio de hora en verano*/
                                            ,
      repeat_interval   => 'freq=daily; byhour=07; byminute=00; bysecond=00',
      end_date          => NULL,
      enabled           => TRUE,
      comments          => 'Carga de datos de AGD desde replica de producci�n');
END;