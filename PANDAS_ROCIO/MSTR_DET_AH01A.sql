/* Formatted on 04/09/2013 10:20:52 (QP5 v5.163.1008.3004) */
TRUNCATE TABLE MSTR_DET_AH01A;

--CREATE TABLE MSTR_DET_AH01A
--NOLOGGING NOMONITORING AS
--BUILD IMMEDIATE
--REFRESH FORCE ON DEMAND
--WITH PRIMARY KEY
INSERT INTO MSTR_DET_AH01A
  SELECT TRUNC (SYSDATE) NATID_DIA,
          --uf.uf_nombre,
         ubi.UBI_CAH_CODIGO NATID_CENTRO,
         uf.uf_codigo NATID_UNIDAD_FUNCIONAL,
         COUNT (loc.ID) AH01A
        --tubi.tubi_descripcion
    FROM rep_his_own.com_ubicacion_gestion_local@EXP loc
         JOIN rep_pro_est.unidades_funcionales@EXP uf
            ON (uf.uf_codigo = loc.unidad_funcional)
         JOIN rep_pro_est.ubicaciones@EXP ubi
            ON (loc.codigo_estructura = ubi.ubi_codigo)
         JOIN rep_pro_est.tipos_ubicacion@EXP tubi
            ON (ubi.ubi_tip_ubicacion = tubi.tubi_codigo)
   WHERE loc.activa = 1 AND loc.activa_en_estructura = 0 --AND loc.unidad_funcional IS NOT NULL
         AND tubi.tubi_codigo IN (14, 24) AND tubi.tubi_activo = 'S'
GROUP BY TRUNC (SYSDATE),
         --uf.uf_nombre,
         ubi.UBI_CAH_CODIGO,
         uf.uf_codigo;
         --tubi.tubi_descripcion;