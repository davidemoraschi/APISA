CREATE MATERIALIZED VIEW ADM_PREINGRESO
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
/* Formatted on 6/4/2012 8:33:05 AM (QP5 v5.163.1008.3004) */
SELECT * FROM HIS_RND.ADM_PREINGRESO@DAE;

--COMMENT ON MATERIALIZED VIEW ADM_PREINGRESO IS 'snapshot table for snapshot CDM.ADM_PREINGRESO';
