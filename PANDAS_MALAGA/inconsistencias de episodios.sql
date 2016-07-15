/* Formatted on 9/9/2014 12:45:45 PM (QP5 v5.163.1008.3004) */
SELECT *--DISTINCT NATID_FECHA
  FROM MSTR_HOSPITALIZACION.MSTR_DET_CAMAS_HISTORICO
 WHERE /*NATID_AREA_HOSPITALARIA = '02037' AND */NATID_EPISODIO > 0 AND NATID_UNIDAD_FUNCIONAL3_RESP IS NULL 
 AND NATID_FECHA = (SELECT MAX (NATID_FECHA) FROM MSTR_HOSPITALIZACION.MSTR_DET_CAMAS_HISTORICO);
 /
 CREATE TABLE BACK_DET_CAMAS_HISTORICO NOLOGGING NOMONITORING PARALLEL
 AS SELECT * FROM MSTR_DET_CAMAS_HISTORICO
 ;
 ALTER TABLE MSTR_DET_CAMAS_HISTORICO READ ONLY;
 DELETE FROM MSTR_DET_CAMAS_HISTORICO
 WHERE NATID_FECHA = (SELECT MAX (NATID_FECHA) FROM MSTR_HOSPITALIZACION.MSTR_DET_CAMAS_HISTORICO);