          SELECT *
            FROM (  SELECT TRUNC (cab.fecha_hora_inicio, 'MM') fecha, COUNT (1) AS contador
                      FROM REP_HIS_OWN.ADM_QRF_IQ_PRE@SEE41DAE pre, REP_HIS_OWN.ADM_QRF_PQ_DET@SEE41DAE det, REP_HIS_OWN.ADM_QRF_PQ_CAB@SEE41DAE cab
                     WHERE     pre.episodio_id IS NULL
                           AND pre.iq_pre_id = det.iq_pre_id
                           AND det.pq_cab_id = cab.pq_cab_id
                           AND pre.estado_id <> 2
                           AND pre.estado_id <> 4
                           AND det.iq_despr_id IS NULL
                           AND modalidad_episodio (pre.id_usuario, cab.fecha_hora_inicio) = 1
                           AND TRUNC (cab.fecha_hora_inicio) >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
                  GROUP BY TRUNC (cab.fecha_hora_inicio, 'MM'))--)
;

/* Formatted on 10/29/2014 2:09:50 PM (QP5 v5.163.1008.3004) */
WITH SINEPISODIO
     AS (SELECT DISTINCT ID_USUARIO, CAB.FECHA_HORA_INICIO --, cab.fecha_hora_fin                                                                                                         --TRUNC (cab.fecha_hora_inicio, 'MM') fecha, COUNT (1) AS contador
           FROM REP_HIS_OWN.ADM_QRF_IQ_PRE@SEE41DAE PRE, REP_HIS_OWN.ADM_QRF_PQ_DET@SEE41DAE DET, REP_HIS_OWN.ADM_QRF_PQ_CAB@SEE41DAE CAB
          WHERE     PRE.EPISODIO_ID IS NULL
                AND PRE.IQ_PRE_ID = DET.IQ_PRE_ID
                AND DET.PQ_CAB_ID = CAB.PQ_CAB_ID
                AND PRE.ESTADO_ID <> 2
                AND PRE.ESTADO_ID <> 4
                AND DET.IQ_DESPR_ID IS NULL                                                                                                                                 --AND modalidad_episodio (pre.id_usuario, cab.fecha_hora_inicio) = 1
                AND TRUNC (CAB.FECHA_HORA_INICIO) >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
                --AND ID_USUARIO = 83765
                --AND TRUNC (CAB.FECHA_HORA_INICIO, 'MM') = '1-SEP-2014'                                                                                                                                                  --AND MODAL_ASIST_ID = 1
                                                                      )
SELECT * FROM (                                                                      
  SELECT EPISODIO_ID, MODALIDAD_ASIST, USUARIO, FCH_APERTURA, HORA_APERTURA, FCH_CIERRE, HORA_CIERRE, FECHA_HORA_INICIO, RANK() OVER(PARTITION BY USUARIO, FECHA_HORA_INICIO ORDER BY EPI.FCH_APERTURA DESC, EPI.HORA_APERTURA DESC) R
    FROM REP_HIS_OWN.ADM_EPISODIO@SEE41DAE EPI JOIN SINEPISODIO ON (EPI.USUARIO = SINEPISODIO.ID_USUARIO)
   WHERE     ( (TRUNC (EPI.FCH_APERTURA, 'dd') <> TRUNC (EPI.FCH_CIERRE, 'dd') AND TRUNC (SINEPISODIO.FECHA_HORA_INICIO, 'dd') <= EPI.FCH_CIERRE) OR EPI.FCH_CIERRE IS NULL)
         AND TRUNC (SINEPISODIO.FECHA_HORA_INICIO, 'dd') >= EPI.FCH_APERTURA
         AND EPI.MODALIDAD_ASIST = 1
ORDER BY USUARIO, EPI.FCH_APERTURA DESC, EPI.HORA_APERTURA DESC)
WHERE R = 1;

/

SELECT DISTINCT ID_USUARIO, cab.fecha_hora_inicio --, cab.fecha_hora_fin                                                                                                         --TRUNC (cab.fecha_hora_inicio, 'MM') fecha, COUNT (1) AS contador
  FROM REP_HIS_OWN.ADM_QRF_IQ_PRE@SEE41DAE pre, REP_HIS_OWN.ADM_QRF_PQ_DET@SEE41DAE det, REP_HIS_OWN.ADM_QRF_PQ_CAB@SEE41DAE cab
 WHERE     pre.episodio_id IS NULL
       AND pre.iq_pre_id = det.iq_pre_id
       AND det.pq_cab_id = cab.pq_cab_id
       AND pre.estado_id <> 2
       AND pre.estado_id <> 4
       AND det.iq_despr_id IS NULL                                                                                                                                          --AND modalidad_episodio (pre.id_usuario, cab.fecha_hora_inicio) = 1
       AND TRUNC (cab.fecha_hora_inicio) >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
       AND TRUNC (cab.fecha_hora_inicio, 'MM') = '1-SEP-2014'                                                                                                                                                           --AND MODAL_ASIST_ID = 1
--AND PREING_DET_ID = 2274075-- IS NOT NULL
/

SELECT *
  FROM REP_HIS_OWN.ADM_PREINGRESO_DET@SEE41DAE
 WHERE                                                                                                                                                                                                                    --PREINGRESO = 2278025
      PREING_DET_ID = 2274075
/

SELECT *
  FROM REP_HIS_OWN.ADM_PREINGRESO@SEE41DAE
 WHERE PREINGRESO_ID = 2278025
--PREINGRESO_ID = 2279727
/

SELECT *
  FROM REP_HIS_OWN.ADM_ADMISION@SEE41DAE
 WHERE                                                                                                                                                                                                                   --ADMISION_ID = 2130381
      SESION_PADRE = 2278025
/

SELECT *
  FROM REP_HIS_OWN.ADM_EPIS_DETALLE@SEE41DAE
 WHERE                                                                                                                                                                                                                  --EPISODIO_ID  = 2786076
      REFERENCIA_ID = 2130381
/

SELECT *
  FROM REP_HIS_OWN.ADM_EPISODIO@SEE41DAE
 WHERE EPISODIO_ID = 2786076