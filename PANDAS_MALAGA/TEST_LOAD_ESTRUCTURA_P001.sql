/* Formatted on 29/10/2013 17:30:54 (QP5 v5.163.1008.3004) */
BEGIN
   DBMS_SCHEDULER.DROP_JOB (job_name => 'TEST_LOAD_ESTRUCTURA_P001');
END;

ALTER SESSION SET TIME_ZONE = 'Europe/Madrid';

BEGIN
   DBMS_SCHEDULER.create_job (job_name          => 'TEST_LOAD_ESTRUCTURA_P001',
                              job_type          => 'PLSQL_BLOCK',
                              job_action        => 'BEGIN ETL_LOAD_ESTRUCTURA.P_001; END;',
                              start_date        => CURRENT_TIMESTAMP /*hay que hacerlo así por el tema del cambio de hora en verano*/
                                                                    ,
                              repeat_interval   => 'freq=minutely; interval=10;',
                              end_date          => NULL,
                              enabled           => TRUE,
                              comments          => 'Carga de estructura a partir de la réplica');
END;