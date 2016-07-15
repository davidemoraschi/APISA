/* Formatted on 03/04/2014 13:58:20 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducción Total o Parcial. */
SELECT UBI_CODIGO, UBI_NOMBRE--*
	FROM REP_HIS_OWN.COM_UBICACION_GESTION_LOCAL@SEE40DAE
			 JOIN REP_PRO_EST.UBICACIONES@SEE40DAE
				 ON (CODIGO_ESTRUCTURA = UBI_CODIGO)
			 JOIN REP_PRO_EST.CENTROS_AH@SEE40DAE
				 ON (UBI_CAH_CODIGO = CAH_CODIGO)
                 WHERE CAH_AH_CODIGO = '02004'
                 AND ACTIVA = 1 AND UBI_ACTIVO = 0