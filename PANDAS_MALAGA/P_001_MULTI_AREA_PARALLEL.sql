/* Formatted on 8/27/2014 12:30:28 PM (QP5 v5.163.1008.3004) */
BEGIN
   DBMS_SCHEDULER.DROP_PROGRAM (program_name => 'P_001_MULTI_AREA_PARALLEL');
END;
/

BEGIN
   SYS.DBMS_SCHEDULER.CREATE_PROGRAM (program_name          => 'P_001_MULTI_AREA_PARALLEL',
                                      program_type          => 'STORED_PROCEDURE',
                                      program_action        => 'ETL_LOAD_ESTANCIAS_V3.P_001_MULTI_AREA',
                                      number_of_arguments   => 1,
                                      enabled               => FALSE,
                                      comments              => 'Use this program to run multiple loads in parallel');

   SYS.DBMS_SCHEDULER.DEFINE_PROGRAM_ARGUMENT (program_name        => 'P_001_MULTI_AREA_PARALLEL',
                                               argument_name       => 'NATID_AREA_HOSPITALARIA',
                                               argument_position   => 1,
                                               argument_type       => 'VARCHAR2',
                                               DEFAULT_VALUE       => 'NULL');
END;
/

EXEC dbms_scheduler.enable (name => 'P_001_MULTI_AREA_PARALLEL');