/* Formatted on 5/23/2014 9:18:57 (QP5 v5.163.1008.3004) */
BEGIN
   FOR C1 IN (SELECT NATID_AREA_HOSPITALARIA, DB_LINK_REPLICA
                FROM MSTR_UTL_LOCAL_CODIGOS
               WHERE ENABLED = 1)
   LOOP
      --      DBMS_OUTPUT.PUT_LINE (
      EXECUTE IMMEDIATE
         'CREATE TABLE TEMP_CAMAS_A2' || C1.NATID_AREA_HOSPITALARIA
         || '   NOLOGGING
            NOPARALLEL
            NOMONITORING
            AS
               SELECT *
                 FROM (  SELECT CH.NATID_AREA_HOSPITALARIA,
                                CH.NATID_EPISODIO,
                                CH.NATID_CAMA,
                                CH.NATID_FECHA,
                                CH.NATID_FECHA_ULTIMO_REFRESCO,
                                ED.REFERENCIA_ID,
                                TR.TRASLADO_ID,
                                RANK ()
                                OVER (PARTITION BY TR.ADMISION, CH.NATID_FECHA
                                      ORDER BY TR.TRASLADO_ID)
                                   R,
                                TR.FCH_APERTURA
                                + (TR.HORA_APERTURA - TRUNC (TR.HORA_APERTURA))
                                   INICIO_TRASLADO,
                                TR.FCH_CIERRE + (TR.HORA_CIERRE - TRUNC (TR.HORA_CIERRE))
                                   FIN_TRASLADO,
                                TR.UNIDAD_FUNCIONAL,
                                TR.UBIC_TERMINAL,
                                CASE
                                   WHEN CH.NATID_FECHA_ULTIMO_REFRESCO >=
                                           (TR.FCH_APERTURA
                                            + (TR.HORA_APERTURA - TRUNC (TR.HORA_APERTURA)))
                                   THEN
                                      1
                                   ELSE
                                      0
                                END
                                   CW1,
                                CASE
                                   WHEN CH.NATID_FECHA_ULTIMO_REFRESCO <=
                                           (TR.FCH_CIERRE
                                            + (TR.HORA_CIERRE - TRUNC (TR.HORA_CIERRE)))
                                   THEN
                                      1
                                   WHEN (TR.FCH_CIERRE
                                         + (TR.HORA_CIERRE - TRUNC (TR.HORA_CIERRE)))
                                           IS NULL
                                   THEN
                                      1
                                   ELSE
                                      0
                                END
                                   CW2
                           FROM MSTR_DET_CAMAS_HISTORICO CH
                                LEFT JOIN REP_HIS_OWN.ADM_EPIS_DETALLE@'
         || C1.DB_LINK_REPLICA
         || ' ED
                                   ON (ED.EPISODIO_ID = CH.NATID_EPISODIO)
                                LEFT JOIN REP_HIS_OWN.ADM_TRASLADO@'
         || C1.DB_LINK_REPLICA
         || ' TR
                                   ON (ED.REFERENCIA_ID = TR.ADMISION)
                          WHERE     CH.NATID_AREA_HOSPITALARIA = '''
         || C1.NATID_AREA_HOSPITALARIA
         || '''
                                AND CH.NATID_UNIDAD_FUNCIONAL3_RESP IS NULL
                                AND CH.NATID_EPISODIO > 0
                       ORDER BY CH.NATID_EPISODIO, CH.NATID_FECHA, TR.TRASLADO_ID)
                WHERE CW1 = 1 AND CW2 = 1';
   --);
   END LOOP;
END;