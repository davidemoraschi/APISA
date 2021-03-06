/* Formatted on 04/12/2013 18:16:57 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducción Total o Parcial. */
SELECT ( (TO_DATE (TO_CHAR (SYS_EXTRACT_UTC (SYSTIMESTAMP), 'yyyymmddhh24miss'), 'yyyymmddhh24miss') - TO_DATE ('01-JAN-1970', 'dd-mon-yyyy')) * 86400 * 1000) EPOCH
	FROM DUAL
--UNION ALL
--SELECT EXTRACT (DAY FROM (FROM_TZ (CAST (CURRENT_TIMESTAMP AS TIMESTAMP), SESSIONTIMEZONE) AT TIME ZONE 'UTC' - TIMESTAMP '1970-01-01 00:00:00 +00:00'))
--			 * 86400
--			 + EXTRACT (HOUR FROM (FROM_TZ (CAST (CURRENT_TIMESTAMP AS TIMESTAMP), SESSIONTIMEZONE) AT TIME ZONE 'UTC' - TIMESTAMP '1970-01-01 00:00:00 +00:00'))
--				 * 3600
--			 + EXTRACT (MINUTE FROM (FROM_TZ (CAST (CURRENT_TIMESTAMP AS TIMESTAMP), SESSIONTIMEZONE) AT TIME ZONE 'UTC' - TIMESTAMP '1970-01-01 00:00:00 +00:00'))
--				 * 60
--			 + EXTRACT (SECOND FROM (FROM_TZ (CAST (CURRENT_TIMESTAMP AS TIMESTAMP), SESSIONTIMEZONE) AT TIME ZONE 'UTC' - TIMESTAMP '1970-01-01 00:00:00 +00:00'))
--				 n
--	FROM DUAL