/* Formatted on 10/27/2014 1:24:49 PM (QP5 v5.163.1008.3004) */
  SELECT fecha, SUM (contador)
    FROM (  SELECT TRUNC (cab.fecha_hora_inicio, 'MM') FECHA, COUNT (1) AS contador
              FROM REP_HIS_OWN.ADM_QRF_IQ_PRE pre,
                   REP_HIS_OWN.ADM_QRF_PQ_DET det,
                   REP_HIS_OWN.ADM_QRF_PQ_CAB cab,
                   REP_HIS_OWN.ADM_EPISODIO epi
             WHERE     pre.episodio_id = epi.episodio_id
                   AND pre.iq_pre_id = det.iq_pre_id
                   AND det.pq_cab_id = cab.pq_cab_id
                   AND epi.modalidad_asist = 1
                   AND (epi.fch_cierre IS NULL OR (TRUNC (epi.fch_apertura, 'dd') <> TRUNC (epi.fch_cierre, 'dd')))
                   AND TRUNC (cab.fecha_hora_inicio) >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
                   AND pre.estado_id <> 2
                   AND pre.estado_id <> 4
                   AND det.iq_despr_id IS NULL
          GROUP BY TRUNC (cab.fecha_hora_inicio, 'MM')
          UNION ALL
          SELECT *
            FROM (  SELECT TRUNC (cab.fecha_hora_inicio, 'MM') fecha, COUNT (1) AS contador
                      FROM REP_HIS_OWN.ADM_QRF_IQ_PRE pre, REP_HIS_OWN.ADM_QRF_PQ_DET det, REP_HIS_OWN.ADM_QRF_PQ_CAB cab
                     WHERE     pre.episodio_id IS NULL
                           AND pre.iq_pre_id = det.iq_pre_id
                           AND det.pq_cab_id = cab.pq_cab_id
                           AND pre.estado_id <> 2
                           AND pre.estado_id <> 4
                           AND det.iq_despr_id IS NULL
                           AND modalidad_episodio (pre.id_usuario, cab.fecha_hora_inicio) = 1
                           AND TRUNC (cab.fecha_hora_inicio) >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
                  GROUP BY TRUNC (cab.fecha_hora_inicio, 'MM')))
GROUP BY fecha;