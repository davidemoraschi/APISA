/* Formatted on 8/25/2014 1:42:01 PM (QP5 v5.163.1008.3004) */
  SELECT NATID_AREA_HOSPITALARIA,
         NATID_CENTRO_CAMA,
         NATID_UNIDAD_FUNCIONAL3_RESP,
         TOT_ESTANCIAS_CE,
         TOT_ESTANCIAS_UF,
         (TOT_ESTANCIAS_UF - TOT_ESTANCIAS_CE) DIFF
    FROM    (  SELECT NATID_AREA_HOSPITALARIA,
                      NATID_CENTRO_CAMA,
                      NATID_UNIDAD_FUNCIONAL3_RESP,
                      SUM (ESTANCIAS) TOT_ESTANCIAS_CE
                 FROM MSTR_HOSPITALIZACION.MSTR_DET_ESTANCIAS_HISTORICO_2
                WHERE NATID_FECHA = TRUNC (SYSDATE)
             GROUP BY NATID_AREA_HOSPITALARIA, NATID_CENTRO_CAMA, NATID_UNIDAD_FUNCIONAL3_RESP
             ORDER BY 1)
         JOIN
            (  SELECT NATID_AREA_HOSPITALARIA,
                      NATID_CENTRO_CAMA,
                      NATID_UNIDAD_FUNCIONAL3_RESP,
                      SUM (ESTANCIAS) TOT_ESTANCIAS_UF
                 FROM MSTR_HOSPITALIZACION.MSTR_DET_ESTANCIAS_HISTORICO
                WHERE NATID_FECHA = TRUNC (SYSDATE)
             GROUP BY NATID_AREA_HOSPITALARIA, NATID_CENTRO_CAMA, NATID_UNIDAD_FUNCIONAL3_RESP
             ORDER BY 1)
         USING (NATID_AREA_HOSPITALARIA, NATID_CENTRO_CAMA, NATID_UNIDAD_FUNCIONAL3_RESP)
ORDER BY 6 DESC
/
SELECT * --DISTINCT NATID_CONTROL_ENFERMERIA
FROM MSTR_HOSPITALIZACION.MSTR_DET_ESTANCIAS_HISTORICO_2
WHERE NATID_CONTROL_ENFERMERIA NOT IN
(SELECT NATID_CONTROL_ENFERMERIA FROM MSTR_MAE_CONTROLES_ENFERMERIA)