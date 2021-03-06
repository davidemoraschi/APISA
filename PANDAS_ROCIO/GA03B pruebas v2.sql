/* Formatted on 02/09/2013 9:18:13 (QP5 v5.163.1008.3004) */
  SELECT SUM(NVL(FAL.BASEIMPONIBLE, 0) + NVL(FAL.IMPORTE, 0) ) GA03B, COUNT(1)
     FROM REP_PRO_SIGLO.FAC_FACTURA FA,
          REP_PRO_SIGLO.FAC_FACTURALINEA FAL
    WHERE FAL.FACTURA = FA.ID
      AND TO_NUMBER(TO_CHAR(FA.FECHAFACTURA, 'YYYY')) = 2013
      AND FA.ESTADO IN ('CONCILIADA', 'PENDCONCILIAR', 'PENDREGISTRAR', 'REGISTRADA', 'TRAMITADA')
      AND FAL.TIPODESCUENTO IS NULL
      AND FA.TIPO NOT IN (6, 7, 8)
--UNION ALL
;
  SELECT 'Directas' FACTURAS, SUM(NVL(FAL.BASEIMPONIBLE, 0) + NVL(FAL.IMPORTE, 0) ) GA03B, COUNT(1)
     FROM REP_PRO_SIGLO.FAC_FACTURA FA,
          REP_PRO_SIGLO.FAC_FACTURALINEA FAL
    WHERE FAL.FACTURA = FA.ID
      AND TO_NUMBER(TO_CHAR(FA.FECHAFACTURA, 'YYYY')) = 2013
      AND FA.ESTADO IN ('CONCILIADA', 'PENDCONCILIAR', 'PENDREGISTRAR', 'REGISTRADA', 'TRAMITADA')
      AND FAL.TIPODESCUENTO IS NULL
      AND FAL.GCDIRECTA IS NOT NULL
      AND FA.TIPO NOT IN (6, 7, 8)
UNION ALL
  SELECT  'No Directas' FACTURAS, SUM(NVL(FAL.BASEIMPONIBLE, 0) + NVL(FAL.IMPORTE, 0) ) GA03B, COUNT(1)
     FROM REP_PRO_SIGLO.FAC_FACTURA FA,
          REP_PRO_SIGLO.FAC_FACTURALINEA FAL
    WHERE FAL.FACTURA = FA.ID
      AND TO_NUMBER(TO_CHAR(FA.FECHAFACTURA, 'YYYY')) = 2013
      AND FA.ESTADO IN ('CONCILIADA', 'PENDCONCILIAR', 'PENDREGISTRAR', 'REGISTRADA', 'TRAMITADA')
      AND FAL.TIPODESCUENTO IS NULL
      AND FAL.GCDIRECTA IS NULL
      AND FA.TIPO NOT IN (6, 7, 8)
;