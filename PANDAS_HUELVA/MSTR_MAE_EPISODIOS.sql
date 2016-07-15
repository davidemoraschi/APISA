/* Formatted on 05/03/2013 14:05:48 (QP5 v5.163.1008.3004) */
DROP TABLE MSTR_MAE_EPISODIOS;

CREATE TABLE MSTR_MAE_EPISODIOS
NOLOGGING
AS
  SELECT DISTINCT
               TO_CHAR (EPISODIO_ID) NATID_EPISODIO,
               NUHSA,
               DECODE (ADM_EPISODIO.MODALIDAD_ASIST,
                       2, DES_MODAL_ASIST || ' ' || DECODE (HD_QUIR_SN, 1, 'Quirúrgico', 'Médico'),
                       DES_MODAL_ASIST)
                  TIPO,
               (FCH_APERTURA + (HORA_APERTURA - TRUNC (HORA_APERTURA))) FHORA_EPISODIO,
               CENTRO_INGRESO NATID_CENTRO,
               UNID_FUNC_INGRESO NATID_UNIDAD_FUNCIONAL
          FROM REP_HIS_OWN.ADM_EPISODIO@RND
               JOIN REP_HIS_OWN.ADM_EPIS_DETALLE@RND
                  USING (EPISODIO_ID)
               JOIN REP_HIS_OWN.ADM_ADMISION@RND
                  ON (REFERENCIA_ID = ADMISION_ID)
               JOIN REP_HIS_OWN.COM_USUARIO@RND
                  ON (ADM_EPISODIO.USUARIO = ID_USUARIO)
               JOIN REP_HIS_OWN.ADM_M_MODAL_ASIST@RND
                  ON (ADM_EPISODIO.MODALIDAD_ASIST = ADM_M_MODAL_ASIST.MODAL_ASIST_ID
                  --)--        UNION ALL
                                                                                      --SELECT TO_CHAR (AU_EPISODIO) NATID_EPISODIO,
                                                                                      --       USU_BDU_NUSA NUHSA,
                                                                                      --       'Urgencias' TIPO,
                                                                                      --       EU_FHCREACION FHORA_EPISODIO,
                                                                                      --       DECODE (AU_CENTRO, '002083', 10004, AU_CENTRO) NATID_CENTRO,
                                                                                      --       NVL (EU_LUGAR_COD, -1) NATID_UNIDAD_FUNCIONAL
                                                                                      --  FROM CAE_OWN.ADMISION@RND
                                                                                      --       JOIN CAE_OWN.EPISODIO_URGENCIAS@RND
                                                                                      --          ON (AU_EPISODIO = EU_IDENTIFICADOR)
                                                                                      --       JOIN CAE_OWN.USUARIO@RND
                                                                                      --          ON (AU_USUARIO = USU_ID)
                                                                                      -- WHERE AU_EPISODIO IS NOT NULL AND USU_BDU_NUSA IS NOT NULL
       )

/

  ALTER TABLE MSTR_MAE_EPISODIOS ADD (
  CONSTRAINT MSTR_MAE_EPISODIOS_PK
  PRIMARY KEY
  (NATID_EPISODIO, NUHSA, TIPO))
/