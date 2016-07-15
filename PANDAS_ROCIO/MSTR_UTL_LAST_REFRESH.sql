create materialized view MSTR_UTL_LAST_REFRESH
AS
  SELECT  'SIG' BBDD, owner, mview_name,   (last_refresh_date)
    FROM all_mviews@SIG
WHERE OWNER = 'REP_PRO_SEV'
ORDER BY last_refresh_date