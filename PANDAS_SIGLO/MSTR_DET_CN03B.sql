/* Formatted on 24/01/2014 14:12:14 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducci�n Total o Parcial. */
SELECT SUM (CN03B_IMPORTE) FROM MSTR_DET_CN03B
UNION ALL
SELECT SUM (IMPORTE_REPARTIDO) FROM MSTR_DET_CN03B_REPARTIDO
/
SELECT SUM (CN03B_IMPORTE)
	FROM MSTR_DET_CN03B
 --WHERE NATID_CENTROCONSUMO NOT IN
 --(SELECT NATID_CENTROCONSUMO FROM MSTR_HLP_PORCENTAJES_CC_SV_UG)
 WHERE NATID_CENTROCONSUMO = 13153
/
SELECT *
	FROM	 (	SELECT NATID_CENTROCONSUMO, SUM (CN03B_IMPORTE) A
							FROM MSTR_DET_CN03B
					GROUP BY NATID_CENTROCONSUMO) T1
			 JOIN
				 (	SELECT NATID_CENTROCONSUMO, SUM (CN03B_IMPORTE) B
							FROM MSTR_DET_CN03B_REPARTIDO
					GROUP BY NATID_CENTROCONSUMO) T2
			 USING (NATID_CENTROCONSUMO)
 WHERE A <> B
/
	SELECT COUNT (*)
				,NATID_DIA
				,NATID_ARTICULO
				,NATID_CENTROCONSUMO
				,NATID_SERVICIO
		FROM MSTR_DET_CN03B_REPARTIDO
GROUP BY NATID_DIA
				,NATID_ARTICULO
				,NATID_CENTROCONSUMO
				,NATID_SERVICIO
	HAVING COUNT (*) > 1