/* Formatted on 27/03/2014 10:40:49 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducci�n Total o Parcial. */
DROP TABLE MSTR_MAE_CONTROLES_ENFERMERIA;
CREATE TABLE MSTR_MAE_CONTROLES_ENFERMERIA
(
	NATID_AREA_HOSPITALARIA
 ,NATID_CENTRO
 ,NATID_CONTROL_ENFERMERIA
 ,DESCR_CONTROL_ENFERMERIA
 ,LDESC_CONTROL_ENFERMERIA
 ,CONSTRAINT MAE_CONTROLES_ENFERMERIA_PK PRIMARY KEY (NATID_CONTROL_ENFERMERIA)
)
ORGANIZATION INDEX
NOLOGGING
NOMONITORING
NOPARALLEL
STORAGE (BUFFER_POOL KEEP) AS
	SELECT '-1' NATID_AREA_HOSPITALARIA
				,-1 NATID_CENTRO
				,'-1' NATID_CONTROL_ENFERMERIA
				,'n/a' DESCR_CONTROL_ENFERMERIA
				,'n/a' LDESC_CONTROL_ENFERMERIA
		--,'-1' NATID_UBICACION_PADRE
		--,'n/a' DESCR_UBICACION_PADRE
		FROM DUAL --,
	UNION ALL
	SELECT MSTR_MAE_CENTROS.NATID_AREA_HOSPITALARIA NATID_AREA_HOSPITALARIA
				,UBICACIONES.UBI_CAH_CODIGO NATID_CENTRO
				,UBICACIONES.UBI_CODIGO NATID_CONTROL_ENFERMERIA
				,UBICACIONES.UBI_NOMBRE DESCR_CONTROL_ENFERMERIA
				,UBICACIONES.UBI_DESCRIPCION LDESC_CONTROL_ENFERMERIA
		--,UBICACIONES.UBI_UBI_CODIGO NATID_UBICACION_PADRE
		--,PADRE.UBI_NOMBRE DESCR_UBICACION_PADRE
		FROM REP_PRO_EST.UBICACIONES@SEE41DAE --JOIN REP_PRO_EST.UBICACIONES@SEE41DAE PADRE
																					--ON UBICACIONES.UBI_UBI_CODIGO = PADRE.UBI_CODIGO
																					JOIN MSTR_MAE_CENTROS ON (UBICACIONES.UBI_CAH_CODIGO = NATID_CENTRO)
	 WHERE UBICACIONES.UBI_TIP_UBICACION = 20 --AND UBICACIONES.UBI_CAH_CODIGO IN (SELECT NATID_CENTRO FROM MSTR_MAE_CENTROS);;;