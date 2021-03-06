/* Formatted on 16/06/2014 11:51:50 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducci�n Total o Parcial. */
SELECT * FROM REP_HIS_OWN.ADM_ADMISION@SEE41DAE;
/

WITH cal AS (SELECT ADD_MONTHS (TRUNC (SYSDATE, 'YEAR'), -12) inicio_a�o_pasado FROM DUAL)
SELECT CAH_AH_CODIGO NATID_AREA_HOSPITALARIA
			,TRUNC (SYSDATE) NATID_FECHA
			,LAST_REFRESH_DATE NATID_FECHA_ULTIMO_REFRESCO
			,NVL (ADM.CENTRO_INGRESO, -1) NATID_CENTRO_INGRESO
			,NVL (UBI_CAH_CODIGO, -1) NATID_CENTRO_CAMA
			,TR.UNIDAD_FUNCIONAL NATID_UNIDAD_FUNCIONAL3_RESP
			,NVL (UBIL.UNIDAD_FUNCIONAL, -1) NATID_UNIDAD_FUNCIONAL3_CAMA
			,NVL (TR.UBIC_TERMINAL, -1) NATID_CAMA
			,ADM.ADMISION_ID NATID_ADMISION
			,TR.TRASLADO_ID NATID_TRASLADO
			,TR.FCH_APERTURA + (TR.HORA_APERTURA - TRUNC (TR.HORA_APERTURA)) INICIO_TRASLADO
			,NVL (NVL (TR.FCH_CIERRE + (TR.HORA_CIERRE - TRUNC (TR.HORA_CIERRE)), ADM.FCH_ALTA + (ADM.HORA_ALTA - TRUNC (ADM.HORA_ALTA))), SYSDATE) FIN_TRASLADO
			, (NVL (NVL (TR.FCH_CIERRE + (TR.HORA_CIERRE - TRUNC (TR.HORA_CIERRE)), ADM.FCH_ALTA + (ADM.HORA_ALTA - TRUNC (ADM.HORA_ALTA))), SYSDATE))
			 - (TR.FCH_APERTURA + (TR.HORA_APERTURA - TRUNC (TR.HORA_APERTURA)))
				 LAPSO_DE_TIEMPO
			,TR.OBSERVACIONES
			,TR.TRASLADO_PADRE NATID_TRASLADO_ANTERIOR
			,CAMBIO_ASISTENCIA_SN IND_CAMBIO_ASISTENCIA
	FROM ADM_TRASLADO TR
			 JOIN ADM_ADMISION ADM
				 ON (TR.ADMISION = ADM.ADMISION_ID)
			 LEFT JOIN UBICACIONES UBI
				 ON (UBIC_TERMINAL = UBI_CODIGO)
			 LEFT JOIN COM_UBICACION_GESTION_LOCAL UBIL
				 ON (UBIC_TERMINAL = CODIGO_ESTRUCTURA)
			 LEFT JOIN CENTROS_AH CE
				 ON (UBI_CAH_CODIGO = CAH_CODIGO)
			 JOIN ALL_DAE_MVIEWS MV
				 ON (MVIEW_NAME = 'ADM_TRASLADO' AND OWNER = 'REP_HIS_OWN')
			 CROSS JOIN cal
 WHERE ADM.FCH_INGRESO >= cal.inicio_a�o_pasado AND ADM.MODALIDAD_ASIST = 1 AND ADM.EPIS_CONTAB = 1;