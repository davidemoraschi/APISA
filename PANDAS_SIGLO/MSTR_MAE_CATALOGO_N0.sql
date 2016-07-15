/* Formatted on 29/10/2013 13:50:23 (QP5 v5.163.1008.3004) */
--DROP TABLE MSTR_MAE_CATALOGO_N0;

CREATE TABLE MSTR_MAE_CATALOGO_N0
NOLOGGING
NOMONITORING
NOPARALLEL
AS
   SELECT ID NATID_CATALOGO_N0, DESCRIPCION DESCR_CATALOGO_N0
     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
    WHERE CLASIFICACION = 5 AND VALORPADRE IS NULL AND ACTIVO = 'T'
   UNION ALL
   SELECT -1 NATID_CATALOGO_N0, 'n/a' DESCR_CATALOGO_N0 FROM DUAL;

/

ALTER TABLE MSTR_MAE_CATALOGO_N0 ADD (
  CONSTRAINT MSTR_MAE_CATALOGO_N0_PK
  PRIMARY KEY
  (NATID_CATALOGO_N0)
  USING INDEX
    TABLESPACE USERS
    NOLOGGING
);

/

BEGIN
   SYS.DBMS_STATS.GATHER_TABLE_STATS (OwnName            => 'MSTR_SIGLO',
                                      TabName            => 'MSTR_MAE_CATALOGO_N0',
                                      Estimate_Percent   => 0,
                                      Method_Opt         => 'FOR ALL COLUMNS SIZE 1',
                                      Degree             => 4,
                                      Cascade            => FALSE,
                                      No_Invalidate      => FALSE);
END;
/