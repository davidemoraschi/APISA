/* Formatted on 5/6/2014 9:28:14 (QP5 v5.163.1008.3004) */

-- Recupera nombre proyecto
SELECT OBJECT_NAME PROJECT_NAME
  FROM MD.DSSMDOBJINFO
 WHERE OBJECT_ID = (SELECT PROJECT_ID
                      FROM MD.DSSMDOBJINFO
                     WHERE OBJECT_ID = '023945294B63B9AE122177BCD84DA645')
                     ;

                     