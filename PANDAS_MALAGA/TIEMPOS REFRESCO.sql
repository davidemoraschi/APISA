/* Formatted on 9/5/2014 10:19:51 AM (QP5 v5.163.1008.3004) */
  SELECT ALL_MVIEWS.OWNER,
         MVIEW_NAME,
         LAG (LAST_REFRESH_DATE) OVER (ORDER BY LAST_REFRESH_DATE) INICIO_REFRESCO,
         LAST_REFRESH_DATE FIN_REFRESCO,
         NUMTODSINTERVAL ( (LAST_REFRESH_DATE - LAG (LAST_REFRESH_DATE) OVER (ORDER BY LAST_REFRESH_DATE)), 'day') TIEMPO_REFRESCO,
         ROW_COUNT                                                                                                                                                                                                                           --,
    --         ((LAST_REFRESH_DATE - (LAG (LAST_REFRESH_DATE) OVER (ORDER BY LAST_REFRESH_DATE)))/ROW_COUNT) TIEMPO_MEDIO
    FROM ALL_MVIEWS@SEE41DAE JOIN TEMP_REPLICAS_A102003 USING (MVIEW_NAME)
   WHERE ALL_MVIEWS.OWNER = 'REP_HIS_OWN'
ORDER BY NUMTODSINTERVAL ( (LAST_REFRESH_DATE - LAG (LAST_REFRESH_DATE) OVER (ORDER BY LAST_REFRESH_DATE)), 'day') DESC NULLS LAST--LAST_REFRESH_DATE
/

  SELECT /*+DRIVING_SITE(ALL_MVIEWS)*/ ALL_MVIEWS.OWNER REPLICA,
         MVIEW_NAME VISTA_MATERIALIZADA,
         LAST_REFRESH_DATE INICIO_REFRESCO,
         LEAD (LAST_REFRESH_DATE) OVER (ORDER BY LAST_REFRESH_DATE) FIN_REFRESCO,
         NUMTODSINTERVAL ( (LEAD (LAST_REFRESH_DATE) OVER (ORDER BY LAST_REFRESH_DATE) - LAST_REFRESH_DATE), 'day') TIEMPO_REFRESCO,
         ROW_COUNT NUMERO_DE_FILAS--,
         --CASE ROW_COUNT WHEN 0 THEN NULL ELSE NUMTODSINTERVAL((LEAD (LAST_REFRESH_DATE) OVER (ORDER BY LAST_REFRESH_DATE) - LAST_REFRESH_DATE) / ROW_COUNT,'day') END TIEMPO_POR_FILA 
         --, AVG_ROW_LEN TAMA�O_MEDIO_DE_FILA                                                                                                                                                                                                                     --,
    --         ((LAST_REFRESH_DATE - (LAG (LAST_REFRESH_DATE) OVER (ORDER BY LAST_REFRESH_DATE)))/ROW_COUNT) TIEMPO_MEDIO
    FROM ALL_MVIEWS@SEE41DAE JOIN TEMP_REPLICAS_A102003 USING (MVIEW_NAME)
    --JOIN SYS.ALL_ALL_TABLES@SEE41DAE ON (TABLE_NAME = MVIEW_NAME)
   WHERE ALL_MVIEWS.OWNER = 'REP_HIS_OWN'
ORDER BY NUMTODSINTERVAL ( (LEAD (LAST_REFRESH_DATE) OVER (ORDER BY LAST_REFRESH_DATE) - LAST_REFRESH_DATE), 'day') DESC NULLS LAST --ROW_COUNT DESC--LAST_REFRESH_DATE
/