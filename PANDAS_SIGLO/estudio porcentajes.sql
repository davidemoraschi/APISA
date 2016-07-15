SELECT * FROM
(

/* Formatted on 17/01/2014 10:35:23 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducción Total o Parcial. */
	SELECT CODIGO, CENTRO_CONSUMO, SUM (PORCENTAJE) PORCENTAJE_SERVICIO
		FROM (	SELECT CC.ID CC_ID
									,SCC.SERVICIO
									,PORCENTAJE
									-- ,VERSION
									,CC.NOMBRE CENTRO_CONSUMO
									--,
									,CODIGO
							--,DESCRIPCION
							--,ORGANICA
							-- ,ESTADO
							FROM REP_PRO_SIGLO.ORG_CENTROCONSUMO CC LEFT JOIN REP_PRO_SIGLO.ORG_SERVICIOCC SCC ON (CC.ID = SCC.CENTROCONSUMO)
						 WHERE SCC.ID IS NOT NULL --AND PORCENTAJE <> 100
																		 AND SCC.ESTADO = 'CONFIRMADO'
					ORDER BY 1, 2)
GROUP BY CODIGO, CENTRO_CONSUMO
	HAVING SUM (PORCENTAJE) <> 100
) A
FULL OUTER JOIN
(
	SELECT CODIGO, CENTRO_CONSUMO, SUM (PORCENTAJE) PORCENTAJE_UGC
		FROM (	SELECT CC.ID CC_ID
									,UCC.UNIDADGESTIONCLINICA
									,PORCENTAJE
									--		,VERSION
									,CC.NOMBRE CENTRO_CONSUMO
									--,
									,CODIGO
							--,DESCRIPCION
							--,ORGANICA
							--		,ESTADO
							FROM REP_PRO_SIGLO.ORG_CENTROCONSUMO CC LEFT JOIN REP_PRO_SIGLO.ORG_UNIDADGESTIONCLINICACC UCC ON (CC.ID = UCC.CENTROCONSUMO)
						 WHERE UCC.ID IS NOT NULL --AND PORCENTAJE <> 100
																		 AND UCC.ESTADO = 'CONFIRMADO'
					ORDER BY 1, 2)
GROUP BY CODIGO, CENTRO_CONSUMO
	HAVING SUM (PORCENTAJE) <> 100
) B USING (CODIGO, CENTRO_CONSUMO)    
UNION ALL
SELECT * FROM
(

/* Formatted on 17/01/2014 10:35:23 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducción Total o Parcial. */
    SELECT CODIGO, CENTRO_CONSUMO, SUM (PORCENTAJE) PORCENTAJE_SERVICIO
        FROM (    SELECT CC.ID CC_ID
                                    ,SCC.SERVICIO
                                    ,PORCENTAJE
                                    -- ,VERSION
                                    ,CC.NOMBRE CENTRO_CONSUMO
                                    --,
                                    ,CODIGO
                            --,DESCRIPCION
                            --,ORGANICA
                            -- ,ESTADO
                            FROM REP_PRO_SIGLO.ORG_CENTROCONSUMO CC LEFT JOIN REP_PRO_SIGLO.ORG_SERVICIOCC SCC ON (CC.ID = SCC.CENTROCONSUMO)
                         WHERE SCC.ID IS NOT NULL --AND PORCENTAJE <> 100
                                                                         AND SCC.ESTADO = 'CONFIRMADO'
                    ORDER BY 1, 2)
GROUP BY CODIGO, CENTRO_CONSUMO
    HAVING SUM (PORCENTAJE) = 100
) A
FULL OUTER JOIN
(
    SELECT CODIGO, CENTRO_CONSUMO, SUM (PORCENTAJE) PORCENTAJE_UGC
        FROM (    SELECT CC.ID CC_ID
                                    ,UCC.UNIDADGESTIONCLINICA
                                    ,PORCENTAJE
                                    --        ,VERSION
                                    ,CC.NOMBRE CENTRO_CONSUMO
                                    --,
                                    ,CODIGO
                            --,DESCRIPCION
                            --,ORGANICA
                            --        ,ESTADO
                            FROM REP_PRO_SIGLO.ORG_CENTROCONSUMO CC LEFT JOIN REP_PRO_SIGLO.ORG_UNIDADGESTIONCLINICACC UCC ON (CC.ID = UCC.CENTROCONSUMO)
                         WHERE UCC.ID IS NOT NULL --AND PORCENTAJE <> 100
                                                                         AND UCC.ESTADO = 'CONFIRMADO'
                    ORDER BY 1, 2)
GROUP BY CODIGO, CENTRO_CONSUMO
    HAVING SUM (PORCENTAJE) = 100
) B USING (CODIGO, CENTRO_CONSUMO)    
WHERE PORCENTAJE_UGC + PORCENTAJE_SERVICIO <> 100
