/* Formatted on 22/01/2014 9:46:57 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducci�n Total o Parcial. */
--SELECT DISTINCT NATID_CENTROCONSUMO FROM (
-- con servicios
--SELECT * FROM (
DROP TABLE MSTR_DET_REPARTO_CC_SV_UGC;
CREATE TABLE MSTR_DET_REPARTO_CC_SV_UGC
NOLOGGING
NOMONITORING
NOPARALLEL AS
	SELECT CC.ORGANICA NATID_ORGANOGESTOR
				,CC.ID NATID_CENTROCONSUMO
				,CC.NOMBRE DESCR_CENTROCONSUMO
				,CC.CODIGO LDESC_CENTROCONSUMO
				,CC.ESTADO ESTADO_CENTROCONSUMO
				,NVL (SV.ID, -1) NATID_SERVICIO
				,NVL (SV.DESCRIPCION, 'Sin Servicio') DESCR_SERVICIO
				,NVL (SV.CODIGO, 'N/A') LDESC_SERVICIO
				,NVL (SV.ESTADO, 'N/A') ESTADO_SERVICIO
				,NVL (SCC.PORCENTAJE, 0) PORCENTAJE_SERVICIO
				,NVL (SCC.ESTADO, 'N/A') ESTADO_PORCENTAJE_SERVICIO
				,NVL (UGCSV.UNIDADGESTIONCLINICA, -1) NATID_UNIDAD_GESTION_CLINICA
				,NVL (UGC.DESCRIPCION, 'Sin UGC') DESCR_UNIDAD_GESTION_CLINICA
				,NVL (UGC.ESTADO, 'N/A') ESTADO_UNIDAD_GESTION_CLINICA
				,NVL (SCC.PORCENTAJE, 0) PORCENTAJE_UGC
				,NVL (UGCSV.ESTADO, 'N/A') ESTADO_PORCENTAJE_UGC
		FROM REP_PRO_SIGLO.ORG_CENTROCONSUMO@SYG CC
				 LEFT JOIN REP_PRO_SIGLO.ORG_SERVICIOCC@SYG SCC
					 ON (SCC.CENTROCONSUMO = CC.ID /*  --para quitar los repartos 'BORRADO' */
																				AND SCC.ESTADO = 'CONFIRMADO')
				 LEFT JOIN REP_PRO_SIGLO.ORG_SERVICIO@SYG SV
					 ON (SCC.SERVICIO = SV.ID)
				 LEFT JOIN REP_PRO_SIGLO.ORG_UNIDADGESTIONCLINICASRV@SYG UGCSV
					 ON (UGCSV.SERVICIO = SV.ID)
				 LEFT JOIN REP_PRO_SIGLO.ORG_UNIDADGESTIONCLINICA@SYG UGC
					 ON (UGCSV.UNIDADGESTIONCLINICA = UGC.ID)
	 --para no duplicar los que reparten solo a UGC
	 WHERE CC.ID NOT IN
					 (SELECT ID
							FROM REP_PRO_SIGLO.ORG_CENTROCONSUMO@SYG CC
						 WHERE		 id NOT IN (SELECT centroconsumo FROM REP_PRO_SIGLO.ORG_SERVICIOCC@SYG)
									 AND id IN (SELECT centroconsumo FROM REP_PRO_SIGLO.ORG_UNIDADGESTIONCLINICACC@SYG)
									 AND CC.ESTADO = 'CONFIRMADO')
	--AND SCC.ESTADO = 'CONFIRMADO'
    --AND CC.ESTADO <> 'PROPINICIAL'
	UNION ALL
	SELECT CC.ORGANICA NATID_ORGANOGESTOR
				,CC.ID NATID_CENTROCONSUMO
				,CC.NOMBRE DESCR_CENTROCONSUMO
				,CC.CODIGO LDESC_CENTROCONSUMO
				,CC.ESTADO ESTADO_CENTROCONSUMO
				,-1 NATID_SERVICIO
				,'Sin Servicio' DESCR_SERVICIO
				,'N/A' LDESC_SERVICIO
				,'N/A' ESTADO_SERVICIO
				,0 PORCENTAJE_SERVICIO
				,'N/A' ESTADO_PORCENTAJE_SERVICIO
				,NVL (UGC.ID, -1) NATID_UNIDAD_GESTION_CLINICA
				,NVL (UGC.DESCRIPCION, 'Sin UGC') DESCR_UNIDAD_GESTION_CLINICA
				,NVL (UGC.ESTADO, 'Sin UGC') ESTADO_UNIDAD_GESTION_CLINICA
				,UCC.PORCENTAJE PORCENTAJE_UGC
				,NVL (UCC.ESTADO, 'N/A') ESTADO_PORCENTAJE_UGC
		FROM REP_PRO_SIGLO.ORG_CENTROCONSUMO@SYG CC
				 JOIN REP_PRO_SIGLO.ORG_UNIDADGESTIONCLINICACC@SYG UCC
					 ON (UCC.CENTROCONSUMO = CC.ID /* 		--para quitar los repartos 'BORRADO' */
																				AND UCC.ESTADO = 'CONFIRMADO')
				 JOIN REP_PRO_SIGLO.ORG_UNIDADGESTIONCLINICA@SYG UGC
					 ON (UCC.UNIDADGESTIONCLINICA = UGC.ID)
--para quitar los repartos 'BORRADO'
--WHERE UCC.ESTADO = 'CONFIRMADO';
--WHERE CC.ESTADO <> 'PROPINICIAL'
/
--)
--) WHERE NATID_ORGANOGESTOR <> ORGANOGESTOR

BEGIN
	SYS.DBMS_STATS.GATHER_TABLE_STATS (OwnName => 'MSTR_SIGLO'
																		,TabName => 'MSTR_MAE_CENTROS_SERVICIOS_UGC'
																		,Estimate_Percent => 0
																		,Method_Opt => 'FOR ALL COLUMNS SIZE 1'
																		,Degree => 4
																		,Cascade => FALSE
																		,No_Invalidate => FALSE);
END;