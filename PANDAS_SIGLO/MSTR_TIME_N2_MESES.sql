/* Formatted on 20/03/2014 11:12:29 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducci�n Total o Parcial. */
DROP TABLE MSTR_TIME_N2_MESES
/
CREATE TABLE MSTR_TIME_N2_MESES
(
  SUBID_MES ,
  NATID_MES   ,
  DESCR_MES  ,
  DESCR_MES_ES   ,
  DESCR_MES_SORT   ,
  MES_DEL_A�O   ,
  DESCR_MES_DEL_A�O    ,
  DESCR_MES_DEL_A�O_ES  ,
  NATID_ULTIMO_DIA_DEL_MES ,
  SUBID_A�O         ,
  SUBID_TRIMESTRE    ,
  SUBID_MES_ANTERIOR ,
  SUBID_MES_TRIMESTRE_ANTERIOR ,
  SUBID_MISMO_MES_A�O_ANTERIOR ,
  DURACION_MES       
 ,CONSTRAINT MSTR_TIME_N2_MESES_PK PRIMARY KEY (SUBID_MES)
)
ORGANIZATION INDEX
NOLOGGING
NOMONITORING
NOPARALLEL
STORAGE (BUFFER_POOL KEEP) AS
	SELECT   SUBID_MES ,
  NATID_MES   ,
  DESCR_MES  ,
  DESCR_MES_ES   ,
  DESCR_MES_SORT   ,
  MES_DEL_A�O   ,
  DESCR_MES_DEL_A�O    ,
  DESCR_MES_DEL_A�O_ES  ,
  NATID_ULTIMO_DIA_DEL_MES ,
  SUBID_A�O         ,
  SUBID_TRIMESTRE    ,
  SUBID_MES_ANTERIOR ,
  SUBID_MES_TRIMESTRE_ANTERIOR ,
  SUBID_MISMO_MES_A�O_ANTERIOR ,
  DURACION_MES    
		FROM MSTR_MAE_TIEMPO_02_MESES;
        
        
ALTER TABLE MSTR_TIME_N2_MESES ADD (
  CONSTRAINT MSTR_TIME_N2_MESES_R01 
  FOREIGN KEY (SUBID_A�O) 
  REFERENCES MSTR_TIME_N1_A�OS (SUBID_A�O));

ALTER TABLE  MSTR_TIME_N2_MESES READ ONLY;
BEGIN
    SYS.DBMS_STATS.GATHER_TABLE_STATS (OwnName => USER
                                                                        ,TabName => 'MSTR_TIME_N2_MESES'
                                                                        ,Estimate_Percent => NULL --SYS.DBMS_STATS.AUTO_SAMPLE_SIZE
                                                                        ,Method_Opt => 'FOR ALL COLUMNS SIZE SKEWONLY '
                                                                        ,Degree => DBMS_STATS.DEFAULT_DEGREE
                                                                        ,Cascade => DBMS_STATS.AUTO_CASCADE
                                                                        ,No_Invalidate => DBMS_STATS.AUTO_INVALIDATE);
END;