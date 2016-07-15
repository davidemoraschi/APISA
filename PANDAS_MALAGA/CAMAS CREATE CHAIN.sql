/* Formatted on 8/27/2014 5:02:53 PM (QP5 v5.163.1008.3004) */
BEGIN
   DBMS_SCHEDULER.DROP_JOB (job_name => 'ETL_LOAD_CAMAS_P001_MT');
END;
/

BEGIN
   DBMS_SCHEDULER.DROP_CHAIN (chain_name => 'PANDAS_CAMAS');
END;
/

BEGIN
   DBMS_SCHEDULER.CREATE_CHAIN (chain_name            => 'PANDAS_CAMAS',
                                rule_set_name         => NULL,
                                evaluation_interval   => NULL,
                                comments              => 'Cadena de ejecuciones para CAMAS');
END;
/

DECLARE
   v_step_name   VARCHAR2 (30) := NULL;
BEGIN

   DBMS_SCHEDULER.DEFINE_CHAIN_STEP (chain_name => 'PANDAS_CAMAS', step_name => 'ESTRUCTURA_ALL_STEP01', program_name => 'ESTRUCTURA_ALL_STEP01');

   FOR C1 IN (SELECT NATID_AREA_HOSPITALARIA, DB_LINK_REPLICA
                FROM MSTR_UTL_LOCAL_CODIGOS
               WHERE ENABLED = 1)
   LOOP
      v_step_name := 'CAMAS_' || C1.NATID_AREA_HOSPITALARIA || '_STEP01';
      DBMS_SCHEDULER.DEFINE_CHAIN_STEP (chain_name => 'PANDAS_CAMAS', step_name => v_step_name, program_name => v_step_name);
   END LOOP;
END;
/
--
BEGIN
   DBMS_SCHEDULER.DEFINE_CHAIN_STEP (chain_name => 'PANDAS_CAMAS', step_name => 'CAMAS_ALL_STEP02', program_name => 'CAMAS_ALL_STEP02');
END;
/