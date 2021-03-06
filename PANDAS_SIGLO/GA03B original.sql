DECLARE
   V_I_FACTURA NUMBER;
   V_I_FACABO  NUMBER;
BEGIN
   -- IMPORTE TOTAL DE FACTURAS
   SELECT SUM(NVL(FAL.BASEIMPONIBLE, 0) + NVL(FAL.IMPORTE, 0) )
     INTO V_I_FACTURA
     FROM REP_PRO_SIGLO.FAC_FACTURA FA,
          REP_PRO_SIGLO.FAC_FACTURALINEA FAL
    WHERE FAL.FACTURA = FA.ID
      AND TO_NUMBER(TO_CHAR(FA.FECHAFACTURA, 'YYYY')) = 2013
      AND FA.ESTADO IN ('CONCILIADA', 'PENDCONCILIAR', 'PENDREGISTRAR', 'REGISTRADA', 'TRAMITADA')
      AND FAL.TIPODESCUENTO IS NULL
      AND FA.TIPO NOT IN (6, 7, 8);

   -- IMPORTE DE FACTURAS DE ABONO
   SELECT SUM(NVL(FAL.BASEIMPONIBLE, 0) + NVL(FAL.IMPORTE, 0))
     INTO V_I_FACABO
     FROM REP_PRO_SIGLO.FAC_FACTURA FA,
          REP_PRO_SIGLO.FAC_FACTURALINEA FAL
    WHERE FAL.FACTURA = FA.ID
      AND TO_CHAR(FA.FECHAFACTURA, 'YYYY') = $ANYO
      AND FA.ESTADO IN ('CONCILIADA', 'PENDCONCILIAR', 'PENDREGISTRAR', 'REGISTRADA', 'TRAMITADA')
      AND FAL.TIPODESCUENTO IS NULL
      AND FA.TIPO IN (6, 7, 8);

   :1 := NVL(V_I_FACTURA, 0) - NVL(V_I_FACABO, 0);
END;