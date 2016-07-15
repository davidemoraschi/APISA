/* Formatted on 20/03/2014 11:12:29 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducción Total o Parcial. */
DROP TABLE MSTR_TIME_N3_DIAS
/
CREATE TABLE MSTR_TIME_N3_DIAS
(
   SUBID_DIA,
  NATID_DIA  ,
  DESCR_DIA  ,
  DESCR_DIA_ES ,
  DIA_DE_LA_SEMANA   ,
  SUBID_SEMANA   ,
  SUBID_MES ,
  SUBID_TRIMESTRE  ,
  SUBID_AÑO  ,
  NATID_DIA_ANTERIOR ,
  SUBID_MISMO_DIA_MES_ANTERIOR  ,
  SUBID_MISMO_DIA_TRIMESTRE_ANTE ,
  SUBID_MISMO_DIA_AÑO_ANTERIOR  
 ,CONSTRAINT MSTR_TIME_N3_DIAS_PK PRIMARY KEY (SUBID_DIA)
)
ORGANIZATION INDEX
NOLOGGING
NOMONITORING
NOPARALLEL
STORAGE (BUFFER_POOL KEEP) AS
	SELECT    SUBID_DIA,
  NATID_DIA  ,
  DESCR_DIA  ,
  DESCR_DIA_ES ,
  DIA_DE_LA_SEMANA   ,
  SUBID_SEMANA   ,
  SUBID_MES ,
  SUBID_TRIMESTRE  ,
  SUBID_AÑO  ,
  NATID_DIA_ANTERIOR ,
  SUBID_MISMO_DIA_MES_ANTERIOR  ,
  SUBID_MISMO_DIA_TRIMESTRE_ANTE ,
  SUBID_MISMO_DIA_AÑO_ANTERIOR    
		FROM ZZOBS_MAE_TIEMPO_03_DIAS;
        
        
ALTER TABLE MSTR_TIME_N3_DIAS ADD (
  CONSTRAINT MSTR_TIME_N3_DIAS_R02
  FOREIGN KEY (SUBID_MES) 
  REFERENCES MSTR_TIME_N2_MESES (SUBID_MES));

        
ALTER TABLE MSTR_TIME_N3_DIAS ADD (
  CONSTRAINT MSTR_TIME_N3_DIAS_R01
  FOREIGN KEY (SUBID_AÑO) 
  REFERENCES MSTR_TIME_N1_AÑOS (SUBID_AÑO));

ALTER TABLE MSTR_TIME_N3_DIAS READ ONLY;

BEGIN
    SYS.DBMS_STATS.GATHER_TABLE_STATS (OwnName => USER
                                                                        ,TabName => 'MSTR_TIME_N3_DIAS'
                                                                        ,Estimate_Percent => NULL --SYS.DBMS_STATS.AUTO_SAMPLE_SIZE
                                                                        ,Method_Opt => 'FOR ALL COLUMNS SIZE SKEWONLY '
                                                                        ,Degree => DBMS_STATS.DEFAULT_DEGREE
                                                                        ,Cascade => DBMS_STATS.AUTO_CASCADE
                                                                        ,No_Invalidate => DBMS_STATS.AUTO_INVALIDATE);
END;