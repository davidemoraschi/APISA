BEGIN
  SYS.DBMS_SCHEDULER.CREATE_PROGRAM
    (
      program_name         => 'INGRESOS_02012_STEP01'
     ,program_type         => 'PLSQL_BLOCK'
     ,program_action       => 'BEGIN ETL_LOAD_INGRESOS_DEL_DIA_V3.P_001_MULTI_AREA(''02012''); END;'
     ,number_of_arguments  => 0
     ,enabled              => FALSE
     ,comments             => 'Carga de INGRESOS del área 02012'
    );

  SYS.DBMS_SCHEDULER.ENABLE
    (name                  => 'INGRESOS_02012_STEP01');
END;
/
