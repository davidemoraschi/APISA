/* Formatted on 14/10/2013 12:44:34 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE VIEW MSTR_MAE_ECONOMICA_N0
AS
   SELECT ID NATID_ECONOMICA_N0, DESCRIPCION DESCR_ECONOMICA_N0                                                                  --,
     --CODIGO CODE1_CAPITULO_N0--,
     --NIVEL NIVEL,
     --VALORPADRE                                                                                                           --,
     FROM REP_PRO_SIGLO.CAT_NIVELVALOR@SYG
    WHERE CLASIFICACION = 4 AND VALORPADRE IS NULL