/* Formatted on 9/8/2014 11:43:23 AM (QP5 v5.163.1008.3004) */
BEGIN
   DBMS_SCHEDULER.DROP_JOB (job_name => 'DQA_REP_HIS_OWN_P001_MT');
END;
/

BEGIN
   DBMS_SCHEDULER.DROP_CHAIN (chain_name => 'PANDAS_DATA_QUALITY');
END;
/

DECLARE
   v_program_name   VARCHAR2 (30) := NULL;
BEGIN
   FOR C1 IN (SELECT NATID_AREA_HOSPITALARIA
                FROM MSTR_UTL_LOCAL_CODIGOS
               WHERE ENABLED = 1)
   LOOP
      v_program_name := 'DQA_EPI_HUERFANOS_' || C1.NATID_AREA_HOSPITALARIA;

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
                                        program_action   => 'BEGIN DQA_REP_HIS_OWN.P_001_EPISODIOS_HERFANOS(''' || C1.NATID_AREA_HOSPITALARIA || '''); END;',
                                        --number_of_arguments   => 1,
                                        enabled          => TRUE,
                                        comments         => 'Data Quality Assessment ' || C1.NATID_AREA_HOSPITALARIA);
      END;
   END LOOP;
END;
/

BEGIN
   DBMS_SCHEDULER.CREATE_CHAIN (chain_name            => 'PANDAS_DATA_QUALITY',
                                rule_set_name         => NULL,
                                evaluation_interval   => NULL,
                                comments              => 'Cadena de ejecuciones para Data Quality Assessment');
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
      v_step_name := 'DQA_EPI_HUERFANOS_' || C1.NATID_AREA_HOSPITALARIA;
      DBMS_SCHEDULER.DEFINE_CHAIN_STEP (chain_name => 'PANDAS_DATA_QUALITY', step_name => v_step_name, program_name => v_step_name);
   END LOOP;
END;
/

----
--
--BEGIN
--   DBMS_SCHEDULER.DEFINE_CHAIN_STEP (chain_name => 'PANDAS_DATA_QUALITY', step_name => 'CAMAS_ALL_STEP02', program_name => 'CAMAS_ALL_STEP02');
--END;
--/


DECLARE
   v_action      VARCHAR2 (2000) := NULL;
   v_condition   VARCHAR2 (2000) := NULL;
BEGIN
   --DBMS_SCHEDULER.DEFINE_CHAIN_RULE (chain_name => 'PANDAS_DATA_QUALITY', condition => 'TRUE', action => 'START ESTRUCTURA_ALL_STEP01');

   FOR C1 IN (SELECT NATID_AREA_HOSPITALARIA
                FROM MSTR_UTL_LOCAL_CODIGOS
               WHERE ENABLED = 1)
   LOOP
      v_action := 'DQA_EPI_HUERFANOS_' || C1.NATID_AREA_HOSPITALARIA;

      IF v_condition IS NULL
      THEN
         v_condition := v_action || ' SUCCEEDED';
      ELSE
         v_condition := v_condition || ' AND ' || v_action || ' SUCCEEDED';
      END IF;

      DBMS_SCHEDULER.DEFINE_CHAIN_RULE (chain_name => 'PANDAS_DATA_QUALITY', condition => 'TRUE', action => 'START ' || v_action);
   END LOOP;

   --DBMS_OUTPUT.put_line (v_condition);
   -- DBMS_SCHEDULER.DEFINE_CHAIN_RULE (chain_name => 'PANDAS_DATA_QUALITY', condition => v_condition, action => 'START CAMAS_ALL_STEP02');
   DBMS_SCHEDULER.DEFINE_CHAIN_RULE (chain_name => 'PANDAS_DATA_QUALITY', condition => v_condition, action => 'END');
END;
/

--
--BEGIN
--   DBMS_SCHEDULER.DEFINE_CHAIN_RULE (chain_name => 'PANDAS_ESTANCIAS', condition => v_condition, action => 'END');
--END;
--/

--- enable the chain

BEGIN
   DBMS_SCHEDULER.ENABLE (name => 'PANDAS_DATA_QUALITY');
END;
/

ALTER SESSION SET TIME_ZONE = 'Europe/Madrid';


BEGIN
   DBMS_SCHEDULER.CREATE_JOB (job_name          => 'DQA_REP_HIS_OWN_P001_MT',
                              job_type          => 'CHAIN',
                              job_action        => 'PANDAS_DATA_QUALITY',
                              start_date        => CURRENT_TIMESTAMP,
                              repeat_interval   => 'freq=daily; byhour=11; byminute=00; bysecond=45',
                              end_date          => NULL,
                              enabled           => TRUE,
                              comments          => 'Data Quality Assessment sobre las réplicas');
END;