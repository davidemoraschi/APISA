/* Formatted on 22/03/2013 8:59:05 (QP5 v5.163.1008.3004) */
SELECT *
  FROM (SELECT DISTINCT
               TO_CHAR (EPISODIO_ID) NATID_EPISODIO,
               NUHSA,
               DECODE (ADM_EPISODIO.MODALIDAD_ASIST,
                       2, DES_MODAL_ASIST || ' ' || DECODE (HD_QUIR_SN, 1, 'Quirúrgico', 'Médico'),
                       DES_MODAL_ASIST)
                  TIPO,
               (FCH_APERTURA + (HORA_APERTURA - TRUNC (HORA_APERTURA))) FHORA_APERTURA_EPISODIO,
               (FCH_CIERRE + (HORA_CIERRE - TRUNC (HORA_CIERRE))) FHORA_CIERRE_EPISODIO,
               (FCH_INGRESO + (HORA_INGRESO - TRUNC (HORA_INGRESO))) FHORA_INGRESO,
               (FCH_ALTA + (HORA_ALTA - TRUNC (HORA_ALTA))) FHORA_ALTA,
               CENTRO_INGRESO NATID_CENTRO,
               UNID_FUNC_INGRESO NATID_UNIDAD_FUNCIONAL
          FROM HIS_OWN.ADM_EPISODIO@DAE
               JOIN HIS_OWN.ADM_EPIS_DETALLE@DAE
                  USING (EPISODIO_ID)
               JOIN HIS_OWN.ADM_ADMISION@DAE
                  ON (REFERENCIA_ID = ADMISION_ID)
               JOIN HIS_OWN.COM_USUARIO@DAE
                  ON (ADM_EPISODIO.USUARIO = ID_USUARIO)
               JOIN HIS_OWN.ADM_M_MODAL_ASIST@DAE
                  ON (ADM_EPISODIO.MODALIDAD_ASIST = ADM_M_MODAL_ASIST.MODAL_ASIST_ID)
                  --        UNION ALL
                                                                                      --SELECT TO_CHAR (AU_EPISODIO) NATID_EPISODIO,
                                                                                      --       USU_BDU_NUSA NUHSA,
                                                                                      --       'Urgencias' TIPO,
                                                                                      --       EU_FHCREACION FHORA_EPISODIO,
                                                                                      --       DECODE (AU_CENTRO, '002083', 10004, AU_CENTRO) NATID_CENTRO,
                                                                                      --       NVL (EU_LUGAR_COD, -1) NATID_UNIDAD_FUNCIONAL
                                                                                      --  FROM CAE_OWN.ADMISION@DAE
                                                                                      --       JOIN CAE_OWN.EPISODIO_URGENCIAS@DAE
                                                                                      --          ON (AU_EPISODIO = EU_IDENTIFICADOR)
                                                                                      --       JOIN CAE_OWN.USUARIO@DAE
                                                                                      --          ON (AU_USUARIO = USU_ID)
                                                                                      -- WHERE AU_EPISODIO IS NOT NULL AND USU_BDU_NUSA IS NOT NULL
       );