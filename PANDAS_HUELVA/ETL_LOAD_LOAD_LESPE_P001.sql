/* Formatted on 08/10/2012 9:19:08 (QP5 v5.163.1008.3004) */
BEGIN
   DBMS_SCHEDULER.DROP_JOB (job_name => 'ETL_LOAD_LOAD_LESPE_P001');
END;

ALTER SESSION SET TIME_ZONE = 'Europe/Madrid';

BEGIN
   DBMS_SCHEDULER.create_job (
      job_name          => 'ETL_LOAD_LOAD_LESPE_P001',
      job_type          => 'PLSQL_BLOCK',
      job_action        => 'BEGIN ETL_LOAD_LISTA_DE_ESPERA.P_001; END;',
      start_date        => CURRENT_TIMESTAMP /*hay que hacerlo así por el tema del cambio de hora en verano*/
                                            ,
      repeat_interval   => 'freq=daily; byhour=03; byminute=45; bysecond=00',
      end_date          => NULL,
      enabled           => TRUE,
      comments          => 'Carga de datos de AGD desde replica de producción');
END;