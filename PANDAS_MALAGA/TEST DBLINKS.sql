/* Formatted on 08/04/2014 17:42:15 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducción Total o Parcial. */
EXEC dbms_output.put_line(FUNC_is_link_active ('ALE42DAE'));

SELECT DB_LINK -- ACTIVE
	FROM ALL_DB_LINKS
 WHERE OWNER = 'PUBLIC';
 --AND FUNC_is_link_active (DB_LINK) = 0;
 
SELECT MIN(LAST_REFRESH_DATE) MIN_REFRESH_DATE, MAX(LAST_REFRESH_DATE) MAX_REFRESH_DATE FROM SYS.ALL_MVIEWS@COE42DAE WHERE OWNER = 'REP_HIS_OWN';
--AND MVIEW_NAME = 'COM_UBICACION_GESTION_LOCAL';