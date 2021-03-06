/* Formatted on 20/01/2014 17:39:43 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducción Total o Parcial. */
--SELECT DISTINCT NID FROM
--(
-- con UGC
SELECT CC.ORGANICA NATID_ORGANOGESTOR
			,CC.ID NATID_CENTROCONSUMO
			,CC.NOMBRE DESCR_CENTROCONSUMO
			,CC.CODIGO LDESC_CENTROCONSUMO
			,CC.ESTADO ESTADO_CENTROCONSUMO
			,100 PORCENTAJE_SERVICIO
			,'N/A' ESTADO_PORCENTAJE_SERVICIO
			,-1 NATID_SERVICIO
			,'N/A' LDESC_SERVICIO
			,'Sin Servicio' DESCR_SERVICIO
			,'N/A' ESTADO_SERVICIO
			,NVL (UGC.ID, -1) NATID_UNIDAD_GESTION_CLINICA
			,UCC.PORCENTAJE PORCENTAJE_UGC
			,NVL (UGC.ESTADO, 'N/A') ESTADO_PORCENTAJE_UGC
			,NVL (UGC.DESCRIPCION, 'Sin UGC') DESCR_UNIDAD_GESTION_CLINICA
	FROM REP_PRO_SIGLO.ORG_CENTROCONSUMO@SYG CC
			 JOIN REP_PRO_SIGLO.ORG_UNIDADGESTIONCLINICACC@SYG UCC
				 ON (UCC.CENTROCONSUMO = CC.ID)
			 JOIN REP_PRO_SIGLO.ORG_UNIDADGESTIONCLINICA@SYG UGC
				 ON (UCC.UNIDADGESTIONCLINICA = UGC.ID)
--)