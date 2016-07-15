/* Formatted on 04/12/2013 18:31:48 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducción Total o Parcial. */
--SELECT l.log_id "Log ID", TO_CHAR (l.log_date, 'yyyy/mm/dd hh24:mi:ss.ff tzh:tzm') "Log Date", L.operation "Operation", L.STATUS "Status", TO_CHAR (R.REQ_START_DATE, 'yyyy/mm/dd hh24:mi:ss.ff tzh:tzm') "Required Start Date", TO_CHAR (R.ACTUAL_START_DATE, 'yyyy/mm/dd hh24:mi:ss.ff tzh:tzm') "Actual Start Date", TO_CHAR (R.RUN_DURATION) "Run Duration", R.INSTANCE_ID "Instance ID", TO_CHAR (R.CPU_USED) "CPU Used", R.ADDITIONAL_INFO "Additional Info (Run)" FROM DBA_SCHEDULER_JOB_LOG L, DBA_SCHEDULER_JOB_RUN_DETAILS R WHERE l.log_id = r.log_id(+) AND R.ACTUAL_START_DATE IN (SELECT MAX (R.ACTUAL_START_DATE) FROM DBA_SCHEDULER_JOB_LOG L, DBA_SCHEDULER_JOB_RUN_DETAILS R WHERE l.Owner = 'MSTR_SIGLO' AND l.job_name = 'ETL_LOAD_CATALOGO_P001' AND l.log_id = r.log_id(+))
SELECT (	(TO_DATE (TO_CHAR (SYS_EXTRACT_UTC (R.ACTUAL_START_DATE), 'yyyymmddhh24miss'), 'yyyymmddhh24miss') - TO_DATE ('01-JAN-1970', 'dd-mon-yyyy'))
				* 86400
				* 1)
				 EPOCH
	FROM DBA_SCHEDULER_JOB_LOG L, DBA_SCHEDULER_JOB_RUN_DETAILS R
 WHERE l.log_id = r.log_id(+)
			 AND R.ACTUAL_START_DATE IN (SELECT MAX (R.ACTUAL_START_DATE)
																		 FROM DBA_SCHEDULER_JOB_LOG L, DBA_SCHEDULER_JOB_RUN_DETAILS R
																		WHERE l.Owner = 'MSTR_SIGLO' AND l.job_name = 'ETL_LOAD_CATALOGO_P001' AND l.log_id = r.log_id(+))