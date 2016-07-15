SELECT SUM(VALOR_CONTRAALBARAN)
FROM (
SELECT CON.FECHAREGISTRO NATID_DIA,
                    PED.ORGANOGESTOR NATID_ORGANOGESTOR,
                    -1 NATID_ECONOMICA_N4,
                    PEL.ARTICULO NATID_ARTICULO,
                    SUM (EL.IMPORTELINEA) VALOR_CONTRAALBARAN
               FROM REP_PRO_SIGLO.PED_ENTRALMACLINEA@SYG EL,
                    REP_PRO_SIGLO.PED_ENTRADAALMACEN@SYG E,
                    REP_PRO_SIGLO.FAC_CONTRAALBARAN@SYG CON,
                    REP_PRO_SIGLO.PED_PEDIDO@SYG PED,
                    REP_PRO_SIGLO.PED_PEDIDOLINEA@SYG PEL
              WHERE     EL.confirmada = 'T'
                    AND EL.ACTIVO = 'T'
                    AND EL.entradaalmacen = E.ID
                    AND EL.CONTRAALBARAN = CON.ID
                    AND CON.FECHAREGISTRO IS NOT NULL
                    AND E.PEDIDO = PED.ID
                    AND EL.LINEAPEDIDO = PEL.ID
           GROUP BY CON.FECHAREGISTRO, PED.ORGANOGESTOR, PEL.ARTICULO
           )