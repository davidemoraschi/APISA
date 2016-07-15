/* Formatted on 28/05/2013 9:36:59 (QP5 v5.163.1008.3004) */
--EXEC DBMS_SCHEDULER.drop_credential('TIM_HALL_CREDENTIAL');
--exec dbms_scheduler.create_credential('root_cred','root','all828inpatientbeds')
-- Create a job that lists a directory. After running, the job is dropped.


BEGIN
   DBMS_SCHEDULER.DROP_JOB (job_name => 'ETL_LOAD_CONSU_EXTERNAS_E001');
END;

ALTER SESSION SET TIME_ZONE = 'Europe/Madrid';

BEGIN
   DBMS_SCHEDULER.CREATE_JOB (job_name          => 'ETL_LOAD_CONSU_EXTERNAS_E001',
                              job_type          => 'EXECUTABLE',
                              job_action        => '/u01/app/oracle/consultas_externas/descarga_infhos_consultas.sh',
                              start_date        => CURRENT_TIMESTAMP /*hay que hacerlo así por el tema del cambio de hora en verano*/
                                                                    ,
                              repeat_interval   => 'freq=daily; byhour=04; byminute=00; bysecond=00',
                              end_date          => NULL,
                              enabled           => TRUE,
                              comments          => 'Carga de datos de consultas desde INFHOS');
   --DBMS_SCHEDULER.set_job_argument_value ('lsdir', 1, '/u01/app/oracle/consultas_externas');
   --DBMS_SCHEDULER.set_attribute ('lsdir', 'credential_name', 'my_cred');
   --DBMS_SCHEDULER.enable ('ETL_LOAD_CONSU_EXTERNAS_E001');
END;
/