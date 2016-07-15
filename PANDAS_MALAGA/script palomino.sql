/* Formatted on 10/29/2014 5:11:22 PM (QP5 v5.163.1008.3004) */
CREATE OR REPLACE PACKAGE BODY "PKG_UPDATE_KPI_QUI"
IS
   --============================================================================--
   --==========================MODULO DE QUIRURGICO==============================--
   --============================================================================--

   PROCEDURE QUI_N_INTERV
   IS
      --Numero de intervenciones programadas y realizadas en el ambito de hospitalizacion, con , al menos, 1 dia de estancia en el hospital.

      l_mensaje_error   KPI_ERRORES.error%TYPE;

      secuencia         NUMBER;
   BEGIN
      SELECT own_kpi.SEQ_LANZAMIENTO.NEXTVAL INTO secuencia FROM DUAL;

      INSERT INTO own_kpi.CONTROL_LANZAMIENTO (ID, PROCEDIMIENTO, FECHA_INI)
           VALUES (secuencia, 'QUI_N_INTERV', SYSDATE);

      COMMIT;


      DELETE FROM OWN_KPI.KPI_QUI_N_INTERV
            WHERE fecha >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM');

      --estado de intervencion 2 desprogramada, 4 suspendida
      INSERT INTO OWN_KPI.KPI_QUI_N_INTERV (FECHA, contador)
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

      UPDATE own_kpi.CONTROL_LANZAMIENTO
         SET fecha_fin = SYSDATE
       WHERE id = secuencia;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         l_mensaje_error := SUBSTR (DBMS_UTILITY.format_error_stack (), 1, 1999);

         INSERT INTO OWN_KPI.KPI_ERRORES (fecha_error, KPI_NAME, error)
              VALUES (SYSDATE, 'QUI_N_INTERV', l_mensaje_error);

         UPDATE own_kpi.CONTROL_LANZAMIENTO
            SET fecha_fin = SYSDATE, PROCEDIMIENTO = ('QUI_N_INTERV ERROR: ' || l_mensaje_error)
          WHERE id = secuencia;

         COMMIT;
   END QUI_N_INTERV;

   PROCEDURE QUI_N_INTERV_FIRM
   IS
      --Numero de intervenciones programadas y realizadas en el ambito de hospitalizacion, con, al menos, 1 dia de estancia , en las que se ha realizado el circuito quirurgico completo.

      l_mensaje_error   KPI_ERRORES.error%TYPE;

      secuencia         NUMBER;
   BEGIN
      SELECT own_kpi.SEQ_LANZAMIENTO.NEXTVAL INTO secuencia FROM DUAL;

      INSERT INTO own_kpi.CONTROL_LANZAMIENTO (ID, PROCEDIMIENTO, FECHA_INI)
           VALUES (secuencia, 'QUI_N_INTERV_FIRM', SYSDATE);

      COMMIT;

      DELETE FROM OWN_KPI.KPI_QUI_N_INTERV_FIRM
            WHERE fecha >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM');

      INSERT INTO OWN_KPI.KPI_QUI_N_INTERV_FIRM (FECHA, contador)
           SELECT fecha, SUM (contador)
             FROM (  SELECT TRUNC (cab.fecha_hora_inicio, 'MM') FECHA, COUNT (1) AS contador
                       FROM REP_HIS_OWN.ADM_QRF_IQ_PRE pre,
                            REP_HIS_OWN.ADM_EPISODIO epi,
                            REP_HIS_OWN.ADM_QRF_PQ_DET det,
                            REP_HIS_OWN.ADM_QRF_PQ_CAB cab
                      WHERE     pre.episodio_id = epi.episodio_id
                            AND det.iq_pre_id = pre.iq_pre_id
                            AND det.pq_cab_id = cab.pq_cab_id
                            AND epi.modalidad_asist = 1
                            AND det.iq_post_id IS NOT NULL
                            AND (TRUNC (epi.fch_apertura, 'dd') <> TRUNC (epi.fch_cierre, 'dd'))
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
                                    AND det.iq_post_id IS NOT NULL
                                    AND modalidad_episodio (pre.id_usuario, cab.fecha_hora_inicio) = 1
                                    AND TRUNC (cab.fecha_hora_inicio) >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
                           GROUP BY TRUNC (cab.fecha_hora_inicio, 'MM')))
         GROUP BY fecha;

      UPDATE own_kpi.CONTROL_LANZAMIENTO
         SET fecha_fin = SYSDATE
       WHERE id = secuencia;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         l_mensaje_error := SUBSTR (DBMS_UTILITY.format_error_stack (), 1, 1999);

         INSERT INTO OWN_KPI.KPI_ERRORES (fecha_error, KPI_NAME, error)
              VALUES (SYSDATE, 'QUI_N_INTERV_FIRM', l_mensaje_error);

         UPDATE own_kpi.CONTROL_LANZAMIENTO
            SET fecha_fin = SYSDATE, PROCEDIMIENTO = ('QUI_N_INTERV_FIRM ERROR: ' || l_mensaje_error)
          WHERE id = secuencia;

         COMMIT;
   END QUI_N_INTERV_FIRM;

   PROCEDURE QUI_N_INTERV_MENOS_UNO
   IS
      --Numero de intervenciones  programadas y realizadas en el ambito de hospitalizacion, con menos de 1 dia de estancia en el hospital.

      l_mensaje_error   KPI_ERRORES.error%TYPE;

      secuencia         NUMBER;
   BEGIN
      SELECT own_kpi.SEQ_LANZAMIENTO.NEXTVAL INTO secuencia FROM DUAL;

      INSERT INTO own_kpi.CONTROL_LANZAMIENTO (ID, PROCEDIMIENTO, FECHA_INI)
           VALUES (secuencia, 'QUI_N_INTERV_MENOS_UNO', SYSDATE);

      COMMIT;

      DELETE FROM OWN_KPI.KPI_QUI_N_INTERV_MENOS_UNO
            WHERE fecha >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM');

      INSERT INTO OWN_KPI.KPI_QUI_N_INTERV_MENOS_UNO (FECHA, contador)
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
                            AND epi.fch_cierre IS NOT NULL
                            AND epi.fch_apertura = epi.fch_cierre
                            AND pre.estado_id <> 2
                            AND pre.estado_id <> 4
                            AND det.iq_despr_id IS NULL
                            AND TRUNC (cab.fecha_hora_inicio) >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
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
                                    AND modalidad_episodio_un_dia (pre.id_usuario, cab.fecha_hora_inicio) = 1
                                    AND TRUNC (cab.fecha_hora_inicio) >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
                           GROUP BY TRUNC (cab.fecha_hora_inicio, 'MM')))
         GROUP BY fecha;

      UPDATE own_kpi.CONTROL_LANZAMIENTO
         SET fecha_fin = SYSDATE
       WHERE id = secuencia;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         l_mensaje_error := SUBSTR (DBMS_UTILITY.format_error_stack (), 1, 1999);

         INSERT INTO OWN_KPI.KPI_ERRORES (fecha_error, KPI_NAME, error)
              VALUES (SYSDATE, 'QUI_N_INTERV_MENOS_UNO', l_mensaje_error);

         UPDATE own_kpi.CONTROL_LANZAMIENTO
            SET fecha_fin = SYSDATE, PROCEDIMIENTO = ('QUI_N_INTERV_MENOS_UNO ERROR: ' || l_mensaje_error)
          WHERE id = secuencia;

         COMMIT;
   END QUI_N_INTERV_MENOS_UNO;

   PROCEDURE QUI_N_INTERV_FIRM_M_UNO
   IS
      --Numero de intervenciones programadas y realizadas en el ambito de hospitalizacion, con menos de 1 dia de estancia, en las que se ha realizado el circuito quirurgico completo.

      l_mensaje_error   KPI_ERRORES.error%TYPE;

      secuencia         NUMBER;
   BEGIN
      SELECT own_kpi.SEQ_LANZAMIENTO.NEXTVAL INTO secuencia FROM DUAL;

      INSERT INTO own_kpi.CONTROL_LANZAMIENTO (ID, PROCEDIMIENTO, FECHA_INI)
           VALUES (secuencia, 'QUI_N_INTERV_FIRM_M_UNO', SYSDATE);

      COMMIT;

      DELETE FROM OWN_KPI.KPI_QUI_N_INTERV_FIRM_M_UNO
            WHERE fecha >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM');

      INSERT INTO OWN_KPI.KPI_QUI_N_INTERV_FIRM_M_UNO (FECHA, contador)
           SELECT fecha, SUM (contador)
             FROM (  SELECT TRUNC (cab.fecha_hora_inicio, 'MM') FECHA, COUNT (1) AS contador
                       FROM REP_HIS_OWN.ADM_QRF_IQ_PRE pre,
                            REP_HIS_OWN.ADM_EPISODIO epi,
                            REP_HIS_OWN.ADM_QRF_PQ_DET det,
                            REP_HIS_OWN.ADM_QRF_PQ_CAB cab
                      WHERE     pre.episodio_id = epi.episodio_id
                            AND det.iq_pre_id = pre.iq_pre_id
                            AND det.pq_cab_id = cab.pq_cab_id
                            AND epi.modalidad_asist = 1
                            AND epi.fch_cierre IS NOT NULL
                            AND epi.fch_apertura = epi.fch_cierre
                            AND det.iq_post_id IS NOT NULL
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
                                    AND det.iq_post_id IS NOT NULL
                                    AND pre.estado_id <> 2
                                    AND pre.estado_id <> 4
                                    AND det.iq_despr_id IS NULL
                                    AND modalidad_episodio_un_dia (pre.id_usuario, cab.fecha_hora_inicio) = 1
                                    AND TRUNC (cab.fecha_hora_inicio) >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
                           GROUP BY TRUNC (cab.fecha_hora_inicio, 'MM')))
         GROUP BY fecha;

      UPDATE own_kpi.CONTROL_LANZAMIENTO
         SET fecha_fin = SYSDATE
       WHERE id = secuencia;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         l_mensaje_error := SUBSTR (DBMS_UTILITY.format_error_stack (), 1, 1999);

         INSERT INTO OWN_KPI.KPI_ERRORES (fecha_error, KPI_NAME, error)
              VALUES (SYSDATE, 'QUI_N_INTERV_FIRM_M_UNO', l_mensaje_error);

         UPDATE own_kpi.CONTROL_LANZAMIENTO
            SET fecha_fin = SYSDATE, PROCEDIMIENTO = ('QUI_N_INTERV_FIRM_M_UNO ERROR: ' || l_mensaje_error)
          WHERE id = secuencia;

         COMMIT;
   END QUI_N_INTERV_FIRM_M_UNO;

   PROCEDURE QUI_N_INTERV_CMA
   IS
      --Numero de intervenciones de CMA programadas y realizadas en el ambito de HDQ con 0 dias de estancia, o 1 dia si se interviene en horario de tarde.

      l_mensaje_error   KPI_ERRORES.error%TYPE;

      secuencia         NUMBER;
   BEGIN
      SELECT own_kpi.SEQ_LANZAMIENTO.NEXTVAL INTO secuencia FROM DUAL;

      INSERT INTO own_kpi.CONTROL_LANZAMIENTO (ID, PROCEDIMIENTO, FECHA_INI)
           VALUES (secuencia, 'QUI_N_INTERV_CMA', SYSDATE);

      COMMIT;

      DELETE FROM OWN_KPI.KPI_QUI_N_INTERV_CMA
            WHERE fecha >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM');

      INSERT INTO OWN_KPI.KPI_QUI_N_INTERV_CMA (FECHA, contador)
           SELECT fecha, SUM (contador)
             FROM (  SELECT TRUNC (fecha, 'MM') fecha, COUNT (1) AS contador
                       FROM ( (SELECT DISTINCT cab.fecha_hora_inicio fecha, pre.iq_pre_id iqpre
                                 FROM REP_HIS_OWN.ADM_QRF_IQ_PRE pre,
                                      REP_HIS_OWN.ADM_QRF_PQ_DET det,
                                      REP_HIS_OWN.ADM_QRF_PQ_CAB cab,
                                      REP_HIS_OWN.ADM_EPISODIO epi,
                                      REP_HIS_OWN.ADM_ADMISION ADM,
                                      REP_HIS_OWN.ADM_EPIS_DETALLE EPIDET,
                                      REP_HIS_OWN.ADM_QRF_IQ_ICD_PRE ICD,
                                      own_kpi.kpi_cma_2013 cma
                                WHERE     PRE.EPISODIO_ID = EPI.EPISODIO_ID
                                      AND ICD.CODIGO_PROC = CMA.CODIGO_CIE
                                      AND icd.DIAGN_PROCE = 'P'
                                      AND icd.iq_pre_id = pre.iq_pre_id
                                      AND det.iq_pre_id = pre.iq_pre_id
                                      AND det.pq_cab_id = cab.pq_cab_id
                                      AND EPI.EPISODIO_ID = EPIDET.EPISODIO_ID
                                      AND pre.episodio_id = epi.episodio_id
                                      AND epidet.referencia_id = adm.admision_id
                                      AND epi.modalidad_asist = 2
                                      AND epi.fch_cierre IS NOT NULL
                                      AND (epi.fch_apertura = epi.fch_cierre - 1 AND TO_CHAR (epi.hora_cierre, 'HH24') <= '15' AND TO_CHAR (cab.fecha_hora_inicio, 'HH24') >= '15')
                                      AND adm.destino_alta <> 7
                                      AND adm.motivo_alta <> 6
                                      AND TRUNC (cab.fecha_hora_inicio) >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
                                      AND cab.fecha_hora_inicio < SYSDATE
                                      AND pre.estado_id <> 2
                                      AND PRE.ESTADO_ID <> 4
                                      AND det.iq_despr_id IS NULL)
                             UNION ALL
                             (SELECT DISTINCT cab.fecha_hora_inicio fecha, pre.iq_pre_id iqpre
                                FROM REP_HIS_OWN.ADM_QRF_IQ_PRE pre,
                                     REP_HIS_OWN.ADM_QRF_PQ_DET det,
                                     REP_HIS_OWN.ADM_QRF_PQ_CAB cab,
                                     REP_HIS_OWN.ADM_EPISODIO epi,
                                     REP_HIS_OWN.ADM_ADMISION adm,
                                     REP_HIS_OWN.ADM_EPIS_DETALLE epidet,
                                     REP_HIS_OWN.ADM_QRF_IQ_ICD_PRE ICD,
                                     own_kpi.kpi_cma_2013 cma
                               WHERE     PRE.EPISODIO_ID = EPI.EPISODIO_ID
                                     AND ICD.CODIGO_PROC = CMA.CODIGO_CIE
                                     AND icd.DIAGN_PROCE = 'P'
                                     AND icd.iq_pre_id = pre.iq_pre_id
                                     AND det.iq_pre_id = pre.iq_pre_id
                                     AND det.pq_cab_id = cab.pq_cab_id
                                     AND epi.episodio_id = epidet.episodio_id
                                     AND pre.episodio_id = epi.episodio_id
                                     AND epidet.referencia_id = adm.admision_id
                                     AND epi.modalidad_asist = 2
                                     AND epi.fch_cierre IS NOT NULL
                                     AND (adm.fch_ingreso = adm.fch_alta)
                                     AND adm.destino_alta <> 7
                                     AND adm.motivo_alta <> 6
                                     AND TRUNC (cab.fecha_hora_inicio) >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
                                     AND cab.fecha_hora_inicio < SYSDATE
                                     AND pre.estado_id <> 2
                                     AND pre.estado_id <> 4
                                     AND det.iq_despr_id IS NULL))
                   GROUP BY TRUNC (fecha, 'MM'), iqpre
                   UNION ALL
                     --A CONTINUACION VIENEN LOS QUE NO TIENEN EPISODIO ASOCIADO
                     SELECT TRUNC (fecha, 'MM') fecha, COUNT (1) AS contador
                       FROM ( (SELECT DISTINCT cab.fecha_hora_inicio fecha, pre.iq_pre_id iqpre
                                 FROM REP_HIS_OWN.ADM_QRF_IQ_PRE pre,
                                      REP_HIS_OWN.ADM_QRF_PQ_DET det,
                                      REP_HIS_OWN.ADM_QRF_PQ_CAB cab,
                                      REP_HIS_OWN.ADM_QRF_IQ_ICD_PRE ICD,
                                      own_kpi.kpi_cma_2013 cma
                                WHERE     PRE.EPISODIO_ID IS NULL
                                      AND ICD.CODIGO_PROC = CMA.CODIGO_CIE
                                      AND icd.DIAGN_PROCE = 'P'
                                      AND icd.iq_pre_id = pre.iq_pre_id
                                      AND det.iq_pre_id = pre.iq_pre_id
                                      AND det.pq_cab_id = cab.pq_cab_id
                                      AND modalidad_episodio_cma_1 (pre.id_usuario, cab.fecha_hora_inicio) = 2
                                      AND TRUNC (CAB.FECHA_HORA_INICIO) >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
                                      AND pre.estado_id <> 2
                                      AND pre.estado_id <> 4
                                      AND det.iq_despr_id IS NULL)
                             UNION ALL
                             (SELECT DISTINCT cab.fecha_hora_inicio fecha, pre.iq_pre_id iqpre
                                FROM REP_HIS_OWN.ADM_QRF_IQ_PRE pre,
                                     REP_HIS_OWN.ADM_QRF_PQ_DET det,
                                     REP_HIS_OWN.ADM_QRF_PQ_CAB cab,
                                     REP_HIS_OWN.ADM_QRF_IQ_ICD_PRE ICD,
                                     own_kpi.kpi_cma_2013 cma
                               WHERE     PRE.EPISODIO_ID IS NULL
                                     AND ICD.CODIGO_PROC = CMA.CODIGO_CIE
                                     AND icd.DIAGN_PROCE = 'P'
                                     AND icd.iq_pre_id = pre.iq_pre_id
                                     AND det.iq_pre_id = pre.iq_pre_id
                                     AND det.pq_cab_id = cab.pq_cab_id
                                     AND modalidad_episodio_cma_2 (pre.id_usuario, cab.fecha_hora_inicio) = 2
                                     AND TRUNC (cab.fecha_hora_inicio) >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
                                     AND cab.fecha_hora_inicio < SYSDATE
                                     AND pre.estado_id <> 2
                                     AND pre.estado_id <> 4
                                     AND det.iq_despr_id IS NULL))
                   GROUP BY TRUNC (fecha, 'MM'), iqpre)
         GROUP BY fecha;

      UPDATE own_kpi.CONTROL_LANZAMIENTO
         SET fecha_fin = SYSDATE
       WHERE id = secuencia;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         l_mensaje_error := SUBSTR (DBMS_UTILITY.format_error_stack (), 1, 1999);

         INSERT INTO OWN_KPI.KPI_ERRORES (fecha_error, KPI_NAME, error)
              VALUES (SYSDATE, 'QUI_N_INTERV_CMA', l_mensaje_error);

         UPDATE own_kpi.CONTROL_LANZAMIENTO
            SET fecha_fin = SYSDATE, PROCEDIMIENTO = ('QUI_N_INTERV_CMA ERROR: ' || l_mensaje_error)
          WHERE id = secuencia;

         COMMIT;
   END QUI_N_INTERV_CMA;

   PROCEDURE QUI_N_INTERV_FIRM_CMA
   IS
      --Numero de intervenciones de CMA programadas y realizadas en el ambito de HDQ con 0 dias de estancia, o 1 dia si se interviene en horario de tarde, en las que se ha realizado el circuito quirurgico completo.

      l_mensaje_error   KPI_ERRORES.error%TYPE;

      secuencia         NUMBER;
   BEGIN
      SELECT own_kpi.SEQ_LANZAMIENTO.NEXTVAL INTO secuencia FROM DUAL;

      INSERT INTO own_kpi.CONTROL_LANZAMIENTO (ID, PROCEDIMIENTO, FECHA_INI)
           VALUES (secuencia, 'QUI_N_INTERV_FIRM_CMA', SYSDATE);

      COMMIT;

      DELETE FROM OWN_KPI.KPI_QUI_N_INTERV_FIRM_CMA
            WHERE fecha >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM');

      INSERT INTO OWN_KPI.KPI_QUI_N_INTERV_FIRM_CMA (FECHA, contador)
           SELECT fecha, SUM (contador)
             FROM (  SELECT TRUNC (fecha, 'MM') fecha, COUNT (1) AS contador
                       FROM ( (SELECT DISTINCT cab.fecha_hora_inicio fecha, pre.iq_pre_id iqpre
                                 FROM REP_HIS_OWN.ADM_QRF_IQ_PRE pre,
                                      REP_HIS_OWN.ADM_QRF_PQ_DET det,
                                      REP_HIS_OWN.ADM_QRF_PQ_CAB cab,
                                      REP_HIS_OWN.ADM_EPISODIO epi,
                                      REP_HIS_OWN.ADM_ADMISION ADM,
                                      REP_HIS_OWN.ADM_EPIS_DETALLE EPIDET,
                                      REP_HIS_OWN.ADM_QRF_IQ_ICD_PRE ICD,
                                      own_kpi.kpi_cma_2013 cma
                                WHERE     PRE.EPISODIO_ID = EPI.EPISODIO_ID
                                      AND ICD.CODIGO_PROC = CMA.CODIGO_CIE
                                      AND icd.DIAGN_PROCE = 'P'
                                      AND icd.iq_pre_id = pre.iq_pre_id
                                      AND det.iq_pre_id = pre.iq_pre_id
                                      AND det.pq_cab_id = cab.pq_cab_id
                                      AND det.iq_post_id IS NOT NULL
                                      AND EPI.EPISODIO_ID = EPIDET.EPISODIO_ID
                                      AND pre.episodio_id = epi.episodio_id
                                      AND epidet.referencia_id = adm.admision_id
                                      AND epi.modalidad_asist = 2
                                      AND epi.fch_cierre IS NOT NULL
                                      AND (epi.fch_apertura = epi.fch_cierre - 1 AND TO_CHAR (epi.hora_cierre, 'HH24') <= '15' AND TO_CHAR (cab.fecha_hora_inicio, 'HH24') >= '15')
                                      AND adm.destino_alta <> 7
                                      AND adm.motivo_alta <> 6
                                      AND TRUNC (cab.fecha_hora_inicio) >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
                                      AND cab.fecha_hora_inicio < SYSDATE
                                      AND pre.estado_id <> 2
                                      AND PRE.ESTADO_ID <> 4
                                      AND det.iq_despr_id IS NULL)
                             UNION ALL
                             (SELECT DISTINCT cab.fecha_hora_inicio fecha, pre.iq_pre_id iqpre
                                FROM REP_HIS_OWN.ADM_QRF_IQ_PRE pre,
                                     REP_HIS_OWN.ADM_QRF_PQ_DET det,
                                     REP_HIS_OWN.ADM_QRF_PQ_CAB cab,
                                     REP_HIS_OWN.ADM_EPISODIO epi,
                                     REP_HIS_OWN.ADM_ADMISION adm,
                                     REP_HIS_OWN.ADM_EPIS_DETALLE epidet,
                                     REP_HIS_OWN.ADM_QRF_IQ_ICD_PRE ICD,
                                     own_kpi.kpi_cma_2013 cma
                               WHERE     PRE.EPISODIO_ID = EPI.EPISODIO_ID
                                     AND ICD.CODIGO_PROC = CMA.CODIGO_CIE
                                     AND icd.DIAGN_PROCE = 'P'
                                     AND icd.iq_pre_id = pre.iq_pre_id
                                     AND det.iq_pre_id = pre.iq_pre_id
                                     AND det.pq_cab_id = cab.pq_cab_id
                                     AND det.iq_post_id IS NOT NULL
                                     AND epi.episodio_id = epidet.episodio_id
                                     AND pre.episodio_id = epi.episodio_id
                                     AND epidet.referencia_id = adm.admision_id
                                     AND epi.modalidad_asist = 2
                                     AND epi.fch_cierre IS NOT NULL
                                     AND (adm.fch_ingreso = adm.fch_alta)
                                     AND adm.destino_alta <> 7
                                     AND adm.motivo_alta <> 6
                                     AND TRUNC (cab.fecha_hora_inicio) >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
                                     AND cab.fecha_hora_inicio < SYSDATE
                                     AND pre.estado_id <> 2
                                     AND pre.estado_id <> 4
                                     AND det.iq_despr_id IS NULL))
                   GROUP BY TRUNC (fecha, 'MM'), iqpre
                   UNION ALL
                     --A CONTINUACION VIENEN LOS QUE NO TIENEN EPISODIO ASOCIADO
                     SELECT TRUNC (fecha, 'MM') fecha, COUNT (1) AS contador
                       FROM ( (SELECT DISTINCT cab.fecha_hora_inicio fecha, pre.iq_pre_id iqpre
                                 FROM REP_HIS_OWN.ADM_QRF_IQ_PRE pre,
                                      REP_HIS_OWN.ADM_QRF_PQ_DET det,
                                      REP_HIS_OWN.ADM_QRF_PQ_CAB cab,
                                      REP_HIS_OWN.ADM_QRF_IQ_ICD_PRE ICD,
                                      own_kpi.kpi_cma_2013 cma
                                WHERE     PRE.EPISODIO_ID IS NULL
                                      AND det.iq_post_id IS NOT NULL
                                      AND ICD.CODIGO_PROC = CMA.CODIGO_CIE
                                      AND icd.DIAGN_PROCE = 'P'
                                      AND icd.iq_pre_id = pre.iq_pre_id
                                      AND det.iq_pre_id = pre.iq_pre_id
                                      AND det.pq_cab_id = cab.pq_cab_id
                                      AND modalidad_episodio_cma_1 (pre.id_usuario, cab.fecha_hora_inicio) = 2
                                      AND TRUNC (CAB.FECHA_HORA_INICIO) >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
                                      AND pre.estado_id <> 2
                                      AND pre.estado_id <> 4
                                      AND det.iq_despr_id IS NULL)
                             UNION ALL
                             (SELECT DISTINCT cab.fecha_hora_inicio fecha, pre.iq_pre_id iqpre
                                FROM REP_HIS_OWN.ADM_QRF_IQ_PRE pre,
                                     REP_HIS_OWN.ADM_QRF_PQ_DET det,
                                     REP_HIS_OWN.ADM_QRF_PQ_CAB cab,
                                     REP_HIS_OWN.ADM_QRF_IQ_ICD_PRE ICD,
                                     own_kpi.kpi_cma_2013 cma
                               WHERE     PRE.EPISODIO_ID IS NULL
                                     AND det.iq_post_id IS NOT NULL
                                     AND ICD.CODIGO_PROC = CMA.CODIGO_CIE
                                     AND icd.DIAGN_PROCE = 'P'
                                     AND icd.iq_pre_id = pre.iq_pre_id
                                     AND det.iq_pre_id = pre.iq_pre_id
                                     AND det.pq_cab_id = cab.pq_cab_id
                                     AND modalidad_episodio_cma_2 (pre.id_usuario, cab.fecha_hora_inicio) = 2
                                     AND TRUNC (cab.fecha_hora_inicio) >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
                                     AND cab.fecha_hora_inicio < SYSDATE
                                     AND pre.estado_id <> 2
                                     AND pre.estado_id <> 4
                                     AND det.iq_despr_id IS NULL))
                   GROUP BY TRUNC (fecha, 'MM'), iqpre)
         GROUP BY fecha;

      UPDATE own_kpi.CONTROL_LANZAMIENTO
         SET fecha_fin = SYSDATE
       WHERE id = secuencia;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         l_mensaje_error := SUBSTR (DBMS_UTILITY.format_error_stack (), 1, 1999);

         INSERT INTO OWN_KPI.KPI_ERRORES (fecha_error, KPI_NAME, error)
              VALUES (SYSDATE, 'QUI_N_INTERV_FIRM_CMA', l_mensaje_error);

         UPDATE own_kpi.CONTROL_LANZAMIENTO
            SET fecha_fin = SYSDATE, PROCEDIMIENTO = ('QUI_N_INTERV_FIRM_CMA ERROR: ' || l_mensaje_error)
          WHERE id = secuencia;

         COMMIT;
   END QUI_N_INTERV_FIRM_CMA;

   PROCEDURE QUI_N_INTERV_AMBU
   IS
      --Numero de intervenciones programadas y realizadas en el ambito de HDQ con 0 dias de estancia, o 1 dia para los procesos de CMA resueltos en en horario de tarde. Incluye la cirugia mayor y menor

      l_mensaje_error   KPI_ERRORES.error%TYPE;

      secuencia         NUMBER;
   BEGIN
      SELECT own_kpi.SEQ_LANZAMIENTO.NEXTVAL INTO secuencia FROM DUAL;

      INSERT INTO own_kpi.CONTROL_LANZAMIENTO (ID, PROCEDIMIENTO, FECHA_INI)
           VALUES (secuencia, 'QUI_N_INTERV_AMBU', SYSDATE);

      COMMIT;


      DELETE FROM OWN_KPI.KPI_QUI_N_INTERV_AMBU
            WHERE fecha >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM');

      INSERT INTO OWN_KPI.KPI_QUI_N_INTERV_AMBU (FECHA, contador)
           SELECT fecha, SUM (contador)
             FROM ( (  SELECT fecha, SUM (contador) AS contador
                         FROM (  SELECT TRUNC (fecha, 'MM') fecha, COUNT (1) AS contador
                                   FROM (SELECT cab.fecha_hora_inicio fecha
                                           FROM REP_HIS_OWN.ADM_QRF_IQ_PRE pre,
                                                REP_HIS_OWN.ADM_QRF_PQ_DET det,
                                                REP_HIS_OWN.ADM_QRF_PQ_CAB cab,
                                                REP_HIS_OWN.ADM_EPISODIO epi,
                                                REP_HIS_OWN.ADM_ADMISION adm,
                                                REP_HIS_OWN.ADM_EPIS_DETALLE epidet
                                          WHERE     pre.episodio_id = epi.episodio_id
                                                AND det.iq_pre_id = pre.iq_pre_id
                                                AND det.pq_cab_id = cab.pq_cab_id
                                                AND epi.episodio_id = epidet.episodio_id
                                                AND epidet.referencia_id = adm.admision_id
                                                AND epi.modalidad_asist = 2
                                                AND epi.fch_cierre IS NOT NULL
                                                AND epi.fch_apertura = epi.fch_cierre
                                                AND adm.destino_alta <> 7
                                                AND adm.motivo_alta <> 6
                                                AND TRUNC (cab.fecha_hora_inicio) >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
                                                AND cab.fecha_hora_inicio < SYSDATE
                                                AND pre.estado_id <> 2
                                                AND pre.estado_id <> 4
                                                AND adm.hd_quir_sn = 1
                                                AND det.iq_despr_id IS NULL)
                               GROUP BY TRUNC (fecha, 'MM')
                               UNION ALL
                                 --A CONTINUACION VIENEN LOS QUE NO TIENEN EPISODIO ASOCIADO
                                 SELECT TRUNC (fecha, 'MM') fecha, COUNT (1) AS contador
                                   FROM (SELECT cab.fecha_hora_inicio fecha
                                           FROM REP_HIS_OWN.ADM_QRF_IQ_PRE pre, REP_HIS_OWN.ADM_QRF_PQ_DET det, REP_HIS_OWN.ADM_QRF_PQ_CAB cab
                                          WHERE     pre.episodio_id IS NULL
                                                AND det.iq_pre_id = pre.iq_pre_id
                                                AND det.pq_cab_id = cab.pq_cab_id
                                                AND modalidad_episodio_un_dia_ambu (pre.id_usuario, cab.fecha_hora_inicio) = 2
                                                AND TRUNC (cab.fecha_hora_inicio) >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
                                                AND pre.estado_id <> 2
                                                AND pre.estado_id <> 4
                                                AND det.iq_despr_id IS NULL)
                               GROUP BY TRUNC (fecha, 'MM'))
                     GROUP BY fecha)
                   UNION ALL
                   (  SELECT fecha, SUM (contador) AS contador
                        FROM (  SELECT TRUNC (fecha, 'MM') fecha, COUNT (1) AS contador
                                  FROM (SELECT cab.fecha_hora_inicio fecha, pre.iq_pre_id iqpre
                                          FROM REP_HIS_OWN.ADM_QRF_IQ_PRE pre,
                                               REP_HIS_OWN.ADM_QRF_PQ_DET det,
                                               REP_HIS_OWN.ADM_QRF_PQ_CAB cab,
                                               REP_HIS_OWN.ADM_EPISODIO epi,
                                               REP_HIS_OWN.ADM_ADMISION ADM,
                                               REP_HIS_OWN.ADM_EPIS_DETALLE EPIDET,
                                               REP_HIS_OWN.ADM_QRF_IQ_ICD_PRE ICD,
                                               own_kpi.kpi_cma_2013 cma
                                         WHERE     PRE.EPISODIO_ID = EPI.EPISODIO_ID
                                               AND ICD.CODIGO_PROC = CMA.CODIGO_CIE
                                               AND icd.DIAGN_PROCE = 'P'
                                               AND icd.iq_pre_id = pre.iq_pre_id
                                               AND det.iq_pre_id = pre.iq_pre_id
                                               AND det.pq_cab_id = cab.pq_cab_id
                                               AND EPI.EPISODIO_ID = EPIDET.EPISODIO_ID
                                               AND pre.episodio_id = epi.episodio_id
                                               AND epidet.referencia_id = adm.admision_id
                                               AND epi.modalidad_asist = 2
                                               AND epi.fch_cierre IS NOT NULL
                                               AND (epi.fch_apertura = epi.fch_cierre - 1 AND TO_CHAR (epi.hora_cierre, 'HH24') <= '15' AND TO_CHAR (cab.fecha_hora_inicio, 'HH24') >= '15')
                                               AND adm.destino_alta <> 7
                                               AND adm.motivo_alta <> 6
                                               AND TRUNC (cab.fecha_hora_inicio) >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
                                               AND cab.fecha_hora_inicio < SYSDATE
                                               AND pre.estado_id <> 2
                                               AND PRE.ESTADO_ID <> 4
                                               AND det.iq_despr_id IS NULL)
                              GROUP BY TRUNC (fecha, 'MM'), iqpre
                              UNION ALL
                                --A CONTINUACION VIENEN LOS QUE NO TIENEN EPISODIO ASOCIADO
                                SELECT TRUNC (fecha, 'MM') fecha, COUNT (1) AS contador
                                  FROM (SELECT cab.fecha_hora_inicio fecha, pre.iq_pre_id iqpre
                                          FROM REP_HIS_OWN.ADM_QRF_IQ_PRE pre,
                                               REP_HIS_OWN.ADM_QRF_PQ_DET det,
                                               REP_HIS_OWN.ADM_QRF_PQ_CAB cab,
                                               REP_HIS_OWN.ADM_QRF_IQ_ICD_PRE ICD,
                                               own_kpi.kpi_cma_2013 cma
                                         WHERE     PRE.EPISODIO_ID IS NULL
                                               AND ICD.CODIGO_PROC = CMA.CODIGO_CIE
                                               AND icd.DIAGN_PROCE = 'P'
                                               AND icd.iq_pre_id = pre.iq_pre_id
                                               AND det.iq_pre_id = pre.iq_pre_id
                                               AND det.pq_cab_id = cab.pq_cab_id
                                               AND modalidad_episodio_cma_1 (pre.id_usuario, cab.fecha_hora_inicio) = 2
                                               AND TRUNC (CAB.FECHA_HORA_INICIO) >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
                                               AND pre.estado_id <> 2
                                               AND pre.estado_id <> 4
                                               AND det.iq_despr_id IS NULL)
                              GROUP BY TRUNC (fecha, 'MM'), iqpre)
                    GROUP BY fecha))
         GROUP BY fecha;

      UPDATE own_kpi.CONTROL_LANZAMIENTO
         SET fecha_fin = SYSDATE
       WHERE id = secuencia;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         l_mensaje_error := SUBSTR (DBMS_UTILITY.format_error_stack (), 1, 1999);

         INSERT INTO OWN_KPI.KPI_ERRORES (fecha_error, KPI_NAME, error)
              VALUES (SYSDATE, 'QUI_N_INTERV_AMBU', l_mensaje_error);

         UPDATE own_kpi.CONTROL_LANZAMIENTO
            SET fecha_fin = SYSDATE, PROCEDIMIENTO = ('QUI_N_INTERV_AMBU ERROR: ' || l_mensaje_error)
          WHERE id = secuencia;

         COMMIT;
   END QUI_N_INTERV_AMBU;

   PROCEDURE QUI_N_INTERV_FIRM_AMBU
   IS
      --Numero de intervenciones programadas y realizadas en el ambito de HDQ con 0 dias de estancia, o 1 dia para los procesos de CMA resueltos en en horario de tarde, en las que se ha realizado el circuito quirurgico completo.

      l_mensaje_error   KPI_ERRORES.error%TYPE;

      secuencia         NUMBER;
   BEGIN
      SELECT own_kpi.SEQ_LANZAMIENTO.NEXTVAL INTO secuencia FROM DUAL;

      INSERT INTO own_kpi.CONTROL_LANZAMIENTO (ID, PROCEDIMIENTO, FECHA_INI)
           VALUES (secuencia, 'QUI_N_INTERV_FIRM_AMBU', SYSDATE);

      COMMIT;

      DELETE FROM OWN_KPI.KPI_QUI_N_INTERV_FIRM_AMBU
            WHERE fecha >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM');

      INSERT INTO OWN_KPI.KPI_QUI_N_INTERV_FIRM_AMBU (FECHA, contador)
           SELECT fecha, SUM (contador)
             FROM ( (  SELECT fecha, SUM (contador) AS contador
                         FROM (  SELECT TRUNC (fecha, 'MM') fecha, COUNT (1) AS contador
                                   FROM (SELECT cab.fecha_hora_inicio fecha
                                           FROM REP_HIS_OWN.ADM_QRF_IQ_PRE pre,
                                                REP_HIS_OWN.ADM_QRF_PQ_DET det,
                                                REP_HIS_OWN.ADM_QRF_PQ_CAB cab,
                                                REP_HIS_OWN.ADM_EPISODIO epi,
                                                REP_HIS_OWN.ADM_ADMISION adm,
                                                REP_HIS_OWN.ADM_EPIS_DETALLE epidet
                                          WHERE     pre.episodio_id = epi.episodio_id
                                                AND det.iq_pre_id = pre.iq_pre_id
                                                AND det.pq_cab_id = cab.pq_cab_id
                                                AND det.iq_post_id IS NOT NULL
                                                AND epi.episodio_id = epidet.episodio_id
                                                AND epidet.referencia_id = adm.admision_id
                                                AND epi.modalidad_asist = 2
                                                AND epi.fch_cierre IS NOT NULL
                                                AND epi.fch_apertura = epi.fch_cierre
                                                AND adm.destino_alta <> 7
                                                AND adm.motivo_alta <> 6
                                                AND TRUNC (cab.fecha_hora_inicio) >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
                                                AND cab.fecha_hora_inicio < SYSDATE
                                                AND pre.estado_id <> 2
                                                AND pre.estado_id <> 4
                                                AND adm.hd_quir_sn = 1
                                                AND det.iq_despr_id IS NULL)
                               GROUP BY TRUNC (fecha, 'MM')
                               UNION ALL
                                 --A CONTINUACION VIENEN LOS QUE NO TIENEN EPISODIO ASOCIADO
                                 SELECT TRUNC (fecha, 'MM') fecha, COUNT (1) AS contador
                                   FROM (SELECT cab.fecha_hora_inicio fecha
                                           FROM REP_HIS_OWN.ADM_QRF_IQ_PRE pre, REP_HIS_OWN.ADM_QRF_PQ_DET det, REP_HIS_OWN.ADM_QRF_PQ_CAB cab
                                          WHERE     pre.episodio_id IS NULL
                                                AND det.iq_pre_id = pre.iq_pre_id
                                                AND det.pq_cab_id = cab.pq_cab_id
                                                AND det.iq_post_id IS NOT NULL
                                                AND modalidad_episodio_un_dia_ambu (pre.id_usuario, cab.fecha_hora_inicio) = 2
                                                AND TRUNC (cab.fecha_hora_inicio) >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
                                                AND pre.estado_id <> 2
                                                AND pre.estado_id <> 4
                                                AND det.iq_despr_id IS NULL)
                               GROUP BY TRUNC (fecha, 'MM'))
                     GROUP BY fecha)
                   UNION ALL
                   (  SELECT fecha, SUM (contador) AS contador
                        FROM (  SELECT TRUNC (fecha, 'MM') fecha, COUNT (1) AS contador
                                  FROM (SELECT cab.fecha_hora_inicio fecha, pre.iq_pre_id iqpre
                                          FROM REP_HIS_OWN.ADM_QRF_IQ_PRE pre,
                                               REP_HIS_OWN.ADM_QRF_PQ_DET det,
                                               REP_HIS_OWN.ADM_QRF_PQ_CAB cab,
                                               REP_HIS_OWN.ADM_EPISODIO epi,
                                               REP_HIS_OWN.ADM_ADMISION ADM,
                                               REP_HIS_OWN.ADM_EPIS_DETALLE EPIDET,
                                               REP_HIS_OWN.ADM_QRF_IQ_ICD_PRE ICD,
                                               own_kpi.kpi_cma_2013 cma
                                         WHERE     PRE.EPISODIO_ID = EPI.EPISODIO_ID
                                               AND ICD.CODIGO_PROC = CMA.CODIGO_CIE
                                               AND icd.DIAGN_PROCE = 'P'
                                               AND icd.iq_pre_id = pre.iq_pre_id
                                               AND det.iq_pre_id = pre.iq_pre_id
                                               AND det.pq_cab_id = cab.pq_cab_id
                                               AND det.iq_post_id IS NOT NULL
                                               AND EPI.EPISODIO_ID = EPIDET.EPISODIO_ID
                                               AND pre.episodio_id = epi.episodio_id
                                               AND epidet.referencia_id = adm.admision_id
                                               AND epi.modalidad_asist = 2
                                               AND epi.fch_cierre IS NOT NULL
                                               AND (epi.fch_apertura = epi.fch_cierre - 1 AND TO_CHAR (epi.hora_cierre, 'HH24') <= '15' AND TO_CHAR (cab.fecha_hora_inicio, 'HH24') >= '15')
                                               AND adm.destino_alta <> 7
                                               AND adm.motivo_alta <> 6
                                               AND TRUNC (cab.fecha_hora_inicio) >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
                                               AND cab.fecha_hora_inicio < SYSDATE
                                               AND pre.estado_id <> 2
                                               AND PRE.ESTADO_ID <> 4
                                               AND det.iq_despr_id IS NULL)
                              GROUP BY TRUNC (fecha, 'MM'), iqpre
                              UNION ALL
                                --A CONTINUACION VIENEN LOS QUE NO TIENEN EPISODIO ASOCIADO
                                SELECT TRUNC (fecha, 'MM') fecha, COUNT (1) AS contador
                                  FROM (SELECT cab.fecha_hora_inicio fecha, pre.iq_pre_id iqpre
                                          FROM REP_HIS_OWN.ADM_QRF_IQ_PRE pre,
                                               REP_HIS_OWN.ADM_QRF_PQ_DET det,
                                               REP_HIS_OWN.ADM_QRF_PQ_CAB cab,
                                               REP_HIS_OWN.ADM_QRF_IQ_ICD_PRE ICD,
                                               own_kpi.kpi_cma_2013 cma
                                         WHERE     PRE.EPISODIO_ID IS NULL
                                               AND ICD.CODIGO_PROC = CMA.CODIGO_CIE
                                               AND icd.DIAGN_PROCE = 'P'
                                               AND icd.iq_pre_id = pre.iq_pre_id
                                               AND det.iq_pre_id = pre.iq_pre_id
                                               AND det.pq_cab_id = cab.pq_cab_id
                                               AND det.iq_post_id IS NOT NULL
                                               AND modalidad_episodio_cma_1 (pre.id_usuario, cab.fecha_hora_inicio) = 2
                                               AND TRUNC (CAB.FECHA_HORA_INICIO) >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
                                               AND pre.estado_id <> 2
                                               AND pre.estado_id <> 4
                                               AND det.iq_despr_id IS NULL)
                              GROUP BY TRUNC (fecha, 'MM'), iqpre)
                    GROUP BY fecha))
         GROUP BY fecha;

      UPDATE own_kpi.CONTROL_LANZAMIENTO
         SET fecha_fin = SYSDATE
       WHERE id = secuencia;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         l_mensaje_error := SUBSTR (DBMS_UTILITY.format_error_stack (), 1, 1999);

         INSERT INTO OWN_KPI.KPI_ERRORES (fecha_error, KPI_NAME, error)
              VALUES (SYSDATE, 'QUI_N_INTERV_FIRM_AMBU', l_mensaje_error);

         UPDATE own_kpi.CONTROL_LANZAMIENTO
            SET fecha_fin = SYSDATE, PROCEDIMIENTO = ('QUI_N_INTERV_FIRM_AMBU ERROR: ' || l_mensaje_error)
          WHERE id = secuencia;

         COMMIT;
   END QUI_N_INTERV_FIRM_AMBU;

   PROCEDURE QUI_N_INTERV_URG_HOSP
   IS
      --Numero de intervenciones urgentes realizadas en el ambito de hospitalizacion con, al menos, 1 dia de estancia.

      l_mensaje_error   KPI_ERRORES.error%TYPE;

      secuencia         NUMBER;
   BEGIN
      SELECT own_kpi.SEQ_LANZAMIENTO.NEXTVAL INTO secuencia FROM DUAL;

      INSERT INTO own_kpi.CONTROL_LANZAMIENTO (ID, PROCEDIMIENTO, FECHA_INI)
           VALUES (secuencia, 'QUI_N_INTERV_URG_HOSP', SYSDATE);

      COMMIT;

      DELETE FROM OWN_KPI.KPI_QUI_N_INTERV_URG_HOSP
            WHERE fecha >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM');

      INSERT INTO OWN_KPI.KPI_QUI_N_INTERV_URG_HOSP (FECHA, contador)
           SELECT                                                                                                                                                                                       /*+ index (ep HCE_EPIS_CLI_NEPISODIO) */
                 TRUNC (POST.fh_inicio, 'MM') AS fecha, COUNT (1) AS contador
             FROM rep_sidca_own.hce_episodio_clinico ep
                  INNER JOIN rep_his_own.adm_qrf_iq_post POST
                     ON TO_CHAR (POST.episodio_id) = ep.nepisodio
                  INNER JOIN rep_his_own.adm_episodio epi_eg
                     ON epi_eg.episodio_id = POST.episodio_id
            WHERE ep.nepisodio IS NOT NULL AND ep.tipo_episodio = 'H' AND epi_eg.modalidad_asist = 1                                                                                                                           --hospitalizacion
                                                                                                    AND ep.fch_alta > ep.fch_ingreso AND POST.iq_pre_id IS NULL                                                     --que no haya parte asociado
                                                                                                                                                               AND TRUNC (POST.fh_inicio, 'MM') >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
         GROUP BY TRUNC (POST.fh_inicio, 'MM');

      UPDATE own_kpi.CONTROL_LANZAMIENTO
         SET fecha_fin = SYSDATE
       WHERE id = secuencia;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         l_mensaje_error := SUBSTR (DBMS_UTILITY.format_error_stack (), 1, 1999);

         INSERT INTO OWN_KPI.KPI_ERRORES (fecha_error, KPI_NAME, error)
              VALUES (SYSDATE, 'QUI_N_INTERV_URG_HOSP', l_mensaje_error);

         UPDATE own_kpi.CONTROL_LANZAMIENTO
            SET fecha_fin = SYSDATE, PROCEDIMIENTO = ('QUI_N_INTERV_URG_HOSP ERROR: ' || l_mensaje_error)
          WHERE id = secuencia;

         COMMIT;
   END QUI_N_INTERV_URG_HOSP;

   PROCEDURE QUI_N_INTERV_URG_HDQ
   IS
      --Numero de intervenciones urgentes realizadas en el ambito de HDQ con 0 dias de estancia, o 1 dia para los procesos de CMA resueltos en en horario de tarde. Incluye la cirugia mayor y menor

      l_mensaje_error   KPI_ERRORES.error%TYPE;

      secuencia         NUMBER;
   BEGIN
      SELECT own_kpi.SEQ_LANZAMIENTO.NEXTVAL INTO secuencia FROM DUAL;

      INSERT INTO own_kpi.CONTROL_LANZAMIENTO (ID, PROCEDIMIENTO, FECHA_INI)
           VALUES (secuencia, 'QUI_N_INTERV_URG_HDQ', SYSDATE);

      COMMIT;

      DELETE FROM OWN_KPI.KPI_QUI_N_INTERV_URG_HDQ
            WHERE fecha >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM');

      INSERT INTO OWN_KPI.KPI_QUI_N_INTERV_URG_HDQ (FECHA, contador)
           SELECT TRUNC (fecha, 'MM') AS fecha, COUNT (1) AS contador
             FROM (SELECT                                                                                                                                                                               /*+ index (ep HCE_EPIS_CLI_NEPISODIO) */
                         POST.FH_INICIO AS fecha
                     FROM REP_SIDCA_OWN.HCE_EPISODIO_CLINICO ep,
                          own_kpi.uf_con_padres uf,
                          rep_his_own.adm_qrf_iq_post POST,
                          rep_his_own.adm_episodio epi_eg
                    WHERE     ep.nepisodio IS NOT NULL
                          AND tipo_episodio = 'A'
                          AND TO_CHAR (epi_eg.episodio_id) = ep.nepisodio
                          AND epi_eg.modalidad_asist = 2                                                                                                                                                                --hospitalizacion de dia
                          AND ep.destino_alta <> 7
                          AND ep.tipo_alta <> 'T'
                          AND ep.fch_alta IS NOT NULL
                          AND TO_CHAR (POST.episodio_id) = ep.nepisodio
                          AND POST.iq_pre_id IS NULL                                                                                                                                                                --que no haya parte asociado
                          AND (TRUNC (ep.fch_ingreso) = TRUNC (ep.fch_alta))
                          AND (ep.cod_servicio_alta IS NOT NULL AND ep.cod_servicio_alta = uf.uf_codigo OR ep.cod_servicio_alta IS NULL AND ep.cod_servicio_ingreso = uf.uf_codigo)
                          AND TRUNC (POST.FH_INICIO, 'MM') >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
                   UNION ALL
                   --LA SEGUNDA PARTE DEL UNION SE REFIERE A AQUELLOS EPISODIOS DE DURACION 1 DIA DE 15H DEL DIA DE INGRESO A 15H DEL DIA DEL ALTA
                   --MISMO CRITERIO QUE LAS AMBU NO URGENTES PERO AQUI SE COGE LA INFO DEL POST
                   SELECT                                                                                                                                                                               /*+ index (ep HCE_EPIS_CLI_NEPISODIO) */
                         POST.FH_INICIO AS fecha
                     FROM REP_SIDCA_OWN.HCE_EPISODIO_CLINICO ep,
                          own_kpi.kpi_cma_2013 cma,
                          own_kpi.uf_con_padres uf,
                          rep_his_own.adm_qrf_iq_post POST,
                          rep_his_own.adm_episodio epi_eg,
                          rep_his_own.ADM_QRF_IQ_ICD_POST icd
                    WHERE     ep.nepisodio IS NOT NULL
                          AND TO_CHAR (epi_eg.episodio_id) = ep.nepisodio
                          AND ep.tipo_episodio = 'A'
                          AND epi_eg.modalidad_asist = 2                                                                                                                                                                --hospitalizacion de dia
                          AND ep.destino_alta <> 7
                          AND ep.tipo_alta <> 'T'
                          AND ep.fch_alta IS NOT NULL
                          AND TO_CHAR (POST.episodio_id) = ep.nepisodio
                          AND POST.iq_pre_id IS NULL                                                                                                                                                                --que no haya parte asociado
                          AND icd.iq_post_id = POST.iq_post_id
                          AND icd.codigo_icd9 = cma.codigo_cie
                          AND icd.DIAGN_PROCE = 'P'
                          AND icd.principal = 1
                          AND (TRUNC (ep.fch_ingreso, 'dd') = TRUNC (ep.fch_alta, 'dd') - 1 AND TO_CHAR (ep.fch_ingreso, 'HH24') <= '15' AND TO_CHAR (ep.fch_alta, 'HH24') >= '15')
                          AND (ep.cod_servicio_alta IS NOT NULL AND ep.cod_servicio_alta = uf.uf_codigo OR ep.cod_servicio_alta IS NULL AND ep.cod_servicio_ingreso = uf.uf_codigo)
                          AND TRUNC (POST.FH_INICIO, 'MM') >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM'))
         GROUP BY TRUNC (fecha, 'MM');

      UPDATE own_kpi.CONTROL_LANZAMIENTO
         SET fecha_fin = SYSDATE
       WHERE id = secuencia;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         l_mensaje_error := SUBSTR (DBMS_UTILITY.format_error_stack (), 1, 1999);

         INSERT INTO OWN_KPI.KPI_ERRORES (fecha_error, KPI_NAME, error)
              VALUES (SYSDATE, 'QUI_N_INTERV_URG_HDQ', l_mensaje_error);

         UPDATE own_kpi.CONTROL_LANZAMIENTO
            SET fecha_fin = SYSDATE, PROCEDIMIENTO = ('QUI_N_INTERV_URG_HDQ ERROR: ' || l_mensaje_error)
          WHERE id = secuencia;

         COMMIT;
   END QUI_N_INTERV_URG_HDQ;

   PROCEDURE QUI_N_INTERV_URG_URG
   IS
      --Numero de intervenciones realizadas en el ambito de urgencias o no asignadas a ningun episodio

      l_mensaje_error   KPI_ERRORES.error%TYPE;

      secuencia         NUMBER;
   BEGIN
      SELECT own_kpi.SEQ_LANZAMIENTO.NEXTVAL INTO secuencia FROM DUAL;

      INSERT INTO own_kpi.CONTROL_LANZAMIENTO (ID, PROCEDIMIENTO, FECHA_INI)
           VALUES (secuencia, 'QUI_N_INTERV_URG_URG', SYSDATE);

      COMMIT;

      DELETE FROM OWN_KPI.KPI_QUI_N_INTERV_URG_URG
            WHERE fecha >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM');

      INSERT INTO OWN_KPI.KPI_QUI_N_INTERV_URG_URG (FECHA, contador)
           SELECT fecha, COUNT (1) AS contador
             FROM (SELECT TRUNC (POST.FH_INICIO, 'MM') AS fecha
                     FROM rep_sidca_own.hce_episodio_clinico ep
                          INNER JOIN rep_his_own.adm_qrf_iq_post POST
                             ON TO_CHAR (POST.episodio_id) = ep.nepisodio
                          INNER JOIN rep_his_own.adm_episodio epi_eg
                             ON epi_eg.episodio_id = POST.episodio_id
                    WHERE ep.nepisodio IS NOT NULL AND tipo_episodio = 'U' AND epi_eg.modalidad_asist = 3                                                                                                                            --urgencias
                                                                                                         AND ep.fch_alta > ep.fch_ingreso AND POST.iq_pre_id IS NULL                                                --que no haya parte asociado
                                                                                                                                                                    AND TRUNC (POST.FH_INICIO, 'MM') >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
                   UNION ALL
                   SELECT TRUNC (POST.FH_INICIO, 'MM') AS fecha
                     FROM rep_his_own.adm_qrf_iq_post POST
                    WHERE POST.episodio_id IS NULL AND POST.iq_pre_id IS NULL                                                                                                                                       --que no haya parte asociado
                                                                             AND TRUNC (POST.FH_INICIO, 'MM') >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM'))
         GROUP BY fecha;

      UPDATE own_kpi.CONTROL_LANZAMIENTO
         SET fecha_fin = SYSDATE
       WHERE id = secuencia;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         l_mensaje_error := SUBSTR (DBMS_UTILITY.format_error_stack (), 1, 1999);

         INSERT INTO OWN_KPI.KPI_ERRORES (fecha_error, KPI_NAME, error)
              VALUES (SYSDATE, 'QUI_N_INTERV_URG_URG', l_mensaje_error);

         UPDATE own_kpi.CONTROL_LANZAMIENTO
            SET fecha_fin = SYSDATE, PROCEDIMIENTO = ('QUI_N_INTERV_URG_URG ERROR: ' || l_mensaje_error)
          WHERE id = secuencia;

         COMMIT;
   END QUI_N_INTERV_URG_URG;

   PROCEDURE QUI_N_SUSP_HOSP
   IS
      --Numero de suspensiones (no incluye las desprogramaciones) en el ambito de hospitalizacion. Solo en el informe "Resumen por UF" aparecera desagregado por motivos

      l_mensaje_error   KPI_ERRORES.error%TYPE;

      secuencia         NUMBER;
   BEGIN
      SELECT own_kpi.SEQ_LANZAMIENTO.NEXTVAL INTO secuencia FROM DUAL;

      INSERT INTO own_kpi.CONTROL_LANZAMIENTO (ID, PROCEDIMIENTO, FECHA_INI)
           VALUES (secuencia, 'QUI_N_SUSP_HOSP', SYSDATE);

      COMMIT;

      ------------------------- POR UF

      DELETE FROM OWN_KPI.KPI_QUI_N_SUSP_HOSP
            WHERE fecha >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM');

      INSERT INTO OWN_KPI.KPI_QUI_N_SUSP_HOSP (FECHA,
                                               contador,
                                               nombre,
                                               codigo)
           SELECT fecha,
                  SUM (contador),
                  uf_nombre,
                  uf_codigo
             FROM (  SELECT TRUNC (desp.fh_desprog, 'MONTH') fecha,
                            COUNT (1) AS contador,
                            uf.uf_padre_nombre AS uf_nombre,
                            uf.uf_padre AS uf_codigo
                       FROM REP_HIS_OWN.ADM_QRF_M_MOT_DESPROG mot,
                            REP_HIS_OWN.ADM_QRF_IQ_DESPR desp,
                            REP_HIS_OWN.ADM_QRF_PQ_DET det,
                            REP_HIS_OWN.ADM_QRF_PQ_CAB cab,
                            REP_HIS_OWN.ADM_QRF_IQ_PRE pre,
                            REP_HIS_OWN.ADM_EPISODIO epi,
                            own_kpi.uf_con_padres uf
                      WHERE     mot.mot_desprog_id = desp.mot_desprog_id
                            AND desp.iq_despr_id = det.iq_despr_id
                            AND det.iq_pre_id = pre.iq_pre_id
                            AND det.pq_cab_id = cab.pq_cab_id
                            AND desp.desprog_susp = 0
                            AND pre.episodio_id = epi.episodio_id
                            AND epi.modalidad_asist = 1
                            AND cab.uni_funcional_id = uf.uf_codigo
                            AND TRUNC (desp.fh_desprog) >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
                   GROUP BY TRUNC (desp.fh_desprog, 'MONTH'), uf.uf_padre_nombre, uf.uf_padre
                   UNION ALL
                     --aquellas intervenciones sin episodio asociado
                     SELECT TRUNC (desp.fh_desprog, 'MONTH') fecha,
                            COUNT (1) AS contador,
                            uf.uf_padre_nombre AS uf_nombre,
                            uf.uf_padre AS uf_codigo
                       FROM REP_HIS_OWN.ADM_QRF_M_MOT_DESPROG mot,
                            REP_HIS_OWN.ADM_QRF_IQ_DESPR desp,
                            REP_HIS_OWN.ADM_QRF_PQ_DET det,
                            REP_HIS_OWN.ADM_QRF_PQ_CAB cab,
                            REP_HIS_OWN.ADM_QRF_IQ_PRE pre,
                            own_kpi.uf_con_padres uf
                      WHERE     mot.mot_desprog_id = desp.mot_desprog_id
                            AND desp.iq_despr_id = det.iq_despr_id
                            AND det.iq_pre_id = pre.iq_pre_id
                            AND desp.desprog_susp = 0
                            AND pre.episodio_id IS NULL
                            AND det.pq_cab_id = cab.pq_cab_id
                            AND modalidad_episodio (pre.id_usuario, cab.fecha_hora_inicio) = 1
                            AND cab.uni_funcional_id = uf.uf_codigo
                            AND TRUNC (desp.fh_desprog) >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
                   GROUP BY TRUNC (desp.fh_desprog, 'MONTH'), uf.uf_padre_nombre, uf.uf_padre)
         GROUP BY fecha, uf_nombre, uf_codigo;

      ------------------------- POR MOTIVOS

      DELETE FROM KPI_QUI_N_SUSP_HOSP_MOT
            WHERE fecha >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM');

      INSERT INTO KPI_QUI_N_SUSP_HOSP_MOT (FECHA,
                                           contador,
                                           motivo,
                                           motivo_id)
           SELECT fecha,
                  SUM (contador),
                  motivo,
                  motivo_id
             FROM (  SELECT TRUNC (DESP.FH_DESPROG, 'MONTH') FECHA,
                            COUNT (1) AS CONTADOR,
                            MOT.DESC_MOT_DESPROG AS motivo,
                            MOT.MOT_DESPROG_ID AS motivo_id
                       FROM REP_HIS_OWN.ADM_QRF_M_MOT_DESPROG MOT,
                            REP_HIS_OWN.ADM_QRF_IQ_DESPR DESP,
                            REP_HIS_OWN.ADM_QRF_PQ_DET DET,
                            REP_HIS_OWN.ADM_QRF_IQ_PRE pre,
                            REP_HIS_OWN.ADM_EPISODIO epi
                      WHERE     mot.mot_desprog_id = desp.mot_desprog_id
                            AND desp.iq_despr_id = det.iq_despr_id
                            AND det.iq_pre_id = pre.iq_pre_id
                            AND desp.desprog_susp = 0
                            AND pre.episodio_id = epi.episodio_id
                            AND epi.modalidad_asist = 1
                            AND TRUNC (desp.fh_desprog) >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
                   GROUP BY TRUNC (DESP.FH_DESPROG, 'MONTH'), MOT.DESC_MOT_DESPROG, MOT.MOT_DESPROG_ID
                   UNION ALL
                     --aquellas intervenciones sin episodio asociado
                     SELECT TRUNC (DESP.FH_DESPROG, 'MONTH') FECHA,
                            COUNT (1) AS CONTADOR,
                            MOT.DESC_MOT_DESPROG AS motivo,
                            MOT.MOT_DESPROG_ID AS motivo_id
                       FROM REP_HIS_OWN.ADM_QRF_M_MOT_DESPROG mot,
                            REP_HIS_OWN.ADM_QRF_IQ_DESPR desp,
                            REP_HIS_OWN.ADM_QRF_PQ_DET det,
                            REP_HIS_OWN.ADM_QRF_PQ_CAB cab,
                            REP_HIS_OWN.ADM_QRF_IQ_PRE pre
                      WHERE     mot.mot_desprog_id = desp.mot_desprog_id
                            AND desp.iq_despr_id = det.iq_despr_id
                            AND det.iq_pre_id = pre.iq_pre_id
                            AND desp.desprog_susp = 0
                            AND pre.episodio_id IS NULL
                            AND det.pq_cab_id = cab.pq_cab_id
                            AND modalidad_episodio (pre.id_usuario, cab.fecha_hora_inicio) = 1
                            AND TRUNC (desp.fh_desprog) >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
                   GROUP BY TRUNC (DESP.FH_DESPROG, 'MONTH'), MOT.DESC_MOT_DESPROG, MOT.MOT_DESPROG_ID)
         GROUP BY fecha, motivo, motivo_id;

      ------------------------- POR MOTIVOS Y UF A LA VEZ

      DELETE FROM KPI_QUI_N_SUSP_HOSP_MOT_UF
            WHERE fecha >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM');

      INSERT INTO OWN_KPI.KPI_QUI_N_SUSP_HOSP_MOT_UF (FECHA,
                                                      uf_nombre,
                                                      uf_codigo,
                                                      motivo,
                                                      motivo_id,
                                                      contador)
           SELECT fecha,
                  uf_nombre,
                  uf_codigo,
                  motivo,
                  motivo_id,
                  SUM (contador) AS contador
             FROM (  SELECT TRUNC (desp.fh_desprog, 'MONTH') fecha,
                            COUNT (1) AS contador,
                            uf.uf_padre_nombre AS uf_nombre,
                            uf.uf_padre AS uf_codigo,
                            MOT.DESC_MOT_DESPROG AS motivo,
                            MOT.MOT_DESPROG_ID AS motivo_id
                       FROM REP_HIS_OWN.ADM_QRF_M_MOT_DESPROG mot,
                            REP_HIS_OWN.ADM_QRF_IQ_DESPR desp,
                            REP_HIS_OWN.ADM_QRF_PQ_DET det,
                            REP_HIS_OWN.ADM_QRF_PQ_CAB cab,
                            REP_HIS_OWN.ADM_QRF_IQ_PRE pre,
                            REP_HIS_OWN.ADM_EPISODIO epi,
                            own_kpi.uf_con_padres uf
                      WHERE     mot.mot_desprog_id = desp.mot_desprog_id
                            AND desp.iq_despr_id = det.iq_despr_id
                            AND det.iq_pre_id = pre.iq_pre_id
                            AND det.pq_cab_id = cab.pq_cab_id
                            AND desp.desprog_susp = 0
                            AND pre.episodio_id = epi.episodio_id
                            AND epi.modalidad_asist = 1
                            AND cab.uni_funcional_id = uf.uf_codigo
                            AND TRUNC (desp.fh_desprog) >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
                   GROUP BY TRUNC (desp.fh_desprog, 'MONTH'),
                            uf.uf_padre_nombre,
                            uf.uf_padre,
                            MOT.DESC_MOT_DESPROG,
                            MOT.MOT_DESPROG_ID
                   UNION ALL
                     --aquellas intervenciones sin episodio asociado
                     SELECT TRUNC (desp.fh_desprog, 'MONTH') fecha,
                            COUNT (1) AS contador,
                            uf.uf_padre_nombre AS uf_nombre,
                            uf.uf_padre AS uf_codigo,
                            MOT.DESC_MOT_DESPROG AS motivo,
                            MOT.MOT_DESPROG_ID AS motivo_id
                       FROM REP_HIS_OWN.ADM_QRF_M_MOT_DESPROG mot,
                            REP_HIS_OWN.ADM_QRF_IQ_DESPR desp,
                            REP_HIS_OWN.ADM_QRF_PQ_DET det,
                            REP_HIS_OWN.ADM_QRF_PQ_CAB cab,
                            REP_HIS_OWN.ADM_QRF_IQ_PRE pre,
                            own_kpi.uf_con_padres uf
                      WHERE     mot.mot_desprog_id = desp.mot_desprog_id
                            AND desp.iq_despr_id = det.iq_despr_id
                            AND det.iq_pre_id = pre.iq_pre_id
                            AND desp.desprog_susp = 0
                            AND pre.episodio_id IS NULL
                            AND det.pq_cab_id = cab.pq_cab_id
                            AND modalidad_episodio (pre.id_usuario, cab.fecha_hora_inicio) = 1
                            AND cab.uni_funcional_id = uf.uf_codigo
                            AND TRUNC (desp.fh_desprog) >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
                   GROUP BY TRUNC (desp.fh_desprog, 'MONTH'),
                            uf.uf_padre_nombre,
                            uf.uf_padre,
                            MOT.DESC_MOT_DESPROG,
                            MOT.MOT_DESPROG_ID)
         GROUP BY fecha,
                  uf_nombre,
                  uf_codigo,
                  motivo,
                  motivo_id;

      UPDATE own_kpi.CONTROL_LANZAMIENTO
         SET fecha_fin = SYSDATE
       WHERE id = secuencia;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         l_mensaje_error := SUBSTR (DBMS_UTILITY.format_error_stack (), 1, 1999);

         INSERT INTO OWN_KPI.KPI_ERRORES (fecha_error, KPI_NAME, error)
              VALUES (SYSDATE, 'QUI_N_SUSP_HOSP', l_mensaje_error);

         UPDATE own_kpi.CONTROL_LANZAMIENTO
            SET fecha_fin = SYSDATE, PROCEDIMIENTO = ('QUI_N_SUSP_HOSP ERROR: ' || l_mensaje_error)
          WHERE id = secuencia;

         COMMIT;
   END QUI_N_SUSP_HOSP;

   PROCEDURE QUI_N_SUSP_AMBU
   IS
      --Numero de suspensiones (no incluye las desprogramaciones) en el ambito de hospital de dia quirurgico. Solo en el informe "Resumen por UF" aparecera desagregado por motivos

      l_mensaje_error   KPI_ERRORES.error%TYPE;

      secuencia         NUMBER;
   BEGIN
      SELECT own_kpi.SEQ_LANZAMIENTO.NEXTVAL INTO secuencia FROM DUAL;

      INSERT INTO own_kpi.CONTROL_LANZAMIENTO (ID, PROCEDIMIENTO, FECHA_INI)
           VALUES (secuencia, 'QUI_N_SUSP_AMBU', SYSDATE);

      COMMIT;

      ------------------------ POR UF

      DELETE FROM OWN_KPI.KPI_QUI_N_SUSP_AMBU
            WHERE fecha >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM');

      INSERT INTO OWN_KPI.KPI_QUI_N_SUSP_AMBU (FECHA,
                                               contador,
                                               nombre,
                                               codigo)
           SELECT fecha,
                  SUM (contador),
                  uf_nombre,
                  uf_codigo
             FROM (  SELECT TRUNC (desp.fh_desprog, 'MONTH') fecha,
                            COUNT (1) AS contador,
                            uf.uf_padre_nombre AS uf_nombre,
                            uf.uf_padre AS uf_codigo
                       FROM REP_HIS_OWN.ADM_QRF_M_MOT_DESPROG mot,
                            REP_HIS_OWN.ADM_QRF_IQ_DESPR desp,
                            REP_HIS_OWN.ADM_QRF_PQ_DET det,
                            REP_HIS_OWN.ADM_QRF_PQ_CAB cab,
                            REP_HIS_OWN.ADM_QRF_IQ_PRE pre,
                            REP_HIS_OWN.ADM_EPISODIO epi,
                            own_kpi.uf_con_padres uf
                      WHERE     mot.mot_desprog_id = desp.mot_desprog_id
                            AND desp.iq_despr_id = det.iq_despr_id
                            AND det.iq_pre_id = pre.iq_pre_id
                            AND det.pq_cab_id = cab.pq_cab_id
                            AND desp.desprog_susp = 0
                            AND pre.episodio_id = epi.episodio_id
                            AND epi.modalidad_asist = 2
                            AND cab.uni_funcional_id = uf.uf_codigo
                            AND TRUNC (desp.fh_desprog) >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
                   GROUP BY TRUNC (desp.fh_desprog, 'MONTH'), uf.uf_padre_nombre, uf.uf_padre
                   UNION ALL
                     --aquellas intervenciones sin episodio asociado
                     SELECT TRUNC (desp.fh_desprog, 'MONTH') fecha,
                            COUNT (1) AS contador,
                            uf.uf_padre_nombre AS uf_nombre,
                            uf.uf_padre AS uf_codigo
                       FROM REP_HIS_OWN.ADM_QRF_M_MOT_DESPROG mot,
                            REP_HIS_OWN.ADM_QRF_IQ_DESPR desp,
                            REP_HIS_OWN.ADM_QRF_PQ_DET det,
                            REP_HIS_OWN.ADM_QRF_PQ_CAB cab,
                            REP_HIS_OWN.ADM_QRF_IQ_PRE pre,
                            own_kpi.uf_con_padres uf
                      WHERE     mot.mot_desprog_id = desp.mot_desprog_id
                            AND desp.iq_despr_id = det.iq_despr_id
                            AND det.iq_pre_id = pre.iq_pre_id
                            AND desp.desprog_susp = 0
                            AND pre.episodio_id IS NULL
                            AND det.pq_cab_id = cab.pq_cab_id
                            AND modalidad_episodio (pre.id_usuario, cab.fecha_hora_inicio) = 2
                            AND cab.uni_funcional_id = uf.uf_codigo
                            AND TRUNC (desp.fh_desprog) >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
                   GROUP BY TRUNC (desp.fh_desprog, 'MONTH'), uf.uf_padre_nombre, uf.uf_padre)
         GROUP BY fecha, uf_nombre, uf_codigo;

      ------------------------- POR MOTIVOS

      DELETE FROM KPI_QUI_N_SUSP_AMBU_MOT
            WHERE fecha >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM');

      INSERT INTO KPI_QUI_N_SUSP_AMBU_MOT (FECHA,
                                           contador,
                                           motivo,
                                           motivo_id)
           SELECT fecha,
                  SUM (contador),
                  motivo,
                  motivo_id
             FROM (  SELECT TRUNC (DESP.FH_DESPROG, 'MONTH') FECHA,
                            COUNT (1) AS CONTADOR,
                            MOT.DESC_MOT_DESPROG AS motivo,
                            MOT.MOT_DESPROG_ID AS motivo_id
                       FROM REP_HIS_OWN.ADM_QRF_M_MOT_DESPROG MOT,
                            REP_HIS_OWN.ADM_QRF_IQ_DESPR DESP,
                            REP_HIS_OWN.ADM_QRF_PQ_DET DET,
                            REP_HIS_OWN.ADM_QRF_IQ_PRE pre,
                            REP_HIS_OWN.ADM_EPISODIO epi
                      WHERE     mot.mot_desprog_id = desp.mot_desprog_id
                            AND desp.iq_despr_id = det.iq_despr_id
                            AND det.iq_pre_id = pre.iq_pre_id
                            AND desp.desprog_susp = 0
                            AND pre.episodio_id = epi.episodio_id
                            AND epi.modalidad_asist = 2
                            AND TRUNC (desp.fh_desprog) >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
                   GROUP BY TRUNC (DESP.FH_DESPROG, 'MONTH'), MOT.DESC_MOT_DESPROG, MOT.MOT_DESPROG_ID
                   UNION ALL
                     --aquellas intervenciones sin episodio asociado
                     SELECT TRUNC (DESP.FH_DESPROG, 'MONTH') FECHA,
                            COUNT (1) AS CONTADOR,
                            MOT.DESC_MOT_DESPROG AS motivo,
                            MOT.MOT_DESPROG_ID AS motivo_id
                       FROM REP_HIS_OWN.ADM_QRF_M_MOT_DESPROG mot,
                            REP_HIS_OWN.ADM_QRF_IQ_DESPR desp,
                            REP_HIS_OWN.ADM_QRF_PQ_DET det,
                            REP_HIS_OWN.ADM_QRF_PQ_CAB cab,
                            REP_HIS_OWN.ADM_QRF_IQ_PRE pre
                      WHERE     mot.mot_desprog_id = desp.mot_desprog_id
                            AND desp.iq_despr_id = det.iq_despr_id
                            AND det.iq_pre_id = pre.iq_pre_id
                            AND desp.desprog_susp = 0
                            AND pre.episodio_id IS NULL
                            AND det.pq_cab_id = cab.pq_cab_id
                            AND modalidad_episodio (pre.id_usuario, cab.fecha_hora_inicio) = 2
                            AND TRUNC (desp.fh_desprog) >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
                   GROUP BY TRUNC (DESP.FH_DESPROG, 'MONTH'), MOT.DESC_MOT_DESPROG, MOT.MOT_DESPROG_ID)
         GROUP BY fecha, motivo, motivo_id;

      ---------------------- POR UF Y POR MOTIVOS A LA VEZ

      DELETE FROM OWN_KPI.KPI_QUI_N_SUSP_AMBU_MOT_UF
            WHERE fecha >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM');

      INSERT INTO OWN_KPI.KPI_QUI_N_SUSP_AMBU_MOT_UF (FECHA,
                                                      uf_nombre,
                                                      uf_codigo,
                                                      motivo,
                                                      motivo_id,
                                                      contador)
           SELECT fecha,
                  uf_nombre,
                  uf_codigo,
                  motivo,
                  motivo_id,
                  SUM (contador)
             FROM (  SELECT TRUNC (desp.fh_desprog, 'MONTH') fecha,
                            COUNT (1) AS contador,
                            uf.uf_padre_nombre AS uf_nombre,
                            uf.uf_padre AS uf_codigo,
                            MOT.DESC_MOT_DESPROG AS motivo,
                            MOT.MOT_DESPROG_ID AS motivo_id
                       FROM REP_HIS_OWN.ADM_QRF_M_MOT_DESPROG mot,
                            REP_HIS_OWN.ADM_QRF_IQ_DESPR desp,
                            REP_HIS_OWN.ADM_QRF_PQ_DET det,
                            REP_HIS_OWN.ADM_QRF_PQ_CAB cab,
                            REP_HIS_OWN.ADM_QRF_IQ_PRE pre,
                            REP_HIS_OWN.ADM_EPISODIO epi,
                            own_kpi.uf_con_padres uf
                      WHERE     mot.mot_desprog_id = desp.mot_desprog_id
                            AND desp.iq_despr_id = det.iq_despr_id
                            AND det.iq_pre_id = pre.iq_pre_id
                            AND det.pq_cab_id = cab.pq_cab_id
                            AND desp.desprog_susp = 0
                            AND pre.episodio_id = epi.episodio_id
                            AND epi.modalidad_asist = 2
                            AND cab.uni_funcional_id = uf.uf_codigo
                            AND TRUNC (desp.fh_desprog) >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
                   GROUP BY TRUNC (desp.fh_desprog, 'MONTH'),
                            uf.uf_padre_nombre,
                            uf.uf_padre,
                            MOT.DESC_MOT_DESPROG,
                            MOT.MOT_DESPROG_ID
                   UNION ALL
                     --aquellas intervenciones sin episodio asociado
                     SELECT TRUNC (desp.fh_desprog, 'MONTH') fecha,
                            COUNT (1) AS contador,
                            uf.uf_padre_nombre AS uf_nombre,
                            uf.uf_padre AS uf_codigo,
                            MOT.DESC_MOT_DESPROG AS motivo,
                            MOT.MOT_DESPROG_ID AS motivo_id
                       FROM REP_HIS_OWN.ADM_QRF_M_MOT_DESPROG mot,
                            REP_HIS_OWN.ADM_QRF_IQ_DESPR desp,
                            REP_HIS_OWN.ADM_QRF_PQ_DET det,
                            REP_HIS_OWN.ADM_QRF_PQ_CAB cab,
                            REP_HIS_OWN.ADM_QRF_IQ_PRE pre,
                            own_kpi.uf_con_padres uf
                      WHERE     mot.mot_desprog_id = desp.mot_desprog_id
                            AND desp.iq_despr_id = det.iq_despr_id
                            AND det.iq_pre_id = pre.iq_pre_id
                            AND desp.desprog_susp = 0
                            AND pre.episodio_id IS NULL
                            AND det.pq_cab_id = cab.pq_cab_id
                            AND modalidad_episodio (pre.id_usuario, cab.fecha_hora_inicio) = 2
                            AND cab.uni_funcional_id = uf.uf_codigo
                            AND TRUNC (desp.fh_desprog) >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
                   GROUP BY TRUNC (desp.fh_desprog, 'MONTH'),
                            uf.uf_padre_nombre,
                            uf.uf_padre,
                            MOT.DESC_MOT_DESPROG,
                            MOT.MOT_DESPROG_ID)
         GROUP BY fecha,
                  uf_nombre,
                  uf_codigo,
                  motivo,
                  motivo_id;

      UPDATE own_kpi.CONTROL_LANZAMIENTO
         SET fecha_fin = SYSDATE
       WHERE id = secuencia;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         l_mensaje_error := SUBSTR (DBMS_UTILITY.format_error_stack (), 1, 1999);

         INSERT INTO OWN_KPI.KPI_ERRORES (fecha_error, KPI_NAME, error)
              VALUES (SYSDATE, 'QUI_N_SUSP_AMBU', l_mensaje_error);

         UPDATE own_kpi.CONTROL_LANZAMIENTO
            SET fecha_fin = SYSDATE, PROCEDIMIENTO = ('QUI_N_SUSP_AMBU ERROR: ' || l_mensaje_error)
          WHERE id = secuencia;

         COMMIT;
   END QUI_N_SUSP_AMBU;

   PROCEDURE QUI_N_SUSP_MOT_P_UF
   IS
      --Suma de las intervenciones quirurgicas suspendidas clasificadas por motivos y por UF padre

      l_mensaje_error   KPI_ERRORES.error%TYPE;

      secuencia         NUMBER;
   BEGIN
      DELETE FROM own_kpi.KPI_QUI_N_SUSP_MOT_UF
            WHERE fecha >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM');

      INSERT INTO own_kpi.KPI_QUI_N_SUSP_MOT_UF (fecha,
                                                 uf_nombre,
                                                 uf_codigo,
                                                 motivo,
                                                 motivo_id,
                                                 contador)
           SELECT fecha,
                  uf_nombre,
                  uf_codigo,
                  motivo,
                  motivo_id,
                  SUM (contador) AS contador
             FROM (SELECT * FROM own_kpi.KPI_QUI_N_SUSP_AMBU_MOT_UF
                   UNION ALL
                   SELECT * FROM KPI_QUI_N_SUSP_HOSP_MOT_UF)
            WHERE fecha >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
         GROUP BY fecha,
                  uf_nombre,
                  uf_codigo,
                  motivo,
                  motivo_id;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         l_mensaje_error := SUBSTR (DBMS_UTILITY.format_error_stack (), 1, 1999);

         INSERT INTO OWN_KPI.KPI_ERRORES (fecha_error, KPI_NAME, error)
              VALUES (SYSDATE, 'QUI_N_SUSP_MOT_P_UF', l_mensaje_error);

         UPDATE own_kpi.CONTROL_LANZAMIENTO
            SET fecha_fin = SYSDATE, PROCEDIMIENTO = ('QUI_N_SUSP_MOT_P_UF ERROR: ' || l_mensaje_error)
          WHERE id = secuencia;

         COMMIT;
   END QUI_N_SUSP_MOT_P_UF;

   PROCEDURE QUI_REND_QRF_H_DISP_AH
   IS
      --Numero de horas disponibles de un quirofano.

      l_mensaje_error   kpi_errores.error%TYPE;
      secuencia         NUMBER;
   BEGIN
      SELECT own_kpi.SEQ_LANZAMIENTO.NEXTVAL INTO secuencia FROM DUAL;

      INSERT INTO own_kpi.CONTROL_LANZAMIENTO (ID, PROCEDIMIENTO, FECHA_INI)
           VALUES (secuencia, 'QUI_REND_QRF_H_DISP_AH', SYSDATE);

      COMMIT;

      DELETE FROM OWN_KPI.KPI_QUI_REND_QRF_H_DISP_AH
            WHERE fecha >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'mm');

      INSERT INTO OWN_KPI.KPI_QUI_REND_QRF_H_DISP_AH (fecha, contador)
           SELECT TRUNC (fecha_hora_fin, 'mm'), SUM (contador) AS contador
             FROM (SELECT DISTINCT pq_cab_id, (fecha_hora_fin - fecha_hora_inicio) * 24 AS contador, fecha_hora_fin
                     FROM REP_HIS_OWN.ADM_QRF_PQ_CAB cab
                          INNER JOIN REP_HIS_OWN.ADM_QRF_PQ_DET det
                             USING (pq_cab_id)
                          INNER JOIN REP_HIS_OWN.ADM_QRF_LOCAL qrf
                             ON cab.quirofano = qrf.ID
                    WHERE     fecha_hora_fin >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'mm')
                          AND fecha_hora_fin <= SYSDATE - 1
                          AND qrf.consulta = 0
                          AND (SELECT COUNT (1)
                                 FROM REP_HIS_OWN.ADM_QRF_IQ_PRE pre INNER JOIN REP_HIS_OWN.ADM_QRF_PQ_DET det USING (iq_pre_id)
                                WHERE det.pq_cab_id = pq_cab_id AND det.orden <> 65000) > 0
                          AND det.orden <> 65000)
         GROUP BY TRUNC (fecha_hora_fin, 'mm');

      UPDATE own_kpi.CONTROL_LANZAMIENTO
         SET fecha_fin = SYSDATE
       WHERE id = secuencia;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         l_mensaje_error := SUBSTR (DBMS_UTILITY.format_error_stack (), 1, 1999);

         INSERT INTO own_kpi.kpi_errores (fecha_error, kpi_name, error)
              VALUES (SYSDATE, 'QUI_REND_QRF_H_DISP_AH', l_mensaje_error);

         UPDATE own_kpi.CONTROL_LANZAMIENTO
            SET fecha_fin = SYSDATE, PROCEDIMIENTO = ('QUI_REND_QRF_H_DISP_AH ERROR: ' || l_mensaje_error)
          WHERE id = secuencia;

         COMMIT;
   END QUI_REND_QRF_H_DISP_AH;

   PROCEDURE QUI_REND_QRF_H_UTIL_AH
   IS
      --Numero de horas utilizadas de un quirofano

      l_mensaje_error   kpi_errores.error%TYPE;
      secuencia         NUMBER;
   BEGIN
      SELECT own_kpi.SEQ_LANZAMIENTO.NEXTVAL INTO secuencia FROM DUAL;

      INSERT INTO own_kpi.CONTROL_LANZAMIENTO (ID, PROCEDIMIENTO, FECHA_INI)
           VALUES (secuencia, 'QUI_REND_QRF_H_UTIL_AH', SYSDATE);

      COMMIT;


      DELETE FROM OWN_KPI.KPI_QUI_REND_QRF_H_UTIL_AH
            WHERE fecha >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'mm');

      INSERT INTO OWN_KPI.KPI_QUI_REND_QRF_H_UTIL_AH (fecha, contador)
           SELECT TRUNC (fecha_hora_fin, 'mm') AS fecha, SUM ( (fh_fin_ocup - fh_inicio_ocup) * 24) AS contador
             FROM REP_HIS_OWN.ADM_QRF_IQ_POST POST
                  INNER JOIN REP_HIS_OWN.ADM_QRF_PQ_DET det
                     USING (iq_post_id)
                  INNER JOIN REP_HIS_OWN.ADM_QRF_PQ_CAB cab
                     USING (pq_cab_id)
                  INNER JOIN REP_HIS_OWN.ADM_QRF_LOCAL qrf
                     ON cab.quirofano = qrf.ID
            WHERE     fecha_hora_fin >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'mm')
                  AND fecha_hora_fin <= SYSDATE - 1
                  AND qrf.consulta = 0
                  AND (fh_fin_ocup - fh_inicio_ocup) * 24 * 60 < 720
                  AND (fh_fin_ocup - fh_inicio_ocup) > 0
                  AND det.orden <> 65000
                  AND TRUNC (fecha_hora_inicio, 'dd') = TRUNC (fh_inicio_ocup, 'dd')
                  AND fh_inicio_ocup >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'mm')
         GROUP BY TRUNC (fecha_hora_fin, 'mm');

      UPDATE own_kpi.CONTROL_LANZAMIENTO
         SET fecha_fin = SYSDATE
       WHERE id = secuencia;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         l_mensaje_error := SUBSTR (DBMS_UTILITY.format_error_stack (), 1, 1999);

         INSERT INTO own_kpi.kpi_errores (fecha_error, kpi_name, error)
              VALUES (SYSDATE, 'QUI_REND_QRF_H_UTIL_AH', l_mensaje_error);

         UPDATE own_kpi.CONTROL_LANZAMIENTO
            SET fecha_fin = SYSDATE, PROCEDIMIENTO = ('QUI_REND_QRF_H_UTIL_AH ERROR: ' || l_mensaje_error)
          WHERE id = secuencia;

         COMMIT;
   END QUI_REND_QRF_H_UTIL_AH;

   PROCEDURE QUI_REND_QRF_IND_UTIL_AH
   IS
      --Porcentaje de utilizacion de un quirofano.

      l_mensaje_error   kpi_errores.error%TYPE;
      secuencia         NUMBER;
   BEGIN
      SELECT own_kpi.SEQ_LANZAMIENTO.NEXTVAL INTO secuencia FROM DUAL;

      INSERT INTO own_kpi.CONTROL_LANZAMIENTO (ID, PROCEDIMIENTO, FECHA_INI)
           VALUES (secuencia, 'QUI_REND_QRF_IND_UTIL_AH', SYSDATE);

      COMMIT;

      DELETE FROM OWN_KPI.KPI_qui_rend_qrf_ind_util_AH
            WHERE fecha >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'mm');

      INSERT INTO own_kpi.KPI_qui_rend_qrf_ind_util_AH (fecha, contador)
         SELECT TRUNC (fecha, 'mm'), NVL (util.contador / disp.contador * 100, 0) AS contador
           FROM OWN_KPI.KPI_qui_rend_qrf_h_disp_AH disp LEFT JOIN OWN_KPI.KPI_qui_rend_qrf_h_util_AH util USING (fecha)
          WHERE fecha >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'mm');

      UPDATE own_kpi.CONTROL_LANZAMIENTO
         SET fecha_fin = SYSDATE
       WHERE id = secuencia;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         l_mensaje_error := SUBSTR (DBMS_UTILITY.format_error_stack (), 1, 1999);

         INSERT INTO own_kpi.kpi_errores (fecha_error, kpi_name, error)
              VALUES (SYSDATE, 'QUI_REND_QRF_IND_UTIL_AH', l_mensaje_error);

         UPDATE own_kpi.CONTROL_LANZAMIENTO
            SET fecha_fin = SYSDATE, PROCEDIMIENTO = ('QUI_REND_QRF_IND_UTIL_AH ERROR: ' || l_mensaje_error)
          WHERE id = secuencia;

         COMMIT;
   END QUI_REND_QRF_IND_UTIL_AH;


   PROCEDURE QUI_REN_PORCENT_ELIM_AH
   IS
      --% registros de actividad quirurgica eliminados  en el calculo del  indicador "Rendimiento de quirofano" porque los tiempos cumplimentados no son logicos (negativos, nulos o superiores a 720 minutos)

      l_mensaje_error   kpi_errores.error%TYPE;

      fecha             DATE;

      --cursor para leer las iqpre que no tienen iqpost
      CURSOR pre_cursor
      IS
           SELECT COUNT (*) AS contador
             FROM REP_HIS_OWN.ADM_QRF_IQ_PRE PRE
                  INNER JOIN REP_HIS_OWN.ADM_QRF_PQ_DET det
                     USING (iq_pre_id)
                  INNER JOIN REP_HIS_OWN.ADM_QRF_PQ_CAB cab
                     USING (pq_cab_id)
                  INNER JOIN REP_HIS_OWN.ADM_QRF_LOCAL qrf
                     ON cab.quirofano = qrf.ID
            WHERE     cab.FECHA_HORA_FIN >= TRUNC (fecha, 'mm')
                  AND cab.FECHA_HORA_FIN <= LAST_DAY (fecha)
                  AND qrf.consulta = 0
                  AND iq_post_id IS NULL
                  AND pre.estado_id <> 2
                  AND pre.estado_id <> 4
                  AND det.IQ_DESPR_ID IS NULL
                  AND cab.fecha_hora_inicio >= TRUNC (fecha, 'mm')
                  AND cab.fecha_hora_fin <= LAST_DAY (fecha)
         GROUP BY TRUNC (fecha, 'mm');

      --cursor para leer las iqpost que duran un tiempo incorrecto

      CURSOR post_cursor
      IS
           SELECT COUNT (*) AS contador
             FROM REP_HIS_OWN.ADM_QRF_IQ_POST POST
                  INNER JOIN REP_HIS_OWN.ADM_QRF_PQ_DET det
                     USING (iq_post_id)
                  INNER JOIN REP_HIS_OWN.ADM_QRF_PQ_CAB cab
                     USING (pq_cab_id)
                  INNER JOIN REP_HIS_OWN.ADM_QRF_LOCAL qrf
                     ON cab.quirofano = qrf.ID
            WHERE (   (POST.fh_fin >= TRUNC (fecha, 'mm') AND POST.fh_fin <= LAST_DAY (fecha) AND qrf.consulta = 0 AND ( (POST.fh_fin_ocup - POST.fh_inicio_ocup) * 24 * 60 >= 720 OR (POST.fh_fin_ocup - POST.fh_inicio_ocup) <= 0))
                   OR POST.fh_fin IS NULL
                   OR POST.fh_inicio IS NULL)
                  AND det.IQ_DESPR_ID IS NULL
                  AND cab.fecha_hora_inicio >= TRUNC (fecha, 'mm')
                  AND cab.fecha_hora_fin <= LAST_DAY (fecha)
         GROUP BY TRUNC (fecha, 'mm');

      secuencia         NUMBER;
      eliminados        NUMBER;
      pre_sin_post      NUMBER;

      --(CODIGO-NOMBRE,CONTADOR)
      TYPE UF_COUNTERS IS TABLE OF NUMBER
                             INDEX BY VARCHAR2 (500);

      clave             VARCHAR2 (500);
      datos             uf_counters;
   BEGIN
      SELECT own_kpi.SEQ_LANZAMIENTO.NEXTVAL INTO secuencia FROM DUAL;

      INSERT INTO own_kpi.CONTROL_LANZAMIENTO (ID, PROCEDIMIENTO, FECHA_INI)
           VALUES (secuencia, 'QUI_REN_PORCENT_ELIM_AH', SYSDATE);

      COMMIT;

      fecha := ADD_MONTHS (SYSDATE - 1, -12);


      WHILE (fecha <= ADD_MONTHS (SYSDATE - 1, 0))
      LOOP
         DELETE FROM OWN_KPI.KPI_qui_ren_porcent_eli_AH d
               WHERE d.FECHA = TRUNC (fecha, 'mm');

         eliminados := 0;

         FOR fila
            IN (  SELECT TRUNC (cab.FECHA_HORA_FIN, 'mm') AS fecha, COUNT (*) AS contador
                    FROM REP_HIS_OWN.ADM_QRF_IQ_PRE PRE
                         INNER JOIN REP_HIS_OWN.ADM_QRF_PQ_DET det
                            USING (iq_pre_id)
                         INNER JOIN REP_HIS_OWN.ADM_QRF_PQ_CAB cab
                            USING (pq_cab_id)
                         INNER JOIN REP_HIS_OWN.ADM_QRF_LOCAL qrf
                            ON cab.quirofano = qrf.ID
                   WHERE     cab.FECHA_HORA_FIN >= TRUNC (fecha, 'mm')
                         AND cab.FECHA_HORA_FIN <= LAST_DAY (fecha)
                         AND qrf.consulta = 0
                         AND pre.estado_id <> 2
                         AND pre.estado_id <> 4
                         AND det.IQ_DESPR_ID IS NULL
                         AND cab.fecha_hora_inicio >= TRUNC (fecha, 'mm')
                         AND cab.fecha_hora_fin <= LAST_DAY (fecha)
                GROUP BY TRUNC (cab.FECHA_HORA_FIN, 'mm'))
         LOOP
            --contamos laspostintervenciones que no cumplen la regla de tiempo por cada uf

            OPEN post_cursor;

            FETCH post_cursor INTO eliminados;

            IF post_cursor%NOTFOUND
            THEN
               eliminados := 0;
            END IF;

            CLOSE post_cursor;

            clave := TO_CHAR (fecha, 'dd/mm/yyyy');

            --cursor
            OPEN pre_cursor;

            FETCH pre_cursor INTO pre_sin_post;

            IF pre_cursor%NOTFOUND
            THEN
               pre_sin_post := 0;
            END IF;

            CLOSE pre_cursor;

            eliminados := eliminados + pre_sin_post;

            datos (clave) := eliminados / fila.contador * 100;
         END LOOP;

         clave := datos.FIRST;

         WHILE (clave IS NOT NULL)
         LOOP
            IF (TO_DATE (clave, 'dd/mm/yyyy') >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM'))
            THEN
               INSERT INTO OWN_KPI.KPI_qui_ren_porcent_eli_AH (fecha, contador)
                    VALUES (TRUNC (TO_DATE (clave, 'dd/mm/yyyy'), 'mm'), datos (clave));
            END IF;

            clave := datos.NEXT (clave);
         END LOOP;

         fecha := ADD_MONTHS (fecha, 1);
      END LOOP;

      UPDATE own_kpi.CONTROL_LANZAMIENTO
         SET fecha_fin = SYSDATE
       WHERE id = secuencia;

      COMMIT;
   --DBMS_OUTPUT.put_line ('commit final');
   EXCEPTION
      WHEN OTHERS
      THEN
         l_mensaje_error := SUBSTR (DBMS_UTILITY.format_error_stack (), 1, 1999);

         /*DBMS_OUTPUT.put_line (
            SUBSTR (DBMS_UTILITY.format_error_stack (), 1, 1999));*/

         INSERT INTO own_kpi.kpi_errores (fecha_error, kpi_name, error)
              VALUES (SYSDATE, 'QUI_REN_PORCENT_ELIM_AH', l_mensaje_error);

         UPDATE own_kpi.CONTROL_LANZAMIENTO
            SET fecha_fin = SYSDATE, PROCEDIMIENTO = ('QUI_REN_PORCENT_ELIM_AH ERROR: ' || l_mensaje_error)
          WHERE id = secuencia;

         COMMIT;
   END QUI_REN_PORCENT_ELIM_AH;

   PROCEDURE QUI_EST_MED_PREOP_PROG
   IS
      --Tiempo medio desde un ingreso en hospitalizacion hasta la intervencion quirurgica programada con indicacion "preingreso".

      l_mensaje_error   kpi_errores.error%TYPE;

      secuencia         NUMBER;

      TYPE tipoConsulta IS RECORD
      (
         episodio_id     NUMBER (25),
         fingreso        DATE,
         fintervencion   DATE
      );

      TYPE tipoFecha IS RECORD
      (
         fingreso        DATE,
         fintervencion   DATE,
         diferencia      NUMBER
      );

      TYPE htable IS TABLE OF tipoConsulta
                        INDEX BY VARCHAR2 (500);

      TYPE ftable IS TABLE OF tipoFecha
                        INDEX BY VARCHAR2 (500);

      TYPE meses IS TABLE OF NUMBER
                       INDEX BY VARCHAR2 (500);

      CURSOR CONSULTA
      IS
           SELECT DISTINCT ep.episodio_id, ep.fch_apertura AS fingreso, TRUNC (cab.fecha_hora_inicio) AS fintervencion
             FROM REP_HIS_OWN.ADM_EPISODIO ep,
                  REP_HIS_OWN.ADM_QRF_IQ_PRE pre,
                  REP_HIS_OWN.ADM_QRF_PQ_CAB cab,
                  REP_HIS_OWN.ADM_QRF_PQ_DET det
            WHERE     pre.episodio_id = ep.episodio_id
                  AND det.iq_pre_id = pre.iq_pre_id
                  AND pre.tipo_programacion = 2
                  AND det.pq_cab_id = cab.pq_cab_id
                  AND ep.modalidad_asist = 1
                  AND pre.estado_id <> 2
                  AND pre.estado_id <> 4
                  AND ep.fch_apertura >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
         ORDER BY ep.episodio_id;


      objeto            tipoConsulta;
      mitabla           htable;

      oFecha            tipoFecha;
      mitablaFecha      ftable;

      tablaMeses        meses;
      contadorMeses     meses;

      i                 NUMBER;
      ichar             VARCHAR (500);

      c                 NUMBER;
      acumulado         NUMBER;

      clavetrunc        VARCHAR (500);
   BEGIN
      SELECT own_kpi.SEQ_LANZAMIENTO.NEXTVAL INTO secuencia FROM DUAL;

      INSERT INTO own_kpi.CONTROL_LANZAMIENTO (ID, PROCEDIMIENTO, FECHA_INI)
           VALUES (secuencia, 'QUI_EST_MED_PREOP_PROG', SYSDATE);

      COMMIT;

      FOR FILA IN CONSULTA
      LOOP
         IF (NOT mitabla.EXISTS (TO_CHAR (fila.episodio_id)))
         THEN
            objeto.episodio_id := fila.episodio_id;
            objeto.fingreso := fila.fingreso;
            objeto.fintervencion := fila.fintervencion;
            mitabla (TO_CHAR (fila.episodio_id)) := objeto;
         END IF;
      END LOOP;

      i := mitabla.FIRST;

      --where fintervencion >= fingreso AND fintervencion < fingreso + 30)
      WHILE i IS NOT NULL
      LOOP
         objeto := mitabla (i);

         IF (objeto.fintervencion >= objeto.fingreso AND objeto.fintervencion < objeto.fingreso + 30)
         THEN
            oFecha.fingreso := objeto.fingreso;
            oFecha.fintervencion := objeto.fintervencion;
            oFecha.diferencia := objeto.fintervencion - objeto.fingreso;

            mitablaFecha (i) := oFecha;
         END IF;

         i := mitabla.NEXT (i);
      END LOOP;

      i := mitablaFecha.FIRST;

      --agrupacion por mes de intervenciones
      WHILE i IS NOT NULL
      LOOP
         oFecha := mitablaFecha (i);

         clavetrunc := TO_CHAR (TRUNC (oFecha.fingreso, 'MM'), 'DD/MM/YYYY');

         IF (NOT contadorMeses.EXISTS (clavetrunc))                                                                                                                                                                             --inicializacion
         THEN
            contadorMeses (clavetrunc) := 0;
         END IF;


         IF (tablaMeses.EXISTS (clavetrunc))                                                                                                                                                                                 --si existe acumulo
         THEN
            tablaMeses (clavetrunc) := tablaMeses (clavetrunc) + (oFecha.fintervencion - oFecha.fingreso);
            contadorMeses (clavetrunc) := contadorMeses (clavetrunc) + 1;
         ELSE
            tablaMeses (clavetrunc) := oFecha.fintervencion - oFecha.fingreso;
            contadorMeses (clavetrunc) := 1;
         END IF;

         i := mitablaFecha.NEXT (i);
      END LOOP;


      DELETE FROM own_kpi.kpi_qui_est_med_preop_prog
            WHERE fecha >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM');


      ichar := contadorMeses.FIRST;

      WHILE ichar IS NOT NULL
      LOOP
         c := contadorMeses (ichar);

         IF (c <> 0 AND TO_DATE (ichar, 'dd/mm/yyyy') >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM'))
         THEN
            acumulado := tablaMeses (ichar);

            /*DBMS_OUTPUT.put_line (
                  'mes:'
               || ichar
               || ' acumulado:'
               || acumulado
               || ' contador mensual:'
               || c
               || ' resultado:'
               || acumulado / c);
            DBMS_OUTPUT.put_line (
               'INSERT' || TO_DATE (ichar, 'dd/mm/yyyy') || ',' || acumulado / c);*/

            INSERT INTO own_kpi.kpi_qui_est_med_preop_prog (fecha, contador)
                 VALUES (TO_DATE (ichar, 'dd/mm/yyyy'), acumulado / c);
         END IF;

         ichar := contadorMeses.NEXT (ichar);
      END LOOP;

      COMMIT;

      UPDATE own_kpi.CONTROL_LANZAMIENTO
         SET fecha_fin = SYSDATE
       WHERE id = secuencia;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         l_mensaje_error := SUBSTR (DBMS_UTILITY.format_error_stack (), 1, 1999);

         --dbms_output.put_line(SUBSTR (DBMS_UTILITY.format_error_stack (), 1, 1999));
         INSERT INTO own_kpi.kpi_errores (fecha_error, kpi_name, error)
              VALUES (SYSDATE, 'QUI_EST_MED_PREOP_PROG', l_mensaje_error);

         UPDATE own_kpi.CONTROL_LANZAMIENTO
            SET fecha_fin = SYSDATE, PROCEDIMIENTO = ('QUI_EST_MED_PREOP_PROG ERROR: ' || l_mensaje_error)
          WHERE id = secuencia;

         COMMIT;
   END QUI_EST_MED_PREOP_PROG;

   PROCEDURE QUI_EST_MED_PREOP_URG_DIF
   IS
      --Tiempo medio desde un ingreso en hospitalizacion hasta la intervencion  quirurgica con indicacion "urgente diferida", incluyendo las estancias previas en urgencias (criterios CMBD), si procede.

      l_mensaje_error   kpi_errores.error%TYPE;

      secuencia         NUMBER;
   BEGIN
      SELECT own_kpi.SEQ_LANZAMIENTO.NEXTVAL INTO secuencia FROM DUAL;

      INSERT INTO own_kpi.CONTROL_LANZAMIENTO (ID, PROCEDIMIENTO, FECHA_INI)
           VALUES (secuencia, 'QUI_EST_MED_PREOP_URG_DIF', SYSDATE);

      COMMIT;

      DELETE FROM own_kpi.KPI_QUI_EST_MED_PREOP_URG_DIF
            WHERE fecha >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM');

      INSERT INTO own_kpi.KPI_QUI_EST_MED_PREOP_URG_DIF (fecha, contador)
         SELECT datos.*
           FROM (  SELECT TRUNC (fintervencion, 'MM') AS fecha, (SUM (fintervencion - fingreso) / COUNT (1)) AS contador
                     FROM (SELECT *
                             FROM (                                                                                                                                                                                  --PARTE DE EPISODIO INTERNO
                                   SELECT  fingreso, fintervencion, fintervencion - fingreso
                                      FROM (SELECT NVL2 (adm.FCH_ADMISION_URGENCIAS, TO_DATE (TO_CHAR (adm.fch_admision_urgencias, 'dd/mm/yyyy'), 'dd/mm/yyyy'), ep.fch_apertura) AS fingreso, TRUNC (cab.fecha_hora_inicio) AS fintervencion
                                              FROM REP_HIS_OWN.ADM_EPISODIO ep,
                                                   REP_HIS_OWN.ADM_EPIS_DETALLE epdet,
                                                   REP_HIS_OWN.ADM_ADMISION adm,
                                                   REP_HIS_OWN.ADM_QRF_IQ_PRE pre,
                                                   REP_HIS_OWN.ADM_QRF_PQ_CAB cab,
                                                   REP_HIS_OWN.ADM_QRF_PQ_DET det,
                                                   own_kpi.uf_con_padres uf
                                             WHERE     pre.episodio_id = ep.episodio_id
                                                   AND ep.episodio_id = epdet.episodio_id
                                                   AND epdet.referencia_id = adm.admision_id
                                                   AND det.iq_pre_id = pre.iq_pre_id
                                                   AND pre.tipo_programacion = 1
                                                   AND det.pq_cab_id = cab.pq_cab_id
                                                   AND cab.uni_funcional_id = uf.uf_codigo
                                                   AND pre.estado_id <> 2
                                                   AND pre.estado_id <> 4
                                                   AND NVL2 (adm.FCH_ADMISION_URGENCIAS, TO_DATE (TO_CHAR (adm.fch_admision_urgencias, 'dd/mm/yyyy'), 'dd/mm/yyyy'), ep.fch_apertura) >= ADD_MONTHS (TRUNC (SYSDATE, 'MM'), -12)
                                                   AND CAB.UNI_FUNCIONAL_ID = uf.uf_codigo)
                                     WHERE fintervencion >= fingreso AND fintervencion < fingreso + 30)
                           UNION ALL
                           (                                                                                                                                                                                         --PARTE DE EPISODIO EXTERNO
                            SELECT  fingreso, fintervencion, fintervencion - fingreso
                               FROM (SELECT                                                                                                                               /*+ index (pre ADM_QRF_IQ_PRE_TP) index (ep HCE_EPIS_CLI_NEPISODIO) */
                                           ep.fch_ingreso AS fingreso, TRUNC (cab.fecha_hora_inicio) AS fintervencion
                                       FROM REP_SIDCA_OWN.HCE_EPISODIO_CLINICO ep,
                                            REP_HIS_OWN.ADM_QRF_IQ_PRE pre,
                                            REP_HIS_OWN.ADM_QRF_PQ_CAB cab,
                                            REP_HIS_OWN.ADM_QRF_PQ_DET det,
                                            own_kpi.uf_con_padres uf
                                      WHERE     TO_CHAR (pre.epis_externo) = ep.nepisodio
                                            AND det.iq_pre_id = pre.iq_pre_id
                                            AND pre.tipo_programacion = 1
                                            AND det.pq_cab_id = cab.pq_cab_id
                                            AND cab.uni_funcional_id = uf.uf_codigo
                                            AND pre.estado_id <> 2
                                            AND pre.estado_id <> 4
                                            AND ep.fch_ingreso >= ADD_MONTHS (TRUNC (SYSDATE, 'MM'), -12)
                                            AND CAB.UNI_FUNCIONAL_ID = uf.uf_codigo
                                            AND PRE.EPISODIO_ID IS NULL                                                                                                                            -- se comprueba que no tenga episodio interno
                                                                       )
                              WHERE fintervencion >= fingreso AND fintervencion < fingreso + 30)
                           UNION ALL
                           (                                                                                                                                                                      --PARTE SIN NINGUN EPISODIO de hospitalizacion
                            SELECT  fingreso, fintervencion, fintervencion - fingreso
                               FROM (SELECT NVL2 (adm.FCH_ADMISION_URGENCIAS, TO_DATE (TO_CHAR (adm.fch_admision_urgencias, 'dd/mm/yyyy'), 'dd/mm/yyyy'), ep.fch_apertura) AS fingreso, TRUNC (cab.fecha_hora_inicio) AS fintervencion
                                       FROM REP_HIS_OWN.ADM_QRF_IQ_PRE pre,
                                            REP_HIS_OWN.ADM_QRF_PQ_CAB cab,
                                            REP_HIS_OWN.ADM_QRF_PQ_DET det,
                                            REP_HIS_OWN.ADM_EPIS_DETALLE epdet,
                                            REP_HIS_OWN.ADM_ADMISION adm,
                                            own_kpi.uf_con_padres uf,
                                            REP_HIS_OWN.ADM_EPISODIO ep
                                      WHERE     det.iq_pre_id = pre.iq_pre_id
                                            AND pre.tipo_programacion = 1
                                            AND det.pq_cab_id = cab.pq_cab_id
                                            AND cab.uni_funcional_id = uf.uf_codigo
                                            AND pre.estado_id <> 2
                                            AND pre.estado_id <> 4
                                            AND NVL2 (adm.FCH_ADMISION_URGENCIAS, TO_DATE (TO_CHAR (adm.fch_admision_urgencias, 'dd/mm/yyyy'), 'dd/mm/yyyy'), ep.fch_apertura) >= ADD_MONTHS (TRUNC (SYSDATE, 'MM'), -12)
                                            AND CAB.UNI_FUNCIONAL_ID = uf.uf_codigo
                                            AND own_kpi.episodio_sin_asociar (pre.id_usuario, cab.fecha_hora_inicio) = ep.episodio_id
                                            AND (own_kpi.modalidad_episodio (pre.id_usuario, cab.fecha_hora_inicio) = 1 OR own_kpi.modalidad_episodio (pre.id_usuario, cab.fecha_hora_inicio) = 2)
                                            AND ep.episodio_id = epdet.episodio_id
                                            AND epdet.referencia_id = adm.admision_id
                                            AND pre.epis_externo IS NULL
                                            AND pre.episodio_id IS NULL                                                                                                                 -- se comprueba que no tenga episodio interno ni externo
                                                                       )
                              WHERE fintervencion >= fingreso AND fintervencion < fingreso + 30))
                 GROUP BY TRUNC (fintervencion, 'MM')) datos;

      UPDATE own_kpi.CONTROL_LANZAMIENTO
         SET fecha_fin = SYSDATE
       WHERE id = secuencia;

      COMMIT;
   --DBMS_OUTPUT.put_line ('commit final');
   EXCEPTION
      WHEN OTHERS
      THEN
         l_mensaje_error := SUBSTR (DBMS_UTILITY.format_error_stack (), 1, 1999);

         --DBMS_OUTPUT.put_line ('error: ' || l_mensaje_error);
         /*DBMS_OUTPUT.put_line (   'error: '
                               || SUBSTR (DBMS_UTILITY.format_error_stack (),
                                          1,
                                          1999
                                         )
                              );*/
         INSERT INTO own_kpi.kpi_errores (fecha_error, kpi_name, error)
              VALUES (SYSDATE, 'KPI_QUI_EST_MED_PREOP_URG_DIF', l_mensaje_error);

         UPDATE own_kpi.CONTROL_LANZAMIENTO
            SET fecha_fin = SYSDATE, PROCEDIMIENTO = ('QUI_EST_MED_PREOP_URG_DIF ERROR: ' || l_mensaje_error)
          WHERE id = secuencia;

         COMMIT;
   END QUI_EST_MED_PREOP_URG_DIF;

   PROCEDURE QUI_EST_MED_PREOP_GLO
   IS
      --Tiempo medio desde un ingreso en hospitalizacion hasta la intervencion quirurgica programada con indicacion "preingreso".

      l_mensaje_error   kpi_errores.error%TYPE;

      secuencia         NUMBER;

      TYPE tipoConsulta IS RECORD
      (
         fingreso        DATE,
         fintervencion   DATE
      );

      TYPE tipoFecha IS RECORD
      (
         fingreso        DATE,
         fintervencion   DATE,
         diferencia      NUMBER
      );

      TYPE htable IS TABLE OF tipoConsulta
                        INDEX BY VARCHAR2 (500);

      TYPE ftable IS TABLE OF tipoFecha
                        INDEX BY VARCHAR2 (500);

      TYPE meses IS TABLE OF NUMBER
                       INDEX BY VARCHAR2 (500);

      CURSOR CONSULTA
      IS
         SELECT DISTINCT ep.episodio_id, ep.fch_apertura AS fingreso, TRUNC (cab.fecha_hora_inicio) AS fintervencion
           FROM REP_HIS_OWN.ADM_EPISODIO ep,
                REP_HIS_OWN.ADM_QRF_IQ_PRE pre,
                REP_HIS_OWN.ADM_QRF_PQ_CAB cab,
                REP_HIS_OWN.ADM_QRF_PQ_DET det
          WHERE     pre.episodio_id = ep.episodio_id
                AND det.iq_pre_id = pre.iq_pre_id
                AND pre.tipo_programacion = 2
                AND det.pq_cab_id = cab.pq_cab_id
                AND ep.modalidad_asist = 1
                AND pre.estado_id <> 2
                AND pre.estado_id <> 4
                AND ep.fch_apertura >= ADD_MONTHS (TRUNC (SYSDATE, 'MM'), -12);

      /*
       Se utiliza 0-episodio_id para que se cuenten correctamente las urgentes en caso de que el episodio_id sea el mismo
       que el de una programada. Si no se hace esto el algoritmo encontraria que ya esta cargado y no entraría en la cuenta.
       Por otro lado para el caso de aquellos que no tengan episodio asociado, se utiliza el 0-rownum para tener un id con
       el que referenciarlo
       */
      CURSOR URGENTES
      IS
         SELECT datos.*
           FROM (SELECT *
                   FROM (                                                                                                                                                                                            --PARTE DE EPISODIO INTERNO
                         SELECT  0 - episodio_id AS episodio_id, fingreso, fintervencion
                            FROM (SELECT ep.episodio_id,
                                         NVL2 (adm.FCH_ADMISION_URGENCIAS, TO_DATE (TO_CHAR (adm.fch_admision_urgencias, 'dd/mm/yyyy'), 'dd/mm/yyyy'), ep.fch_apertura) AS fingreso,
                                         TRUNC (cab.fecha_hora_inicio) AS fintervencion
                                    FROM REP_HIS_OWN.ADM_EPISODIO ep,
                                         REP_HIS_OWN.ADM_EPIS_DETALLE epdet,
                                         REP_HIS_OWN.ADM_ADMISION adm,
                                         REP_HIS_OWN.ADM_QRF_IQ_PRE pre,
                                         REP_HIS_OWN.ADM_QRF_PQ_CAB cab,
                                         REP_HIS_OWN.ADM_QRF_PQ_DET det,
                                         own_kpi.uf_con_padres uf
                                   WHERE     pre.episodio_id = ep.episodio_id
                                         AND ep.episodio_id = epdet.episodio_id
                                         AND epdet.referencia_id = adm.admision_id
                                         AND det.iq_pre_id = pre.iq_pre_id
                                         AND pre.tipo_programacion = 1
                                         AND det.pq_cab_id = cab.pq_cab_id
                                         AND cab.uni_funcional_id = uf.uf_codigo
                                         AND pre.estado_id <> 2
                                         AND pre.estado_id <> 4
                                         AND NVL2 (adm.FCH_ADMISION_URGENCIAS, TO_DATE (TO_CHAR (adm.fch_admision_urgencias, 'dd/mm/yyyy'), 'dd/mm/yyyy'), ep.fch_apertura) >= ADD_MONTHS (TRUNC (SYSDATE, 'MM'), -12)
                                         AND CAB.UNI_FUNCIONAL_ID = uf.uf_codigo)
                           WHERE fintervencion >= fingreso AND fintervencion < fingreso + 30)
                 UNION ALL
                 (                                                                                                                                                                                                   --PARTE DE EPISODIO EXTERNO
                  SELECT  0 - episodio_id AS episodio_id, fingreso, fintervencion
                     FROM (SELECT                                                                                                                                         /*+ index (pre ADM_QRF_IQ_PRE_TP) index (ep HCE_EPIS_CLI_NEPISODIO) */
                                 pre.iq_pre_id AS episodio_id, ep.fch_ingreso AS fingreso, TRUNC (cab.fecha_hora_inicio) AS fintervencion
                             FROM REP_SIDCA_OWN.HCE_EPISODIO_CLINICO ep,
                                  REP_HIS_OWN.ADM_QRF_IQ_PRE pre,
                                  REP_HIS_OWN.ADM_QRF_PQ_CAB cab,
                                  REP_HIS_OWN.ADM_QRF_PQ_DET det,
                                  own_kpi.uf_con_padres uf
                            WHERE     TO_CHAR (pre.epis_externo) = ep.nepisodio
                                  AND det.iq_pre_id = pre.iq_pre_id
                                  AND pre.tipo_programacion = 1
                                  AND det.pq_cab_id = cab.pq_cab_id
                                  AND cab.uni_funcional_id = uf.uf_codigo
                                  AND pre.estado_id <> 2
                                  AND pre.estado_id <> 4
                                  AND ep.fch_ingreso >= ADD_MONTHS (TRUNC (SYSDATE, 'MM'), -12)
                                  AND CAB.UNI_FUNCIONAL_ID = uf.uf_codigo
                                  AND PRE.EPISODIO_ID IS NULL                                                                                                                                      -- se comprueba que no tenga episodio interno
                                                             )
                    WHERE fintervencion >= fingreso AND fintervencion < fingreso + 30)
                 UNION ALL
                 (                                                                                                                                                                                --PARTE SIN NINGUN EPISODIO de hospitalizacion
                  SELECT  0 - ROWNUM, fingreso, fintervencion
                     FROM (SELECT NVL2 (adm.FCH_ADMISION_URGENCIAS, TO_DATE (TO_CHAR (adm.fch_admision_urgencias, 'dd/mm/yyyy'), 'dd/mm/yyyy'), ep.fch_apertura) AS fingreso, TRUNC (cab.fecha_hora_inicio) AS fintervencion
                             FROM REP_HIS_OWN.ADM_QRF_IQ_PRE pre,
                                  REP_HIS_OWN.ADM_QRF_PQ_CAB cab,
                                  REP_HIS_OWN.ADM_QRF_PQ_DET det,
                                  REP_HIS_OWN.ADM_EPIS_DETALLE epdet,
                                  REP_HIS_OWN.ADM_ADMISION adm,
                                  own_kpi.uf_con_padres uf,
                                  REP_HIS_OWN.ADM_EPISODIO ep
                            WHERE     det.iq_pre_id = pre.iq_pre_id
                                  AND pre.tipo_programacion = 1
                                  AND det.pq_cab_id = cab.pq_cab_id
                                  AND cab.uni_funcional_id = uf.uf_codigo
                                  AND pre.estado_id <> 2
                                  AND pre.estado_id <> 4
                                  AND NVL2 (adm.FCH_ADMISION_URGENCIAS, TO_DATE (TO_CHAR (adm.fch_admision_urgencias, 'dd/mm/yyyy'), 'dd/mm/yyyy'), ep.fch_apertura) >= ADD_MONTHS (TRUNC (SYSDATE, 'MM'), -12)
                                  AND CAB.UNI_FUNCIONAL_ID = uf.uf_codigo
                                  AND own_kpi.episodio_sin_asociar (pre.id_usuario, cab.fecha_hora_inicio) = ep.episodio_id
                                  AND (own_kpi.modalidad_episodio (pre.id_usuario, cab.fecha_hora_inicio) = 1 OR own_kpi.modalidad_episodio (pre.id_usuario, cab.fecha_hora_inicio) = 2)
                                  AND ep.episodio_id = epdet.episodio_id
                                  AND epdet.referencia_id = adm.admision_id
                                  AND pre.epis_externo IS NULL
                                  AND pre.episodio_id IS NULL                                                                                                                           -- se comprueba que no tenga episodio interno ni externo
                                                             )
                    WHERE fintervencion >= fingreso AND fintervencion < fingreso + 30)) datos;

      objeto            tipoConsulta;
      mitabla           htable;

      oFecha            tipoFecha;
      mitablaFecha      ftable;

      tablaMeses        meses;
      contadorMeses     meses;

      i                 NUMBER;
      ichar             VARCHAR (500);

      c                 NUMBER;
      acumulado         NUMBER;

      clavetrunc        VARCHAR (500);
   BEGIN
      SELECT own_kpi.SEQ_LANZAMIENTO.NEXTVAL INTO secuencia FROM DUAL;

      INSERT INTO own_kpi.CONTROL_LANZAMIENTO (ID, PROCEDIMIENTO, FECHA_INI)
           VALUES (secuencia, 'QUI_EST_MED_PREOP_GLO', SYSDATE);

      COMMIT;

      FOR FILA IN CONSULTA
      LOOP
         IF (NOT mitabla.EXISTS (TO_CHAR (fila.episodio_id)))
         THEN
            objeto.fingreso := fila.fingreso;
            objeto.fintervencion := fila.fintervencion;
            mitabla (TO_CHAR (fila.episodio_id)) := objeto;
         END IF;
      END LOOP;

      FOR FILA IN URGENTES
      LOOP
         IF (NOT mitabla.EXISTS (TO_CHAR (fila.episodio_id)))
         THEN
            objeto.fingreso := fila.fingreso;
            objeto.fintervencion := fila.fintervencion;
            mitabla (TO_CHAR (fila.episodio_id)) := objeto;
         END IF;
      END LOOP;

      i := mitabla.FIRST;


      WHILE i IS NOT NULL
      LOOP
         objeto := mitabla (i);

         IF (objeto.fintervencion >= objeto.fingreso AND objeto.fintervencion < objeto.fingreso + 30)
         THEN
            oFecha.fingreso := objeto.fingreso;
            oFecha.fintervencion := objeto.fintervencion;
            oFecha.diferencia := objeto.fintervencion - objeto.fingreso;

            mitablaFecha (i) := oFecha;
         END IF;

         i := mitabla.NEXT (i);
      END LOOP;

      i := mitablaFecha.FIRST;

      --agrupacion por mes de intervenciones
      WHILE i IS NOT NULL
      LOOP
         oFecha := mitablaFecha (i);

         clavetrunc := TO_CHAR (TRUNC (oFecha.fingreso, 'MM'), 'DD/MM/YYYY');

         IF (NOT contadorMeses.EXISTS (clavetrunc))                                                                                                                                                                             --inicializacion
         THEN
            contadorMeses (clavetrunc) := 0;
         END IF;


         IF (tablaMeses.EXISTS (clavetrunc))                                                                                                                                                                                 --si existe acumulo
         THEN
            tablaMeses (clavetrunc) := tablaMeses (clavetrunc) + (oFecha.fintervencion - oFecha.fingreso);
            contadorMeses (clavetrunc) := contadorMeses (clavetrunc) + 1;
         ELSE
            tablaMeses (clavetrunc) := oFecha.fintervencion - oFecha.fingreso;
            contadorMeses (clavetrunc) := 1;
         END IF;

         i := mitablaFecha.NEXT (i);
      END LOOP;

      DELETE FROM own_kpi.KPI_QUI_EST_MED_PREOP_GLO
            WHERE fecha >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM');


      ichar := contadorMeses.FIRST;

      WHILE ichar IS NOT NULL
      LOOP
         c := contadorMeses (ichar);

         --controlo que no se vaya a insertar nada anterior a 12 meses
         IF (c <> 0 AND TO_DATE (ichar, 'dd/mm/yyyy') >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM'))
         THEN
            acumulado := tablaMeses (ichar);

            /*DBMS_OUTPUT.put_line (
                  'mes:'
               || ichar
              || ' acumulado:'
               || acumulado
               || ' contador mensual:'
               || c
               || ' resultado:'
               || acumulado / c);
            DBMS_OUTPUT.put_line (
               'INSERT' || TO_DATE (ichar, 'dd/mm/yyyy') || ',' || acumulado / c);*/

            INSERT INTO own_kpi.KPI_QUI_EST_MED_PREOP_GLO (fecha, contador)
                 VALUES (TO_DATE (ichar, 'dd/mm/yyyy'), acumulado / c);
         END IF;

         ichar := contadorMeses.NEXT (ichar);
      END LOOP;

      COMMIT;

      UPDATE own_kpi.CONTROL_LANZAMIENTO
         SET fecha_fin = SYSDATE
       WHERE id = secuencia;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         l_mensaje_error := SUBSTR (DBMS_UTILITY.format_error_stack (), 1, 1999);

         --dbms_output.put_line(SUBSTR (DBMS_UTILITY.format_error_stack (), 1, 1999));
         INSERT INTO own_kpi.kpi_errores (fecha_error, kpi_name, error)
              VALUES (SYSDATE, 'QUI_EST_MED_PREOP_GLO', l_mensaje_error);

         UPDATE own_kpi.CONTROL_LANZAMIENTO
            SET fecha_fin = SYSDATE, PROCEDIMIENTO = ('QUI_EST_MED_PREOP_GLO ERROR: ' || l_mensaje_error)
          WHERE id = secuencia;

         COMMIT;
   END QUI_EST_MED_PREOP_GLO;

   PROCEDURE LANZAR_TODO
   IS
   --Procedimiento resumen de lanzamiento de este paquete

   BEGIN
      PKG_UPDATE_KPI_QUI.QUI_N_INTERV ();
      PKG_UPDATE_KPI_QUI.QUI_N_INTERV_FIRM ();
      PKG_UPDATE_KPI_QUI.QUI_N_INTERV_MENOS_UNO ();
      PKG_UPDATE_KPI_QUI.QUI_N_INTERV_FIRM_M_UNO ();
      PKG_UPDATE_KPI_QUI.QUI_N_INTERV_CMA ();
      PKG_UPDATE_KPI_QUI.QUI_N_INTERV_FIRM_CMA ();
      PKG_UPDATE_KPI_QUI.QUI_N_INTERV_AMBU ();
      PKG_UPDATE_KPI_QUI.QUI_N_INTERV_FIRM_AMBU ();
      PKG_UPDATE_KPI_QUI.QUI_N_INTERV_URG_HOSP ();
      PKG_UPDATE_KPI_QUI.QUI_N_INTERV_URG_HDQ ();
      PKG_UPDATE_KPI_QUI.QUI_N_INTERV_URG_URG ();
      PKG_UPDATE_KPI_QUI.QUI_N_SUSP_HOSP ();
      PKG_UPDATE_KPI_QUI.QUI_N_SUSP_AMBU ();
      PKG_UPDATE_KPI_QUI.QUI_N_SUSP_MOT_P_UF ();
      PKG_UPDATE_KPI_QUI.QUI_REND_QRF_H_DISP_AH ();
      PKG_UPDATE_KPI_QUI.QUI_REND_QRF_H_UTIL_AH ();
      PKG_UPDATE_KPI_QUI.QUI_REND_QRF_IND_UTIL_AH ();
      PKG_UPDATE_KPI_QUI.QUI_REN_PORCENT_ELIM_AH ();
      PKG_UPDATE_KPI_QUI.QUI_EST_MED_PREOP_PROG ();
      PKG_UPDATE_KPI_QUI.QUI_EST_MED_PREOP_GLO ();
      PKG_UPDATE_KPI_QUI.QUI_EST_MED_PREOP_URG_DIF ();
   END LANZAR_TODO;
END PKG_UPDATE_KPI_QUI;