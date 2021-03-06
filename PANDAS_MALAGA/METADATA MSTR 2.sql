/* Formatted on 5/6/2014 14:18:53 (QP5 v5.163.1008.3004) */
SELECT PANDAS_003_JSON.get_tag ('75BF74D440F2A006C08595B0FB3DED06') FROM DUAL
UNION ALL
SELECT PANDAS_003_JSON.get_tag ('023945294B63B9AE122177BCD84DA645') FROM DUAL;

SELECT PANDAS_003_JSON.get_tag ('023945294B63B9AE122177BCD84DA645') FROM DUAL;

SELECT OBJECT_ID || EPOCH2 (LAST_REFRESH) TAG
  -- INTO v_TAG
  FROM (  SELECT DSSMDOBJINFO.OBJECT_ID, MAX (FINISHTIME) LAST_REFRESH
            FROM MD.DSSMDOBJDEPN
                 JOIN MD.DSSMDOBJINFO
                    ON (DSSMDOBJDEPN.DEPN_OBJID = DSSMDOBJINFO.OBJECT_ID)
                 JOIN MD.IS_CUBE_REP_STATS
                    ON (IS_CUBE_REP_STATS.CUBEREPORTGUID =
                           DSSMDOBJINFO.OBJECT_ID)
           WHERE DSSMDOBJDEPN.OBJECT_ID = '023945294B63B9AE122177BCD84DA645' --'75BF74D440F2A006C08595B0FB3DED06' -- '023945294B63B9AE122177BCD84DA645'
                 AND DSSMDOBJDEPN.OBJECT_TYPE = 3
                 AND SUBTYPE = 776
        GROUP BY DSSMDOBJINFO.OBJECT_ID);

/

SELECT OBJECT_ID || EPOCH2 (LAST_REFRESH) TAG
  FROM (  SELECT REPORTID OBJECT_ID, MAX (DAY_ID) LAST_REFRESH
            FROM MD.IS_REPORT_STATS
           WHERE REPORTID = '2D8F26A64E27E6F649DB698138E83387'
        GROUP BY REPORTID);