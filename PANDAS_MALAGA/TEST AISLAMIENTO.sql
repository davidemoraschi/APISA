/* Formatted on 06/04/2014 16:29:57 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducción Total o Parcial. */
	SELECT DISTINCT NATID_TIPO_AISLAMIENTO, DESCR_TIPO_AISLAMIENTO
		FROM MSTR_DET_CAMAS_DEL_DIA
ORDER BY 1;

SELECT *
	FROM MSTR_DET_CAMAS_DEL_DIA
 WHERE DESCR_TIPO_AISLAMIENTO = '--' AND NATID_TIPO_AISLAMIENTO IS NOT NULL;
/

ALTER TABLE MSTR_DET_CAMAS_DEL_DIA READ WRITE;

UPDATE MSTR_DET_CAMAS_DEL_DIA
	 SET NATID_TIPO_AISLAMIENTO = NULL, ETL_ERROR_DESCR = NULL
 WHERE DESCR_TIPO_AISLAMIENTO = '--';