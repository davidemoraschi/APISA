/* Formatted on 03/02/2014 14:08:16 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducción Total o Parcial. */
EXEC dbms_stats.gather_schema_stats(ownname=>'MSTR_SIGLO', options=>'GATHER AUTO');

-- DIMENSIONES
BEGIN
	SYS.DBMS_STATS.GATHER_TABLE_STATS (OwnName => 'MSTR_SIGLO'
																		,TabName => 'MSTR_MAE_CATALOGO_N0'
																		,Estimate_Percent => NULL --SYS.DBMS_STATS.AUTO_SAMPLE_SIZE
																		,Method_Opt => 'FOR ALL COLUMNS SIZE SKEWONLY '
																		,Degree => DBMS_STATS.DEFAULT_DEGREE
																		,Cascade => DBMS_STATS.AUTO_CASCADE
																		,No_Invalidate => DBMS_STATS.AUTO_INVALIDATE);
END;
/
-- HECHOS
BEGIN
    SYS.DBMS_STATS.GATHER_TABLE_STATS (OwnName => 'MSTR_SIGLO'
                                                                        ,TabName => 'MSTR_DET_CN03B'
                                                                        ,Estimate_Percent => NULL --30 --SYS.DBMS_STATS.AUTO_SAMPLE_SIZE
                                                                        ,Method_Opt => 'FOR ALL INDEXED COLUMNS SIZE AUTO '
                                                                        ,Degree => DBMS_STATS.DEFAULT_DEGREE
                                                                        ,Cascade => DBMS_STATS.AUTO_CASCADE
                                                                        ,No_Invalidate => DBMS_STATS.AUTO_INVALIDATE);
END;
/