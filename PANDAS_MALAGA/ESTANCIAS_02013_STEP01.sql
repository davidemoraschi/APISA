BEGIN
  SYS.DBMS_SCHEDULER.CREATE_PROGRAM
    (
      program_name         => 'ESTANCIAS_02012_STEP01'
     ,program_type         => 'PLSQL_BLOCK'
     ,program_action       => 'BEGIN ETL_LOAD_ESTANCIAS_V3.P_001_MULTI_AREA(''02012''); END;'
     ,number_of_arguments  => 0
     ,enabled              => FALSE
     ,comments             => 'Carga de traslados para cálculo de ESTANCIAS del área 02012'
    );

  SYS.DBMS_SCHEDULER.ENABLE
    (name                  => 'ESTANCIAS_02012_STEP01');
END;
/
