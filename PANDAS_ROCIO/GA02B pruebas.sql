CREATE VIEW TMP_GA02B
AS
  SELECT B.FECHAENTREGA NATID_DIA, SUM (PL.IMPORTELINEA) GA02B
    FROM    REP_PRO_SEV.PED_PEDIDOLINEA@SIG PL
         JOIN
            (  SELECT MIN (ENT.FECHAENTREGA) FECHAENTREGA, ENT.PEDIDOLINEA
                 FROM REP_PRO_SEV.PED_PROGRAMENTREGA@SIG ENT
                WHERE ENT.ACTIVO = 'T'
             GROUP BY ENT.PEDIDOLINEA) B
         ON (PEDIDOLINEA = PL.ID)
   WHERE PL.ACTIVO = 'T'
GROUP BY B.FECHAENTREGA
UNION ALL
  SELECT B.FECHAENTREGA NATID_DIA, SUM (PL.IMPORTELINEA) GA02B
    FROM    REP_PRO_SEV.PED_PEDIDOLINEA@SIG PL
         JOIN
            (  SELECT MIN (ENT.FECHAENTREGA) FECHAENTREGA, ENT.PEDIDOLINEA
                 FROM REP_PRO_SEV.PED_PROGRAMENTREGA@SIG ENT
                WHERE ENT.ACTIVO = 'F'
             GROUP BY ENT.PEDIDOLINEA) B
         ON (PEDIDOLINEA = PL.ID)
   WHERE PL.ACTIVO = 'T'
GROUP BY B.FECHAENTREGA
UNION ALL
  SELECT PE.FECHAPEDIDO NATID_DIA, SUM (PL.IMPORTELINEA) GA02B
    FROM REP_PRO_SEV.PED_PEDIDO@SIG PE JOIN REP_PRO_SEV.PED_PEDIDOLINEA@SIG PL ON (PL.PEDIDO = PE.ID)
   WHERE PL.ACTIVO = 'T'
         AND PL.ID NOT IN (SELECT DISTINCT ENT.PEDIDOLINEA
                             FROM REP_PRO_SEV.PED_PROGRAMENTREGA@SIG ENT)
GROUP BY PE.FECHAPEDIDO
