CREATE OR REPLACE PACKAGE BODY MSTR_SIGLO.ETL_LOAD_GA01B
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
         DBMS_SNAPSHOT.REFRESH (LIST                   => 'MSTR_SIGLO.MSTR_DET_GA01B',
                                PUSH_DEFERRED_RPC      => TRUE,
                                REFRESH_AFTER_ERRORS   => FALSE,
                                PURGE_OPTION           => 1,
                                PARALLELISM            => 0,
                                ATOMIC_REFRESH         => TRUE,
                                NESTED                 => FALSE);
      END;

      COMMIT;


      BEGIN
         SYS.DBMS_STATS.GATHER_TABLE_STATS (OwnName            => 'MSTR_SIGLO',
                                            TabName            => 'MSTR_DET_GA01B',
                                            Estimate_Percent   => 0,
                                            Method_Opt         => 'FOR ALL COLUMNS SIZE 1',
                                            Degree             => 4,
                                            Cascade            => FALSE,
                                            No_Invalidate      => FALSE);
      END;

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
   EXCEPTION
      WHEN OTHERS
      THEN
--         BEGIN
--            MSTR.PANDAS_093_TWIT.POST_STATUS (
--                  'Camas+'
--               || TO_CHAR (SYSDATE, 'hh24"h"mi')
--               || '+'
--               || v_area_hospitalaria
--               || '+'
--               || SUBSTR (REPLACE (REPLACE (REPLACE (SQLERRM, ' ', '+'), ',', ''), CHR (10), '+'), 1, 90)
--               || '...#ProyectoPandas',
--               'PANDAS_ERROR');
--         END;

         RAISE;
   END P_001;
END;
/

