/* Formatted on 19/09/2013 18:33:45 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE VIEW MSTR_MAE_URGENTE_PROGRAMADO
AS
   SELECT MOTIVO_ING_ID NATID_URGENTE_PROGRAMADO, DES_MOTIVO_ING DESCR_URGENTE_PROGRAMADO                               --, ACTIVO
     FROM REP_HIS_OWN.ADM_M_MOTIVO_INGRESO@EXP
   UNION ALL
   SELECT -1, 'n/a' FROM DUAL