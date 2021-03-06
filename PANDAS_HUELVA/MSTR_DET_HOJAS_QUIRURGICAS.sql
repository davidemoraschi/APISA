DROP TABLE MSTR_DET_HOJAS_QUIRURGICAS;
--DROP MATERIALIZED VIEW MSTR_DET_HOJAS_QUIRURGICAS;

CREATE TABLE MSTR_DET_HOJAS_QUIRURGICAS
NOLOGGING
--CREATE MATERIALIZED VIEW MSTR_DET_HOJAS_QUIRURGICAS
--BUILD IMMEDIATE
--REFRESH FORCE ON DEMAND
--WITH PRIMARY KEY
AS
--SELECT  NATID_HOJA_QUIRURGICA,NATID_EPISODIO,NUHSA,FHORA_INICIO_OCUPACION,FHORA_FIN_OCUPACION,DELTA_OCUPACION,FHORA_INICIO_INTERVENCION,FHORA_FIN_INTERVENCION,DELTA_INTERVENCION,FHORA_INICIO_ANESTESIA,FHORA_FIN_ANESTESIA,DELTA_ANESTESIA,FHORA_INICIO_PARTE_QUIRU,NATID_CODIGO_RDQ_PRE,NATID_DIAGNOSTICO_CIE_PRE,NATID_PROCEDIMIENTO_CIE_PRE,NATID_GRUPO_CCS,NATID_CODIGO_RDQ_POST,TEXTO_DIAGNOSTICO_POST,TEXTO_PROCEDIMIENTO_POST,DURACION_PREVISTA,FIRMA_ADICIONAL1,FIRMA_ADICIONAL2,IND_ANATOMIAS_PATOLOGICAS,IND_CONTAJE_INSTRUMENTOS,IND_CUIDADOS_POSTQUIRURGICOS,IND_REINTERVENCION,IND_TIPO_INTERVENCION,IND_TIPO_PROGRAMACION,IND_MOTIVO_ANULACION,NATID_TURNO_QUIROFANO,NATID_CENTRO,NATID_UNIDAD_FUNCIONAL,TIPO_EPISODIO,IND_PROVISIONAL,NATID_DETALLE_PARTE_QUIRU,
--(SELECT RDQ_CODIGO FROM HIS_OWN.ADM_QRF_IQ_X_LEQ@DAE WHERE IQ_PRE_ID = A.NATID_DETALLE_PARTE_QUIRU) RDQ
-- FROM
--(
SELECT
R_OBJECT_ID NATID_HOJA_QUIRURGICA,
       FUNC_EPISODIO_TO_NUMBER (NEPISODIO) NATID_EPISODIO,
       --FUNC_RECUPERA_MODAL_ASIST (NEPISODIO) IND_MODALIDAD_ASISTENCIAL,
       NHC NUHSA,
       FCH_OCUPACION_INICIO FHORA_INICIO_OCUPACION,
       FCH_OCUPACION_FIN FHORA_FIN_OCUPACION,
       ROUND (FCH_OCUPACION_FIN - FCH_OCUPACION_INICIO, 4) DELTA_OCUPACION,
       FCH_INTERVENCION FHORA_INICIO_INTERVENCION,
       FCH_INTERVENCION_FIN FHORA_FIN_INTERVENCION,
       ROUND (FCH_INTERVENCION_FIN - FCH_INTERVENCION, 4) DELTA_INTERVENCION,
       FCH_ANESTESIA_INICIO FHORA_INICIO_ANESTESIA,
       FCH_ANESTESIA_FIN FHORA_FIN_ANESTESIA,
       ROUND (FCH_ANESTESIA_FIN - FCH_ANESTESIA_INICIO, 4) DELTA_ANESTESIA,
       FECHA_PARTE FHORA_INICIO_PARTE_QUIRU,
       CODIGOS_RDQ_PRE NATID_CODIGO_RDQ_PRE,
       COD_DIAG_PRINC_PRE NATID_DIAGNOSTICO_CIE_PRE,
       COD_PROC_PRINC_PRE NATID_PROCEDIMIENTO_CIE_PRE,
       NATID_GRUPO_CCS,
       CODIGOS_RDQ_POST NATID_CODIGO_RDQ_POST,
       COD_DIAG_PRINC_POST TEXTO_DIAGNOSTICO_POST,
       COD_PROC_PRINC_POST TEXTO_PROCEDIMIENTO_POST,
       TO_NUMBER (DURACION_PREVISTA) DURACION_PREVISTA,
       FIRMA_ADICIONAL1,
       FIRMA_ADICIONAL2,
       IND_ANATOMIAS_PATOLOGICAS,
       IND_CONTAJE_INSTRUMENTOS,
       IND_CUIDADOS_POSTQUIRURGICOS,
       IND_REINTERVENCION,
       IND_TIPO_INTERVENCION,
       TO_NUMBER (IND_TIPO_PROGRAMACION) IND_TIPO_PROGRAMACION,
       MOTIVO_ANULACION IND_MOTIVO_ANULACION,
       TO_NUMBER (TURNO_PARTE) NATID_TURNO_QUIROFANO,
       /* SI NO HAY UF EN EL PARTE TOMA LA UF DE INGRESO*/
       --NVL (UF_PARTE, FUNC_RECUPERA_UNIDAD_FUNCIONAL (NEPISODIO)) NATID_UNIDAD_FUNCIONAL,
       NVL(NATID_CENTRO,-1) NATID_CENTRO,
       NVL(NVL (UF_PARTE,NATID_UNIDAD_FUNCIONAL),-1) NATID_UNIDAD_FUNCIONAL,
       NVL(TIPO,'Desconocido') TIPO_EPISODIO,
       --FUNC_RECUPERA_CENTRO_INGRESO (NEPISODIO) NATID_CENTRO,
       TO_NUMBER (R_CURRENT_STATE) IND_PROVISIONAL,
       NVL (FUNC_RECUPERA_DETALLE_PARTE_v3 (NEPISODIO, UF_PARTE, FCH_INTERVENCION, NHC), -1) NATID_DETALLE_PARTE_QUIRU
  FROM REP_SIDCA_OWN.HCE_HOJA_QUIRURGICA@RND LEFT JOIN MSTR_MAE_PROCEDIMIENTOS_CMA ON (COD_PROC_PRINC_PRE = NATID_PROCEDIMIENTO_CMA)
  LEFT JOIN MSTR_MAE_EPISODIOS ON (NEPISODIO = NATID_EPISODIO AND NHC = NUHSA)
 WHERE     ID_VERS_POSTERIOR IS NULL
       AND IND_CANCELACION IS NULL
       AND FCH_INTERVENCION >= ADD_MONTHS (TRUNC (SYSDATE, 'YEAR'), -12)
       AND FCH_INTERVENCION <= ADD_MONTHS (TRUNC (SYSDATE, 'YEAR'), 12)                                 --AND NHC = 'AN0568368770'
--AND R_CURRENT_STATE = 1
--ORDER BY FCH_INTERVENCION DESC;
--) A
/

UPDATE MSTR_DET_HOJAS_QUIRURGICAS
   SET NATID_CODIGO_RDQ_PRE =
          (SELECT RDQ_CODIGO
             FROM REP_HIS_OWN.ADM_QRF_IQ_X_LEQ@RND
            WHERE IQ_PRE_ID = NATID_DETALLE_PARTE_QUIRU)
            WHERE NATID_CODIGO_RDQ_PRE IS NULL;
/

CREATE INDEX IX01_HOJAS_UNIDAD_FUNCIONAL
   ON MSTR_DET_HOJAS_QUIRURGICAS (NATID_UNIDAD_FUNCIONAL)
   LOGGING
   NOPARALLEL;

CREATE INDEX IX02_HOJAS_FECHA_INTERVENCION
   ON MSTR_DET_HOJAS_QUIRURGICAS (FHORA_INICIO_INTERVENCION)
   LOGGING
   NOPARALLEL;

CREATE INDEX IX03_HOJAS_NATID_DETALLE_PARTE
   ON MSTR_DET_HOJAS_QUIRURGICAS (NATID_DETALLE_PARTE_QUIRU)
   LOGGING
   NOPARALLEL;

CREATE INDEX IX04_HOJAS_FECHA_PARTE
   ON MSTR_DET_HOJAS_QUIRURGICAS (FHORA_INICIO_PARTE_QUIRU)
   LOGGING
   NOPARALLEL;

CREATE UNIQUE INDEX MSTR_DET_HOJAS_QUIRURGICAS_PK
   ON MSTR_DET_HOJAS_QUIRURGICAS (NATID_HOJA_QUIRURGICA)
   LOGGING
   NOPARALLEL;

ALTER TABLE MSTR_QUIROFANO.MSTR_DET_HOJAS_QUIRURGICAS
 ADD (FHORA_FIN_PARTE_QUIRU  DATE);

ALTER TABLE MSTR_QUIROFANO.MSTR_DET_HOJAS_QUIRURGICAS
 ADD (HORAS_DISPONIBLES_PARTE  NUMBER);

ALTER TABLE MSTR_QUIROFANO.MSTR_DET_HOJAS_QUIRURGICAS
 ADD (PORCENTAJE_OCUPACION  NUMBER);

ALTER TABLE MSTR_QUIROFANO.MSTR_DET_HOJAS_QUIRURGICAS
 ADD (NATID_CABECERA_PARTE_QUIRU  NUMBER);

ALTER TABLE MSTR_QUIROFANO.MSTR_DET_HOJAS_QUIRURGICAS
 ADD (NATID_QUIROFANO  NUMBER(8));
    