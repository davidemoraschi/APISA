SELECT  SUM (NVL (FAL.BASEIMPONIBLE, 0) + NVL (FAL.IMPORTE, 0)) 
FROM REP_PRO_SIGLO.FAC_FACTURALINEA FAL
JOIN REP_PRO_SIGLO.FAC_FACTURA FA ON (FAL.FACTURA = FA.ID)
   WHERE     --
         --AND 
         FAL.GCDIRECTA IS NOT NULL
         AND FA.ESTADO IN ('CONCILIADA', 'TRAMITADA')
         AND FAL.TIPODESCUENTO IS NULL
         AND FA.TIPO NOT IN (6, 7, 8)

/
