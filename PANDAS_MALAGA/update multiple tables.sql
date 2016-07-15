/* Formatted on 5/23/2014 9:48:09 (QP5 v5.163.1008.3004) */
DECLARE
   v_NATID_UNIDAD_FUNCIONAL3_RESP   MSTR_DET_CAMAS_HISTORICO.NATID_UNIDAD_FUNCIONAL3_RESP%TYPE;
BEGIN
   EXECUTE IMMEDIATE 'ALTER TABLE MSTR_DET_CAMAS_HISTORICO READ WRITE';
   FOR C1 IN (SELECT NATID_AREA_HOSPITALARIA               --, DB_LINK_REPLICA
                FROM MSTR_UTL_LOCAL_CODIGOS
               WHERE ENABLED = 1     /*AND NATID_AREA_HOSPITALARIA = '02028'*/
                                )
   LOOP
      FOR C2
         IN (SELECT NATID_AREA_HOSPITALARIA, NATID_EPISODIO, NATID_FECHA
               FROM MSTR_DET_CAMAS_HISTORICO
              WHERE     NATID_AREA_HOSPITALARIA = C1.NATID_AREA_HOSPITALARIA
                    AND NATID_UNIDAD_FUNCIONAL3_RESP IS NULL
                    AND NATID_EPISODIO > 0)
      LOOP
         BEGIN
            EXECUTE IMMEDIATE
                  'SELECT UNIDAD_FUNCIONAL
              FROM TEMP_CAMAS_A2'
               || C1.NATID_AREA_HOSPITALARIA
               || '
             WHERE     NATID_AREA_HOSPITALARIA = '''
               || C2.NATID_AREA_HOSPITALARIA
               || '''
                   AND NATID_EPISODIO = '''
               || C2.NATID_EPISODIO
               || '''
                   AND NATID_FECHA = '''
               || C2.NATID_FECHA
               || ''''
               INTO v_NATID_UNIDAD_FUNCIONAL3_RESP;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.put_line (
                     'Error '
                  || C2.NATID_AREA_HOSPITALARIA
                  || ' '
                  || C2.NATID_EPISODIO
                  || ' '
                  || C2.NATID_FECHA);
         END;

         UPDATE MSTR_DET_CAMAS_HISTORICO
            SET NATID_UNIDAD_FUNCIONAL3_RESP = v_NATID_UNIDAD_FUNCIONAL3_RESP
          WHERE     NATID_AREA_HOSPITALARIA = C2.NATID_AREA_HOSPITALARIA
                AND NATID_EPISODIO = C2.NATID_EPISODIO
                AND NATID_FECHA = C2.NATID_FECHA
                AND NATID_UNIDAD_FUNCIONAL3_RESP IS NULL;

         DBMS_OUTPUT.put_line (SQL%ROWCOUNT);
      END LOOP;
   END LOOP;
   EXECUTE IMMEDIATE 'ALTER TABLE MSTR_DET_CAMAS_HISTORICO READ ONLY';
END;