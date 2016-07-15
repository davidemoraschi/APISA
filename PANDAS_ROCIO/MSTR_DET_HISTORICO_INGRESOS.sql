/* Formatted on 19/09/2013 18:48:35 (QP5 v5.163.1008.3004) */
DROP TABLE MSTR_DET_HISTORICO_INGRESOS;

CREATE TABLE MSTR_DET_HISTORICO_INGRESOS
NOLOGGING
NOMONITORING
NOPARALLEL
AS
     SELECT FCH_INGRESO NATID_DIA,
            NVL (CENTRO_INGRESO, -1) NATID_CENTRO,
            NVL (UNID_FUNC_INGRESO, -1) NATID_UNIDAD_FUNCIONAL,
            MODALIDAD_ASIST NATID_MODALIDAD_ASIST,
            NVL (MOTIVO_INGRESO, -1) NATID_URGENTE_PROGRAMADO,
            NVL (ORIGEN_INGRESO, -1) NATID_PROCEDENCIA,
            --COUNT (ADMISION_ID) AH04A,
            COUNT (ADMISION_ID) INGRESOS,
            LAST_REFRESH_DATE
       FROM REP_HIS_OWN.ADM_ADMISION@EXP JOIN ALL_MVIEWS@EXP ON (OWNER = 'REP_HIS_OWN' AND MVIEW_NAME = 'ADM_ADMISION')
      WHERE EPIS_CONTAB = 1
   GROUP BY FCH_INGRESO,
            CENTRO_INGRESO,
            UNID_FUNC_INGRESO,
            MODALIDAD_ASIST,
            MOTIVO_INGRESO,
            ORIGEN_INGRESO,
            LAST_REFRESH_DATE;


ALTER TABLE MSTR_DET_HISTORICO_INGRESOS ADD (
  CONSTRAINT MSTR_DET_HISTORICO_INGRESOS_PK
  PRIMARY KEY
  (NATID_DIA, NATID_CENTRO, NATID_UNIDAD_FUNCIONAL, NATID_MODALIDAD_ASIST, NATID_URGENTE_PROGRAMADO,NATID_PROCEDENCIA)
  USING INDEX)