/* Formatted on 05/06/2013 13:09:16 (QP5 v5.163.1008.3004) */
SET DEFINE OFF

BEGIN
   DBMS_SCHEDULER.DROP_JOB (job_name => 'ETL_LOAD_CONSU_HISTORICO_E003');
END;

ALTER SESSION SET TIME_ZONE = 'Europe/Madrid';

DECLARE
   l_job_action   VARCHAR2 (32000);
--l_mes VARCHAR2 :=
BEGIN
   EXECUTE IMMEDIATE 'ALTER SESSION SET TIME_ZONE = ''Europe/Madrid''';

   l_job_action :=
      'curl -v -s -d "td_ap=2-DW2&mes_i=%mes%&mes_f=%mes%&layout=txt&fecha_ini=%ayer%&fecha_fin=%ayer%&f=%ahora%&dia_i=%dia%&dia_f=%dia%&boton=ACEPTAR&area=02004&anio_i=%year%&anio_f=%year%" -o C:\repositorio\archivos\CCEE\TXT\infhos.txt http://10.234.23.171/infhos.php';
   DBMS_OUTPUT.put_line (l_job_action);
--
--   DBMS_SCHEDULER.CREATE_JOB (job_name     => 'ETL_LOAD_CONSU_HISTORICO_E003',
--                              job_type     => 'EXECUTABLE',
--                              job_action   => l_job_action,
--                              start_date   => CURRENT_TIMESTAMP   /*hay que hacerlo así por el tema del cambio de hora en verano*/
--                                                               ,
--                              --repeat_interval   => 'freq=daily; byhour=04; byminute=15; bysecond=00',
--                              end_date     => NULL,
--                              enabled      => FALSE,
--                              auto_drop    => TRUE,
--                              comments     => 'Carga de historico de consultas desde CITAWEB');
--   --DBMS_SCHEDULER.set_job_argument_value ('lsdir', 1, '/u01/app/oracle/consultas_externas');
--   --DBMS_SCHEDULER.set_attribute ('lsdir', 'credential_name', 'my_cred');
--   DBMS_SCHEDULER.enable ('ETL_LOAD_CONSU_HISTORICO_E003');

END;
/