/* Formatted on 6/2/2014 14:09:49 (QP5 v5.163.1008.3004) */
BEGIN
   FOR C1 IN (SELECT NATID_AREA_HOSPITALARIA, DB_LINK_REPLICA
                FROM MSTR_UTL_LOCAL_CODIGOS
               WHERE ENABLED = 1)
   LOOP
      EXECUTE IMMEDIATE
            'CREATE TABLE TEMP_ESTANCIAS_A1'
         || C1.NATID_AREA_HOSPITALARIA
         || ' NOLOGGING
NOMONITORING
NOPARALLEL
AS
   SELECT adm.fch_alta,
          tr.fch_apertura,
          tr.fch_cierre,
          cah.cah_codigo,
          cah.cah_nombre,
          uf.uf_padre AS uf_codigo,
          uf.uf_padre_nombre AS uf_nombre,
          adm.usuario,
          ufloc.uf_padre AS uf_codigo_loc,
          ufloc.uf_padre_nombre AS uf_nombre_loc
     FROM REP_HIS_OWN.ADM_TRASLADO@'
         || C1.DB_LINK_REPLICA
         || ' tr,
          REP_HIS_OWN.ADM_ADMISION@'
         || C1.DB_LINK_REPLICA
         || ' adm,
          REP_HIS_OWN.COM_UBICACION_GESTION_LOCAL@'
         || C1.DB_LINK_REPLICA
         || ' loc,
          rep_pro_est.centros_ah@'
         || C1.DB_LINK_REPLICA
         || ' cah,
          rep_pro_est.ubicaciones@'
         || C1.DB_LINK_REPLICA
         || ' ubi,
          OWN_KPI.UF_CON_PADRES@'
         || C1.DB_LINK_REPLICA
         || ' uf,
          OWN_KPI.UF_CON_PADRES/* Formatted on 6/2/2014 14:11:12 (QP5 v5.163.1008.3004) */
@'
         || C1.DB_LINK_REPLICA
         || ' ufloc
    WHERE     tr.admision = adm.admision_id
          AND tr.unidad_funcional = uf.uf_codigo
          AND tr.ubic_terminal = loc.codigo_estructura
          AND loc.unidad_funcional = ufloc.uf_codigo
          AND loc.codigo_estructura = ubi.ubi_codigo
          AND ubi.ubi_cah_codigo = cah.cah_codigo
          AND (tr.fch_cierre >= ADD_MONTHS (TRUNC (SYSDATE, ''MM''), -12)
               OR tr.fch_cierre IS NULL)
          AND adm.modalidad_asist = 1
          AND ADM.EPIS_CONTAB = 1
          AND TRUNC (tr.fch_apertura, ''dd'') < TRUNC (SYSDATE, ''dd'')
          AND tr.fch_apertura > ADD_MONTHS (SYSDATE, -36)';
   END LOOP;
END;