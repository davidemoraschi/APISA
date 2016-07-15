/* Formatted on 5/6/2014 13:55:53 (QP5 v5.163.1008.3004) */
SELECT *
  FROM MD.DSSMDOBJINFO
 WHERE OBJECT_ID IN (SELECT DEPN_OBJID                                     --,
                       --       DEPN_PRJID,
                       --       DEPNOBJ_TYPE,
                       --       OBJECT_ID,
                       --       OBJECT_TYPE,
                       --       PROJECT_ID
                       FROM MD.DSSMDOBJDEPN
                      WHERE OBJECT_ID = 'FD7FC2C04179F4033DC31E900D89DC62')
/

SELECT *
  FROM MD.DSSMDOBJINFO
 WHERE OBJECT_ID IN (SELECT                                      --DEPN_OBJID,
                            --       DEPN_PRJID,
                            DEPNOBJ_TYPE, OBJECT_ID                        --,
                       --       OBJECT_TYPE,
                       --      PROJECT_ID
                       FROM MD.DSSMDOBJDEPN
                      WHERE DEPN_OBJID = 'FD7FC2C04179F4033DC31E900D89DC62') --
/

-- OBJECT_TYPE = 3 AND SUBTYPE= 776

  SELECT OBJECT_NAME,
         MAX (FINISHTIME) ULTIMO_REFRESH,
         CUBEREPORTGUID || TO_CHAR (MAX (FINISHTIME), 'YYYYMMDDHH24MISS') TAG
    FROM    MD.IS_CUBE_REP_STATS
         JOIN
            MD.DSSMDOBJINFO
         ON (CUBEREPORTGUID = OBJECT_ID)
   WHERE CUBEREPORTGUID IN
            (SELECT DSSMDOBJINFO.OBJECT_ID        --, DSSMDOBJINFO.OBJECT_NAME
               FROM    MD.DSSMDOBJDEPN
                    JOIN
                       MD.DSSMDOBJINFO
                    ON (DSSMDOBJDEPN.DEPN_OBJID =
                           DSSMDOBJINFO.OBJECT_ID)
              WHERE DSSMDOBJDEPN.OBJECT_ID = '75BF74D440F2A006C08595B0FB3DED06' -- '023945294B63B9AE122177BCD84DA645'
                    AND DSSMDOBJDEPN.OBJECT_TYPE = 3
                    AND SUBTYPE = 776)
GROUP BY OBJECT_NAME, CUBEREPORTGUID
/

-- Recupera el cubo de un informe

SELECT OBJECT_ID || EPOCH2(LAST_REFRESH) TAG
FROM
(
SELECT DSSMDOBJINFO.OBJECT_ID, MAX(FINISHTIME) LAST_REFRESH
  FROM    MD.DSSMDOBJDEPN
       JOIN
          MD.DSSMDOBJINFO
       ON (DSSMDOBJDEPN.DEPN_OBJID = DSSMDOBJINFO.OBJECT_ID)
       JOIN MD.IS_CUBE_REP_STATS ON (IS_CUBE_REP_STATS.CUBEREPORTGUID = DSSMDOBJINFO.OBJECT_ID)
 WHERE     DSSMDOBJDEPN.OBJECT_ID = '75BF74D440F2A006C08595B0FB3DED06' -- '023945294B63B9AE122177BCD84DA645'
       AND DSSMDOBJDEPN.OBJECT_TYPE = 3
       AND SUBTYPE = 776
       GROUP BY DSSMDOBJINFO.OBJECT_ID)