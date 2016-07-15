/* Formatted on 8/27/2014 5:02:21 PM (QP5 v5.163.1008.3004) */
DECLARE
   v_action      VARCHAR2 (2000) := NULL;
   v_condition   VARCHAR2 (2000) := NULL;
BEGIN
   FOR C1 IN (SELECT NATID_AREA_HOSPITALARIA
                FROM MSTR_UTL_LOCAL_CODIGOS
               WHERE ENABLED = 1)
   LOOP
      v_action := 'ESTANCIAS_' || C1.NATID_AREA_HOSPITALARIA || '_STEP01';

      IF v_condition IS NULL
      THEN
         v_condition := v_action || ' COMPLETED';
      ELSE
         v_condition := v_condition || ' AND ' || v_action || ' COMPLETED';
      END IF;

      DBMS_SCHEDULER.DEFINE_CHAIN_RULE (chain_name => 'PANDAS_ESTANCIAS', condition => 'TRUE', action => 'START ' || v_action);
   END LOOP;

   DBMS_OUTPUT.put_line (v_condition);
   DBMS_SCHEDULER.DEFINE_CHAIN_RULE (chain_name => 'PANDAS_ESTANCIAS', condition => v_condition, action => 'START ESTANCIAS_ALL_STEP02');
   DBMS_SCHEDULER.DEFINE_CHAIN_RULE (chain_name => 'PANDAS_ESTANCIAS', condition => 'ESTANCIAS_ALL_STEP02 COMPLETED', action => 'END');
END;
/

--
--BEGIN
--   DBMS_SCHEDULER.DEFINE_CHAIN_RULE (chain_name => 'PANDAS_ESTANCIAS', condition => v_condition, action => 'END');
--END;
--/

--- enable the chain

BEGIN
   DBMS_SCHEDULER.ENABLE (name => 'PANDAS_ESTANCIAS');
END;
/

ALTER SESSION SET TIME_ZONE = 'Europe/Madrid';


BEGIN
   DBMS_SCHEDULER.CREATE_JOB (job_name          => 'ETL_LOAD_ESTANCIAS_P001_MT',
                              job_type          => 'CHAIN',
                              job_action        => 'PANDAS_ESTANCIAS',
                              start_date        => CURRENT_TIMESTAMP,
                              repeat_interval   => 'freq=daily; byhour=08; byminute=30; bysecond=30',
                              end_date          => NULL,
                              enabled           => TRUE,
                              comments          => 'Carga paralela de traslados y estancias a partir de las réplicas');
END;

--COMMIT;