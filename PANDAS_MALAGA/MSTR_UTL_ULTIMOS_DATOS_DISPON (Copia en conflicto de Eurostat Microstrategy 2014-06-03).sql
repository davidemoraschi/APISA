/* Formatted on 29/04/2014 10:06:23 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducción Total o Parcial. */
CREATE OR REPLACE FORCE VIEW MSTR_UTL_ULTIMOS_DATOS_DISPON
 AS
	SELECT *
		FROM TABLE (func_get_tab_tf_replicas);
