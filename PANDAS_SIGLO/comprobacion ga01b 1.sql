  SELECT SUM(EL.IMPORTELINEA)
  --   INTO V_N_CONTRAALBARAN
     FROM REP_PRO_SIGLO.PED_ENTRALMACLINEA EL,
          REP_PRO_SIGLO.PED_ENTRADAALMACEN E,
          REP_PRO_SIGLO.FAC_CONTRAALBARAN CON
    WHERE EL.confirmada = 'T'
      AND EL.ACTIVO = 'T'
      AND EL.entradaalmacen = E.ID
      AND EL.CONTRAALBARAN = CON.ID
      AND CON.FECHAREGISTRO IS NOT NULL
      AND TO_NUMBER(TO_CHAR(CON.FECHAREGISTRO, 'YYYYMM')) = 201301
      union all
      SELECT 
      SUM( VALOR_CONTRAALBARAN )
      FROM (
       SELECT TRUNC (CON.FECHAREGISTRO) NATID_DIA,
                    PED.ORGANOGESTOR NATID_ORGANOGESTOR,
                    ECONOMICA NATID_ECONOMICA_N4,
                    PEL.ARTICULO NATID_ARTICULO,
                    SUM (EL.IMPORTELINEA) VALOR_CONTRAALBARAN                  
               FROM REP_PRO_SIGLO.PED_ENTRALMACLINEA EL
                    JOIN REP_PRO_SIGLO.PED_ENTRADAALMACEN E
                       ON (EL.ENTRADAALMACEN = E.ID)
                    /*LEFT */
                    JOIN REP_PRO_SIGLO.FAC_CONTRAALBARAN CON
                       ON (EL.CONTRAALBARAN = CON.ID)
                    JOIN REP_PRO_SIGLO.PED_PEDIDO PED
                       ON E.PEDIDO = PED.ID
                    JOIN REP_PRO_SIGLO.PED_PEDIDOLINEA PEL
                       ON (EL.LINEAPEDIDO = PEL.ID)
                    JOIN REP_PRO_SIGLO.PED_PROPUESTASL PRO
                       ON (PEL.PROPUESTALINEA = PRO.ID)
                       WHERE EL.CONFIRMADA = 'T'
                       AND EL.ACTIVO = 'T'
           GROUP BY TRUNC (CON.FECHAREGISTRO),
                    PED.ORGANOGESTOR,
                    PEL.ARTICULO,
                    ECONOMICA
                    )
                    WHERE TO_CHAR(NATID_DIA,'YYYYMM')=201301;

