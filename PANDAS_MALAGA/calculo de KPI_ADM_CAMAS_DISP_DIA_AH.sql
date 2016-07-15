/* Formatted on 02/04/2014 10:51:39 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducción Total o Parcial. */
--KPI_ADM_CAMAS_DISP_DIA_AH
			 --Nº DE CAMAS DISPONIBLES O FUNCIONANTES POR DIA Y AH
			 --Camas de dotacion que estan en condiciones de ser ocupadas.

	SELECT TRUNC (SYSDATE), COUNT (1)
		FROM REP_HIS_OWN.COM_UBICACION_GESTION_LOCAL loc, rep_pro_est.ubicaciones ubi, rep_pro_est.tipos_ubicacion tubi
	 WHERE		 loc.activa = 1
				 AND loc.activa_en_estructura = 0
				 AND loc.unidad_funcional IS NOT NULL
				 AND loc.codigo_estructura = ubi.ubi_codigo
				 AND ubi.ubi_tip_ubicacion = tubi.tubi_codigo
				 AND tubi.tubi_codigo IN (14, 24)
GROUP BY TRUNC (SYSDATE)