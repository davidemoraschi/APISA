SELECT SUM (EL.IMPORTELINEA)
FROM 
REP_PRO_SIGLO.PED_ENTRALMACLINEA EL
JOIN REP_PRO_SIGLO.PED_ENTRADAALMACEN E ON (EL.entradaalmacen = E.ID)
 JOIN REP_PRO_SIGLO.FAC_CONTRAALBARAN CON ON (EL.CONTRAALBARAN = CON.ID)
             WHERE     EL.confirmada = 'T'
                    AND EL.ACTIVO = 'T'
                    --AND EL.entradaalmacen = E.ID
                    --AND EL.CONTRAALBARAN = CON.ID
                    --AND CON.FECHAREGISTRO IS NOT NULL
                    --AND E.PEDIDO = PED.ID
                    --AND EL.LINEAPEDIDO = PEL.ID
                    
                    --AND EL.CONTRAALBARAN IS NULL
