/* Formatted on 12/5/2013 9:37:35 (QP5 v5.163.1008.3004) */
SELECT owner, mview_name, last_refresh_date
  FROM sys.all_mviews
 --  ORDER BY last_refresh_date DESC
-- WHERE mview_name = 'COM_UBICACION_GESTION_LOCAL'
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

  SELECT 'EXP' BBDD,
         owner,
         mview_name,
         (last_refresh_date)
    FROM all_mviews@EXP
   WHERE OWNER = 'REP_HIS_OWN'
ORDER BY last_refresh_date;

--REP_PRO_SEV

  SELECT 'SIG' BBDD,
         owner,
         mview_name,
         (last_refresh_date)
    FROM all_mviews@SIG
   WHERE OWNER = 'REP_PRO_SEV'
ORDER BY last_refresh_date;

SELECT owner, /*mview_name,*/  MAX(last_refresh_date) mas_nueva, MIN(last_refresh_date) mas_antigua
  FROM sys.all_mviews@SYG
  --GROUP BY OWNER;
  WHERE OWNER = 'REP_PRO_SIGLO'
  GROUP BY OWNER;