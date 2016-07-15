/* Formatted on 10/06/2013 17:30:31 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW MSTR_MAE_QUIROFANOS
(
   NATID_QUIROFANO,
   DESCR_QUIROFANO,
   LDESC_QUIROFANO,
   NATID_TIPO_UBICACION,
   NATID_CENTRO,
   NATID_UBICACION,
   NATID_PADRE_UBICACION
)
AS
   SELECT -1 NATID_QUIROFANO,
          'n/a' DESCR_QUIROFANO,
          '' LDESC_QUIROFANO,
          '-1' NATID_TIPO_UBICACION,
          -1 NATID_CENTRO,
          '-1' NATID_UBICACION,
          NULL NATID_PADRE_UBICACION
     FROM DUAL
   UNION ALL
   SELECT ID,
          --QUIROFANO,
          --TIPO_SALA,
          --QRF_MENOR,
          --ACTIVO_ESTRUCTURA,
          --ACTIVO,
          --PROGRAMABLE,
          --CONSULTA,
          --UBI_ACTIVO,
          UBI_NOMBRE,
          --UBI_UBICACIONES_DEP,
          UBI_DESCRIPCION,
          UBI_TIP_UBICACION,
          --UBI_VAR_USUARIOS,
          UBI_CAH_CODIGO,
          UBI_CODIGO,
          UBI_UBI_CODIGO
     --UBI_TELEFONO
     FROM REP_HIS_OWN.ADM_QRF_LOCAL@EXP JOIN REP_PRO_EST.UBICACIONES@VAL ON (QUIROFANO = UBI_CODIGO);
