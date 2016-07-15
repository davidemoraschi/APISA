/* Formatted on 04/12/2013 9:01:03 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducción Total o Parcial. */
	SELECT l.log_id "Log ID",
				 TO_CHAR (l.log_date, 'yyyy/mm/dd hh24:mi:ss.ff tzh:tzm') "Log Date",
				 L.operation "Operation",
				 L.STATUS "Status",
				 L.user_name "User Name",
				 L.CLIENT_ID "Client ID",
				 L.global_uid "Global UID",
				 TO_CHAR (R.REQ_START_DATE, 'yyyy/mm/dd hh24:mi:ss.ff tzh:tzm') "Required Start Date",
				 TO_CHAR (R.ACTUAL_START_DATE, 'yyyy/mm/dd hh24:mi:ss.ff tzh:tzm') "Actual Start Date",
				 TO_CHAR (R.RUN_DURATION) "Run Duration",
				 R.INSTANCE_ID "Instance ID",
				 R.SESSION_ID "Session ID",
				 R.SLAVE_PID "Slave PID",
				 TO_CHAR (R.CPU_USED) "CPU Used",
				 R.ADDITIONAL_INFO "Additional Info (Run)"
		FROM ALL_SCHEDULER_JOB_LOG L, ALL_SCHEDULER_JOB_RUN_DETAILS R
	 WHERE l.Owner = 'MSTR_SIGLO' AND l.job_name = 'ETL_LOAD_CATALOGO_P001' AND l.log_id = r.log_id(+)
ORDER BY 1 DESC