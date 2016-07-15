/* Formatted on 9/5/2014 9:52:16 AM (QP5 v5.163.1008.3004) */
DROP TABLE TEMP_REPLICAS_A102003;

CREATE TABLE TEMP_REPLICAS_A102003
(
   MVIEW_NAME   VARCHAR2 (30),
   ROW_COUNT    NUMBER
)
NOLOGGING NOPARALLEL NOMONITORING;

DECLARE
   v_ROW_COUNT   NUMBER;
BEGIN
   FOR C1 IN (SELECT ALL_MVIEWS.MVIEW_NAME FROM ALL_MVIEWS@SEE41DAE WHERE ALL_MVIEWS.OWNER = 'REP_HIS_OWN')
   LOOP
      EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM REP_HIS_OWN.' || C1.MVIEW_NAME || '@SEE41DAE' INTO v_ROW_COUNT;

      INSERT INTO TEMP_REPLICAS_A102003
           VALUES (C1.MVIEW_NAME, v_ROW_COUNT);
   END LOOP;
END;