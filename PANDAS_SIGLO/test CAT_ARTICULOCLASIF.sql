/* Formatted on 19/12/2013 11:37:27 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducción Total o Parcial. */
--SELECT *
--FROM REP_PRO_SIGLO.CAT_ARTICULOCLASIF
--JOIN	(
	SELECT COUNT (ID) N, ARTICULO, NIVELVALOR
		FROM (SELECT ID -- ,VERSION
									 , ARTICULO, NIVELVALOR
						-- ,FECHAINICIOVALIDEZ
						-- ,FECHAFINVALIDEZ
						-- ,COMENTARIO
						-- ,DEFECTO
						-- ,CODIGOCONCATENADO
						FROM REP_PRO_SIGLO.CAT_ARTICULOCLASIF
					 WHERE		 FECHAFINVALIDEZ IS NULL
								 AND DEFECTO = 'T'
								 AND NIVELVALOR IN (SELECT ID
																			FROM REP_PRO_SIGLO.CAT_NIVELVALOR
																		 WHERE CLASIFICACION = 4))
GROUP BY ARTICULO, NIVELVALOR
--																										 ) USING (ARTICULO, NIVELVALOR)
--																										 WHERE N > 1
--																										 ORDER BY 1,2
/

SELECT /*ID, */
			 /*VERSION, */
			 ARTICULO
			,NIVELVALOR
			,FECHAINICIOVALIDEZ
			,FECHAFINVALIDEZ
			,COMENTARIO
			,DEFECTO --, CODIGOCONCATENADO
	FROM REP_PRO_SIGLO.CAT_ARTICULOCLASIF JOIN REP_PRO_SIGLO.CAT_NIVELVALOR ON (CAT_NIVELVALOR.ID = CAT_ARTICULOCLASIF.NIVELVALOR)
 WHERE FECHAFINVALIDEZ IS NULL AND DEFECTO = 'T' AND CLASIFICACION = 4
/
--AND NIVELVALOR IN (SELECT ID FROM REP_PRO_SIGLO.CAT_NIVELVALOR WHERE CLASIFICACION = 4)

	SELECT ARTICULO, NIVELVALOR NATID_ECONOMICA_N4
		FROM (SELECT ID, ARTICULO, NIVELVALOR
						FROM REP_PRO_SIGLO.CAT_ARTICULOCLASIF
					 WHERE		 FECHAFINVALIDEZ IS NULL
								 AND DEFECTO = 'T'
								 AND NIVELVALOR IN (SELECT ID
																			FROM REP_PRO_SIGLO.CAT_NIVELVALOR
																		 WHERE CLASIFICACION = 4))
GROUP BY ARTICULO, NIVELVALOR
/

	SELECT TRUNC (FECHA) NATID_DIA
				,ARTICULO NATID_ARTICULO
				,NVL (CENTROCONSUMO, -1) NATID_CENTROCONSUMO
				,NVL (NATID_ECONOMICA_N4, -1) NATID_ECONOMICA_N4
				,SUM (CANTIDADSALIDA) C
				,SUM (IMPORTESALIDA) I
		FROM	 REP_PRO_SIGLO.ALM_SALIDAALMACEN
				 LEFT JOIN
					 (	SELECT ARTICULO, NIVELVALOR NATID_ECONOMICA_N4
								FROM (SELECT ID, ARTICULO, NIVELVALOR
												FROM REP_PRO_SIGLO.CAT_ARTICULOCLASIF
											 WHERE		 FECHAFINVALIDEZ IS NULL
														 AND DEFECTO = 'T'
														 AND NIVELVALOR IN (SELECT ID
																									FROM REP_PRO_SIGLO.CAT_NIVELVALOR
																								 WHERE CLASIFICACION = 4))
						GROUP BY ARTICULO, NIVELVALOR)
				 USING (ARTICULO)
	 WHERE FECHA BETWEEN ('01-ENE-2012') AND ('31-DiC-2013') AND CENTROCONSUMO IS NOT NULL
GROUP BY TRUNC (FECHA), ARTICULO, CENTROCONSUMO