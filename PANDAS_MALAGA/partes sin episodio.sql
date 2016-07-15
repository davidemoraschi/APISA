/* Formatted on 11/4/2014 2:20:50 PM (QP5 v5.163.1008.3004) */
  SELECT TRUNC (cab.fecha_hora_inicio, 'MM') fecha, COUNT (1) AS contador
    FROM REP_HIS_OWN.ADM_QRF_IQ_PRE@SEE43DAE pre, REP_HIS_OWN.ADM_QRF_PQ_DET@SEE43DAE det, REP_HIS_OWN.ADM_QRF_PQ_CAB@SEE43DAE cab
   WHERE     pre.episodio_id IS NULL
         AND pre.iq_pre_id = det.iq_pre_id
         AND det.pq_cab_id = cab.pq_cab_id
         AND pre.estado_id <> 2
         AND pre.estado_id <> 4
         AND det.iq_despr_id IS NULL
         AND modalidad_episodio (pre.id_usuario, cab.fecha_hora_inicio) = 1
         AND TRUNC (cab.fecha_hora_inicio) >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
GROUP BY TRUNC (cab.fecha_hora_inicio, 'MM');


CREATE TABLE TEMP_INTERVENCIONES_A202004
NOLOGGING
PARALLEL
NOMONITORING
AS
   SELECT                                                                                                                                                                                                        /*+DRIVING_SITE(ADM_EPISODIO)*/
   RANK() OVER(PARTITION BY USUARIO, T.NATID_FECHA_INICIO_PARTE ORDER BY E.FCH_APERTURA DESC, E.HORA_APERTURA DESC) R,
         EPISODIO_ID,
          MODALIDAD_ASIST,
          USUARIO,
          NATID_DETALLE_PARTE,
          T.NATID_FECHA_INICIO_PARTE,
                  (FCH_APERTURA + (HORA_APERTURA - TRUNC (HORA_APERTURA))) NATID_FECHA_INICIO_EPISODIO,
                  (FCH_CIERRE + (HORA_CIERRE - TRUNC (HORA_CIERRE))) NATID_FECHA_FIN_EPISODIO,
          E.FCH_CIERRE,
          E.HORA_CIERRE
     FROM REP_HIS_OWN.ADM_EPISODIO@SEE43DAE E JOIN TEMP_INTERVENCIONES_A102004 T ON (E.USUARIO = T.NATID_USUARIO)
    WHERE T.NATID_EPISODIO < 0 
    AND E.MODALIDAD_ASIST <> 4 
    AND TRUNC(T.NATID_FECHA_INICIO_PARTE) >= E.FCH_APERTURA 
    AND 
            (E.FCH_CIERRE IS NULL 
            OR 
                (TRUNC(T.NATID_FECHA_INICIO_PARTE) <= E.FCH_CIERRE 
                ));
/

SELECT TRUNC(NATID_FECHA_INICIO_PARTE,'MM') F, COUNT(*) N FROM TEMP_INTERVENCIONES_A202004
WHERE MODALIDAD_ASIST = 1
AND TRUNC(NATID_FECHA_INICIO_EPISODIO) <> TRUNC(NATID_FECHA_FIN_EPISODIO)
GROUP BY TRUNC(NATID_FECHA_INICIO_PARTE,'MM');      

DELETE FROM TEMP_INTERVENCIONES_A202004
WHERE R > 1;