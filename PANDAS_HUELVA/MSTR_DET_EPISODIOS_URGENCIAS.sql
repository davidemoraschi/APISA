/* Formatted on 19/03/2013 14:38:34 (QP5 v5.163.1008.3004) */
DROP MATERIALIZED VIEW MSTR_DET_EPISODIOS_URGENCIAS;
CREATE MATERIALIZED VIEW MSTR_DET_EPISODIOS_URGENCIAS
AS

SELECT                                                                                                               --AU_USUARIO,
                                                                                                          --USU_IDENTIFICADOR DNI,
       AU_EPISODIO NATID_EPISODIO_URGENCIAS,
       USU_BDU_NUSA NUHSA,
       --AU_OPERADOR,
       AU_FECHA FHORA_ENTRADA,
       AU_FECHASALIDA FHORA_SALIDA,
       --AU_COD_PROCEDENCIA_URG,
       --AU_COD_TIPO_PROCESO_URG,
       AU_FINANCIACION NATID_FINANCIACION,
       EU_FHCREACION FHORA_INICIO_EPISODIO,
       EU_FHALTA FHORA_FIN_EPISODIO,
       EU_PRIORIDAD IND_PRIORIDAD,
       --EU_INFORMEALTA,
       EU_COD_CAUSA_ALTA_URG NATID_CAUSA_ALTA_URGENCIAS,
       --EU_OPERADOR_FIRMA_ALTA,
       EU_LUGAR_COD NATID_LUGAR_URGENCIAS,
       EU_LUGAR_TXT DESCR_LUGAR_URGENCIAS,
       --MAX_ESTADO.EUE_IDENTIFICADOR,
       EUE_UBICACION NATID_ULTIMA_UBICACION,
       NVL (IND_OBSERVACION, 0) IND_OBSERVACION,
       NVL (IND_EVOLUCION, 0) IND_EVOLUCION
  --       ,
  --       (SELECT COUNT (EUE_IDENTIFICADOR)
  --          FROM CAE_OWN.ESTADOS_EPISODIO_URG EST1
  --         WHERE EUE_EPISODIO = AU_EPISODIO AND EST1.EUE_ESTADO = 10)
  --          IND_OBSERVACION,
  --       (SELECT COUNT (EUE_IDENTIFICADOR)
  --          FROM CAE_OWN.ESTADOS_EPISODIO_URG EST2
  --         WHERE EUE_EPISODIO = AU_EPISODIO AND EST2.EUE_ESTADO = 8)
  --          IND_EVOLUCION
  --       UBI1.UBI_NOMBRE SECCION,
  --       UBI0.UBI_NOMBRE AREA
  FROM CAE_OWN.ADMISION@DAE
       JOIN CAE_OWN.EPISODIO_URGENCIAS@DAE
          ON (AU_EPISODIO = EU_IDENTIFICADOR)
       JOIN (  SELECT EUE_EPISODIO, MAX (EUE_IDENTIFICADOR) EUE_IDENTIFICADOR
                 FROM CAE_OWN.ESTADOS_EPISODIO_URG@DAE
             GROUP BY EUE_EPISODIO) MAX_ESTADO
          ON (AU_EPISODIO = MAX_ESTADO.EUE_EPISODIO)
       JOIN CAE_OWN.ESTADOS_EPISODIO_URG@DAE ESTADOS
          ON (MAX_ESTADO.EUE_IDENTIFICADOR = ESTADOS.EUE_IDENTIFICADOR)
       /*       JOIN CAE_OWN.UBICACIONES_URGENCIAS UBI2
                 ON (ESTADOS.EUE_UBICACION = UBI2.UBI_IDENTIFICADOR)
              JOIN CAE_OWN.UBICACIONES_URGENCIAS UBI1
                 ON (UBI2.UBI_PADRE = UBI1.UBI_IDENTIFICADOR)
              LEFT JOIN CAE_OWN.UBICACIONES_URGENCIAS UBI0
                 ON (UBI1.UBI_PADRE = UBI0.UBI_IDENTIFICADOR)*/
       JOIN CAE_OWN.USUARIO@DAE
          ON (AU_USUARIO = USU_ID)
       LEFT JOIN (  SELECT EUE_EPISODIO, COUNT (EUE_IDENTIFICADOR) IND_OBSERVACION
                      FROM    CAE_OWN.ESTADOS_EPISODIO_URG@DAE EST1
                           LEFT JOIN
                              REP_PRO_EST.UBICACIONES@DAE UBI2
                           ON (EUE_UBICACION = UBI_CODIGO)
                     WHERE UBI2.UBI_NOMBRE LIKE 'Observación%'
                  --EST1.EUE_ESTADO = 10
                  GROUP BY EUE_EPISODIO) EST_OBSERVACION
          ON (EST_OBSERVACION.EUE_EPISODIO = AU_EPISODIO)
       LEFT JOIN (  SELECT EUE_EPISODIO, COUNT (EUE_IDENTIFICADOR) IND_EVOLUCION
                      FROM    CAE_OWN.ESTADOS_EPISODIO_URG@DAE EST1
                           LEFT JOIN
                              REP_PRO_EST.UBICACIONES@DAE UBI2
                           ON (EUE_UBICACION = UBI_CODIGO)
                     WHERE UBI2.UBI_NOMBRE LIKE 'Evolución%'
                  --EST1.EUE_ESTADO = 8
                  GROUP BY EUE_EPISODIO) EST_EVOLUCION
          ON (EST_EVOLUCION.EUE_EPISODIO = AU_EPISODIO)
 --WHERE TRUNC (AU_FECHA) = TRUNC (SYSDATE) - 1;
  WHERE TRUNC (AU_FECHA) >= ADD_MONTHS (TRUNC (SYSDATE, 'YEAR'), -12)
       AND TRUNC (AU_FECHA) <= ADD_MONTHS (TRUNC (SYSDATE, 'YEAR'), 12);
       
       ALTER TABLE MSTR_URGENCIAS.MSTR_DET_EPISODIOS_URGENCIAS ADD 
CONSTRAINT MSTR_DET_EPISODIOS_URGENCIASPK
 PRIMARY KEY (NATID_EPISODIO_URGENCIAS);
 
 CREATE INDEX MSTR_URGENCIAS.IX01_URGENCIAS_FECHA_INICIO ON MSTR_URGENCIAS.MSTR_DET_EPISODIOS_URGENCIAS
(FHORA_INICIO_EPISODIO)
NOLOGGING;

CREATE INDEX MSTR_URGENCIAS.IX02_URGENCIAS_FECHA_FIN ON MSTR_URGENCIAS.MSTR_DET_EPISODIOS_URGENCIAS
(FHORA_FIN_EPISODIO)
NOLOGGING;

CREATE INDEX MSTR_URGENCIAS.IX03_URGENCIAS_NUHSA ON MSTR_URGENCIAS.MSTR_DET_EPISODIOS_URGENCIAS
(NUHSA)
NOLOGGING;

CREATE INDEX MSTR_URGENCIAS.IX04_URGENCIAS_UBICACION ON MSTR_URGENCIAS.MSTR_DET_EPISODIOS_URGENCIAS
(NATID_ULTIMA_UBICACION)
NOLOGGING;

