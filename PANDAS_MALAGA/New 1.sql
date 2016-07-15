
EXEC ETL_LOAD_ESTRUCTURA.P_001;
EXEC ETL_LOAD_CAMAS_DEL_DIA.P_001;

DROP INDEX MSTR_DET_CAMAS_HISTORICO_IDX06;--    N    NO    1    NATID_EPISODIO    Asc    1    MSTR_HOSPITALIZACION

DECLARE
--v_COUNT NUMBER;
BEGIN
	FOR C1 IN (SELECT NATID_AREA_HOSPITALARIA FROM MSTR_UTL_LOCAL_CODIGOS) LOOP
		ETL_LOAD_CAMAS_DEL_DIA.P_001_MULTI_AREA (C1.NATID_AREA_HOSPITALARIA);
	END LOOP;
END;
/

DROP TABLE MSTR_DET_CAMAS_HISTORICO;
/

CREATE TABLE MSTR_DET_CAMAS_HISTORICO
(
	NATID_AREA_HOSPITALARIA
 ,NATID_FECHA
 ,NATID_FECHA_ULTIMO_REFRESCO
 ,NATID_CENTRO
 ,NATID_UNIDAD_FUNCIONAL3
 ,NATID_CAMA
 ,DESCR_CAMA
 ,LDESC_CAMA
 ,NATID_TIPO_CAMA
 ,DESCR_TIPO_CAMA
 ,NATID_TIPO_AISLAMIENTO
 ,DESCR_TIPO_AISLAMIENTO
 ,NATID_EPISODIO
 ,NATID_UNIDAD_FUNCIONAL3_RESP
 ,NATID_CONTROL_ENFERMERIA
 ,NATID_NUHSA
 ,ETL_ERROR_DESCR
 ,CONSTRAINT MSTR_DET_CAMAS_HISTORICO_PK PRIMARY KEY (NATID_FECHA, NATID_CAMA)
)
--ORGANIZATION INDEX
NOLOGGING
NOMONITORING
NOPARALLEL
STORAGE (BUFFER_POOL KEEP) AS
	SELECT NATID_AREA_HOSPITALARIA
				,NATID_FECHA
				,NATID_FECHA_ULTIMO_REFRESCO
				,NATID_CENTRO
				,NATID_UNIDAD_FUNCIONAL3
				,NATID_CAMA
				,DESCR_CAMA
				,LDESC_CAMA
				,NATID_TIPO_CAMA
				,DESCR_TIPO_CAMA
				,NATID_TIPO_AISLAMIENTO
				,DESCR_TIPO_AISLAMIENTO
				,NATID_EPISODIO
                ,NATID_UNIDAD_FUNCIONAL3_RESP
				,NATID_CONTROL_ENFERMERIA
				,NATID_NUHSA
				,ETL_ERROR_DESCR
		FROM TEMP_CAMAS_A102004
	 WHERE 1 = 0