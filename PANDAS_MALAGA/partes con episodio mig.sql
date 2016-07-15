/* Formatted on 11/4/2014 12:37:53 PM (QP5 v5.163.1008.3004) */
CREATE TABLE ZZ_MIG_INTERVENCIONES_02004
NOLOGGING
PARALLEL
NOMONITORING
AS
   SELECT pre.IQ_PRE_ID,
          IQ_TIPO_ID,
          IQ_MOTIVO_ID,
          ESTADO_ID,
          ID_USUARIO,
          epi.EPISODIO_ID,
          MODAL_ASIST_ID,
          CANT_BS,
          DURACION_PREVISTA,
          EPIS_EXTERNO,
          ADMISION_ID,
          --       OBSERVACIONES,
          COD_ADM_QRF_IQ_ANESTESIA_PRE,
          TIPO_PROGRAMACION,
          CUIDADOS_POST,
          --ACTIVO,
          ENVIO_MSG,
          QUIRURGICA,
          FH_PREVISTA_PREINGRESO,
          PERNOCTA,
          ANESTESIA_ID,
          SESION_PROGRAMADA,
          PQ_DET_ID,
          cab.PQ_CAB_ID,
          --       IQ_PRE_ID_1,
          ORDEN,
          RESERVA_SN_PRE,
          QUIROFANO_ID_PRE,
          FH_REGISTRO_IQ_PRE,
          HORA_REGISTRO_IQ_PRE,
          OPERADOR_PRE_ID,
          IQ_POST_ID,
          FH_REGISTRO_IQ_POST,
          HORA_REGISTRO_IQ_POST,
          OPERADOR_POST_ID,
          IQ_DESPR_ID,
          CARAC_ECONOM_ID_PRE,
          TPLANIFICAC_PRE_ID,
          ESTADO_ID_PRE,
          PREING_DET_ID,
          FECHA_HORA_CIERRE,
          OPERADOR_VALIDACION,
          FECHA_HORA_VALIDACION,
          FH_PRIMER_CIERRE,
          --       PQ_CAB_ID_1,
          TURNO_ID,
          CENTRO_ID,
          UNI_FUNCIONAL_ID,
          FECHA_HORA_INICIO,
          CARAC_ECONOM_ID,
          ESTADO,
          OPERADOR_ID,
          OPERADOR_CIERRE_ID,
          FECHA_HORA_REGISTRO,
          HORA_REGISTRO,
          --       ACTIVO_1,
          FECHA_HORA_FIN,
          ESTADO_VALIDACION,
          QUIROFANO,
          BLOQUE_PERIODICO_ID,
          CENTRO_CITA,
          UF_CITA,
          EPISODIO_REFERENCIA,
          --       EPISODIO_ID_1,
          MODALIDAD_ASIST,
          USUARIO,
          FCH_APERTURA,
          FCH_CIERRE,
          HORA_APERTURA,
          HORA_CIERRE,
          --       OBSERVACIONES_1,
          EPIS_PADRE,
          EPIS_PADRE_EXTERNO
     --TRUNC (cab.fecha_hora_inicio, 'MM') FECHA, COUNT (1) AS contador
     FROM REP_HIS_OWN.ADM_QRF_IQ_PRE@SEE43DAE pre,
          REP_HIS_OWN.ADM_QRF_PQ_DET@SEE43DAE det,
          REP_HIS_OWN.ADM_QRF_PQ_CAB@SEE43DAE cab,
          REP_HIS_OWN.ADM_EPISODIO@SEE43DAE epi
    WHERE     pre.episodio_id = epi.episodio_id
          AND pre.iq_pre_id = det.iq_pre_id
          AND det.pq_cab_id = cab.pq_cab_id
          AND epi.modalidad_asist = 1
          AND (epi.fch_cierre IS NULL OR (TRUNC (epi.fch_apertura, 'dd') <> TRUNC (epi.fch_cierre, 'dd')))
          AND TRUNC (cab.fecha_hora_inicio) >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
          AND pre.estado_id <> 2
          AND pre.estado_id <> 4
          AND det.iq_despr_id IS NULL
--GROUP BY TRUNC (cab.fecha_hora_inicio, 'MM')