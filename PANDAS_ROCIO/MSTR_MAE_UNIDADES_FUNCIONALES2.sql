/* Formatted on 04/09/2013 11:48:34 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW MSTR_MAE_UNIDADES_FUNCIONALES2
(
   NATID_UNIDAD_FUNCIONAL2,
   DESCR_UNIDAD_FUNCIONAL2,
   NATID_UNIDAD_FUNCIONAL1
)
AS
   SELECT '-1' NATID_UNIDAD_FUNCIONAL2, 'n/a' DESCR_UNIDAD_FUNCIONAL2, '-1' NATID_UNIDAD_FUNCIONAL1 FROM DUAL
   UNION ALL
   SELECT UF_CODIGO NATID_UNIDAD_FUNCIONAL2, UF_NOMBRE DESCR_UNIDAD_FUNCIONAL2, UF_UF_CODIGO NATID_UNIDAD_FUNCIONAL1
     FROM REP_PRO_EST.UNIDADES_FUNCIONALES@EXP
    WHERE UF_UF_CODIGO IN
             (SELECT UF_CODIGO
                FROM REP_PRO_EST.UNIDADES_FUNCIONALES@EXP
               WHERE UF_UF_CODIGO IS NULL AND UF_AH_CODIGO IN (SELECT NATID_AREA_HOSPITALARIA FROM MSTR_UTL_CODIGOS))
   UNION ALL
   SELECT UF_CODIGO, UF_NOMBRE, UF_CODIGO UF_UF_CODIGO
     FROM REP_PRO_EST.UNIDADES_FUNCIONALES@EXP
    WHERE UF_UF_CODIGO IS NULL AND UF_AH_CODIGO IN (SELECT NATID_AREA_HOSPITALARIA FROM MSTR_UTL_CODIGOS) AND UF_FINAL = 'S';
