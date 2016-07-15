create table TEMP_CAMAS_1 NOLOGGING
AS

/* Formatted on 24/03/2014 12:28:46 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducci�n Total o Parcial. */
SELECT --NUM_CAMA,
			TRUNC (SYSDATE) NATID_FECHA
			,UBI_CODIGO NATID_CAMA
			,UBI_NOMBRE DESCR_CAMA
			,UBI_DESCRIPCION LDESC_CAMA
			, --						TUBI_DESCRIPCION NO_ME_MIRE,
			 NVL (DECODE (NUM_CAMA, NULL, '-1', COM_M_TIPO_AISLAMIENTO.NOMBRE), -1) DESCR_TIPO_AISLAMIENTO
			,EPISODIO_ID NATID_EPISODIO
			,ID_USUARIO NATID_USUARIO
			,NUHSA NATID_NUHSA
			,DOM_CP GEO_CODIGO_POSTAL
			,UNID_FUNC_RESP NATID_UNIDAD_FUNCIONAL3_RESP
			,FUNC_MARCA_SI_ES_ECTOPICO (UBI_CODIGO, UNID_FUNC_RESP, USUARIO) IND_ECTOPICO
			,COM_UBICACION_GESTION_LOCAL.ESTADO NATID_ESTADO
			,ACTIVA IND_HABILITADA
			,UBI_TIP_UBICACION NATID_TIPO_CAMA
			,NVL (UBI_CAH_CODIGO, -1) NATID_CENTRO
			,NVL (UNIDAD_FUNCIONAL, -1) NATID_UNIDAD_FUNCIONAL3
			,NVL (func_recupera_contr_enfermeria (UBI_CODIGO), '-1') NATID_CONTROL_ENFERMERIA
			,LAST_REFRESH_DATE
	FROM REP_HIS_OWN.COM_UBICACION_GESTION_LOCAL@SEE41DAE
			 JOIN REP_PRO_EST.UBICACIONES@SEE41DAE
				 ON (CODIGO_ESTRUCTURA = UBI_CODIGO)
			 JOIN REP_PRO_EST.TIPOS_UBICACION@SEE41DAE
				 ON (UBI_TIP_UBICACION = TUBI_CODIGO)
			 LEFT JOIN REP_HIS_OWN.COM_M_TIPO_AISLAMIENTO@SEE41DAE
				 ON (TIPO_AISLAMIENTO = CODIGO)
			 CROSS JOIN (SELECT last_refresh_date
										 FROM sys.all_mviews@SEE41DAE
										WHERE mview_name = 'COM_UBICACION_GESTION_LOCAL')
			 LEFT JOIN REP_HIS_OWN.ADM_EPIS_DETALLE@SEE41DAE
				 USING (EPISODIO_ID)
			 LEFT JOIN REP_HIS_OWN.ADM_ADMISION@SEE41DAE
				 ON (REFERENCIA_ID = ADMISION_ID)
			 LEFT JOIN REP_HIS_OWN.COM_USUARIO@SEE41DAE
				 ON (USUARIO = ID_USUARIO)
			 LEFT JOIN (SELECT UBICACION_ORIGEN NUM_CAMA FROM REP_HIS_OWN.COM_UBICACION_AISLADA@SEE41DAE
									UNION
									SELECT UBICACION_AFECTADA NUM_CAMA FROM REP_HIS_OWN.COM_UBICACION_AISLADA@SEE41DAE)
				 ON (ID = NUM_CAMA)
 WHERE ACTIVA = 1 AND UBI_ACTIVO = 0 AND UBI_CAH_CODIGO IN (SELECT NATID_CENTRO FROM MSTR_MAE_CENTROS);