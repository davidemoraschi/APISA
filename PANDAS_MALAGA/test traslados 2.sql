/* Formatted on 5/22/2014 10:02:00 (QP5 v5.163.1008.3004) */
SELECT *
  FROM (  SELECT CH.NATID_EPISODIO,
                 CH.NATID_CAMA,
                 CH.NATID_FECHA,
                 ED.REFERENCIA_ID,
                 TR.TRASLADO_ID,
                 RANK ()
                    OVER (PARTITION BY TR.ADMISION ORDER BY TR.TRASLADO_ID)
                    R,
                 TR.FCH_APERTURA
                 + (TR.HORA_APERTURA - TRUNC (TR.HORA_APERTURA))
                    INICIO_TRASLADO,
                 TR.FCH_CIERRE + (TR.HORA_CIERRE - TRUNC (TR.HORA_CIERRE))
                    FIN_TRASLADO,
                 TR.UNIDAD_FUNCIONAL,
                 TR.UBIC_TERMINAL
            FROM MSTR_DET_CAMAS_HISTORICO CH
                 JOIN REP_HIS_OWN.ADM_EPIS_DETALLE@SEE41DAE ED
                    ON (ED.EPISODIO_ID = CH.NATID_EPISODIO)
                 JOIN REP_HIS_OWN.ADM_TRASLADO@SEE41DAE TR
                    ON (ED.REFERENCIA_ID = TR.ADMISION)
           WHERE     CH.NATID_AREA_HOSPITALARIA = '02003'
                 AND CH.NATID_UNIDAD_FUNCIONAL3_RESP IS NULL
                 AND CH.NATID_EPISODIO > 0
        ORDER BY CH.NATID_EPISODIO, CH.NATID_FECHA, TR.TRASLADO_ID)
 WHERE R = 1;