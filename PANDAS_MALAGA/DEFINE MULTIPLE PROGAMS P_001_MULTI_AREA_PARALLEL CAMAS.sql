/* Formatted on 8/27/2014 4:52:01 PM (QP5 v5.163.1008.3004) */
DECLARE
   v_program_name   VARCHAR2 (30) := NULL;
BEGIN
   FOR C1 IN (SELECT NATID_AREA_HOSPITALARIA
                FROM MSTR_UTL_LOCAL_CODIGOS
               WHERE ENABLED = 1)
   LOOP
      v_program_name := 'CAMAS_' || C1.NATID_AREA_HOSPITALARIA || '_STEP01';

      BEGIN
         DBMS_SCHEDULER.DROP_PROGRAM (program_name => v_program_name);
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      BEGIN
         DBMS_SCHEDULER.CREATE_PROGRAM (program_name     => v_program_name,
                                        program_type     => 'PLSQL_BLOCK',
                                        program_action   => 'BEGIN ETL_LOAD_ESTANCIAS_V3.P_001_MULTI_AREA(''' || C1.NATID_AREA_HOSPITALARIA || '''); END;',
                                        --number_of_arguments   => 1,
                                        enabled          => TRUE,
                                        comments         => 'Carga de traslados para cálculo de ESTANCIAS del área ' || C1.NATID_AREA_HOSPITALARIA);
      END;
   END LOOP;
END;

BEGIN
   DBMS_SCHEDULER.CREATE_PROGRAM (program_name     => 'ESTANCIAS_ALL_STEP02',
                                  program_type     => 'STORED_PROCEDURE',
                                  program_action   => 'ETL_LOAD_ESTANCIAS_V3.P_002',
                                  --number_of_arguments   => 1,
                                  enabled          => TRUE,
                                  comments         => 'MERGE de traslados para cálculo de ESTANCIAS de todas las áreas');
END;
/