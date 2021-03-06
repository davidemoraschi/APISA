/* Formatted on 06/09/2013 9:59:09 (QP5 v5.163.1008.3004) */
--INSERT INTO MSTR_DET_AH01A
TRUNCATE TABLE MSTR_DET_AH01A
/

  SELECT TRUNC (SYSDATE) NATID_DIA,
         UBI.UBI_CAH_CODIGO NATID_CENTRO,
         UF.UF_CODIGO NATID_UNIDAD_FUNCIONAL,
         COUNT (LOC.ID) AH01A,
         LAST_REFRESH_DATE
    FROM REP_HIS_OWN.COM_UBICACION_GESTION_LOCAL@EXP LOC
         JOIN REP_PRO_EST.UNIDADES_FUNCIONALES@EXP UF
            ON (UF.UF_CODIGO = LOC.UNIDAD_FUNCIONAL)
         JOIN REP_PRO_EST.UBICACIONES@EXP UBI
            ON (LOC.CODIGO_ESTRUCTURA = UBI.UBI_CODIGO)
         JOIN REP_PRO_EST.TIPOS_UBICACION@EXP TUBI
            ON (UBI.UBI_TIP_UBICACION = TUBI.TUBI_CODIGO)
         CROSS JOIN (SELECT LAST_REFRESH_DATE
                       FROM ALL_MVIEWS@EXP
                      WHERE OWNER = 'REP_HIS_OWN' AND MVIEW_NAME = 'COM_UBICACION_GESTION_LOCAL')
   WHERE LOC.ACTIVA = 1 AND LOC.ACTIVA_EN_ESTRUCTURA = 0 AND TUBI.TUBI_CODIGO IN (14, 24) AND TUBI.TUBI_ACTIVO = 'S'
GROUP BY TRUNC (SYSDATE),
         UBI.UBI_CAH_CODIGO,
         UF.UF_CODIGO,
         LAST_REFRESH_DATE
/

SELECT LAST_REFRESH_DATE
  FROM all_mviews@EXP
 WHERE owner = 'REP_HIS_OWN' AND mview_name = 'COM_UBICACION_GESTION_LOCAL'
--GROUP BY owner
/
DROP TABLE MSTR_DET_AH01A
/

CREATE TABLE MSTR_DET_AH01A
NOLOGGING NOMONITORING NOPARALLEL
AS
  SELECT TRUNC (SYSDATE) NATID_DIA,
         UBI.UBI_CAH_CODIGO NATID_CENTRO,
         UF.UF_CODIGO NATID_UNIDAD_FUNCIONAL,
         COUNT (LOC.ID) AH01A,
         LAST_REFRESH_DATE
    FROM REP_HIS_OWN.COM_UBICACION_GESTION_LOCAL@EXP LOC
         JOIN REP_PRO_EST.UNIDADES_FUNCIONALES@EXP UF
            ON (UF.UF_CODIGO = LOC.UNIDAD_FUNCIONAL)
         JOIN REP_PRO_EST.UBICACIONES@EXP UBI
            ON (LOC.CODIGO_ESTRUCTURA = UBI.UBI_CODIGO)
         JOIN REP_PRO_EST.TIPOS_UBICACION@EXP TUBI
            ON (UBI.UBI_TIP_UBICACION = TUBI.TUBI_CODIGO)
         JOIN ALL_MVIEWS@EXP
            ON (OWNER = 'REP_HIS_OWN' AND MVIEW_NAME = 'COM_UBICACION_GESTION_LOCAL')
   WHERE LOC.ACTIVA = 1 AND LOC.ACTIVA_EN_ESTRUCTURA = 0 AND TUBI.TUBI_CODIGO IN (14, 24) AND TUBI.TUBI_ACTIVO = 'S'
GROUP BY TRUNC (SYSDATE),
         UBI.UBI_CAH_CODIGO,
         UF.UF_CODIGO,
         LAST_REFRESH_DATE
         /
         select distinct natid_dia from MSTR_DET_HISTORICO_CAMAS
         /
         delete from MSTR_DET_HISTORICO_AH01A where natid_dia = '06-SEP-2013'
         /
         update MSTR_DET_HISTORICO_CAMAS set LAST_REFRESH_DATE = NATID_DIA where LAST_REFRESH_DATE is null