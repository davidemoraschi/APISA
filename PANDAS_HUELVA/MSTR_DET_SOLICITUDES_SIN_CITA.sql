/* Formatted on 27/05/2013 13:18:14 (QP5 v5.163.1008.3004) */
DROP TABLE MSTR_DET_SOLICITUDES_SIN_CITA;

CREATE TABLE MSTR_DET_SOLICITUDES_SIN_CITA
AS
   SELECT                                                                                                           --CODIGO_CITA,
         CODIGO_SOLICITUD,
          AREA_H,
          CODIGO_CENTRO,
          NUHSA,
          ESPECIALIDAD,
          PROCEDENCIA,
          TIPO_CITA,
          PRUEBA,
          TO_DATE (FECHASOLIC, 'yyyy-mm-dd') FECHASOLIC,
          --TO_DATE (FECHACITA, 'yyyy-mm-dd') FECHACITA,
          --ESTADOCITA,
          CENTRO_SOLICITANTE,
          UNIDAD_SOLICITANTE,
          CNP_PROF_SOLICITANTE,
          SUJETA_GARANTIA,
          TO_DATE (FECHA_INDIC_PROFE, 'yyyy-mm-dd') FECHA_INDIC_PROFE,
          TO_DATE (FECHA_DESE_USUARIO, 'yyyy-mm-dd') FECHA_DESE_USUARIO,
          MOTIVO_DEMANDA,
          CIE9,
          --TO_DATE (FECHA_DISP_CLINICA, 'yyyy-mm-dd') FECHA_DISP_CLINICA,
          TO_DATE (FECHA_PRESENTACION, 'yyyy-mm-dd') FECHA_PRESENTACION,
          --UNIDAD_REALIZACION,
          --AGENDA_REALIZACION,
          CLAVE_MEDICA,
          DISTRITO,
          TO_DATE (FECHA_REGISTRO, 'yyyy-mm-dd') FECHA_REGISTRO,
          LIBRE_ELECCION,
          --PROCESO_ASIST,
          EN_PLAZO,
          INSC_REGISTRO,
          EPISODIO_ADMIN,
          TIPO_FINAN,
          --TO_DATE (FECHA_ACREDIT, 'yyyy-mm-dd') FECHA_ACREDIT,
          ESTADO_SOLICITUD,
          TO_DATE (FECHAGRABACION, 'yyyy-mm-dd') FECHAGRABACION,
          TAREA,
          --TAREA_PPAL,
          --AGE_NOMBRE,
          SEXO,
          TO_DATE (FECHA_NACIMIENTO, 'yyyy-mm-dd') FECHA_NACIMIENTO,
          --CNP_PROF_REALIZA,
          --TIPO_PROCESO_ASIST,
          --ACT_CODIGO,
          --HORA_CITA,
          --MODELO_ACTUACION,
          TIPO_ASISTENCIA_ORIGEN,
          TIPO_ASISTENCIA_DESTINO,
          TO_DATE (F_INI_DEMORA, 'yyyy-mm-dd') F_INI_DEMORA,
          DEMORA,
          TAREA_DESCRIP
     FROM EXT_INFHOS_TXT_V2
    WHERE CODIGO_CITA IS NULL;

ALTER TABLE MSTR_DET_SOLICITUDES_SIN_CITA ADD (
  CONSTRAINT MSTR_DET_SOLICITUDES_SIN_CI_PK
  PRIMARY KEY
  (CODIGO_SOLICITUD)
  USING INDEX);