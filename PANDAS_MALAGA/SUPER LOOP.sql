/* Formatted on 6/24/2014 1:02:59 PM (QP5 v5.163.1008.3004) */
BEGIN
   FOR C1 IN (SELECT NATID_AREA_HOSPITALARIA                                                                   --, DB_LINK_REPLICA
                FROM MSTR_UTL_LOCAL_CODIGOS
               WHERE ENABLED = 1)
   LOOP
      EXECUTE IMMEDIATE
         'MERGE                                                                          /*+ parallel(MSTR_DET_ESTANCIAS_HISTORICO) */
           INTO  MSTR_DET_ESTANCIAS_HISTORICO H
           USING (WITH CALENDARIO
                       AS (    SELECT (DATE_GENERA_FECHAS_V2.INICIO_DEL_MES_HACE_TRES_MESES + LEVEL - 1) NATID_FECHA
                                 FROM DUAL
                           CONNECT BY ROWNUM <=
                                         (  DATE_GENERA_FECHAS_V2.FIN_DE_ESTE_MES
                                          - DATE_GENERA_FECHAS_V2.INICIO_DEL_MES_HACE_TRES_MESES
                                          + 1))
                    SELECT NATID_AREA_HOSPITALARIA,
                           DIA_DE_ESTANCIA NATID_FECHA,
                           NATID_FECHA_ULTIMO_REFRESCO,
                           NATID_CENTRO_CAMA,
                           NATID_UNIDAD_FUNCIONAL3_CAMA,
                           NATID_UNIDAD_FUNCIONAL3_RESP,
                           COUNT (DIA_DE_ESTANCIA) ESTANCIAS
                      FROM (SELECT NATID_AREA_HOSPITALARIA,
                                   NATID_TRASLADO,
                                   CALENDARIO.NATID_FECHA DIA_DE_ESTANCIA--,NATID_CENTRO_INGRESO
                                   ,
                                   NATID_CENTRO_CAMA,
                                   NATID_UNIDAD_FUNCIONAL3_CAMA,
                                   NATID_UNIDAD_FUNCIONAL3_RESP,
                                   NATID_FECHA_ULTIMO_REFRESCO
                              FROM CALENDARIO, TEMP_TRASLADOS_A1'
         || C1.NATID_AREA_HOSPITALARIA
         || '
                             WHERE FIN_TRASLADO >= CALENDARIO.NATID_FECHA AND INICIO_TRASLADO < CALENDARIO.NATID_FECHA --ORDER BY 1, 2
                                                                                                                      )
                  GROUP BY NATID_AREA_HOSPITALARIA,
                           DIA_DE_ESTANCIA,
                           NATID_FECHA_ULTIMO_REFRESCO,
                           NATID_CENTRO_CAMA,
                           NATID_UNIDAD_FUNCIONAL3_CAMA,
                           NATID_UNIDAD_FUNCIONAL3_RESP) T
              ON (    H.NATID_AREA_HOSPITALARIA = T.NATID_AREA_HOSPITALARIA
                  AND H.NATID_FECHA = T.NATID_FECHA
                  AND H.NATID_CENTRO_CAMA = T.NATID_CENTRO_CAMA
                  AND H.NATID_UNIDAD_FUNCIONAL3_CAMA = T.NATID_UNIDAD_FUNCIONAL3_CAMA
                  AND H.NATID_UNIDAD_FUNCIONAL3_RESP = T.NATID_UNIDAD_FUNCIONAL3_RESP)
      WHEN MATCHED
      THEN
         UPDATE SET H.ESTANCIAS = T.ESTANCIAS, H.NATID_FECHA_ULTIMO_REFRESCO = T.NATID_FECHA_ULTIMO_REFRESCO
      WHEN NOT MATCHED
      THEN
         INSERT     (H.NATID_AREA_HOSPITALARIA,
                     H.NATID_FECHA,
                     H.NATID_FECHA_ULTIMO_REFRESCO,
                     H.NATID_CENTRO_CAMA,
                     H.NATID_UNIDAD_FUNCIONAL3_CAMA,
                     H.NATID_UNIDAD_FUNCIONAL3_RESP,
                     H.ESTANCIAS)
             VALUES (T.NATID_AREA_HOSPITALARIA,
                     T.NATID_FECHA,
                     T.NATID_FECHA_ULTIMO_REFRESCO,
                     T.NATID_CENTRO_CAMA,
                     T.NATID_UNIDAD_FUNCIONAL3_CAMA,
                     T.NATID_UNIDAD_FUNCIONAL3_RESP,
                     T.ESTANCIAS)';
   END LOOP;
   COMMIT;
END;