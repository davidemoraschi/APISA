/* Formatted on 29/10/2013 19:30:17 (QP5 v5.163.1008.3004) */
DROP TABLE MSTR_DET_GA01B
/

CREATE TABLE MSTR_DET_GA01B --(NATID_DIA,NATID_ORGANOGESTOR,VALOR_CONTRAALBARAN,VALOR_FACTURAS_DIRECTAS,VALOR_FACTURAS_ABONO,GA01B)
NOLOGGING
NOMONITORING
PARALLEL
AS
   SELECT NATID_DIA,
          NATID_ORGANOGESTOR,
          NATID_ECONOMICA_N4,
          NATID_ARTICULO,
          VALOR_CONTRAALBARAN,
          VALOR_FACTURAS_DIRECTAS,
          VALOR_FACTURAS_ABONO,
          (NVL (VALOR_CONTRAALBARAN, 0) + NVL (VALOR_FACTURAS_DIRECTAS, 0) - NVL (VALOR_FACTURAS_ABONO, 0)) GA01B
     FROM (  SELECT CON.FECHAREGISTRO NATID_DIA,
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
           GROUP BY CON.FECHAREGISTRO, PED.ORGANOGESTOR, PEL.ARTICULO) CA
          FULL OUTER JOIN (  SELECT FA.FECHAFACTURA NATID_DIA,
                                    FA.ORGANOGESTOR NATID_ORGANOGESTOR,
                                    FAL.CLASIFECONOMICADIRECTA NATID_ECONOMICA_N4,
                                    FAL.GCDIRECTA NATID_ARTICULO,
                                    SUM (NVL (FAL.BASEIMPONIBLE, 0) + NVL (FAL.IMPORTE, 0)) VALOR_FACTURAS_DIRECTAS
                               FROM REP_PRO_SIGLO.FAC_FACTURA@SYG FA, REP_PRO_SIGLO.FAC_FACTURALINEA@SYG FAL
                              WHERE     FAL.FACTURA = FA.ID
                                    AND FAL.GCDIRECTA IS NOT NULL
                                    AND FA.ESTADO IN ('CONCILIADA', 'TRAMITADA')
                                    AND FAL.TIPODESCUENTO IS NULL
                                    AND FA.TIPO NOT IN (6, 7, 8)
                           GROUP BY FA.FECHAFACTURA,
                                    FA.ORGANOGESTOR,
                                    FAL.CLASIFECONOMICADIRECTA,
                                    FAL.GCDIRECTA) FD
             USING (NATID_DIA, NATID_ORGANOGESTOR, NATID_ECONOMICA_N4, NATID_ARTICULO)
          FULL OUTER JOIN (  SELECT FA.FECHAFACTURA NATID_DIA,
                                    FA.ORGANOGESTOR NATID_ORGANOGESTOR,
                                    FAL.CLASIFECONOMICADIRECTA NATID_ECONOMICA_N4,
                                    FAL.GCDIRECTA NATID_ARTICULO,
                                    SUM (NVL (FAL.BASEIMPONIBLE, 0) + NVL (FAL.IMPORTE, 0)) VALOR_FACTURAS_ABONO
                               FROM REP_PRO_SIGLO.FAC_FACTURA@SYG FA, REP_PRO_SIGLO.FAC_FACTURALINEA@SYG FAL
                              WHERE     FAL.FACTURA = FA.ID
                                    AND FAL.GCDIRECTA IS NOT NULL
                                    AND FA.ESTADO IN ('CONCILIADA', 'TRAMITADA')
                                    AND FAL.TIPODESCUENTO IS NULL
                                    AND FA.TIPO IN (6, 7, 8)
                           GROUP BY FA.FECHAFACTURA,
                                    FA.ORGANOGESTOR,
                                    FAL.CLASIFECONOMICADIRECTA,
                                    FAL.GCDIRECTA) FA
             USING (NATID_DIA, NATID_ORGANOGESTOR, NATID_ECONOMICA_N4, NATID_ARTICULO)
/

          ALTER TABLE MSTR_SIGLO.MSTR_DET_GA01B ADD
CONSTRAINT MSTR_DET_GA01B_PK
 PRIMARY KEY (NATID_DIA, NATID_ORGANOGESTOR, NATID_ECONOMICA_N4, NATID_ARTICULO)
 ENABLE
 VALIDATE
/

ALTER TABLE MSTR_SIGLO.MSTR_DET_GA01B ADD 
CONSTRAINT MSTR_DET_GA01B_R01
 FOREIGN KEY (NATID_ARTICULO)
 REFERENCES MSTR_SIGLO.MSTR_MAE_ARTICULOS (NATID_ARTICULO)
 ENABLE
 VALIDATE
/

ALTER TABLE MSTR_DET_GA01B ADD (
  CONSTRAINT MSTR_DET_GA01B_C01
  CHECK (NATID_DIA IS NOT NULL));

ALTER TABLE MSTR_DET_GA01B ADD (
  CONSTRAINT MSTR_DET_GA01B_C02
  CHECK (NATID_ORGANOGESTOR IS NOT NULL));

ALTER TABLE MSTR_DET_GA01B ADD (
  CONSTRAINT MSTR_DET_GA01B_C03
  CHECK (NATID_ECONOMICA_N4 IS NOT NULL));

ALTER TABLE MSTR_DET_GA01B ADD (
  CONSTRAINT MSTR_DET_GA01B_C04
  CHECK (NATID_ARTICULO IS NOT NULL));


BEGIN
   SYS.DBMS_STATS.GATHER_TABLE_STATS (OwnName            => 'MSTR_SIGLO',
                                      TabName            => 'MSTR_DET_GA01B',
                                      Estimate_Percent   => 0,
                                      Method_Opt         => 'FOR ALL COLUMNS SIZE 1',
                                      Degree             => 4,
                                      Cascade            => FALSE,
                                      No_Invalidate      => FALSE);
END;
/