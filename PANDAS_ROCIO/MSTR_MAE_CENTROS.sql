/* Formatted on 04/09/2013 11:51:15 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW MSTR_MAE_CENTROS
(
   NATID_CENTRO,
   DESCR_CENTRO
)
AS
   SELECT -1 NATID_CENTRO, 'n/a' DESCR_CENTRO FROM DUAL
   UNION ALL
   SELECT CAH_CODIGO, CAH_NOMBRE
     FROM REP_PRO_EST.CENTROS_AH@EXP
    WHERE CAH_AH_CODIGO IN (SELECT NATID_AREA_HOSPITALARIA FROM MSTR_UTL_CODIGOS);
