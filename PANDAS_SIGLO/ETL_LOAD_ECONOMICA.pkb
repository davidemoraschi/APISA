CREATE OR REPLACE PACKAGE BODY MSTR_SIGLO.ETL_LOAD_ECONOMICA
AS
   /******************************************************************************
      NAME:       ETL_LOAD_INFHOS
      PURPOSE:

      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        9/17/2012      Davide       1. Created this package body.
   ******************************************************************************/

   PROCEDURE P_001 (Param1 IN NUMBER DEFAULT NULL)
   IS
      v_inicio_ts           DATE;
      v_fin_ts              DATE;
      v_elapsed             NUMBER;
      v_last_refresh        DATE;
      v_area_hospitalaria   VARCHAR2 (10);
   BEGIN
      v_inicio_ts := SYSDATE;

      SELECT NATID_AREA_HOSPITALARIA INTO v_area_hospitalaria FROM MSTR_UTL_CODIGOS;

      BEGIN
         EXECUTE IMMEDIATE 'ALTER TABLE MSTR_SIGLO.MSTR_DET_GA01B DROP CONSTRAINT MSTR_DET_GA01B_R03';
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      BEGIN
         --EXECUTE IMMEDIATE 'DROP TABLE MSTR_MAE_ARTICULOS';
         EXECUTE IMMEDIATE 'DROP TABLE MSTR_MAE_ECONOMICA_N4';
      --      EXCEPTION
      --         WHEN OTHERS
      --         THEN
      --            NULL;
      END;

      BEGIN
         --EXECUTE IMMEDIATE 'DROP TABLE MSTR_MAE_ARTICULOS';
         EXECUTE IMMEDIATE 'DROP TABLE MSTR_MAE_ECONOMICA_N3';
      --      EXCEPTION
      --         WHEN OTHERS
      --         THEN
      --            NULL;
      END;

      BEGIN
         EXECUTE IMMEDIATE 'DROP TABLE MSTR_MAE_ECONOMICA_N2';
      --      EXCEPTION
      --         WHEN OTHERS
      --         THEN
      --            NULL;
      END;

      BEGIN
         EXECUTE IMMEDIATE 'DROP TABLE MSTR_MAE_ECONOMICA_N1';
      --      EXCEPTION
      --         WHEN OTHERS
      --         THEN
      --            NULL;
      END;

      BEGIN
         EXECUTE IMMEDIATE 'DROP TABLE MSTR_MAE_ECONOMICA_N0';
      --      EXCEPTION
      --         WHEN OTHERS
      --         THEN
      --            NULL;
      END;

      --
      --      BEGIN
      --         EXECUTE IMMEDIATE 'DROP TABLE MSTR_MAE_CATALOGO_N8';
      --      --      EXCEPTION
      --      --         WHEN OTHERS
      --      --         THEN
      --      --            NULL;
      --      END;
      --
      --      BEGIN
      --         EXECUTE IMMEDIATE 'DROP TABLE MSTR_MAE_CATALOGO_N7';
      --      --      EXCEPTION
      --      --         WHEN OTHERS
      --      --         THEN
      --      --            NULL;
      --      END;
      --
      --      BEGIN
      --         EXECUTE IMMEDIATE 'DROP TABLE MSTR_MAE_CATALOGO_N6';
      --      --      EXCEPTION
      --      --         WHEN OTHERS
      --      --         THEN
      --      --            NULL;
      --      END;
      --
      --      BEGIN
      --         EXECUTE IMMEDIATE 'DROP TABLE MSTR_MAE_CATALOGO_N5';
      --      --      EXCEPTION
      --      --         WHEN OTHERS
      --      --         THEN
      --      --            NULL;
      --      END;
      --
      --      BEGIN
      --         EXECUTE IMMEDIATE 'DROP TABLE MSTR_MAE_CATALOGO_N4';
      --      --      EXCEPTION
      --      --         WHEN OTHERS
      --      --         THEN
      --      --            NULL;
      --      END;
      --
      --      BEGIN
      --         EXECUTE IMMEDIATE 'DROP TABLE MSTR_MAE_CATALOGO_N3';
      --      --      EXCEPTION
      --      --         WHEN OTHERS
      --      --         THEN
      --      --            NULL;
      --      END;
      --
      --      BEGIN
      --         EXECUTE IMMEDIATE 'DROP TABLE MSTR_MAE_CATALOGO_N2';
      --      --      EXCEPTION
      --      --         WHEN OTHERS
      --      --         THEN
      --      --            NULL;
      --      END;
      --
      --      BEGIN
      --         EXECUTE IMMEDIATE 'DROP TABLE MSTR_MAE_CATALOGO_N1';
      --      --      EXCEPTION
      --      --         WHEN OTHERS
      --      --         THEN
      --      --            NULL;
      --      END;
      --
      --      BEGIN
      --         EXECUTE IMMEDIATE 'DROP TABLE MSTR_MAE_CATALOGO_N0';
      --      --      EXCEPTION
      --      --         WHEN OTHERS
      --      --         THEN
      --      --            NULL;
      --      END;

      P_N0;
      P_N1;
      P_N2;
      P_N3;
      P_N4;

      --      P_N5;
      --      P_N6;
      --      P_N7;
      --      P_N8;
      --      P_N9;
      --      P_NA;
      --      P_NB;
      --      P_NC;
      --      P_NZ;

      BEGIN
         EXECUTE IMMEDIATE 'ALTER TABLE MSTR_SIGLO.MSTR_DET_GA01B ADD 
CONSTRAINT MSTR_DET_GA01B_R03
 FOREIGN KEY (NATID_ECONOMICA_N4)
 REFERENCES MSTR_SIGLO.MSTR_MAE_ECONOMICA_N4 (NATID_ECONOMICA_N4)
 ENABLE
 VALIDATE';
      --      EXCEPTION
      --         WHEN OTHERS
      --         THEN
      --            NULL;
      END;



      COMMIT;

      --     SELECT MAX (LAST_REFRESH_DATE) INTO v_last_refresh FROM MSTR_DET_CAMAS_DEL_DIA;

      v_fin_ts := SYSDATE;
      v_elapsed := (v_fin_ts - v_inicio_ts) * 24 * 60;
   --      MSTR.PANDAS_090_POST_TO_SHAREP_v3.RETRY_N_TIMES (
   --         3,
   --         '{ Title: "Carga Censo de Camas", Content: "'
   --         || '<table border=''1'' cellpadding=''3''><tr><td bgcolor=''#CEA539''>Última Ejecución</td><td bgcolor=''#CEA539''>Duración (min.)</td><td bgcolor=''#CEA539''>Fecha Replica</td></tr><tr><td bgcolor=''#232325''>'
   --         || TO_CHAR (SYSDATE, 'dd-mon hh24:mi')
   --         || '</td><td>'
   --         || ROUND (v_elapsed, 2)
   --         || '</td><td>'
   --         || TO_CHAR (v_last_refresh, 'dd-mon hh24:mi')
   --         || '</td></tr></table> '
   --         || '", Result: "SUCCESS"  }');
   --      MSTR.PANDAS_093_TWIT.POST_STATUS (
   --         TO_CHAR (SYSDATE, 'hh24"h"mi') || '+' || v_area_hospitalaria || '+Carga+Censo+de+Camas+completada+#ProyectoPandas',
   --         'PANDAS_HOSPI');
   --   EXCEPTION
   --      WHEN OTHERS
   --      THEN
   --         --         BEGIN
   --         --            MSTR.PANDAS_093_TWIT.POST_STATUS (
   --         --                  'Camas+'
   --         --               || TO_CHAR (SYSDATE, 'hh24"h"mi')
   --         --               || '+'
   --         --               || v_area_hospitalaria
   --         --               || '+'
   --         --               || SUBSTR (REPLACE (REPLACE (REPLACE (SQLERRM, ' ', '+'), ',', ''), CHR (10), '+'), 1, 90)
   --         --               || '...#ProyectoPandas',
   --         --               'PANDAS_ERROR');
   --         --         END;
   --
   --         RAISE;
   END P_001;

   PROCEDURE P_N0
   IS
   BEGIN
      EXECUTE IMMEDIATE 'CREATE TABLE MSTR_MAE_ECONOMICA_N0
NOLOGGING
NOMONITORING
NOPARALLEL
AS
   SELECT ID NATID_ECONOMICA_N0, DESCRIPCION DESCR_ECONOMICA_N0
     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
    WHERE CLASIFICACION = 4 AND VALORPADRE IS NULL
   UNION ALL
   SELECT -1 NATID_ECONOMICA_N0, ''n/a'' DESCR_ECONOMICA_N0 FROM DUAL';

      EXECUTE IMMEDIATE 'ALTER TABLE MSTR_SIGLO.MSTR_MAE_ECONOMICA_N0 ADD
CONSTRAINT MSTR_MAE_ECONOMICA_N0_PK
 PRIMARY KEY (NATID_ECONOMICA_N0)
 ENABLE
 VALIDATE';

      BEGIN
         SYS.DBMS_STATS.GATHER_TABLE_STATS (OwnName            => 'MSTR_SIGLO',
                                            TabName            => 'MSTR_MAE_ECONOMICA_N0',
                                            Estimate_Percent   => 0,
                                            Method_Opt         => 'FOR ALL COLUMNS SIZE 1',
                                            Degree             => 4,
                                            Cascade            => FALSE,
                                            No_Invalidate      => FALSE);
      END;
   END P_N0;

   PROCEDURE P_N1
   IS
   BEGIN
      EXECUTE IMMEDIATE 'CREATE TABLE MSTR_MAE_ECONOMICA_N1
NOLOGGING
NOMONITORING
NOPARALLEL
AS
   SELECT ID NATID_ECONOMICA_N1,
          DESCRIPCION DESCR_ECONOMICA_N1,
          CODIGOCONCATENADO LDESC_ECONOMICA_N1,
          VALORPADRE NATID_ECONOMICA_N0
     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
    WHERE CLASIFICACION = 4 AND VALORPADRE IN (SELECT NATID_ECONOMICA_N0 FROM MSTR_MAE_ECONOMICA_N0)
   UNION ALL
   SELECT -1 NATID_ECONOMICA_N1,
          ''n/a'' DESCR_ECONOMICA_N1,
          ''n/a'' LDESC_ECONOMICA_N1,
          -1 NATID_ECONOMICA_N0
     FROM DUAL
   UNION ALL
   -- Replica N0
   SELECT ID NATID_ECONOMICA_N1,
          DESCRIPCION DESCR_ECONOMICA_N1,
          CODIGOCONCATENADO || ''*'' LDESC_ECONOMICA_N1,
          ID NATID_ECONOMICA_N0
     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
    WHERE CLASIFICACION = 4 AND VALORPADRE IS NULL';

      EXECUTE IMMEDIATE 'ALTER TABLE MSTR_SIGLO.MSTR_MAE_ECONOMICA_N1 ADD
CONSTRAINT MSTR_MAE_ECONOMICA_N1_PK
 PRIMARY KEY (NATID_ECONOMICA_N1)
 ENABLE
 VALIDATE';

      EXECUTE IMMEDIATE 'ALTER TABLE MSTR_SIGLO.MSTR_MAE_ECONOMICA_N1 ADD
CONSTRAINT MSTR_MAE_ECONOMICA_N1_R01
 FOREIGN KEY (NATID_ECONOMICA_N0)
 REFERENCES MSTR_SIGLO.MSTR_MAE_ECONOMICA_N0 (NATID_ECONOMICA_N0)
 ENABLE
 VALIDATE';

      EXECUTE IMMEDIATE 'CREATE INDEX MSTR_SIGLO.MSTR_MAE_ECONOMICA_N1_IX01
   ON MSTR_SIGLO.MSTR_MAE_ECONOMICA_N1 (NATID_ECONOMICA_N0)
   NOLOGGING
   NOPARALLEL';

      BEGIN
         SYS.DBMS_STATS.GATHER_TABLE_STATS (OwnName            => 'MSTR_SIGLO',
                                            TabName            => 'MSTR_MAE_ECONOMICA_N1',
                                            Estimate_Percent   => 0,
                                            Method_Opt         => 'FOR ALL COLUMNS SIZE 1',
                                            Degree             => 4,
                                            Cascade            => FALSE,
                                            No_Invalidate      => FALSE);
      END;
   END P_N1;

   PROCEDURE P_N2
   IS
   BEGIN
      EXECUTE IMMEDIATE 'CREATE TABLE MSTR_MAE_ECONOMICA_N2
NOLOGGING
NOMONITORING
NOPARALLEL
AS
   SELECT ID NATID_ECONOMICA_N2,
          DESCRIPCION DESCR_ECONOMICA_N2,
          CODIGOCONCATENADO LDESC_ECONOMICA_N2,
          VALORPADRE NATID_ECONOMICA_N1
     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
    WHERE CLASIFICACION = 4
          AND VALORPADRE IN (SELECT NATID_ECONOMICA_N1
                               FROM MSTR_MAE_ECONOMICA_N1
                              WHERE INSTR (LDESC_ECONOMICA_N1, ''*'') = 0)
   UNION ALL
   SELECT -1 NATID_ECONOMICA_N2,
          ''n/a'' DESCR_ECONOMICA_N2,
         ''n/a'' LDESC_ECONOMICA_N2,
          -1 NATID_ECONOMICA_N1
     FROM DUAL
   UNION ALL
   -- Replica N0
   SELECT ID NATID_ECONOMICA_N2,
          DESCRIPCION DESCR_ECONOMICA_N2,
          CODIGOCONCATENADO || ''**'' LDESC_ECONOMICA_N2,
          ID NATID_ECONOMICA_N1
     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
    WHERE CLASIFICACION = 4 AND VALORPADRE IS NULL
   UNION ALL
   -- Replica N1
   SELECT ID NATID_ECONOMICA_N2,
          DESCRIPCION DESCR_ECONOMICA_N2,
          CODIGOCONCATENADO || ''*'' LDESC_ECONOMICA_N2,
          ID NATID_ECONOMICA_N1
     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
    WHERE CLASIFICACION = 4 AND VALORPADRE IN (SELECT NATID_ECONOMICA_N0 FROM MSTR_MAE_ECONOMICA_N0)';

      EXECUTE IMMEDIATE 'ALTER TABLE MSTR_SIGLO.MSTR_MAE_ECONOMICA_N2 ADD
CONSTRAINT MSTR_MAE_ECONOMICA_N2_PK
 PRIMARY KEY (NATID_ECONOMICA_N2)
 ENABLE
 VALIDATE';

      EXECUTE IMMEDIATE 'ALTER TABLE MSTR_SIGLO.MSTR_MAE_ECONOMICA_N2 ADD
CONSTRAINT MSTR_MAE_ECONOMICA_N2_R01
 FOREIGN KEY (NATID_ECONOMICA_N1)
 REFERENCES MSTR_SIGLO.MSTR_MAE_ECONOMICA_N1 (NATID_ECONOMICA_N1)
 ENABLE
 VALIDATE';

      EXECUTE IMMEDIATE 'CREATE INDEX MSTR_SIGLO.MSTR_MAE_ECONOMICA_N2_IX01
   ON MSTR_SIGLO.MSTR_MAE_ECONOMICA_N2 (NATID_ECONOMICA_N1)
   NOLOGGING
   NOPARALLEL';

      BEGIN
         SYS.DBMS_STATS.GATHER_TABLE_STATS (OwnName            => 'MSTR_SIGLO',
                                            TabName            => 'MSTR_MAE_ECONOMICA_N2',
                                            Estimate_Percent   => 0,
                                            Method_Opt         => 'FOR ALL COLUMNS SIZE 1',
                                            Degree             => 4,
                                            Cascade            => FALSE,
                                            No_Invalidate      => FALSE);
      END;
   END P_N2;

   PROCEDURE P_N3
   IS
   BEGIN
      EXECUTE IMMEDIATE 'CREATE TABLE MSTR_MAE_ECONOMICA_N3
NOLOGGING
NOMONITORING
NOPARALLEL
AS
   SELECT ID NATID_ECONOMICA_N3,
          DESCRIPCION DESCR_ECONOMICA_N3,
          CODIGOCONCATENADO LDESC_ECONOMICA_N3,
          VALORPADRE NATID_ECONOMICA_N2
     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
    WHERE CLASIFICACION = 4
          AND VALORPADRE IN (SELECT NATID_ECONOMICA_N2
                               FROM MSTR_MAE_ECONOMICA_N2
                              WHERE INSTR (LDESC_ECONOMICA_N2, ''*'') = 0)
   UNION ALL
   SELECT -1 NATID_ECONOMICA_N3,
          ''n/a'' DESCR_ECONOMICA_N3,
          ''n/a'' LDESC_ECONOMICA_N3,
          -1 NATID_ECONOMICA_N2
     FROM DUAL
   UNION ALL
   -- Replica N0
   SELECT ID NATID_ECONOMICA_N3,
          DESCRIPCION DESCR_ECONOMICA_N3,
          CODIGOCONCATENADO || ''***'' LDESC_ECONOMICA_N3,
          ID NATID_ECONOMICA_N2
     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
    WHERE CLASIFICACION = 4 AND VALORPADRE IS NULL
   UNION ALL
   -- Replica N1
   SELECT ID NATID_ECONOMICA_N3,
          DESCRIPCION DESCR_ECONOMICA_N3,
          CODIGOCONCATENADO || ''**'' LDESC_ECONOMICA_N3,
          ID NATID_ECONOMICA_N2
     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
    WHERE CLASIFICACION = 4 AND VALORPADRE IN (SELECT NATID_ECONOMICA_N0 FROM MSTR_MAE_ECONOMICA_N0)
   UNION ALL
   -- Replica N2
   SELECT ID NATID_ECONOMICA_N3,
          DESCRIPCION DESCR_ECONOMICA_N3,
          CODIGOCONCATENADO || ''*'' LDESC_ECONOMICA_N3,
          ID NATID_ECONOMICA_N2
     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
    WHERE CLASIFICACION = 4
          AND VALORPADRE IN (SELECT NATID_ECONOMICA_N1
                               FROM MSTR_MAE_ECONOMICA_N1
                              WHERE INSTR (LDESC_ECONOMICA_N1, ''*'') = 0)';

      EXECUTE IMMEDIATE 'ALTER TABLE MSTR_SIGLO.MSTR_MAE_ECONOMICA_N3 ADD
CONSTRAINT MSTR_MAE_ECONOMICA_N3_PK
 PRIMARY KEY (NATID_ECONOMICA_N3)
 ENABLE
 VALIDATE';

      EXECUTE IMMEDIATE 'ALTER TABLE MSTR_SIGLO.MSTR_MAE_ECONOMICA_N3 ADD
CONSTRAINT MSTR_MAE_ECONOMICA_N3_R01
 FOREIGN KEY (NATID_ECONOMICA_N2)
 REFERENCES MSTR_SIGLO.MSTR_MAE_ECONOMICA_N2 (NATID_ECONOMICA_N2)
 ENABLE
 VALIDATE';

      EXECUTE IMMEDIATE 'CREATE INDEX MSTR_SIGLO.MSTR_MAE_ECONOMICA_N3_IX01
   ON MSTR_SIGLO.MSTR_MAE_ECONOMICA_N3 (NATID_ECONOMICA_N2)
   NOLOGGING
   NOPARALLEL';

      BEGIN
         SYS.DBMS_STATS.GATHER_TABLE_STATS (OwnName            => 'MSTR_SIGLO',
                                            TabName            => 'MSTR_MAE_ECONOMICA_N3',
                                            Estimate_Percent   => 0,
                                            Method_Opt         => 'FOR ALL COLUMNS SIZE 1',
                                            Degree             => 4,
                                            Cascade            => FALSE,
                                            No_Invalidate      => FALSE);
      END;
   END P_N3;

   PROCEDURE P_N4
   IS
   BEGIN
      EXECUTE IMMEDIATE 'CREATE TABLE MSTR_MAE_ECONOMICA_N4
NOLOGGING
NOMONITORING
NOPARALLEL
AS
   SELECT ID NATID_ECONOMICA_N4,
          DESCRIPCION DESCR_ECONOMICA_N4,
          CODIGOCONCATENADO LDESC_ECONOMICA_N4,
          VALORPADRE NATID_ECONOMICA_N3
     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
    WHERE CLASIFICACION = 4
          AND VALORPADRE IN (SELECT NATID_ECONOMICA_N3
                               FROM MSTR_MAE_ECONOMICA_N3
                              WHERE INSTR (LDESC_ECONOMICA_N3, ''*'') = 0)
   UNION ALL
   SELECT -1 NATID_ECONOMICA_N4,
          ''n/a'' DESCR_ECONOMICA_N4,
          ''n/a'' LDESC_ECONOMICA_N4,
          -1 NATID_ECONOMICA_N3
     FROM DUAL
   UNION ALL
   -- Replica N0
   SELECT ID NATID_ECONOMICA_N4,
          DESCRIPCION DESCR_ECONOMICA_N4,
          CODIGOCONCATENADO || ''****'' LDESC_ECONOMICA_N4,
          ID NATID_ECONOMICA_N3
     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
    WHERE CLASIFICACION = 4 AND VALORPADRE IS NULL
   UNION ALL
   -- Replica N1
   SELECT ID NATID_ECONOMICA_N4,
          DESCRIPCION DESCR_ECONOMICA_N4,
          CODIGOCONCATENADO || ''***'' LDESC_ECONOMICA_N4,
          ID NATID_ECONOMICA_N3
     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
    WHERE CLASIFICACION = 4 AND VALORPADRE IN (SELECT NATID_ECONOMICA_N0 FROM MSTR_MAE_ECONOMICA_N0)
   UNION ALL
   -- Replica N2
   SELECT ID NATID_ECONOMICA_N4,
          DESCRIPCION DESCR_ECONOMICA_N4,
          CODIGOCONCATENADO || ''**'' LDESC_ECONOMICA_N4,
          ID NATID_ECONOMICA_N3
     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
    WHERE CLASIFICACION = 4
          AND VALORPADRE IN (SELECT NATID_ECONOMICA_N1
                               FROM MSTR_MAE_ECONOMICA_N1
                              WHERE INSTR (LDESC_ECONOMICA_N1, ''*'') = 0)
   UNION ALL
   -- Replica N3
   SELECT ID NATID_ECONOMICA_N4,
          DESCRIPCION DESCR_ECONOMICA_N4,
          CODIGOCONCATENADO || ''*'' LDESC_ECONOMICA_N4,
          ID NATID_ECONOMICA_N3
     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
    WHERE CLASIFICACION = 4
          AND VALORPADRE IN (SELECT NATID_ECONOMICA_N2
                               FROM MSTR_MAE_ECONOMICA_N2
                              WHERE INSTR (LDESC_ECONOMICA_N2, ''*'') = 0)';

      EXECUTE IMMEDIATE 'ALTER TABLE MSTR_SIGLO.MSTR_MAE_ECONOMICA_N4 ADD
CONSTRAINT MSTR_MAE_ECONOMICA_N4_PK
 PRIMARY KEY (NATID_ECONOMICA_N4)
 ENABLE
 VALIDATE';

      EXECUTE IMMEDIATE 'ALTER TABLE MSTR_SIGLO.MSTR_MAE_ECONOMICA_N4 ADD
CONSTRAINT MSTR_MAE_ECONOMICA_N4_R01
 FOREIGN KEY (NATID_ECONOMICA_N3)
 REFERENCES MSTR_SIGLO.MSTR_MAE_ECONOMICA_N3 (NATID_ECONOMICA_N3)
 ENABLE
 VALIDATE';

      EXECUTE IMMEDIATE 'CREATE INDEX MSTR_SIGLO.MSTR_MAE_ECONOMICA_N4_IX01
   ON MSTR_SIGLO.MSTR_MAE_ECONOMICA_N4 (NATID_ECONOMICA_N3)
   NOLOGGING
   NOPARALLEL';

      BEGIN
         SYS.DBMS_STATS.GATHER_TABLE_STATS (OwnName            => 'MSTR_SIGLO',
                                            TabName            => 'MSTR_MAE_ECONOMICA_N4',
                                            Estimate_Percent   => 0,
                                            Method_Opt         => 'FOR ALL COLUMNS SIZE 1',
                                            Degree             => 4,
                                            Cascade            => FALSE,
                                            No_Invalidate      => FALSE);
      END;
   END P_N4;
--   PROCEDURE P_N5
--   IS
--   BEGIN
--      EXECUTE IMMEDIATE
--         'CREATE TABLE MSTR_MAE_CATALOGO_N5
--NOLOGGING
--NOMONITORING
--NOPARALLEL
--AS
--   SELECT ID NATID_CATALOGO_N5,
--          DESCRIPCION DESCR_CATALOGO_N5,
--          CODIGOCONCATENADO LDESC_CATALOGO_N5,
--          NIVEL NIVEL_SIGLO_N5,
--          VALORPADRE NATID_CATALOGO_N4
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N4
--                               FROM MSTR_MAE_CATALOGO_N4
--                              WHERE INSTR (LDESC_CATALOGO_N4, ''*'') = 0)
--   UNION ALL
--   SELECT -1 NATID_CATALOGO_N5,
--          ''n/a'' DESCR_CATALOGO_N5,
--          ''n/a'' LDESC_CATALOGO_N5,
--          31 NIVEL_SIGLO_N5,
--          -1 NATID_CATALOGO_N4
--     FROM DUAL
--   UNION ALL
--   -- Replica N1
--   SELECT ID NATID_CATALOGO_N5,
--          DESCRIPCION DESCR_CATALOGO_N5,
--          CODIGOCONCATENADO || ''****'' LDESC_CATALOGO_N5,
--          31 NIVEL_SIGLO_N5,
--          ID NATID_CATALOGO_N4
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE CLASIFICACION = 5 AND ACTIVO = ''T'' AND VALORPADRE IN (SELECT NATID_CATALOGO_N0 FROM MSTR_MAE_CATALOGO_N0)
--   UNION ALL
--   --Replica N2
--   SELECT ID NATID_CATALOGO_N5,
--          DESCRIPCION DESCR_CATALOGO_N5,
--          CODIGOCONCATENADO || ''***'' LDESC_CATALOGO_N5,
--          31 NIVEL_SIGLO_N5,
--          ID NATID_CATALOGO_N4
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N1
--                               FROM MSTR_MAE_CATALOGO_N1
--                              WHERE INSTR (LDESC_CATALOGO_N1, ''*'') = 0)
--   UNION ALL
--   -- Replica N3
--   SELECT ID NATID_CATALOGO_N5,
--          DESCRIPCION DESCR_CATALOGO_N5,
--          CODIGOCONCATENADO || ''**'' LDESC_CATALOGO_N5,
--          31 NIVEL_SIGLO_N5,
--          ID NATID_CATALOGO_N4
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N2
--                               FROM MSTR_MAE_CATALOGO_N2
--                              WHERE INSTR (LDESC_CATALOGO_N2, ''*'') = 0)
--   UNION ALL
--   -- Replica N4
--   SELECT ID NATID_CATALOGO_N5,
--          DESCRIPCION DESCR_CATALOGO_N5,
--          CODIGOCONCATENADO || ''*'' LDESC_CATALOGO_N5,
--          31 NIVEL_SIGLO_N5,
--          ID NATID_CATALOGO_N4
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N3
--                               FROM MSTR_MAE_CATALOGO_N3
--                              WHERE INSTR (LDESC_CATALOGO_N3, ''*'') = 0)';
--
--      EXECUTE IMMEDIATE 'ALTER TABLE MSTR_MAE_CATALOGO_N5 ADD (
--  CONSTRAINT MSTR_MAE_CATALOGO_N5_PK
--  PRIMARY KEY
--  (NATID_CATALOGO_N5)
--  USING INDEX
--    TABLESPACE USERS
--    NOLOGGING
--)';
--
--      EXECUTE IMMEDIATE 'ALTER TABLE MSTR_SIGLO.MSTR_MAE_CATALOGO_N5 ADD
--CONSTRAINT MSTR_MAE_CATALOGO_N5_R01
-- FOREIGN KEY (NATID_CATALOGO_N4)
-- REFERENCES MSTR_SIGLO.MSTR_MAE_CATALOGO_N4 (NATID_CATALOGO_N4)
-- ENABLE
-- VALIDATE';
--
--      BEGIN
--         SYS.DBMS_STATS.GATHER_TABLE_STATS (OwnName            => 'MSTR_SIGLO',
--                                            TabName            => 'MSTR_MAE_CATALOGO_N5',
--                                            Estimate_Percent   => 0,
--                                            Method_Opt         => 'FOR ALL COLUMNS SIZE 1',
--                                            Degree             => 4,
--                                            Cascade            => FALSE,
--                                            No_Invalidate      => FALSE);
--      END;
--   END P_N5;
--
--   PROCEDURE P_N6
--   IS
--   BEGIN
--      EXECUTE IMMEDIATE
--         'CREATE TABLE MSTR_MAE_CATALOGO_N6
--NOLOGGING
--NOMONITORING
--NOPARALLEL
--AS
--   SELECT ID NATID_CATALOGO_N6,
--          DESCRIPCION DESCR_CATALOGO_N6,
--          CODIGOCONCATENADO LDESC_CATALOGO_N6,
--          NIVEL NIVEL_SIGLO_N6,
--          VALORPADRE NATID_CATALOGO_N5
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N5
--                               FROM MSTR_MAE_CATALOGO_N5
--                              WHERE INSTR (LDESC_CATALOGO_N5, ''*'') = 0)
--   UNION ALL
--   SELECT -1 NATID_CATALOGO_N6,
--          ''n/a'' DESCR_CATALOGO_N6,
--          ''n/a'' LDESC_CATALOGO_N6,
--          32 NIVEL_SIGLO_N6,
--          -1 NATID_CATALOGO_N5
--     FROM DUAL
--   UNION ALL
--   -- Replica N1
--   SELECT ID NATID_CATALOGO_N6,
--          DESCRIPCION DESCR_CATALOGO_N6,
--          CODIGOCONCATENADO || ''*****'' LDESC_CATALOGO_N6,
--          32 NIVEL_SIGLO_N6,
--          ID NATID_CATALOGO_N5
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE CLASIFICACION = 5 AND ACTIVO = ''T'' AND VALORPADRE IN (SELECT NATID_CATALOGO_N0 FROM MSTR_MAE_CATALOGO_N0)
--   UNION ALL
--   --Replica N2
--   SELECT ID NATID_CATALOGO_N6,
--          DESCRIPCION DESCR_CATALOGO_N6,
--          CODIGOCONCATENADO || ''****'' LDESC_CATALOGO_N6,
--          32 NIVEL_SIGLO_N6,
--          ID NATID_CATALOGO_N5
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N1
--                               FROM MSTR_MAE_CATALOGO_N1
--                              WHERE INSTR (LDESC_CATALOGO_N1, ''*'') = 0)
--   UNION ALL
--   -- Replica N3
--   SELECT ID NATID_CATALOGO_N6,
--          DESCRIPCION DESCR_CATALOGO_N6,
--          CODIGOCONCATENADO || ''***'' LDESC_CATALOGO_N6,
--          32 NIVEL_SIGLO_N6,
--          ID NATID_CATALOGO_N5
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N2
--                               FROM MSTR_MAE_CATALOGO_N2
--                              WHERE INSTR (LDESC_CATALOGO_N2, ''*'') = 0)
--   UNION ALL
--   -- Replica N4
--   SELECT ID NATID_CATALOGO_N6,
--          DESCRIPCION DESCR_CATALOGO_N6,
--          CODIGOCONCATENADO || ''**'' LDESC_CATALOGO_N6,
--          32 NIVEL_SIGLO_N6,
--          ID NATID_CATALOGO_N5
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N3
--                               FROM MSTR_MAE_CATALOGO_N3
--                              WHERE INSTR (LDESC_CATALOGO_N3, ''*'') = 0)
--   UNION ALL
--   -- Replica N5
--   SELECT ID NATID_CATALOGO_N6,
--          DESCRIPCION DESCR_CATALOGO_N6,
--          CODIGOCONCATENADO || ''*'' LDESC_CATALOGO_N6,
--          32 NIVEL_SIGLO_N6,
--          ID NATID_CATALOGO_N5
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N4
--                               FROM MSTR_MAE_CATALOGO_N4
--                              WHERE INSTR (LDESC_CATALOGO_N4, ''*'') = 0)';
--
--      EXECUTE IMMEDIATE 'ALTER TABLE MSTR_MAE_CATALOGO_N6 ADD (
--  CONSTRAINT MSTR_MAE_CATALOGO_N6_PK
--  PRIMARY KEY
--  (NATID_CATALOGO_N6)
--  USING INDEX
--    TABLESPACE USERS
--    NOLOGGING
--)';
--
--      EXECUTE IMMEDIATE 'ALTER TABLE MSTR_SIGLO.MSTR_MAE_CATALOGO_N6 ADD
--CONSTRAINT MSTR_MAE_CATALOGO_N6_R01
-- FOREIGN KEY (NATID_CATALOGO_N5)
-- REFERENCES MSTR_SIGLO.MSTR_MAE_CATALOGO_N5 (NATID_CATALOGO_N5)
-- ENABLE
-- VALIDATE';
--
--      BEGIN
--         SYS.DBMS_STATS.GATHER_TABLE_STATS (OwnName            => 'MSTR_SIGLO',
--                                            TabName            => 'MSTR_MAE_CATALOGO_N6',
--                                            Estimate_Percent   => 0,
--                                            Method_Opt         => 'FOR ALL COLUMNS SIZE 1',
--                                            Degree             => 4,
--                                            Cascade            => FALSE,
--                                            No_Invalidate      => FALSE);
--      END;
--   END P_N6;
--
--   PROCEDURE P_N7
--   IS
--   BEGIN
--      EXECUTE IMMEDIATE
--         'CREATE TABLE MSTR_MAE_CATALOGO_N7
--NOLOGGING
--NOMONITORING
--NOPARALLEL
--AS
--   SELECT ID NATID_CATALOGO_N7,
--          DESCRIPCION DESCR_CATALOGO_N7,
--          CODIGOCONCATENADO LDESC_CATALOGO_N7,
--          NIVEL NIVEL_SIGLO_N7,
--          VALORPADRE NATID_CATALOGO_N6
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N6
--                               FROM MSTR_MAE_CATALOGO_N6
--                              WHERE INSTR (LDESC_CATALOGO_N6, ''*'') = 0)
--   UNION ALL
--   SELECT -1 NATID_CATALOGO_N7,
--          ''n/a'' DESCR_CATALOGO_N7,
--          ''n/a'' LDESC_CATALOGO_N7,
--          5057 NIVEL_SIGLO_N7,
--          -1 NATID_CATALOGO_N6
--     FROM DUAL
--   UNION ALL
--   -- Replica N1
--   SELECT ID NATID_CATALOGO_N7,
--          DESCRIPCION DESCR_CATALOGO_N7,
--          CODIGOCONCATENADO || ''******'' LDESC_CATALOGO_N7,
--          5057 NIVEL_SIGLO_N7,
--          ID NATID_CATALOGO_N6
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE CLASIFICACION = 5 AND ACTIVO = ''T'' AND VALORPADRE IN (SELECT NATID_CATALOGO_N0 FROM MSTR_MAE_CATALOGO_N0)
--   UNION ALL
--   --Replica N2
--   SELECT ID NATID_CATALOGO_N7,
--          DESCRIPCION DESCR_CATALOGO_N7,
--          CODIGOCONCATENADO || ''*****'' LDESC_CATALOGO_N7,
--          5057 NIVEL_SIGLO_N7,
--          ID NATID_CATALOGO_N6
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N1
--                               FROM MSTR_MAE_CATALOGO_N1
--                              WHERE INSTR (LDESC_CATALOGO_N1, ''*'') = 0)
--   UNION ALL
--   -- Replica N3
--   SELECT ID NATID_CATALOGO_N7,
--          DESCRIPCION DESCR_CATALOGO_N7,
--          CODIGOCONCATENADO || ''****'' LDESC_CATALOGO_N7,
--          5057 NIVEL_SIGLO_N7,
--          ID NATID_CATALOGO_N6
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N2
--                               FROM MSTR_MAE_CATALOGO_N2
--                              WHERE INSTR (LDESC_CATALOGO_N2, ''*'') = 0)
--   UNION ALL
--   -- Replica N4
--   SELECT ID NATID_CATALOGO_N7,
--          DESCRIPCION DESCR_CATALOGO_N7,
--          CODIGOCONCATENADO || ''***'' LDESC_CATALOGO_N7,
--          5057 NIVEL_SIGLO_N7,
--          ID NATID_CATALOGO_N6
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N3
--                               FROM MSTR_MAE_CATALOGO_N3
--                              WHERE INSTR (LDESC_CATALOGO_N3, ''*'') = 0)
--   UNION ALL
--   -- Replica N5
--   SELECT ID NATID_CATALOGO_N7,
--          DESCRIPCION DESCR_CATALOGO_N7,
--          CODIGOCONCATENADO || ''**'' LDESC_CATALOGO_N7,
--          5057 NIVEL_SIGLO_N7,
--          ID NATID_CATALOGO_N6
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N4
--                               FROM MSTR_MAE_CATALOGO_N4
--                              WHERE INSTR (LDESC_CATALOGO_N4, ''*'') = 0)
--   UNION ALL
--   -- Replica N6
--   SELECT ID NATID_CATALOGO_N7,
--          DESCRIPCION DESCR_CATALOGO_N7,
--          CODIGOCONCATENADO || ''*'' LDESC_CATALOGO_N7,
--          5057 NIVEL_SIGLO_N7,
--          ID NATID_CATALOGO_N6
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N5
--                               FROM MSTR_MAE_CATALOGO_N5
--                              WHERE INSTR (LDESC_CATALOGO_N5, ''*'') = 0)';
--
--      EXECUTE IMMEDIATE 'ALTER TABLE MSTR_MAE_CATALOGO_N7 ADD (
--  CONSTRAINT MSTR_MAE_CATALOGO_N7_PK
--  PRIMARY KEY
--  (NATID_CATALOGO_N7)
--  USING INDEX
--    TABLESPACE USERS
--    NOLOGGING
--)';
--
--      EXECUTE IMMEDIATE 'ALTER TABLE MSTR_SIGLO.MSTR_MAE_CATALOGO_N7 ADD
--CONSTRAINT MSTR_MAE_CATALOGO_N7_R01
-- FOREIGN KEY (NATID_CATALOGO_N6)
-- REFERENCES MSTR_SIGLO.MSTR_MAE_CATALOGO_N6 (NATID_CATALOGO_N6)
-- ENABLE
-- VALIDATE';
--
--      BEGIN
--         SYS.DBMS_STATS.GATHER_TABLE_STATS (OwnName            => 'MSTR_SIGLO',
--                                            TabName            => 'MSTR_MAE_CATALOGO_N7',
--                                            Estimate_Percent   => 0,
--                                            Method_Opt         => 'FOR ALL COLUMNS SIZE 1',
--                                            Degree             => 4,
--                                            Cascade            => FALSE,
--                                            No_Invalidate      => FALSE);
--      END;
--   END P_N7;
--
--   PROCEDURE P_N8
--   IS
--   BEGIN
--      EXECUTE IMMEDIATE
--         'CREATE TABLE MSTR_MAE_CATALOGO_N8
--NOLOGGING
--NOMONITORING
--NOPARALLEL
--AS
--   SELECT ID NATID_CATALOGO_N8,
--          DESCRIPCION DESCR_CATALOGO_N8,
--          CODIGOCONCATENADO LDESC_CATALOGO_N8,
--          NIVEL NIVEL_SIGLO_N8,
--          VALORPADRE NATID_CATALOGO_N7
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N7
--                               FROM MSTR_MAE_CATALOGO_N7
--                              WHERE INSTR (LDESC_CATALOGO_N7, ''*'') = 0)
--   UNION ALL
--   SELECT -1 NATID_CATALOGO_N8,
--          ''n/a'' DESCR_CATALOGO_N8,
--          ''n/a'' LDESC_CATALOGO_N8,
--          5058 NIVEL_SIGLO_N8,
--          -1 NATID_CATALOGO_N7
--     FROM DUAL
--   UNION ALL
--   -- Replica N1
--   SELECT ID NATID_CATALOGO_N8,
--          DESCRIPCION DESCR_CATALOGO_N8,
--          CODIGOCONCATENADO || ''*******'' LDESC_CATALOGO_N8,
--          5058 NIVEL_SIGLO_N8,
--          ID NATID_CATALOGO_N7
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE CLASIFICACION = 5 AND ACTIVO = ''T'' AND VALORPADRE IN (SELECT NATID_CATALOGO_N0 FROM MSTR_MAE_CATALOGO_N0)
--   UNION ALL
--   --Replica N2
--   SELECT ID NATID_CATALOGO_N8,
--          DESCRIPCION DESCR_CATALOGO_N8,
--          CODIGOCONCATENADO || ''******'' LDESC_CATALOGO_N8,
--          5058 NIVEL_SIGLO_N8,
--          ID NATID_CATALOGO_N7
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N1
--                               FROM MSTR_MAE_CATALOGO_N1
--                              WHERE INSTR (LDESC_CATALOGO_N1, ''*'') = 0)
--   UNION ALL
--   -- Replica N3
--   SELECT ID NATID_CATALOGO_N8,
--          DESCRIPCION DESCR_CATALOGO_N8,
--          CODIGOCONCATENADO || ''*****'' LDESC_CATALOGO_N8,
--          5058 NIVEL_SIGLO_N8,
--          ID NATID_CATALOGO_N7
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N2
--                               FROM MSTR_MAE_CATALOGO_N2
--                              WHERE INSTR (LDESC_CATALOGO_N2, ''*'') = 0)
--   UNION ALL
--   -- Replica N4
--   SELECT ID NATID_CATALOGO_N8,
--          DESCRIPCION DESCR_CATALOGO_N8,
--          CODIGOCONCATENADO || ''****'' LDESC_CATALOGO_N8,
--          5058 NIVEL_SIGLO_N8,
--          ID NATID_CATALOGO_N7
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N3
--                               FROM MSTR_MAE_CATALOGO_N3
--                              WHERE INSTR (LDESC_CATALOGO_N3, ''*'') = 0)
--   UNION ALL
--   -- Replica N5
--   SELECT ID NATID_CATALOGO_N8,
--          DESCRIPCION DESCR_CATALOGO_N8,
--          CODIGOCONCATENADO || ''***'' LDESC_CATALOGO_N8,
--          5058 NIVEL_SIGLO_N8,
--          ID NATID_CATALOGO_N7
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N4
--                               FROM MSTR_MAE_CATALOGO_N4
--                              WHERE INSTR (LDESC_CATALOGO_N4, ''*'') = 0)
--   UNION ALL
--   -- Replica N6
--   SELECT ID NATID_CATALOGO_N8,
--          DESCRIPCION DESCR_CATALOGO_N8,
--          CODIGOCONCATENADO || ''**'' LDESC_CATALOGO_N8,
--          5058 NIVEL_SIGLO_N8,
--          ID NATID_CATALOGO_N7
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N5
--                               FROM MSTR_MAE_CATALOGO_N5
--                              WHERE INSTR (LDESC_CATALOGO_N5, ''*'') = 0)
--   UNION ALL
--   -- Replica N7
--   SELECT ID NATID_CATALOGO_N8,
--          DESCRIPCION DESCR_CATALOGO_N8,
--          CODIGOCONCATENADO || ''*'' LDESC_CATALOGO_N8,
--          5058 NIVEL_SIGLO_N8,
--          ID NATID_CATALOGO_N7
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N6
--                               FROM MSTR_MAE_CATALOGO_N6
--                              WHERE INSTR (LDESC_CATALOGO_N6, ''*'') = 0)';
--
--      EXECUTE IMMEDIATE 'ALTER TABLE MSTR_MAE_CATALOGO_N8 ADD (
--  CONSTRAINT MSTR_MAE_CATALOGO_N8_PK
--  PRIMARY KEY
--  (NATID_CATALOGO_N8)
--  USING INDEX
--    TABLESPACE USERS
--    NOLOGGING
--)';
--
--      EXECUTE IMMEDIATE 'ALTER TABLE MSTR_SIGLO.MSTR_MAE_CATALOGO_N8 ADD
--CONSTRAINT MSTR_MAE_CATALOGO_N8_R01
-- FOREIGN KEY (NATID_CATALOGO_N7)
-- REFERENCES MSTR_SIGLO.MSTR_MAE_CATALOGO_N7 (NATID_CATALOGO_N7)
-- ENABLE
-- VALIDATE';
--
--      BEGIN
--         SYS.DBMS_STATS.GATHER_TABLE_STATS (OwnName            => 'MSTR_SIGLO',
--                                            TabName            => 'MSTR_MAE_CATALOGO_N8',
--                                            Estimate_Percent   => 0,
--                                            Method_Opt         => 'FOR ALL COLUMNS SIZE 1',
--                                            Degree             => 4,
--                                            Cascade            => FALSE,
--                                            No_Invalidate      => FALSE);
--      END;
--   END P_N8;
--
--   PROCEDURE P_N9
--   IS
--   BEGIN
--      EXECUTE IMMEDIATE
--         'CREATE TABLE MSTR_MAE_CATALOGO_N9
--NOLOGGING
--NOMONITORING
--NOPARALLEL
--AS
--   SELECT ID NATID_CATALOGO_N9,
--          DESCRIPCION DESCR_CATALOGO_N9,
--          CODIGOCONCATENADO LDESC_CATALOGO_N9,
--          NIVEL NIVEL_SIGLO_N9,
--          VALORPADRE NATID_CATALOGO_N8
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N8
--                               FROM MSTR_MAE_CATALOGO_N8
--                              WHERE INSTR (LDESC_CATALOGO_N8, ''*'') = 0)
--    UNION ALL
--   SELECT -1 NATID_CATALOGO_N9,
--          ''n/a'' DESCR_CATALOGO_N9,
--          ''n/a'' LDESC_CATALOGO_N9,
--          5059 NIVEL_SIGLO_N9,
--          -1 NATID_CATALOGO_N8
--     FROM DUAL
--   UNION ALL
--   -- Replica N1
--   SELECT ID NATID_CATALOGO_N9,
--          DESCRIPCION DESCR_CATALOGO_N9,
--          CODIGOCONCATENADO || ''********'' LDESC_CATALOGO_N9,
--          5059 NIVEL_SIGLO_N9,
--          ID NATID_CATALOGO_N8
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE CLASIFICACION = 5 AND ACTIVO = ''T'' AND VALORPADRE IN (SELECT NATID_CATALOGO_N0 FROM MSTR_MAE_CATALOGO_N0)
--   UNION ALL
--   --Replica N2
--   SELECT ID NATID_CATALOGO_N9,
--          DESCRIPCION DESCR_CATALOGO_N9,
--          CODIGOCONCATENADO || ''*******'' LDESC_CATALOGO_N9,
--          5059 NIVEL_SIGLO_N9,
--          ID NATID_CATALOGO_N8
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N1
--                               FROM MSTR_MAE_CATALOGO_N1
--                              WHERE INSTR (LDESC_CATALOGO_N1, ''*'') = 0)
--   UNION ALL
--   -- Replica N3
--   SELECT ID NATID_CATALOGO_N9,
--          DESCRIPCION DESCR_CATALOGO_N9,
--          CODIGOCONCATENADO || ''******'' LDESC_CATALOGO_N9,
--          5059 NIVEL_SIGLO_N9,
--          ID NATID_CATALOGO_N8
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N2
--                               FROM MSTR_MAE_CATALOGO_N2
--                              WHERE INSTR (LDESC_CATALOGO_N2, ''*'') = 0)
--   UNION ALL
--   -- Replica N4
--   SELECT ID NATID_CATALOGO_N9,
--          DESCRIPCION DESCR_CATALOGO_N9,
--          CODIGOCONCATENADO || ''*****'' LDESC_CATALOGO_N9,
--          5059 NIVEL_SIGLO_N9,
--          ID NATID_CATALOGO_N8
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N3
--                               FROM MSTR_MAE_CATALOGO_N3
--                              WHERE INSTR (LDESC_CATALOGO_N3, ''*'') = 0)
--   UNION ALL
--   -- Replica N5
--   SELECT ID NATID_CATALOGO_N9,
--          DESCRIPCION DESCR_CATALOGO_N9,
--          CODIGOCONCATENADO || ''****'' LDESC_CATALOGO_N9,
--          5059 NIVEL_SIGLO_N9,
--          ID NATID_CATALOGO_N8
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N4
--                               FROM MSTR_MAE_CATALOGO_N4
--                              WHERE INSTR (LDESC_CATALOGO_N4, ''*'') = 0)
--   UNION ALL
--   -- Replica N6
--   SELECT ID NATID_CATALOGO_N9,
--          DESCRIPCION DESCR_CATALOGO_N9,
--          CODIGOCONCATENADO || ''***'' LDESC_CATALOGO_N9,
--          5059 NIVEL_SIGLO_N9,
--          ID NATID_CATALOGO_N8
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N5
--                               FROM MSTR_MAE_CATALOGO_N5
--                              WHERE INSTR (LDESC_CATALOGO_N5, ''*'') = 0)
--   UNION ALL
--   -- Replica N7
--   SELECT ID NATID_CATALOGO_N9,
--          DESCRIPCION DESCR_CATALOGO_N9,
--          CODIGOCONCATENADO || ''**'' LDESC_CATALOGO_N9,
--          5059 NIVEL_SIGLO_N9,
--          ID NATID_CATALOGO_N8
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N6
--                               FROM MSTR_MAE_CATALOGO_N6
--                              WHERE INSTR (LDESC_CATALOGO_N6, ''*'') = 0)
--   UNION ALL
--   -- Replica N8
--   SELECT ID NATID_CATALOGO_N9,
--          DESCRIPCION DESCR_CATALOGO_N9,
--          CODIGOCONCATENADO || ''*'' LDESC_CATALOGO_N9,
--          5059 NIVEL_SIGLO_N9,
--          ID NATID_CATALOGO_N8
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N7
--                               FROM MSTR_MAE_CATALOGO_N7
--                              WHERE INSTR (LDESC_CATALOGO_N7, ''*'') = 0)';
--
--      EXECUTE IMMEDIATE 'ALTER TABLE MSTR_MAE_CATALOGO_N9 ADD (
--  CONSTRAINT MSTR_MAE_CATALOGO_N9_PK
--  PRIMARY KEY
--  (NATID_CATALOGO_N9)
--  USING INDEX
--    TABLESPACE USERS
--    NOLOGGING
--)';
--
--      EXECUTE IMMEDIATE 'ALTER TABLE MSTR_SIGLO.MSTR_MAE_CATALOGO_N9 ADD
--CONSTRAINT MSTR_MAE_CATALOGO_N9_R01
-- FOREIGN KEY (NATID_CATALOGO_N8)
-- REFERENCES MSTR_SIGLO.MSTR_MAE_CATALOGO_N8 (NATID_CATALOGO_N8)
-- ENABLE
-- VALIDATE';
--
--      BEGIN
--         SYS.DBMS_STATS.GATHER_TABLE_STATS (OwnName            => 'MSTR_SIGLO',
--                                            TabName            => 'MSTR_MAE_CATALOGO_N9',
--                                            Estimate_Percent   => 0,
--                                            Method_Opt         => 'FOR ALL COLUMNS SIZE 1',
--                                            Degree             => 4,
--                                            Cascade            => FALSE,
--                                            No_Invalidate      => FALSE);
--      END;
--   END P_N9;
--
--   PROCEDURE P_NA
--   IS
--   BEGIN
--      EXECUTE IMMEDIATE
--         'CREATE TABLE MSTR_MAE_CATALOGO_NA
--NOLOGGING
--NOMONITORING
--NOPARALLEL
--AS
--   SELECT ID NATID_CATALOGO_NA,
--          DESCRIPCION DESCR_CATALOGO_NA,
--          CODIGOCONCATENADO LDESC_CATALOGO_NA,
--          NIVEL NIVEL_SIGLO_NA,
--          VALORPADRE NATID_CATALOGO_N9
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          --AND VALORPADRE IN (SELECT NATID_CATALOGO_N9 FROM MSTR_MAE_CATALOGO_N9)
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N9
--                               FROM MSTR_MAE_CATALOGO_N9
--                              WHERE INSTR (LDESC_CATALOGO_N9, ''*'') = 0)
--   UNION ALL
--   SELECT -1 NATID_CATALOGO_NA,
--          ''n/a'' DESCR_CATALOGO_NA,
--          ''n/a'' LDESC_CATALOGO_NA,
--          5060 NIVEL_SIGLO_NA,
--          -1 NATID_CATALOGO_NA
--     FROM DUAL
--   UNION ALL
--   -- Replica N1
--   SELECT ID NATID_CATALOGO_NA,
--          DESCRIPCION DESCR_CATALOGO_NA,
--          CODIGOCONCATENADO || ''*********'' LDESC_CATALOGO_NA,
--          5060 NIVEL_SIGLO_NA,
--          ID NATID_CATALOGO_N9
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE CLASIFICACION = 5 AND ACTIVO = ''T'' AND VALORPADRE IN (SELECT NATID_CATALOGO_N0 FROM MSTR_MAE_CATALOGO_N0)
--   UNION ALL
--   --Replica N2
--   SELECT ID NATID_CATALOGO_NA,
--          DESCRIPCION DESCR_CATALOGO_NA,
--          CODIGOCONCATENADO || ''********'' LDESC_CATALOGO_NA,
--          5060 NIVEL_SIGLO_NA,
--          ID NATID_CATALOGO_N9
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N1
--                               FROM MSTR_MAE_CATALOGO_N1
--                              WHERE INSTR (LDESC_CATALOGO_N1, ''*'') = 0)
--   UNION ALL
--   -- Replica N3
--   SELECT ID NATID_CATALOGO_NA,
--          DESCRIPCION DESCR_CATALOGO_NA,
--          CODIGOCONCATENADO || ''*******'' LDESC_CATALOGO_NA,
--          5060 NIVEL_SIGLO_NA,
--          ID NATID_CATALOGO_N9
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N2
--                               FROM MSTR_MAE_CATALOGO_N2
--                              WHERE INSTR (LDESC_CATALOGO_N2, ''*'') = 0)
--   UNION ALL
--   -- Replica N4
--   SELECT ID NATID_CATALOGO_NA,
--          DESCRIPCION DESCR_CATALOGO_NA,
--          CODIGOCONCATENADO || ''******'' LDESC_CATALOGO_NA,
--          5060 NIVEL_SIGLO_NA,
--          ID NATID_CATALOGO_N9
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N3
--                               FROM MSTR_MAE_CATALOGO_N3
--                              WHERE INSTR (LDESC_CATALOGO_N3, ''*'') = 0)
--   UNION ALL
--   -- Replica N5
--   SELECT ID NATID_CATALOGO_NA,
--          DESCRIPCION DESCR_CATALOGO_NA,
--          CODIGOCONCATENADO || ''*****'' LDESC_CATALOGO_NA,
--          5060 NIVEL_SIGLO_NA,
--          ID NATID_CATALOGO_N9
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N4
--                               FROM MSTR_MAE_CATALOGO_N4
--                              WHERE INSTR (LDESC_CATALOGO_N4, ''*'') = 0)
--   UNION ALL
--   -- Replica N6
--   SELECT ID NATID_CATALOGO_NA,
--          DESCRIPCION DESCR_CATALOGO_NA,
--          CODIGOCONCATENADO || ''****'' LDESC_CATALOGO_NA,
--          5060 NIVEL_SIGLO_NA,
--          ID NATID_CATALOGO_N9
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N5
--                               FROM MSTR_MAE_CATALOGO_N5
--                              WHERE INSTR (LDESC_CATALOGO_N5, ''*'') = 0)
--   UNION ALL
--   -- Replica N7
--   SELECT ID NATID_CATALOGO_NA,
--          DESCRIPCION DESCR_CATALOGO_NA,
--          CODIGOCONCATENADO || ''***'' LDESC_CATALOGO_NA,
--          5060 NIVEL_SIGLO_NA,
--          ID NATID_CATALOGO_N9
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N6
--                               FROM MSTR_MAE_CATALOGO_N6
--                              WHERE INSTR (LDESC_CATALOGO_N6, ''*'') = 0)
--   UNION ALL
--   -- Replica N8
--   SELECT ID NATID_CATALOGO_NA,
--          DESCRIPCION DESCR_CATALOGO_NA,
--          CODIGOCONCATENADO || ''**'' LDESC_CATALOGO_NA,
--          5060 NIVEL_SIGLO_NA,
--          ID NATID_CATALOGO_N9
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N7
--                               FROM MSTR_MAE_CATALOGO_N7
--                              WHERE INSTR (LDESC_CATALOGO_N7, ''*'') = 0)
--   UNION ALL
--   -- Replica N9
--   SELECT ID NATID_CATALOGO_NA,
--          DESCRIPCION DESCR_CATALOGO_NA,
--          CODIGOCONCATENADO || ''*'' LDESC_CATALOGO_NA,
--          5060 NIVEL_SIGLO_NA,
--          ID NATID_CATALOGO_N9
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N8
--                               FROM MSTR_MAE_CATALOGO_N8
--                              WHERE INSTR (LDESC_CATALOGO_N8, ''*'') = 0)';
--
--      EXECUTE IMMEDIATE 'ALTER TABLE MSTR_MAE_CATALOGO_NA ADD (
--  CONSTRAINT MSTR_MAE_CATALOGO_NA_PK
--  PRIMARY KEY
--  (NATID_CATALOGO_NA)
--  USING INDEX
--    TABLESPACE USERS
--    NOLOGGING
--)';
--
--      EXECUTE IMMEDIATE 'ALTER TABLE MSTR_SIGLO.MSTR_MAE_CATALOGO_NA ADD
--CONSTRAINT MSTR_MAE_CATALOGO_NA_R01
-- FOREIGN KEY (NATID_CATALOGO_N9)
-- REFERENCES MSTR_SIGLO.MSTR_MAE_CATALOGO_N9 (NATID_CATALOGO_N9)
-- ENABLE
-- VALIDATE';
--
--      BEGIN
--         SYS.DBMS_STATS.GATHER_TABLE_STATS (OwnName            => 'MSTR_SIGLO',
--                                            TabName            => 'MSTR_MAE_CATALOGO_NA',
--                                            Estimate_Percent   => 0,
--                                            Method_Opt         => 'FOR ALL COLUMNS SIZE 1',
--                                            Degree             => 4,
--                                            Cascade            => FALSE,
--                                            No_Invalidate      => FALSE);
--      END;
--   END P_NA;
--
--   PROCEDURE P_NB
--   IS
--   BEGIN
--      EXECUTE IMMEDIATE
--         'CREATE TABLE MSTR_MAE_CATALOGO_NB
--NOLOGGING
--NOMONITORING
--NOPARALLEL
--AS
--   SELECT ID NATID_CATALOGO_NB,
--          DESCRIPCION DESCR_CATALOGO_NB,
--          CODIGOCONCATENADO LDESC_CATALOGO_NB,
--          NIVEL NIVEL_SIGLO_NB,
--          VALORPADRE NATID_CATALOGO_NA
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_NA
--                               FROM MSTR_MAE_CATALOGO_NA
--                              WHERE INSTR (LDESC_CATALOGO_NA, ''*'') = 0)
--   UNION ALL
--   SELECT -1 NATID_CATALOGO_NB,
--          ''n/a'' DESCR_CATALOGO_NB,
--          ''n/a'' LDESC_CATALOGO_NB,
--          10061 NIVEL_SIGLO_NB,
--          -1 NATID_CATALOGO_NA
--     FROM DUAL
--   UNION ALL
--   -- Replica N1
--   SELECT ID NATID_CATALOGO_NB,
--          DESCRIPCION DESCR_CATALOGO_NB,
--          CODIGOCONCATENADO || ''**********'' LDESC_CATALOGO_NB,
--          10061 NIVEL_SIGLO_NB,
--          ID NATID_CATALOGO_NA
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE CLASIFICACION = 5 AND ACTIVO = ''T'' AND VALORPADRE IN (SELECT NATID_CATALOGO_N0 FROM MSTR_MAE_CATALOGO_N0)
--   UNION ALL
--   --Replica N2
--   SELECT ID NATID_CATALOGO_NB,
--          DESCRIPCION DESCR_CATALOGO_NB,
--          CODIGOCONCATENADO || ''*********'' LDESC_CATALOGO_NB,
--          10061 NIVEL_SIGLO_NB,
--          ID NATID_CATALOGO_NA
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N1
--                               FROM MSTR_MAE_CATALOGO_N1
--                              WHERE INSTR (LDESC_CATALOGO_N1, ''*'') = 0)
--   UNION ALL
--   -- Replica N3
--   SELECT ID NATID_CATALOGO_NB,
--          DESCRIPCION DESCR_CATALOGO_NB,
--          CODIGOCONCATENADO || ''********'' LDESC_CATALOGO_NB,
--          10061 NIVEL_SIGLO_NB,
--          ID NATID_CATALOGO_NA
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N2
--                               FROM MSTR_MAE_CATALOGO_N2
--                              WHERE INSTR (LDESC_CATALOGO_N2, ''*'') = 0)
--   UNION ALL
--   -- Replica N4
--   SELECT ID NATID_CATALOGO_NB,
--          DESCRIPCION DESCR_CATALOGO_NB,
--          CODIGOCONCATENADO || ''*******'' LDESC_CATALOGO_NB,
--          10061 NIVEL_SIGLO_NB,
--          ID NATID_CATALOGO_NA
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N3
--                               FROM MSTR_MAE_CATALOGO_N3
--                              WHERE INSTR (LDESC_CATALOGO_N3, ''*'') = 0)
--   UNION ALL
--   -- Replica N5
--   SELECT ID NATID_CATALOGO_NB,
--          DESCRIPCION DESCR_CATALOGO_NB,
--          CODIGOCONCATENADO || ''******'' LDESC_CATALOGO_NB,
--          10061 NIVEL_SIGLO_NB,
--          ID NATID_CATALOGO_NA
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N4
--                               FROM MSTR_MAE_CATALOGO_N4
--                              WHERE INSTR (LDESC_CATALOGO_N4, ''*'') = 0)
--   UNION ALL
--   -- Replica N6
--   SELECT ID NATID_CATALOGO_NB,
--          DESCRIPCION DESCR_CATALOGO_NB,
--          CODIGOCONCATENADO || ''*****'' LDESC_CATALOGO_NB,
--          10061 NIVEL_SIGLO_NB,
--          ID NATID_CATALOGO_NA
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N5
--                               FROM MSTR_MAE_CATALOGO_N5
--                              WHERE INSTR (LDESC_CATALOGO_N5, ''*'') = 0)
--   UNION ALL
--   -- Replica N7
--   SELECT ID NATID_CATALOGO_NB,
--          DESCRIPCION DESCR_CATALOGO_NB,
--          CODIGOCONCATENADO || ''****'' LDESC_CATALOGO_NB,
--          10061 NIVEL_SIGLO_NB,
--          ID NATID_CATALOGO_NA
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N6
--                               FROM MSTR_MAE_CATALOGO_N6
--                              WHERE INSTR (LDESC_CATALOGO_N6, ''*'') = 0)
--   UNION ALL
--   -- Replica N8
--   SELECT ID NATID_CATALOGO_NB,
--          DESCRIPCION DESCR_CATALOGO_NB,
--          CODIGOCONCATENADO || ''***'' LDESC_CATALOGO_NB,
--          10061 NIVEL_SIGLO_NB,
--          ID NATID_CATALOGO_NA
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N7
--                               FROM MSTR_MAE_CATALOGO_N7
--                              WHERE INSTR (LDESC_CATALOGO_N7, ''*'') = 0)
--   UNION ALL
--   -- Replica N9
--   SELECT ID NATID_CATALOGO_NB,
--          DESCRIPCION DESCR_CATALOGO_NB,
--          CODIGOCONCATENADO || ''**'' LDESC_CATALOGO_NB,
--          10061 NIVEL_SIGLO_NB,
--          ID NATID_CATALOGO_NA
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N8
--                               FROM MSTR_MAE_CATALOGO_N8
--                              WHERE INSTR (LDESC_CATALOGO_N8, ''*'') = 0)
--   UNION ALL
--   -- Replica NA
--   SELECT ID NATID_CATALOGO_NB,
--          DESCRIPCION DESCR_CATALOGO_NB,
--          CODIGOCONCATENADO || ''*'' LDESC_CATALOGO_NB,
--          10061 NIVEL_SIGLO_NB,
--          ID NATID_CATALOGO_NA
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N9
--                               FROM MSTR_MAE_CATALOGO_N9
--                              WHERE INSTR (LDESC_CATALOGO_N9, ''*'') = 0)';
--
--      EXECUTE IMMEDIATE 'ALTER TABLE MSTR_MAE_CATALOGO_NB ADD (
--  CONSTRAINT MSTR_MAE_CATALOGO_NB_PK
--  PRIMARY KEY
--  (NATID_CATALOGO_NB)
--  USING INDEX
--    TABLESPACE USERS
--    NOLOGGING
--)';
--
--      EXECUTE IMMEDIATE 'ALTER TABLE MSTR_SIGLO.MSTR_MAE_CATALOGO_NB ADD
--CONSTRAINT MSTR_MAE_CATALOGO_NB_R01
-- FOREIGN KEY (NATID_CATALOGO_NA)
-- REFERENCES MSTR_SIGLO.MSTR_MAE_CATALOGO_NA (NATID_CATALOGO_NA)
-- ENABLE
-- VALIDATE';
--   END P_NB;
--
--   PROCEDURE P_NC
--   IS
--   BEGIN
--      EXECUTE IMMEDIATE
--         'CREATE TABLE MSTR_MAE_CATALOGO_NC
--NOLOGGING
--NOMONITORING
--NOPARALLEL
--AS
--   SELECT ID NATID_CATALOGO_NC,
--          DESCRIPCION DESCR_CATALOGO_NC,
--          CODIGOCONCATENADO LDESC_CATALOGO_NC,
--          NIVEL NIVEL_SIGLO_NC,
--          VALORPADRE NATID_CATALOGO_NB
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_NB
--                               FROM MSTR_MAE_CATALOGO_NB
--                              WHERE INSTR (LDESC_CATALOGO_NB, ''*'') = 0)
--   UNION ALL
--   SELECT -1 NATID_CATALOGO_NC,
--          ''n/a'' DESCR_CATALOGO_NC,
--          ''n/a'' LDESC_CATALOGO_NC,
--          15262 NIVEL_SIGLO_NC,
--          -1 NATID_CATALOGO_NB
--     FROM DUAL
--   UNION ALL
--   -- Replica N1
--   SELECT ID NATID_CATALOGO_NC,
--          DESCRIPCION DESCR_CATALOGO_NC,
--          CODIGOCONCATENADO || ''***********'' LDESC_CATALOGO_NC,
--          10061 NIVEL_SIGLO_NC,
--          ID NATID_CATALOGO_NB
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE CLASIFICACION = 5 AND ACTIVO = ''T'' AND VALORPADRE IN (SELECT NATID_CATALOGO_N0 FROM MSTR_MAE_CATALOGO_N0)
--   UNION ALL
--   --Replica N2
--   SELECT ID NATID_CATALOGO_NC,
--          DESCRIPCION DESCR_CATALOGO_NC,
--          CODIGOCONCATENADO || ''**********'' LDESC_CATALOGO_NC,
--          10061 NIVEL_SIGLO_NC,
--          ID NATID_CATALOGO_NB
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N1
--                               FROM MSTR_MAE_CATALOGO_N1
--                              WHERE INSTR (LDESC_CATALOGO_N1, ''*'') = 0)
--   UNION ALL
--   -- Replica N3
--   SELECT ID NATID_CATALOGO_NC,
--          DESCRIPCION DESCR_CATALOGO_NC,
--          CODIGOCONCATENADO || ''*********'' LDESC_CATALOGO_NC,
--          10061 NIVEL_SIGLO_NC,
--          ID NATID_CATALOGO_NB
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N2
--                               FROM MSTR_MAE_CATALOGO_N2
--                              WHERE INSTR (LDESC_CATALOGO_N2, ''*'') = 0)
--   UNION ALL
--   -- Replica N4
--   SELECT ID NATID_CATALOGO_NC,
--          DESCRIPCION DESCR_CATALOGO_NC,
--          CODIGOCONCATENADO || ''********'' LDESC_CATALOGO_NC,
--          10061 NIVEL_SIGLO_NC,
--          ID NATID_CATALOGO_NB
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N3
--                               FROM MSTR_MAE_CATALOGO_N3
--                              WHERE INSTR (LDESC_CATALOGO_N3, ''*'') = 0)
--   UNION ALL
--   -- Replica N5
--   SELECT ID NATID_CATALOGO_NC,
--          DESCRIPCION DESCR_CATALOGO_NC,
--          CODIGOCONCATENADO || ''*******'' LDESC_CATALOGO_NC,
--          10061 NIVEL_SIGLO_NC,
--          ID NATID_CATALOGO_NB
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N4
--                               FROM MSTR_MAE_CATALOGO_N4
--                              WHERE INSTR (LDESC_CATALOGO_N4, ''*'') = 0)
--   UNION ALL
--   -- Replica N6
--   SELECT ID NATID_CATALOGO_NC,
--          DESCRIPCION DESCR_CATALOGO_NC,
--          CODIGOCONCATENADO || ''******'' LDESC_CATALOGO_NC,
--          10061 NIVEL_SIGLO_NC,
--          ID NATID_CATALOGO_NB
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N5
--                               FROM MSTR_MAE_CATALOGO_N5
--                              WHERE INSTR (LDESC_CATALOGO_N5, ''*'') = 0)
--   UNION ALL
--   -- Replica N7
--   SELECT ID NATID_CATALOGO_NC,
--          DESCRIPCION DESCR_CATALOGO_NC,
--          CODIGOCONCATENADO || ''*****'' LDESC_CATALOGO_NC,
--          10061 NIVEL_SIGLO_NC,
--          ID NATID_CATALOGO_NB
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N6
--                               FROM MSTR_MAE_CATALOGO_N6
--                              WHERE INSTR (LDESC_CATALOGO_N6, ''*'') = 0)
--   UNION ALL
--   -- Replica N8
--   SELECT ID NATID_CATALOGO_NC,
--          DESCRIPCION DESCR_CATALOGO_NC,
--          CODIGOCONCATENADO || ''****'' LDESC_CATALOGO_NC,
--          10061 NIVEL_SIGLO_NC,
--          ID NATID_CATALOGO_NB
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N7
--                               FROM MSTR_MAE_CATALOGO_N7
--                              WHERE INSTR (LDESC_CATALOGO_N7, ''*'') = 0)
--   UNION ALL
--   -- Replica N9
--   SELECT ID NATID_CATALOGO_NC,
--          DESCRIPCION DESCR_CATALOGO_NC,
--          CODIGOCONCATENADO || ''***'' LDESC_CATALOGO_NC,
--          10061 NIVEL_SIGLO_NC,
--          ID NATID_CATALOGO_NB
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N8
--                               FROM MSTR_MAE_CATALOGO_N8
--                              WHERE INSTR (LDESC_CATALOGO_N8, ''*'') = 0)
--   UNION ALL
--   -- Replica NA
--   SELECT ID NATID_CATALOGO_NC,
--          DESCRIPCION DESCR_CATALOGO_NC,
--          CODIGOCONCATENADO || ''**'' LDESC_CATALOGO_NC,
--          10061 NIVEL_SIGLO_NC,
--          ID NATID_CATALOGO_NB
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_N9
--                               FROM MSTR_MAE_CATALOGO_N9
--                              WHERE INSTR (LDESC_CATALOGO_N9, ''*'') = 0)
--   UNION ALL
--   -- Replica NB
--     SELECT ID NATID_CATALOGO_NC,
--          DESCRIPCION DESCR_CATALOGO_NC,
--          CODIGOCONCATENADO || ''*'' LDESC_CATALOGO_NC,
--          NIVEL NIVEL_SIGLO_NC,
--          VALORPADRE NATID_CATALOGO_NB
--     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--    WHERE     CLASIFICACION = 5
--          AND ACTIVO = ''T''
--          AND VALORPADRE IN (SELECT NATID_CATALOGO_NA
--                               FROM MSTR_MAE_CATALOGO_NA
--                              WHERE INSTR (LDESC_CATALOGO_NA, ''*'') = 0)';
--
--      EXECUTE IMMEDIATE 'ALTER TABLE MSTR_MAE_CATALOGO_NC ADD (
--  CONSTRAINT MSTR_MAE_CATALOGO_NC_PK
--  PRIMARY KEY
--  (NATID_CATALOGO_NC)
--  USING INDEX
--    TABLESPACE USERS
--    NOLOGGING
--)';
--
--      EXECUTE IMMEDIATE 'ALTER TABLE MSTR_SIGLO.MSTR_MAE_CATALOGO_NC ADD
--CONSTRAINT MSTR_MAE_CATALOGO_NC_R01
-- FOREIGN KEY (NATID_CATALOGO_NB)
-- REFERENCES MSTR_SIGLO.MSTR_MAE_CATALOGO_NB (NATID_CATALOGO_NB)
-- ENABLE
-- VALIDATE';
--   END P_NC;
--
--   PROCEDURE P_NZ
--   IS
--   BEGIN
--      EXECUTE IMMEDIATE 'CREATE TABLE MSTR_MAE_ARTICULOS
--NOLOGGING
--NOMONITORING
--NOPARALLEL
--AS
--   SELECT CAT_ARTICULO.ID NATID_ARTICULO,
--          CAT_ARTICULO.DESCRIPCION DESCR_ARTICULO,
--          CAT_ARTICULO.CODCLASIFIC LDESC_ARTICULO,
--          --CODIGO CODIGO_ARTICULO,
--          --NEMOTECNICO NEMOTECNICO_ARTICULO,
--          CAT_ARTICULO.ORGANOGESTOR NATID_ORGANOGESTOR,
--          CAT_ARTICULO.NIVELVALORUNIVERSAL NATID_CATALOGO_NC
--     FROM    REP_PRO_SIGLO.CAT_ARTICULO@SYG
--          JOIN
--             REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
--          ON (CAT_NIVELVALOR.ID = CAT_ARTICULO.NIVELVALORUNIVERSAL)
--    WHERE ACTIVO = ''T''';
--
--      EXECUTE IMMEDIATE 'ALTER TABLE MSTR_MAE_ARTICULOS ADD (
--  CONSTRAINT MSTR_MAE_ARTICULOS_PK
--  PRIMARY KEY
--  (NATID_ARTICULO)
--  USING INDEX
--    TABLESPACE USERS
--    NOLOGGING
--)';
--
--      EXECUTE IMMEDIATE 'CREATE INDEX MSTR_SIGLO.MSTR_MAE_ARTICULOS_IX01
--   ON MSTR_SIGLO.MSTR_MAE_ARTICULOS (NATID_CATALOGO_NC)
--   TABLESPACE USERS
--   NOLOGGING
--   NOPARALLEL';
--
--      EXECUTE IMMEDIATE 'CREATE INDEX MSTR_SIGLO.MSTR_MAE_ARTICULOS_IX02
--   ON MSTR_SIGLO.MSTR_MAE_ARTICULOS (NATID_ORGANOGESTOR)
--   TABLESPACE USERS
--   NOLOGGING
--   NOPARALLEL';
--
--      EXECUTE IMMEDIATE 'ALTER TABLE MSTR_SIGLO.MSTR_MAE_ARTICULOS ADD
--CONSTRAINT MSTR_MAE_ARTICULOS_R01
-- FOREIGN KEY (NATID_CATALOGO_NC)
-- REFERENCES MSTR_SIGLO.MSTR_MAE_CATALOGO_NC (NATID_CATALOGO_NC)
-- ENABLE
-- VALIDATE';
--
--      BEGIN
--         SYS.DBMS_STATS.GATHER_TABLE_STATS (OwnName            => 'MSTR_SIGLO',
--                                            TabName            => 'MSTR_MAE_ARTICULOS',
--                                            Estimate_Percent   => 0,
--                                            Method_Opt         => 'FOR ALL COLUMNS SIZE 1',
--                                            Degree             => 4,
--                                            Cascade            => FALSE,
--                                            No_Invalidate      => FALSE);
--      END;
--   END P_NZ;
END;
/

