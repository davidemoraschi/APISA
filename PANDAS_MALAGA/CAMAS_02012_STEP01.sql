BEGIN
  SYS.DBMS_SCHEDULER.CREATE_PROGRAM
    (
      program_name         => 'CAMAS_02012_STEP01'
     ,program_type         => 'PLSQL_BLOCK'
     ,program_action       => 'BEGIN ETL_LOAD_CAMAS_DEL_DIA_V3.P_001_MULTI_AREA(''02012''); END;'
     ,number_of_arguments  => 0
     ,enabled              => FALSE
     ,comments             => 'Carga de camas del día del área 02012'
    );

  SYS.DBMS_SCHEDULER.ENABLE
    (name                  => 'CAMAS_02012_STEP01');
END;
/
