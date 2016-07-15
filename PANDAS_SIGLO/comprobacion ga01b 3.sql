   SELECT SUM(NVL(FAL.BASEIMPONIBLE, 0) + NVL(FAL.IMPORTE, 0))
   --  INTO V_N_FACABO
     FROM REP_PRO_SIGLO.FAC_FACTURA FA,
          REP_PRO_SIGLO.FAC_FACTURALINEA FAL
    WHERE FAL.FACTURA = FA.ID
      AND TO_NUMBER(TO_CHAR(FA.FECHAFACTURA, 'YYYYMM')) = 201301
      AND FAL.GCDIRECTA IS NOT NULL
      AND FA.ESTADO IN ('CONCILIADA', 'TRAMITADA')
      AND FAL.TIPODESCUENTO IS NULL
      AND FA.TIPO IN (6,7,8)
      union all
           SELECT
           SUM( VALOR_FACTURAS_ABONO )
      FROM ( 
      SELECT FA.FECHAFACTURA NATID_DIA,
                                    FA.ORGANOGESTOR NATID_ORGANOGESTOR,
                                    FAL.CLASIFECONOMICADIRECTA NATID_ECONOMICA_N4,
                                    FAL.GCDIRECTA NATID_ARTICULO,
                                    SUM (NVL (FAL.BASEIMPONIBLE, 0) + NVL (FAL.IMPORTE, 0)) VALOR_FACTURAS_ABONO
                               FROM REP_PRO_SIGLO.FAC_FACTURA FA, REP_PRO_SIGLO.FAC_FACTURALINEA FAL
                              WHERE     FAL.FACTURA = FA.ID
                                    AND FAL.GCDIRECTA IS NOT NULL
                                    AND FA.ESTADO IN ('CONCILIADA', 'TRAMITADA')
                                    AND FAL.TIPODESCUENTO IS NULL
                                    AND FA.TIPO IN (6, 7, 8)
                           GROUP BY FA.FECHAFACTURA,
                                    FA.ORGANOGESTOR,
                                    FAL.CLASIFECONOMICADIRECTA,
                                    FAL.GCDIRECTA
                                            )
                    WHERE TO_CHAR(NATID_DIA,'YYYYMM')=201301;
                                    


