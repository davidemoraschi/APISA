/* Formatted on 07/06/2013 13:53:38 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW MSTR_MAE_CONTROLES_ENFERMERIA
(
   NATID_CONTROL_ENFERMERIA,
   DESCR_CONTROL_ENFERMERIA,
   LDESC_CONTROL_ENFERMERIA,
   NATID_UBICACION_PADRE,
   DESCR_UBICACION_PADRE,
   NATID_CENTRO
)
AS
   SELECT '-1' NATID_CONTROL_ENFERMERIA,
          'n/a' DESCR_CONTROL_ENFERMERIA,
          'n/a' LDESC_CONTROL_ENFERMERIA,
          '-1' NATID_UBICACION_PADRE,
          'n/a' DESCR_UBICACION_PADRE,
          -1 NATID_CENTRO
     FROM DUAL                                                                                                                 --,
   UNION ALL
   SELECT                                                                                                            --UBI_ACTIVO,
         UBICACIONES.UBI_CODIGO NATID_CONTROL_ENFERMERIA,
          UBICACIONES.UBI_NOMBRE DESCR_CONTROL_ENFERMERIA,
          UBICACIONES.UBI_DESCRIPCION LDESC_CONTROL_ENFERMERIA,
          UBICACIONES.UBI_UBI_CODIGO NATID_UBICACION_PADRE,
          PADRE.UBI_NOMBRE DESCR_UBICACION_PADRE,
          --UBI_UBICACIONES_DEP,
          --UBI_TIP_UBICACION,
          --UBI_VAR_USUARIOS,
          UBICACIONES.UBI_CAH_CODIGO NATID_CENTRO                                                                              --,
     --       UBI_TELEFONO
     FROM REP_PRO_EST.UBICACIONES@VAL JOIN REP_PRO_EST.UBICACIONES@VAL PADRE ON UBICACIONES.UBI_UBI_CODIGO = PADRE.UBI_CODIGO
    WHERE UBICACIONES.UBI_TIP_UBICACION = 20 AND UBICACIONES.UBI_CAH_CODIGO IN (SELECT NATID_CENTRO FROM MSTR_MAE_CENTROS);