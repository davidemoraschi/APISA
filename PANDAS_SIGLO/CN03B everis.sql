/* Formatted on 19/12/2013 10:05:53 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducción Total o Parcial. */
	SELECT SAL.FECHA NATID_DIA
				,SAL.CENTROCONSUMO NATID_CENTROCONSUMO
				,SAL.ARTICULO NATID_ARTICULO
				, (CASE WHEN NIV.NIVEL <> 15 THEN -1 ELSE CLA.NIVELVALOR END) NATID_ECONOMICA_N4
				,SUM (SAL.IMPORTESALIDA) CN03B
		FROM REP_PRO_SIGLO.ALM_SALIDAALMACEN@SYG SAL
				,(SELECT DISTINCT VERSION
												 ,ARTICULO
												 ,NIVELVALOR
												 ,FECHAINICIOVALIDEZ
												 ,FECHAFINVALIDEZ
												 ,COMENTARIO
												 ,DEFECTO
												 ,CODIGOCONCATENADO
						FROM REP_PRO_SIGLO.CAT_ARTICULOCLASIF@SYG) CLA
				,REP_PRO_SIGLO.CAT_NIVELVALOR@SYG NIV
	 WHERE		 SAL.ARTICULO = CLA.ARTICULO
				 AND CLA.DEFECTO = 'T'
				 AND NIV.ID = CLA.NIVELVALOR
				 AND NIV.CLASIFICACION = 4
				 AND CLA.FECHAFINVALIDEZ IS NULL
				 AND SAL.CENTROCONSUMO IS NOT NULL
GROUP BY SAL.FECHA
				,SAL.CENTROCONSUMO
				,SAL.ARTICULO
				,(CASE WHEN NIV.NIVEL <> 15 THEN -1 ELSE CLA.NIVELVALOR END);