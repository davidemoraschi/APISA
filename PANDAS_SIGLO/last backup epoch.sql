/* Formatted on 06/12/2013 9:07:03 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducción Total o Parcial. */
SELECT epoch2 (end_time) last_backup_epoc, status
	FROM (	SELECT start_time,
								 end_time,
								 STATUS,
								 RANK () OVER (ORDER BY MAX (END_TIME) DESC NULLS LAST) WJXBFS2
						FROM v$rman_status
					 WHERE OPERATION = 'BACKUP'
				GROUP BY start_time,
								 end_time,
								 STATUS,
								 RECID)
 --WHERE WJXBFS2 = 1;