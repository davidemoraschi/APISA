/* Formatted on 31/05/2013 11:15:10 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW MSTR_UTL_SCHEDULER_JOB_LOG
(
   CLAVE_PRIMARIA_LOG,
   FECHA_INICIO_TAREA,
   OPERACION,
   RESULTADO,
   DURACION,
   INFORMACION
)
AS
 SELECT l.log_id clave_primaria_log,
                    --TO_CHAR (l.log_date, 'yyyy/mm/dd hh24:mi:ss.ff tzh:tzm') "Log Date",
                    --(R.ACTUAL_START_DATE) fecha_inicio_tarea,
                    --to_date(R.ACTUAL_START_DATE,'dd.mm.yyyy hh24:mi:ss'),
                    NEW_TIME (R.ACTUAL_START_DATE, 'GMT', 'GMT') fecha_inicio_tarea,
                    L.operation operacion,
                    L.STATUS resultado,
                    -- L.user_name "User Name",
                    --L.CLIENT_ID "Client ID",
                    --L.global_uid "Global UID",
                    --TO_CHAR (R.REQ_START_DATE, 'yyyy/mm/dd hh24:mi:ss.ff tzh:tzm') "Required Start Date",
                    --TO_CHAR (R.ACTUAL_START_DATE, 'yyyy/mm/dd hh24:mi:ss.ff tzh:tzm') fecha_inicio_tarea,
                    TO_CHAR (R.RUN_DURATION) duracion,
                    --R.INSTANCE_ID "Instance ID",
                    --R.SESSION_ID "Session ID",
                    --R.SLAVE_PID "Slave PID",
                    --TO_CHAR (R.CPU_USED) "CPU Used",
                    R.ADDITIONAL_INFO informacion
               FROM ALL_SCHEDULER_JOB_LOG L, ALL_SCHEDULER_JOB_RUN_DETAILS R
              WHERE l.Owner = 'MSTR_HOSPITALIZACION' AND l.job_name = 'ETL_LOAD_HISTO_CAMAS_P001' AND l.log_id = r.log_id(+)
           --ORDER BY TO_CHAR (R.ACTUAL_START_DATE, 'yyyy/mm/dd hh24:mi:ss.ff tzh:tzm') DESC
