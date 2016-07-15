/* Formatted on 06/11/2013 16:55:53 (QP5 v5.163.1008.3004) */
BEGIN
   DBMS_SCHEDULER.DROP_JOB (job_name => 'ETL_LOAD_ECONOMICA_P001');
END;

ALTER SESSION SET TIME_ZONE = 'Europe/Madrid';

BEGIN
   DBMS_SCHEDULER.create_job (job_name          => 'ETL_LOAD_ECONOMICA_P001',
                              job_type          => 'PLSQL_BLOCK',
                              job_action        => 'BEGIN MSTR_SIGLO.ETL_LOAD_ECONOMICA.P_001; END;',
                              start_date        => CURRENT_TIMESTAMP /*hay que hacerlo así por el tema del cambio de hora en verano*/
                                                                    ,
                              repeat_interval   => 'freq=daily; byhour=01; byminute=22; bysecond=22',
                              end_date          => NULL,
                              enabled           => TRUE,
                              comments          => 'Carga de jerarquía ECONÓMICA desde replica de SIGLO');
END;