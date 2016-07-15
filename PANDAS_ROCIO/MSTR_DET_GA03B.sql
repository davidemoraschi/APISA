/* Formatted on 02/09/2013 9:24:53 (QP5 v5.163.1008.3004) */
CREATE MATERIALIZED VIEW MSTR_DET_GA03B
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS
SELECT NATID_DIA,
       NATID_ORGANOGESTOR,
       IMPORTE_FACTURAS,
       IMPORTE_FACTURAS_ABONO,
       NVL (IMPORTE_FACTURAS, 0) - NVL (IMPORTE_FACTURAS_ABONO, 0) GA03B
  FROM    (  SELECT FA.FECHAFACTURA NATID_DIA,
                    FA.ORGANOGESTOR NATID_ORGANOGESTOR,
                    SUM (NVL (FAL.BASEIMPONIBLE, 0) + NVL (FAL.IMPORTE, 0)) IMPORTE_FACTURAS
               FROM REP_PRO_SEV.FAC_FACTURA@SIG FA, REP_PRO_SEV.FAC_FACTURALINEA@SIG FAL
              WHERE     FAL.FACTURA = FA.ID
                    AND FA.ESTADO IN ('CONCILIADA', 'PENDCONCILIAR', 'PENDREGISTRAR', 'REGISTRADA', 'TRAMITADA')
                    AND FAL.TIPODESCUENTO IS NULL
                    AND FA.TIPO NOT IN (6, 7, 8)
           GROUP BY FA.FECHAFACTURA, FA.ORGANOGESTOR)
       FULL OUTER JOIN
          (  SELECT FA.FECHAFACTURA NATID_DIA,
                    FA.ORGANOGESTOR NATID_ORGANOGESTOR,
                    SUM (NVL (FAL.BASEIMPONIBLE, 0) + NVL (FAL.IMPORTE, 0)) IMPORTE_FACTURAS_ABONO
               FROM REP_PRO_SEV.FAC_FACTURA@SIG FA, REP_PRO_SEV.FAC_FACTURALINEA@SIG FAL
              WHERE     FAL.FACTURA = FA.ID
                    AND FA.ESTADO IN ('CONCILIADA', 'PENDCONCILIAR', 'PENDREGISTRAR', 'REGISTRADA', 'TRAMITADA')
                    AND FAL.TIPODESCUENTO IS NULL
                    AND FA.TIPO IN (6, 7, 8)
           GROUP BY FA.FECHAFACTURA, FA.ORGANOGESTOR)
       USING (NATID_DIA, NATID_ORGANOGESTOR)