/* Formatted on 4/21/2014 12:32:35 (QP5 v5.163.1008.3004) */
create or replace view MSTR_UTL_ULTIMOS_DATOS_DISPON
AS
SELECT * FROM TABLE (func_get_tab_tf_replicas)