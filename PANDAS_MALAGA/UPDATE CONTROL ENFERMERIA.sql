ALTER TABLE MSTR_HOSPITALIZACION.TEMP_TRASLADOS_A102004
READ WRITE;

UPDATE TEMP_TRASLADOS_A102004 T
               SET NATID_CONTROL_ENFERMERIA = NVL(
                      (SELECT NATID_CONTROL_ENFERMERIA
                         FROM MSTR_DET_CAMAS_HISTORICO H
                        WHERE T.NATID_CAMA = H.NATID_CAMA AND H.NATID_FECHA = TRUNC (T.FIN_TRASLADO)), -2);
                        
/* Formatted on 8/20/2014 2:49:59 PM (QP5 v5.163.1008.3004) */
UPDATE TEMP_TRASLADOS_A102004 T
   SET ETL_ERROR_DESCR = 'No se encuentra la cama en el hist�rico por esta fecha, se pone el �ltimo C.E.',
       NATID_CONTROL_ENFERMERIA =
          (SELECT MAX (NATID_CONTROL_ENFERMERIA) KEEP (DENSE_RANK LAST ORDER BY NATID_FECHA) NATID_CONTROL_ENFERMERIA
            FROM MSTR_DET_CAMAS_HISTORICO H
           WHERE H.NATID_CAMA =  T.NATID_CAMA)
 WHERE NATID_CONTROL_ENFERMERIA = -2
 /
 SELECT MAX (NATID_CONTROL_ENFERMERIA) KEEP (DENSE_RANK LAST ORDER BY NATID_FECHA) NATID_CONTROL_ENFERMERIA
            FROM MSTR_DET_CAMAS_HISTORICO
           WHERE NATID_CAMA = 86317-- AND NATID_FECHA BETWEEN T.INICIO_TRASLADO AND T.FIN_TRASLADO)
            --NATID_CONTROL_ENFERMERIA
/
select * from TEMP_TRASLADOS_A102004  
WHERE NATID_CONTROL_ENFERMERIA = -2
/
select NATID_CAMA, COUNT(DISTINCT NATID_CONTROL_ENFERMERIA)
FROM MSTR_DET_CAMAS_HISTORICO
WHERE NATID_CONTROL_ENFERMERIA > 0
GROUP BY NATID_CAMA