/* Formatted on 8/27/2014 12:51:32 PM (QP5 v5.163.1008.3004) */
DECLARE
   v_job_name   VARCHAR2 (30) := NULL;
BEGIN
   FOR C1 IN (SELECT NATID_AREA_HOSPITALARIA, DB_LINK_REPLICA
                FROM MSTR_UTL_LOCAL_CODIGOS
               WHERE ENABLED = 1)
   LOOP
      v_job_name := 'P_001_MULTI_AREA_' || C1.NATID_AREA_HOSPITALARIA || '_P';

      BEGIN
         DBMS_SCHEDULER.DROP_JOB (job_name => v_job_name);
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      BEGIN
         DBMS_SCHEDULER.create_job (job_name => v_job_name, program_name => 'P_001_MULTI_AREA_PARALLEL');
         DBMS_SCHEDULER.set_job_argument_value (job_name => v_job_name, argument_position => 1, argument_value => C1.NATID_AREA_HOSPITALARIA);
      --DBMS_SCHEDULER.set_job_argument_value ('myjob', 2, 'second arg');
      --DBMS_SCHEDULER.enable (name => 'P_001_MULTI_AREA_02039_P');
      END;
   END LOOP;
END;
/