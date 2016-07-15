/* Formatted on 5/15/2014 12:06:54 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FUNCTION MSTR_HOSPITALIZACION.func_get_tab_tf_replicas -- (p_rows IN NUMBER)
   RETURN t_tf_tab_replicas
AS
   l_tab                 t_tf_tab_replicas := t_tf_tab_replicas ();
   l_owner               VARCHAR2 (20);
   l_last_refresh_min    DATE;
   l_last_refresh_max    DATE;
   l_last_analyzed_min   DATE;
   l_last_analyzed_max   DATE;
BEGIN
   FOR c1
      IN (  SELECT NATID_AREA_HOSPITALARIA,
                   DESCR_AREA_HOSPITALARIA,
                   DB_LINK_REPLICA
              FROM    MSTR_UTL_LOCAL_CODIGOS
                   JOIN
                      MSTR_MAE_AREAS_HOSPITALARIAS
                   USING (NATID_AREA_HOSPITALARIA)
             WHERE ENABLED = 1
          ORDER BY NATID_AREA_HOSPITALARIA)
   LOOP
      EXECUTE IMMEDIATE
         'SELECT ALL_MVIEWS.OWNER, MIN(LAST_REFRESH_DATE), MAX(LAST_REFRESH_DATE), MIN(LAST_ANALYZED), MAX(LAST_ANALYZED) FROM ALL_MVIEWS@'
         || c1.DB_LINK_REPLICA || ' JOIN ALL_TABLES@'  || c1.DB_LINK_REPLICA || ' ON (ALL_MVIEWS.OWNER = ALL_TABLES.OWNER AND ALL_MVIEWS.MVIEW_NAME = ALL_TABLES.TABLE_NAME) '
         || ' WHERE ALL_MVIEWS.OWNER = ''REP_HIS_OWN'' GROUP BY ALL_MVIEWS.OWNER'
         INTO l_owner,
              l_last_refresh_min,
              l_last_refresh_max,
              l_last_analyzed_min,
              l_last_analyzed_max;

      l_tab.EXTEND;
      l_tab (l_tab.LAST) :=
         t_tf_row_replicas (c1.NATID_AREA_HOSPITALARIA,
                            c1.DESCR_AREA_HOSPITALARIA,
                            c1.DB_LINK_REPLICA,
                            l_owner,
                            l_last_refresh_min,
                            l_last_refresh_max,
                            l_last_analyzed_min,
                            l_last_analyzed_max);
   END LOOP;

   --
   RETURN l_tab;
END;
/