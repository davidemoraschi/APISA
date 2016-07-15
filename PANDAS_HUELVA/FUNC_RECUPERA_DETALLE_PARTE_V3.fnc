/* Formatted on 05/03/2013 14:18:42 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FUNCTION MSTR_QUIROFANO.FUNC_RECUPERA_DETALLE_PARTE_v3 (NEPISODIO                   IN VARCHAR2,
                                                                          UF_PARTE                    IN VARCHAR2,
                                                                          FHORA_INICIO_INTERVENCION   IN DATE,
                                                                          P_NUHSA                     IN VARCHAR2)
   RETURN NUMBER
AS
   V_PQ_CAB_ID   NUMBER;
   V_PQ_DET_ID   NUMBER;
   V_UF_PARTE    VARCHAR2 (20);
BEGIN
   IF UF_PARTE IS NULL
   THEN
      V_UF_PARTE := FUNC_RECUPERA_UNIDA_FUNCI_v2 (NEPISODIO, P_NUHSA);
   ELSE
      V_UF_PARTE := UF_PARTE;
   END IF;

   IF NEPISODIO IN ('NO_INFORMADO', '0')
   THEN
      RETURN '-1';
   ELSE
      BEGIN
         --V_PQ_CAB_ID := ;
         -- Busca el detalle del parte donde aparece el episodio
         SELECT PQ_DET_ID
           INTO V_PQ_DET_ID
           FROM REP_HIS_OWN.ADM_QRF_PQ_DET@RND
          WHERE PQ_CAB_ID IN
                   (SELECT PQ_CAB_ID
                      FROM REP_HIS_OWN.ADM_QRF_PQ_CAB@RND
                     WHERE TRUNC (FECHA_HORA_INICIO) = TRUNC (FHORA_INICIO_INTERVENCION) AND UNI_FUNCIONAL_ID = V_UF_PARTE)
                AND IQ_PRE_ID =
                       (SELECT IQ_PRE_ID
                          FROM REP_HIS_OWN.ADM_QRF_IQ_PRE@RND
                         WHERE IQ_PRE_ID IN
                                  (SELECT IQ_PRE_ID
                                     FROM REP_HIS_OWN.ADM_QRF_PQ_DET@RND
                                    WHERE PQ_CAB_ID IN
                                             (SELECT PQ_CAB_ID
                                                FROM REP_HIS_OWN.ADM_QRF_PQ_CAB@RND
                                               WHERE TRUNC (FECHA_HORA_INICIO) = TRUNC (FHORA_INICIO_INTERVENCION)
                                                     AND UNI_FUNCIONAL_ID = V_UF_PARTE))
                               AND EPISODIO_ID = NEPISODIO);
      EXCEPTION
         -- Si no aparece el episodio en el parte, busca un detalle con el usuario y la fecha de intervención

         WHEN NO_DATA_FOUND
         THEN
            --V_PQ_DET_ID := -2;

            BEGIN
               SELECT PQ_DET_ID
                 INTO V_PQ_DET_ID
                 FROM REP_HIS_OWN.ADM_QRF_IQ_PRE@RND
                      JOIN REP_HIS_OWN.ADM_QRF_PQ_DET@RND
                         USING (IQ_PRE_ID)
                      JOIN REP_HIS_OWN.ADM_QRF_PQ_CAB@RND
                         USING (PQ_CAB_ID)
                WHERE ID_USUARIO IN (SELECT ID_USUARIO
                                       FROM REP_HIS_OWN.COM_USUARIO@RND
                                      WHERE NUHSA = P_NUHSA)
                      AND TRUNC (FECHA_HORA_INICIO) = TRUNC (FHORA_INICIO_INTERVENCION);
            EXCEPTION
               WHEN TOO_MANY_ROWS
               THEN
                  DBMS_OUTPUT.put_line (P_NUHSA);
            END;
         WHEN OTHERS
         THEN
            DBMS_OUTPUT.put_line (NEPISODIO);
      END;

      RETURN V_PQ_DET_ID;
   END IF;
END;
/