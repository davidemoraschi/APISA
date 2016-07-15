/* Formatted on 19/09/2013 18:50:57 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE VIEW MSTR_MAE_PROCEDENCIAS
AS
   SELECT PROCEDENCIA_ID NATID_PROCEDENCIA, DES_PROCEDENCIA DESCR_PROCEDENCIA                                           --, ACTIVO
                                                                             FROM REP_HIS_OWN.ADM_M_PROCEDENCIA@EXP
   UNION ALL
   SELECT -1, 'n/a' FROM DUAL