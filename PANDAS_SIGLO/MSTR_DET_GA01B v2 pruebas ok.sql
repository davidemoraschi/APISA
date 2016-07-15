/* Formatted on 06/11/2013 17:47:19 (QP5 v5.163.1008.3004) */
  SELECT /*NVL (TRUNC (*/CON.FECHAREGISTRO/*), NVL (TRUNC (FECHAENTRADA), TRUNC (E.FECHAALBARAN))) */NATID_DIA,
         PED.ORGANOGESTOR NATID_ORGANOGESTOR,
         ECONOMICA NATID_ECONOMICA_N4,
         PEL.ARTICULO NATID_ARTICULO,
         SUM (EL.IMPORTELINEA) VALOR_CONTRAALBARAN
    FROM REP_PRO_SIGLO.PED_ENTRALMACLINEA@SYG EL
         JOIN REP_PRO_SIGLO.PED_ENTRADAALMACEN@SYG E
            ON (EL.ENTRADAALMACEN = E.ID)
         /*LEFT*/ JOIN REP_PRO_SIGLO.FAC_CONTRAALBARAN@SYG CON
            ON (EL.CONTRAALBARAN = CON.ID)
         JOIN REP_PRO_SIGLO.PED_PEDIDO@SYG PED
            ON E.PEDIDO = PED.ID
         JOIN REP_PRO_SIGLO.PED_PEDIDOLINEA@SYG PEL
            ON (EL.LINEAPEDIDO = PEL.ID)
         JOIN REP_PRO_SIGLO.PED_PROPUESTASL@SYG PRO
            ON (PEL.PROPUESTALINEA = PRO.ID)
GROUP BY /*NVL (TRUNC (*/CON.FECHAREGISTRO/*), NVL (TRUNC (FECHAENTRADA), TRUNC (E.FECHAALBARAN)))*/,
         PED.ORGANOGESTOR,
         PEL.ARTICULO,
         ECONOMICA