/* Formatted on 10/14/2014 1:14:53 PM (QP5 v5.163.1008.3004) */
BEGIN
   DBMS_SCHEDULER.DROP_JOB (job_name => 'ETL_LOAD_INTERV_P001_MT');
END;
/

BEGIN
   DBMS_SCHEDULER.DROP_CHAIN (chain_name => 'PANDAS_INTERV');
END;
/

DECLARE
   v_program_name   VARCHAR2 (30) := NULL;
BEGIN
   FOR C1 IN (SELECT NATID_AREA_HOSPITALARIA
                FROM MSTR_UTL_LOCAL_CODIGOS
               WHERE ENABLED = 1)
   LOOP
      v_program_name := 'INTERV_' || C1.NATID_AREA_HOSPITALARIA || '_STEP01';

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
                                        program_action   => 'BEGIN ETL_LOAD_INTERVENCIONES_V3.P_001_MULTI_AREA(''' || C1.NATID_AREA_HOSPITALARIA || '''); END;',
                                        --number_of_arguments   => 1,
                                        enabled          => TRUE,
                                        comments         => 'Carga de Intervenciones del �rea ' || C1.NATID_AREA_HOSPITALARIA);
      END;
   END LOOP;
END;
/

BEGIN
   DBMS_SCHEDULER.DROP_PROGRAM (program_name => 'INTERV_ALL_STEP02');
   DBMS_SCHEDULER.CREATE_PROGRAM (program_name     => 'INTERV_ALL_STEP02',
                                  program_type     => 'STORED_PROCEDURE',
                                  program_action   => 'ETL_LOAD_INTERVENCIONES_V3.P_002',
                                  --number_of_arguments   => 1,
                                  enabled          => TRUE,
                                  comments         => 'MERGE de Intervenciones de todas las �reas');
END;
/

BEGIN
   DBMS_SCHEDULER.CREATE_CHAIN (chain_name            => 'PANDAS_INTERV',
                                rule_set_name         => NULL,
                                evaluation_interval   => NULL,
                                comments              => 'Cadena de ejecuciones para Intervenciones a partir de las r�plicas');
END;
/

DECLARE
   v_step_name   VARCHAR2 (30) := NULL;
BEGIN
   --DBMS_SCHEDULER.DEFINE_CHAIN_STEP (chain_name => 'PANDAS_DATA_QUALITY', step_name => 'ESTRUCTURA_ALL_STEP01', program_name => 'ESTRUCTURA_ALL_STEP01');

   FOR C1 IN (SELECT NATID_AREA_HOSPITALARIA, DB_LINK_REPLICA
                FROM MSTR_UTL_LOCAL_CODIGOS
               WHERE ENABLED = 1)
   LOOP
      v_step_name := 'INTERV_' || C1.NATID_AREA_HOSPITALARIA || '_STEP01';
      DBMS_SCHEDULER.DEFINE_CHAIN_STEP (chain_name => 'PANDAS_INTERV', step_name => v_step_name, program_name => v_step_name);
   END LOOP;
END;
/

BEGIN
   DBMS_SCHEDULER.DEFINE_CHAIN_STEP (chain_name => 'PANDAS_INTERV', step_name => 'INTERV_ALL_STEP02', program_name => 'INTERV_ALL_STEP02');
END;
/

DECLARE
   v_action      VARCHAR2 (2000) := NULL;
   v_condition   VARCHAR2 (2000) := NULL;
BEGIN
   --DBMS_SCHEDULER.DEFINE_CHAIN_RULE (chain_name => 'PANDAS_DATA_QUALITY', condition => 'TRUE', action => 'START ESTRUCTURA_ALL_STEP01');

   FOR C1 IN (SELECT NATID_AREA_HOSPITALARIA
                FROM MSTR_UTL_LOCAL_CODIGOS
               WHERE ENABLED = 1)
   LOOP
      v_action := 'INTERV_' || C1.NATID_AREA_HOSPITALARIA || '_STEP01';

      IF v_condition IS NULL
      THEN
         v_condition := v_action || ' COMPLETED';
      ELSE
         v_condition := v_condition || ' AND ' || v_action || ' COMPLETED';
      END IF;

      DBMS_SCHEDULER.DEFINE_CHAIN_RULE (chain_name => 'PANDAS_INTERV', condition => 'TRUE', action => 'START ' || v_action);
   END LOOP;

   --DBMS_OUTPUT.put_line (v_condition);
   DBMS_SCHEDULER.DEFINE_CHAIN_RULE (chain_name => 'PANDAS_INTERV', condition => v_condition, action => 'START INTERV_ALL_STEP02');
   DBMS_SCHEDULER.DEFINE_CHAIN_RULE (chain_name => 'PANDAS_INTERV', condition => 'INTERV_ALL_STEP02 COMPLETED', action => 'END');
END;
/

--
--BEGIN
--   DBMS_SCHEDULER.DEFINE_CHAIN_RULE (chain_name => 'PANDAS_INTERV', condition => v_condition, action => 'END');
--END;
--/

--- enable the chain

BEGIN
   DBMS_SCHEDULER.ENABLE (name => 'PANDAS_INTERV');
END;
/

ALTER SESSION SET TIME_ZONE = 'Europe/Madrid';


BEGIN
   DBMS_SCHEDULER.CREATE_JOB (job_name          => 'ETL_LOAD_INTERV_P001_MT',
                              job_type          => 'CHAIN',
                              job_action        => 'PANDAS_INTERV',
                              start_date        => CURRENT_TIMESTAMP,
                              repeat_interval   => 'freq=daily; byhour=12; byminute=30; bysecond=30',
                              end_date          => NULL,
                              enabled           => TRUE,
                              comments          => 'Carga de INTERV del d�a a partir de la r�plica');
END;