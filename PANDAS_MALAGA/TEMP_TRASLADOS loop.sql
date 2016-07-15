/* Formatted on 6/11/2014 14:23:27 (QP5 v5.163.1008.3004) */
BEGIN
   FOR C1 IN (SELECT NATID_AREA_HOSPITALARIA
                FROM MSTR_UTL_LOCAL_CODIGOS
               WHERE ENABLED = 1)
   LOOP
      -- BEGIN

      EXECUTE IMMEDIATE
            'CREATE TABLE TEMP_TRASLADOS_A1'
         || C1.NATID_AREA_HOSPITALARIA
         || '(
              NATID_ADMISION,
              NATID_TRASLADO,
              INICIO_TRASLADO,
              NATID_UNIDAD_FUNCIONAL_RESP,
              NATID_CAMA,
              FIN_TRASLADO,
              LAPSO_DE_TIEMPO,
              OBSERVACIONES,
              NATID_TRASLADO_ANTERIOR,
              IND_CAMBIO_ASISTENCIA,
              CONSTRAINT TEMP_TRASLADOS_A1'
         || C1.NATID_AREA_HOSPITALARIA
         || '_PK PRIMARY KEY (NATID_TRASLADO)
                            )
                            --ORGANIZATION INDEX
                            NOLOGGING
                            NOMONITORING
                            PARALLEL
                            STORAGE (BUFFER_POOL KEEP) AS
                               SELECT ADM.ADMISION_ID NATID_ADMISION,
                                       TR.TRASLADO_ID NATID_TRASLADO,
                                       TR.FCH_APERTURA + (TR.HORA_APERTURA - TRUNC (TR.HORA_APERTURA))
                                          INICIO_TRASLADO,
                                       TR.UNIDAD_FUNCIONAL NATID_UNIDAD_FUNCIONAL_RESP,
                                       NVL (TR.UBIC_TERMINAL, -1) NATID_CAMA,
                                       NVL (
                                          NVL (TR.FCH_CIERRE + (TR.HORA_CIERRE - TRUNC (TR.HORA_CIERRE)),
                                               ADM.FCH_ALTA + (ADM.HORA_ALTA - TRUNC (ADM.HORA_ALTA))),
                                          SYSDATE)
                                          FIN_TRASLADO,
                                       (NVL (
                                           NVL (TR.FCH_CIERRE + (TR.HORA_CIERRE - TRUNC (TR.HORA_CIERRE)),
                                                ADM.FCH_ALTA + (ADM.HORA_ALTA - TRUNC (ADM.HORA_ALTA))),
                                           SYSDATE))
                                       - (TR.FCH_APERTURA + (TR.HORA_APERTURA - TRUNC (TR.HORA_APERTURA)))
                                          LAPSO_DE_TIEMPO,
                                       TR.OBSERVACIONES,
                                       TR.TRASLADO_PADRE NATID_TRASLADO_ANTERIOR,
                                       CAMBIO_ASISTENCIA_SN IND_CAMBIO_ASISTENCIA
                                  FROM    REP_HIS_OWN.ADM_TRASLADO@SEE41DAE TR
                                       JOIN
                                          REP_HIS_OWN.ADM_ADMISION@SEE41DAE ADM
                                       ON (TR.ADMISION = ADM.ADMISION_ID)
                                 WHERE     ADM.FCH_INGRESO >= ''01-JAN-2013''
                                       AND ADM.MODALIDAD_ASIST = 1
                                       AND ADM.EPIS_CONTAB = 1';
   END LOOP;
END;