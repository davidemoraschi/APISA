/* Formatted on 25/06/2014 9:19:33 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducción Total o Parcial. */
SELECT ALL_MVIEWS.OWNER, ALL_MVIEWS.MVIEW_NAME, (LAST_REFRESH_DATE), (LAST_ANALYZED)
	FROM ALL_MVIEWS@HUE40DAE JOIN ALL_TABLES@HUE40DAE ON (ALL_MVIEWS.OWNER = ALL_TABLES.OWNER AND ALL_MVIEWS.MVIEW_NAME = ALL_TABLES.TABLE_NAME)
 WHERE ALL_MVIEWS.OWNER = 'REP_HIS_OWN'
 ORDER BY 3