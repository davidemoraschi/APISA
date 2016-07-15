/* Formatted on 04/09/2013 10:00:56 (QP5 v5.163.1008.3004) */
  SELECT TRUNC (SYSDATE),
         COUNT (1),
         uf.uf_nombre,
         uf.uf_codigo
    FROM rep_his_own.com_ubicacion_gestion_local@EXP loc,
         rep_pro_est.unidades_funcionales@EXP uf,
         rep_pro_est.ubicaciones@EXP ubi,
         rep_pro_est.tipos_ubicacion@EXP tubi
   WHERE     uf.uf_codigo = loc.unidad_funcional
         AND loc.activa = 1
         AND loc.activa_en_estructura = 0
         AND loc.unidad_funcional IS NOT NULL
         AND loc.codigo_estructura = ubi.ubi_codigo
         AND ubi.ubi_tip_ubicacion = tubi.tubi_codigo
         AND tubi.tubi_codigo IN (14, 24)
         AND tubi.tubi_activo = 'S'
GROUP BY TRUNC (SYSDATE), uf.uf_nombre, uf.uf_codigo;