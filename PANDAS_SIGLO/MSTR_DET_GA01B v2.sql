/* Formatted on 07/11/2013 10:51:34 (QP5 v5.163.1008.3004) */
DROP TABLE MSTR_DET_GA01B
/

CREATE TABLE MSTR_DET_GA01B 
NOLOGGING
NOMONITORING
PARALLEL
AS
   SELECT NATID_DIA,
          NATID_ORGANOGESTOR,
          NATID_ECONOMICA_N4,
          NATID_ARTICULO,
          --VALOR_CONTRAALBARAN,
          --VALOR_FACTURAS_DIRECTAS,
          --VALOR_FACTURAS_ABONO,
          (NVL (VALOR_CONTRAALBARAN, 0) + NVL (VALOR_FACTURAS_DIRECTAS, 0) - NVL (VALOR_FACTURAS_ABONO, 0)) GA01B
     FROM (  SELECT TRUNC (CON.FECHAREGISTRO) NATID_DIA,
                    PED.ORGANOGESTOR NATID_ORGANOGESTOR,
                    ECONOMICA NATID_ECONOMICA_N4,
                    PEL.ARTICULO NATID_ARTICULO,
                    SUM (EL.IMPORTELINEA) VALOR_CONTRAALBARAN
               FROM REP_PRO_SIGLO.PED_ENTRALMACLINEA@SYG EL
                    JOIN REP_PRO_SIGLO.PED_ENTRADAALMACEN@SYG E
                       ON (EL.ENTRADAALMACEN = E.ID)
                    /*LEFT */
                    JOIN REP_PRO_SIGLO.FAC_CONTRAALBARAN@SYG CON
                       ON (EL.CONTRAALBARAN = CON.ID)
                    JOIN REP_PRO_SIGLO.PED_PEDIDO@SYG PED
                       ON E.PEDIDO = PED.ID
                    JOIN REP_PRO_SIGLO.PED_PEDIDOLINEA@SYG PEL
                       ON (EL.LINEAPEDIDO = PEL.ID)
                    JOIN REP_PRO_SIGLO.PED_PROPUESTASL@SYG PRO
                       ON (PEL.PROPUESTALINEA = PRO.ID)
           GROUP BY TRUNC (CON.FECHAREGISTRO),
                    PED.ORGANOGESTOR,
                    PEL.ARTICULO,
                    ECONOMICA) CA
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
ALTER TABLE MSTR_SIGLO.MSTR_DET_GA01B ADD
CONSTRAINT MSTR_DET_GA01B_R02
 FOREIGN KEY (NATID_ECONOMICA_N4)
 REFERENCES MSTR_SIGLO.MSTR_MAE_ECONOMICA_N4 (NATID_ECONOMICA_N4)
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


--BEGIN
--   SYS.DBMS_STATS.GATHER_TABLE_STATS (OwnName            => 'MSTR_SIGLO',
--                                      TabName            => 'MSTR_DET_GA01B',
--                                      Estimate_Percent   => 0,
--                                      Method_Opt         => 'FOR ALL COLUMNS SIZE 1',
--                                      Degree             => 4,
--                                      Cascade            => FALSE,
--                                      No_Invalidate      => FALSE);
--END;
--/

BEGIN
  SYS.DBMS_STATS.GATHER_TABLE_STATS (
      OwnName        => 'MSTR_SIGLO'
     ,TabName        => 'MSTR_DET_GA01B'
    ,Estimate_Percent  => SYS.DBMS_STATS.AUTO_SAMPLE_SIZE
    ,Method_Opt        => 'FOR ALL INDEXED COLUMNS SIZE AUTO '
    ,Degree            => NULL
    ,Cascade           => TRUE
    ,No_Invalidate     => FALSE);
END;
/

