SELECT * FROM ZZ_MIG_INTERVENCIONES_02004
WHERE PQ_DET_ID  IN
(SELECT NATID_DETALLE_PARTE FROM TEMP_INTERVENCIONES_A102004);

SELECT * FROM MSTR_MAE_AREAS_HOSPITALARIAS;

SELECT * FROM TEMP_INTERVENCIONES_A102004
WHERE NATID_EPISODIO < 0
/
SELECT TRUNC(NATID_FECHA_INICIO_PARTE,'MM') MES, COUNT(1) N--NATID_FECHA_INICIO_EPISODIO,NATID_FECHA_FIN_EPISODIO,(NATID_FECHA_FIN_EPISODIO-NATID_FECHA_INICIO_EPISODIO) D--
--* 
FROM TEMP_INTERVENCIONES_A102004
WHERE NATID_EPISODIO > 0
AND IND_MODALIDAD_ASISTENCIAL = 1
--AND IND_ESTADO NOT IN (2,4)
AND IND_ESTADO <> 2
AND IND_ESTADO <> 4
AND
(NATID_FECHA_FIN_EPISODIO IS NULL OR (TRUNC(NATID_FECHA_INICIO_EPISODIO,'dd')<>TRUNC(NATID_FECHA_FIN_EPISODIO,'dd')))
GROUP BY TRUNC(NATID_FECHA_INICIO_PARTE,'MM')
--AND 
--NATID_DETALLE_PARTE NOT IN
--(SELECT PQ_DET_ID FROM ZZ_MIG_INTERVENCIONES_02004);
