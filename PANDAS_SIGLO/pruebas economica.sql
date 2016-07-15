/* Formatted on 06/11/2013 17:03:03 (QP5 v5.163.1008.3004) */
SELECT *
  FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
 WHERE ID IN (SELECT ECONOMICA
                FROM (  SELECT SUM (EL.IMPORTELINEA), P.ECONOMICA
                          FROM REP_PRO_SIGLO.PED_ENTRALMACLINEA@SYG EL
                               JOIN REP_PRO_SIGLO.PED_ENTRADAALMACEN@SYG E
                                  ON (EL.entradaalmacen = E.ID)
                               LEFT JOIN REP_PRO_SIGLO.FAC_CONTRAALBARAN@SYG CON
                                  ON (EL.CONTRAALBARAN = CON.ID)
                               /*LEFT */
                               JOIN REP_PRO_SIGLO.PED_PEDIDOLINEA@SYG PEL
                                  ON (EL.LINEAPEDIDO = PEL.ID)
                               /*LEFT */
                               JOIN REP_PRO_SIGLO.PED_PROPUESTASL@SYG P
                                  ON (PEL.PROPUESTALINEA = P.ID)
                         WHERE EL.confirmada = 'T' AND EL.ACTIVO = 'T'
                      --AND EL.entradaalmacen = E.ID
                      --AND EL.CONTRAALBARAN = CON.ID
                      --AND CON.FECHAREGISTRO IS NOT NULL
                      --AND E.PEDIDO = PED.ID
                      --AND EL.LINEAPEDIDO = PEL.ID
                      --AND EL.CONTRAALBARAN IS NULL
                      GROUP BY ECONOMICA)
               WHERE ECONOMICA NOT IN (SELECT NATID_ECONOMICA_N4 FROM MSTR_MAE_ECONOMICA_N4))