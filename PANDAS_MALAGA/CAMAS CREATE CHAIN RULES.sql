/* Formatted on 9/4/2014 1:33:44 PM (QP5 v5.163.1008.3004) */
DECLARE
   v_action      VARCHAR2 (2000) := NULL;
   v_condition   VARCHAR2 (2000) := NULL;
BEGIN

    DBMS_SCHEDULER.DEFINE_CHAIN_RULE (chain_name => 'PANDAS_CAMAS', condition => 'TRUE', action => 'START ESTRUCTURA_ALL_STEP01');

   FOR C1 IN (SELECT NATID_AREA_HOSPITALARIA
                FROM MSTR_UTL_LOCAL_CODIGOS
               WHERE ENABLED = 1)
   LOOP
      v_action := 'CAMAS_' || C1.NATID_AREA_HOSPITALARIA || '_STEP01';

      IF v_condition IS NULL
      THEN
         v_condition := v_action || ' COMPLETED';
      ELSE
         v_condition := v_condition || ' AND ' || v_action || ' COMPLETED';
      END IF;

      DBMS_SCHEDULER.DEFINE_CHAIN_RULE (chain_name => 'PANDAS_CAMAS', condition => 'ESTRUCTURA_ALL_STEP01 COMPLETED', action => 'START ' || v_action);
   END LOOP;

   DBMS_OUTPUT.put_line (v_condition);
    DBMS_SCHEDULER.DEFINE_CHAIN_RULE (chain_name => 'PANDAS_CAMAS', condition => v_condition, action => 'START CAMAS_ALL_STEP02');
    DBMS_SCHEDULER.DEFINE_CHAIN_RULE (chain_name => 'PANDAS_CAMAS', condition => 'CAMAS_ALL_STEP02 COMPLETED', action => 'END');
END;
/

--
--BEGIN
--   DBMS_SCHEDULER.DEFINE_CHAIN_RULE (chain_name => 'PANDAS_ESTANCIAS', condition => v_condition, action => 'END');
--END;
--/

--- enable the chain

BEGIN
   DBMS_SCHEDULER.ENABLE (name => 'PANDAS_CAMAS');
END;
/

ALTER SESSION SET TIME_ZONE = 'Europe/Madrid';


BEGIN
   DBMS_SCHEDULER.CREATE_JOB (job_name          => 'ETL_LOAD_CAMAS_P001_MT',
                              job_type          => 'CHAIN',
                              job_action        => 'PANDAS_CAMAS',
                              start_date        => CURRENT_TIMESTAMP,
                              repeat_interval   => 'freq=daily; byhour=07; byminute=00; bysecond=45',
                              end_date          => NULL,
                              enabled           => TRUE,
                              comments          => 'Carga paralela de camas a partir de las réplicas');
END;

--COMMIT;