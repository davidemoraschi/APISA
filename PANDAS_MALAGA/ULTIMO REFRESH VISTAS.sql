/* Formatted on 9/10/2014 8:53:18 AM (QP5 v5.163.1008.3004) */
SELECT owner, mview_name, last_refresh_date
  FROM sys.all_mviews@EXP
 --  ORDER BY last_refresh_date DESC
 WHERE mview_name = 'COM_UBICACION_GESTION_LOCAL'
--AND mview_name = <<name of the materialized view>>
;
  SELECT 'VAL' BBDD,
         owner,
         MIN (last_refresh_date),
         MAX (last_refresh_date)
    FROM all_mviews@VAL
GROUP BY owner
UNION ALL
  SELECT 'EXP' BBDD,
         owner,
         MIN (last_refresh_date),
         MAX (last_refresh_date)
    FROM all_mviews@EXP
GROUP BY owner;

--REP_PRO_BDU

  SELECT 'VAL' BBDD,
         owner,
         mview_name,
         (last_refresh_date)
    FROM all_mviews@VAL
   WHERE OWNER = 'REP_PRO_EST'
ORDER BY last_refresh_date;

--REP_HIS_OWN
/*OWNER, MVIEW_NAME */
  SELECT OWNER, MVIEW_NAME, LAST_REFRESH_DATE
    FROM ALL_MVIEWS@SEE41DAE
   WHERE OWNER = 'REP_HIS_OWN'
ORDER BY MVIEW_NAME--LAST_REFRESH_DATE
/

SELECT EPOCH2 (last_refresh_date)
  FROM sys.all_mviews@MAE44DAE
 WHERE mview_name = 'OPERADORUNIDADFUNCIONAL'