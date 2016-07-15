CREATE OR REPLACE PACKAGE BODY MSTR_HOSPITALIZACION.ETL_LOAD_INGRESOS_DEL_DIA AS
	PROCEDURE P_001_MULTI_AREA (p_NATID_AREA_HOSPITALARIA IN VARCHAR2) IS
		v_inicio_ts TIMESTAMP;
		v_fin_ts TIMESTAMP;
		v_DB_LINK_REPLICA MSTR_UTL_LOCAL_CODIGOS.DB_LINK_REPLICA%TYPE;
        cv SYS_REFCURSOR ; 
        v_NATID_EPISODIO NUMBER;
        v_REFERENCIA_ID NUMBER;
        v_USUARIO NUMBER;
        v_UNID_FUNC_RESP VARCHAR2(6);
        v_NATID_NUHSA VARCHAR2(12);
   BEGIN
		v_inicio_ts := SYSTIMESTAMP;
        DBMS_APPLICATION_INFO.set_client_info ('PANDAS Server');
        DBMS_SESSION.set_identifier ('ETL');

        DBMS_APPLICATION_INFO.set_module ('P_001_MULTI_AREA', 'Creando sinónimos');
		SELECT DB_LINK_REPLICA
			INTO v_DB_LINK_REPLICA
			FROM MSTR_UTL_LOCAL_CODIGOS
		 WHERE NATID_AREA_HOSPITALARIA = p_NATID_AREA_HOSPITALARIA;
         
		CREATE_SYNONYMS (v_DB_LINK_REPLICA);
        
        --RETURN;

        DBMS_APPLICATION_INFO.set_module ('P_001_MULTI_AREA', 'Eliminando tabla TEMP_INGRESOS_A1');
        DROP_TABLE (p_table_name => 'TEMP_INGRESOS_A1'||p_NATID_AREA_HOSPITALARIA);

        DBMS_APPLICATION_INFO.set_module ('P_001_MULTI_AREA', 'Creando tabla TEMP_INGRESOS_A1');
        EXECUTE IMMEDIATE 'CREATE TABLE TEMP_INGRESOS_A1'||p_NATID_AREA_HOSPITALARIA||
                           '(
                             NATID_AREA_HOSPITALARIA,
                              NATID_FECHA,
                              NATID_FECHA_ULTIMO_REFRESCO,
                              NATID_CENTRO,
                              NATID_UNIDAD_FUNCIONAL3,
                              NATID_UNIDAD_FUNCIONAL3_RESP,
                              NATID_ADMISION,
                              NATID_EPISODIO,
                              NATID_NUHSA,
                              IND_MODALIDAD_ASISTENCIAL,
                              IND_MEDICO_QUIRURGICO,
                              IND_PROCEDENTE_DE,
                              IND_URGENTE_PROGRAMADO,
                              NATID_CAMA,
                              NATID_CONTROL_ENFERMERIA,
                              CIE9_DIAGNOSTICO_INGRESO,
                             CONSTRAINT TEMP_INGRESOS_A1'||p_NATID_AREA_HOSPITALARIA||'_PK PRIMARY KEY (NATID_ADMISION)
                            )
                            --ORGANIZATION INDEX
                            NOLOGGING
                            NOMONITORING
                            PARALLEL
                            STORAGE (BUFFER_POOL KEEP) AS
                               SELECT CAH_AH_CODIGO NATID_AREA_HOSPITALARIA,
                                      TRUNC (FCH_INGRESO) NATID_FECHA,
                                      LAST_REFRESH_DATE NATID_FECHA_ULTIMO_REFRESCO,
                                      NVL (CENTRO_INGRESO, -1) NATID_CENTRO,
                                      NVL (UNID_FUNC_INGRESO, -1) NATID_UNIDAD_FUNCIONAL3,
                                      NVL (UNID_FUNC_RESP, -1) NATID_UNIDAD_FUNCIONAL3_RESP,
                                      ADMISION_ID NATID_ADMISION,
                                      NVL (EPISODIO_ID, -1) NATID_EPISODIO,
                                      TO_CHAR(USUARIO) NATID_NUHSA,
                                      DES_MODAL_ASIST IND_MODALIDAD_ASISTENCIAL,
                                      DECODE (HD_QUIR_SN,  0, ''Médico'',  1, ''Quirúrgico'')
                                         IND_MEDICO_QUIRURGICO,
                                      DES_PROCEDENCIA IND_PROCEDENTE_DE,
                                      DES_MOTIVO_ING IND_URGENTE_PROGRAMADO,
                                      NVL (UBICACION_TERMINAL, -1) NATID_CAMA,
                                      NVL (UNIDAD_CUIDADO, -1) NATID_CONTROL_ENFERMERIA,
                                      DIAGNOSTICO_ING CIE9_DIAGNOSTICO_INGRESO
                                 FROM ADM_ADMISION
                                      JOIN CENTROS_AH
                                         ON (CENTRO_INGRESO = CAH_CODIGO)
                                      JOIN ALL_MVIEWS
                                         ON (MVIEW_NAME = ''ADM_ADMISION'' AND OWNER = ''REP_HIS_OWN'')
                                      JOIN ADM_EPIS_DETALLE
                                         ON (ADMISION_ID = REFERENCIA_ID)
                                      --          JOIN COM_USUARIO
                                      --             ON (USUARIO = ID_USUARIO)
                                      JOIN ADM_M_MODAL_ASIST
                                         ON (ADM_ADMISION.MODALIDAD_ASIST =
                                                ADM_M_MODAL_ASIST.MODAL_ASIST_ID)
                                      JOIN ADM_M_PROCEDENCIA
                                         ON (ORIGEN_INGRESO = PROCEDENCIA_ID)
                                      JOIN ADM_M_MOTIVO_INGRESO
                                         ON (MOTIVO_INGRESO = MOTIVO_ING_ID)
                                WHERE FCH_INGRESO >= ''01-JAN-2013'' AND EPIS_CONTAB = 1';
        
        DBMS_APPLICATION_INFO.set_module ('P_001_MULTI_AREA', 'Creando índice sobre Episódios');
        EXECUTE IMMEDIATE 'CREATE INDEX TEMP_INGRESOS_A1'||p_NATID_AREA_HOSPITALARIA||'_IDX01
                    ON TEMP_INGRESOS_A1'||p_NATID_AREA_HOSPITALARIA||' (NATID_EPISODIO)
                    NOLOGGING
                    NOPARALLEL';

        DBMS_APPLICATION_INFO.set_module ('P_001_MULTI_AREA', 'Creando columnas adicionales');
        EXECUTE IMMEDIATE 'ALTER TABLE TEMP_INGRESOS_A1'||p_NATID_AREA_HOSPITALARIA||
                    ' ADD (ETL_ERROR_DESCR VARCHAR2(250), NATID_CENTRO_PRIMER_TRASLADO  NUMBER, NATID_CAMA_PRIMER_TRASLADO  VARCHAR2(24))';

--        DBMS_APPLICATION_INFO.set_module ('P_001_MULTI_AREA', 'Actualizando Tipo aislamiento de camas aisladas');
--        EXECUTE IMMEDIATE 'UPDATE TEMP_CAMAS_A1'||p_NATID_AREA_HOSPITALARIA||
--                    ' SET NATID_TIPO_AISLAMIENTO = -1, ETL_ERROR_DESCR = ''cama aislada en COM_UBICACION_AISLADA sin tipo aislamiento en COM_UBICACION_GESTION_LOCAL''
--                    WHERE DESCR_TIPO_AISLAMIENTO = ''N/A''';
--
----        DBMS_APPLICATION_INFO.set_module ('P_001_MULTI_AREA', 'Actualizando Tipo aislamiento de camas no aislada');
----        EXECUTE IMMEDIATE 'UPDATE TEMP_CAMAS_A1'||p_NATID_AREA_HOSPITALARIA||
----                    ' SET NATID_TIPO_AISLAMIENTO = -1, ETL_ERROR_DESCR = ''cama aislada en COM_UBICACION_GESTION_LOCAL sin aislamiento en COM_UBICACION_AISLADA''
----                    WHERE DESCR_TIPO_AISLAMIENTO = ''--''';
--
--        DBMS_APPLICATION_INFO.set_module ('P_001_MULTI_AREA', 'Actualizando Control Enfermería');
--        EXECUTE IMMEDIATE 'UPDATE TEMP_CAMAS_A1'||p_NATID_AREA_HOSPITALARIA||
--                    ' SET NATID_CONTROL_ENFERMERIA = NVL (func_recupera_contr_enfermeria (NATID_CAMA), ''-1'')';
--                   
        DBMS_APPLICATION_INFO.set_module ('P_001_MULTI_AREA', 'Actualizando NUHSA');
--        EXECUTE IMMEDIATE 'UPDATE TEMP_CAMAS_A1'||p_NATID_AREA_HOSPITALARIA||
--                    ' SET NATID_CONTROL_ENFERMERIA = NVL (func_recupera_contr_enfermeria (NATID_CAMA), ''-1'')';
        EXECUTE IMMEDIATE
                        'UPDATE (SELECT NATID_ADMISION, NATID_NUHSA, NUHSA
                                  FROM    TEMP_INGRESOS_A1'||p_NATID_AREA_HOSPITALARIA||
                                      ' LEFT JOIN
                                          COM_USUARIO
                                       ON (NATID_NUHSA = ID_USUARIO))
                           SET NATID_NUHSA = NVL (NUHSA, ''-1'')';        
   
--        OPEN cv FOR
--          'SELECT NATID_EPISODIO
--                    FROM TEMP_CAMAS_A1' ||p_NATID_AREA_HOSPITALARIA || ' FOR UPDATE OF NATID_NUHSA';
--           LOOP
--            FETCH cv INTO v_NATID_EPISODIO;
--            EXIT WHEN cv%NOTFOUND;
--                IF v_NATID_EPISODIO > 0 THEN
--                    BEGIN
--                        SELECT REFERENCIA_ID
--                            INTO v_REFERENCIA_ID
--                            FROM ADM_EPIS_DETALLE
--                         WHERE EPISODIO_ID = v_NATID_EPISODIO;
--                    EXCEPTION
--                        WHEN NO_DATA_FOUND THEN
--                            DBMS_OUTPUT.PUT_LINE ('episodio not found: ' || v_NATID_EPISODIO);
--                            EXECUTE IMMEDIATE 'UPDATE TEMP_CAMAS_A1' ||p_NATID_AREA_HOSPITALARIA || 
--                                    ' SET NATID_NUHSA = ''-2'', ETL_ERROR_DESCR = ''episodio ' || v_NATID_EPISODIO || ' no encontrado en ADM_EPIS_DETALLE''
--                                     WHERE NATID_EPISODIO = ' ||v_NATID_EPISODIO;
--                            v_REFERENCIA_ID := -1;
--                        WHEN TOO_MANY_ROWS THEN
--                            DBMS_OUTPUT.PUT_LINE ('episodio found multiple times: ' || v_NATID_EPISODIO);
----                        SELECT REFERENCIA_ID
----                            INTO v_REFERENCIA_ID
----                            FROM ADM_EPIS_DETALLE
----                         WHERE EPISODIO_ID = v_NATID_EPISODIO;
--                         SELECT MAX (REFERENCIA_ID)
--                            INTO v_REFERENCIA_ID
--                            FROM (SELECT USUARIO, REFERENCIA_ID
--                                            FROM ADM_EPIS_DETALLE, ADM_ADMISION
--                                            WHERE ADMISION_ID = REFERENCIA_ID AND EPISODIO_ID = v_NATID_EPISODIO AND MODAL_ASIST_ID = 2)
--                            GROUP BY USUARIO;
----                            EXECUTE IMMEDIATE 'UPDATE TEMP_CAMAS_A1' ||p_NATID_AREA_HOSPITALARIA || 
----                                    ' SET NATID_NUHSA = ''-2'', ETL_ERROR_DESCR = ''episodio ' || v_NATID_EPISODIO || ' duplicado en ADM_EPIS_DETALLE. Hospital de día?''
----                                     WHERE NATID_EPISODIO = ' ||v_NATID_EPISODIO;
----                            v_REFERENCIA_ID := -1;
--                    END;
--                    IF v_REFERENCIA_ID > 0 THEN
--                        BEGIN
--                            SELECT USUARIO, NVL(UNID_FUNC_RESP, '-1')
--                                INTO v_USUARIO, v_UNID_FUNC_RESP
--                                FROM ADM_ADMISION
--                             WHERE ADMISION_ID = v_REFERENCIA_ID;
----                        EXCEPTION
----                            WHEN NO_DATA_FOUND THEN
----                                DBMS_OUTPUT.PUT_LINE ('referencia not found: ' || v_REFERENCIA_ID);
----                                UPDATE TEMP_CAMAS_A1
----                                     SET ETL_ERROR_DESCR = 'referencia ' || v_REFERENCIA_ID || ' no encontrada en ADM_ADMISION'
----                                 WHERE NATID_EPISODIO = R1.NATID_EPISODIO;
----                                v_USUARIO := -1;
--                        END;
--                        IF v_USUARIO > 0 THEN
--                        BEGIN
--                                SELECT NUHSA
--                                    INTO v_NATID_NUHSA
--                                    FROM COM_USUARIO
--                                 WHERE ID_USUARIO = v_USUARIO;
--                            EXECUTE IMMEDIATE 'UPDATE TEMP_CAMAS_A1' ||p_NATID_AREA_HOSPITALARIA ||
--                                ' SET NATID_NUHSA = ''' || v_NATID_NUHSA ||
--                                ''' , NATID_UNIDAD_FUNCIONAL3_RESP = '''|| v_UNID_FUNC_RESP ||''' WHERE NATID_EPISODIO = ' || v_NATID_EPISODIO;
--                        EXCEPTION
--                            WHEN NO_DATA_FOUND THEN
--                                DBMS_OUTPUT.PUT_LINE ('nuhsa not found for ID_USUARIO: ' || v_USUARIO);
--                                EXECUTE IMMEDIATE 'UPDATE TEMP_CAMAS_A1' ||p_NATID_AREA_HOSPITALARIA || 
--                                        ' SET NATID_NUHSA = ''-3'', NATID_UNIDAD_FUNCIONAL3_RESP = '''|| v_UNID_FUNC_RESP ||''', ETL_ERROR_DESCR = ''usuario ' || v_USUARIO || ' no encontrado en COM_USUARIO''
--                                         WHERE NATID_EPISODIO = ' ||v_NATID_EPISODIO;
--                                --v_REFERENCIA_ID := -1;
--                        END;
--                        END IF;
--                    END IF;
--                END IF;
--            
--           END LOOP;
--        
        DBMS_APPLICATION_INFO.set_module ('P_001_MULTI_AREA', 'Creando clave foránea UF3');
        CREATE_FK (p_table_name => 'TEMP_INGRESOS_A1'||p_NATID_AREA_HOSPITALARIA
           , p_constraint_name => 'TEMP_INGRESOS_A1'||p_NATID_AREA_HOSPITALARIA||'_R01'
           , p_parent_table => 'MSTR_MAE_UNIDADES_FUNCIONALES3'
           , p_columns => 'NATID_UNIDAD_FUNCIONAL3');
   
        DBMS_APPLICATION_INFO.set_module ('P_001_MULTI_AREA', 'Creando clave foránea UF3 RESP');
        CREATE_FK (p_table_name => 'TEMP_INGRESOS_A1'||p_NATID_AREA_HOSPITALARIA
        , p_constraint_name => 'TEMP_INGRESOS_A1'||p_NATID_AREA_HOSPITALARIA||'_R02'
        , p_parent_table => 'MSTR_MAE_UNIDADES_FUNCIONALES3'
        , p_columns => 'NATID_UNIDAD_FUNCIONAL3_RESP'
        , p_parent_columns => 'NATID_UNIDAD_FUNCIONAL3');

        DBMS_APPLICATION_INFO.set_module ('P_001_MULTI_AREA', 'Generando Estadísticas');
        MARK_TABLE_READ_ONLY  (p_table_name => 'TEMP_INGRESOS_A1'||p_NATID_AREA_HOSPITALARIA);
        COMPUTE_STATS  (p_table_name => 'TEMP_INGRESOS_A1'||p_NATID_AREA_HOSPITALARIA);
        
--        
        v_fin_ts := SYSDATE;
        INSERT INTO MSTR_UTL_LOG_CARGAS (TS_LOG, RESULT, INT_DS_ELAPSED, NATID_AREA_HOSPITALARIA) VALUES (v_fin_ts, 'Completada carga Ingresos '/*, DBMS_UTILITY.format_error_backtrace*/, (v_fin_ts - v_inicio_ts), p_NATID_AREA_HOSPITALARIA);
--        EXCEPTION
--        WHEN OTHERS THEN
--        v_fin_ts := SYSDATE;
--        DBMS_APPLICATION_INFO.READ_MODULE ( v_module_name , v_action_name ); 
--                    INSERT INTO MSTR_UTL_LOG_CARGAS (TS_LOG, RESULT, LOG, INT_DS_ELAPSED, NATID_AREA_HOSPITALARIA) 
--                        VALUES (v_fin_ts, 'Error carga Camas '||v_module_name, v_action_name ||' -> '||DBMS_UTILITY.FORMAT_ERROR_STACK ||' -> ' || DBMS_UTILITY.format_error_backtrace, (v_fin_ts - v_inicio_ts), p_NATID_AREA_HOSPITALARIA);
--                    COMMIT;
--                    RAISE;

	END P_001_MULTI_AREA;

	PROCEDURE P_001 (Param1 IN NUMBER DEFAULT NULL) IS
		v_inicio_ts TIMESTAMP;
		v_fin_ts TIMESTAMP;
--		v_elapsed NUMBER;
--		v_last_refresh DATE;
--		v_area_hospitalaria VARCHAR2 (10);
	BEGIN
        v_inicio_ts := SYSTIMESTAMP;
        DBMS_APPLICATION_INFO.set_client_info ('PANDAS Server');
        DBMS_SESSION.set_identifier ('ETL');
        EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';

            FOR C1 IN (  SELECT TABLE_NAME
                                         FROM USER_TABLES
                                        WHERE TABLE_NAME LIKE 'TEMP_INGRESOS_A1%'
                                 ORDER BY 1) LOOP
                    DBMS_APPLICATION_INFO.set_module ('P_001', 'Eliminando tabla '||C1.TABLE_NAME);
                    DROP_TABLE (p_table_name =>C1.TABLE_NAME);
            END LOOP;

        FOR C1 IN (SELECT NATID_AREA_HOSPITALARIA FROM MSTR_UTL_LOCAL_CODIGOS WHERE ENABLED = 1) LOOP
            BEGIN
                DBMS_APPLICATION_INFO.set_module ('P_001', 'Lanzando carga de ingresos');
                ETL_LOAD_INGRESOS_DEL_DIA.P_001_MULTI_AREA (C1.NATID_AREA_HOSPITALARIA);
                
            EXCEPTION WHEN OTHERS THEN
               DBMS_APPLICATION_INFO.READ_MODULE ( v_module_name , v_action_name ); 
                    INSERT INTO MSTR_UTL_LOG_CARGAS (TS_LOG, RESULT, LOG, NATID_AREA_HOSPITALARIA) 
                        VALUES (systimestamp, 'Error carga Ingresos '||v_module_name, v_action_name ||' -> '||DBMS_UTILITY.FORMAT_ERROR_STACK ||' -> ' || DBMS_UTILITY.format_error_backtrace, C1.NATID_AREA_HOSPITALARIA);
                    COMMIT;            
            END;
        END LOOP;
        
        --RETURN;
        
--        DBMS_APPLICATION_INFO.set_module ('P_001', 'Eliminando tabla MSTR_DET_INGRESOS_DEL_DIA');
--        DROP_TABLE (p_table_name => 'MSTR_DET_INGRESOS_DEL_DIA');--DROP TABLE MSTR_DET_CAMAS_DEL_DIA;
--
--        DBMS_APPLICATION_INFO.set_module ('P_001', 'Creando tabla MSTR_DET_INGRESOS_DEL_DIA');
--        EXECUTE IMMEDIATE 'CREATE TABLE MSTR_DET_INGRESOS_DEL_DIA
--        (
--            NATID_AREA_HOSPITALARIA
--         ,NATID_FECHA
--         ,NATID_FECHA_ULTIMO_REFRESCO
--         ,NATID_CENTRO
--         ,NATID_UNIDAD_FUNCIONAL3
--         ,NATID_CAMA
--         ,DESCR_CAMA
--         ,LDESC_CAMA
--         ,NATID_TIPO_CAMA
--         ,DESCR_TIPO_CAMA
--         ,NATID_TIPO_AISLAMIENTO
--         ,DESCR_TIPO_AISLAMIENTO
--         ,NATID_EPISODIO
--         ,NATID_UNIDAD_FUNCIONAL3_RESP
--         ,NATID_CONTROL_ENFERMERIA
--         ,NATID_NUHSA
--         ,ETL_ERROR_DESCR
--         ,CONSTRAINT MSTR_DET_CAMAS_DEL_DIA_PK PRIMARY KEY (NATID_CAMA)
--        )
--        ORGANIZATION INDEX
--        NOLOGGING
--        NOMONITORING
--        NOPARALLEL
--        STORAGE (BUFFER_POOL KEEP) AS
--            SELECT NATID_AREA_HOSPITALARIA
--                        ,NATID_FECHA
--                        ,NATID_FECHA_ULTIMO_REFRESCO
--                        ,NATID_CENTRO
--                        ,NATID_UNIDAD_FUNCIONAL3
--                        ,NATID_CAMA
--                        ,DESCR_CAMA
--                        ,LDESC_CAMA
--                        ,NATID_TIPO_CAMA
--                        ,DESCR_TIPO_CAMA
--                        ,NATID_TIPO_AISLAMIENTO
--                        ,DESCR_TIPO_AISLAMIENTO
--                        ,NATID_EPISODIO
--                        ,NATID_UNIDAD_FUNCIONAL3_RESP
--                        ,NATID_CONTROL_ENFERMERIA
--                        ,NATID_NUHSA
--                        ,ETL_ERROR_DESCR
--                FROM TEMP_INGRESOS_B10
--             WHERE 1 = 0';
--
--            FOR C1 IN (  SELECT TABLE_NAME
--                                         FROM USER_TABLES
--                                        WHERE TABLE_NAME LIKE 'TEMP_INGRESOS_A1%'
--                                 ORDER BY 1) LOOP
--                                BEGIN
--                                DBMS_APPLICATION_INFO.set_module ('P_001', 'Insertando en MSTR_DET_INGRESOS_DEL_DIA datos de '||C1.TABLE_NAME);
--                                                EXECUTE IMMEDIATE 'INSERT INTO MSTR_DET_INGRESOS_DEL_DIA SELECT NATID_AREA_HOSPITALARIA
--                                                        ,NATID_FECHA
--                                                        ,NATID_FECHA_ULTIMO_REFRESCO
--                                                        ,NATID_CENTRO
--                                                        ,NATID_UNIDAD_FUNCIONAL3
--                                                        ,NATID_CAMA
--                                                        ,DESCR_CAMA
--                                                        ,LDESC_CAMA
--                                                        ,NATID_TIPO_CAMA
--                                                        ,DESCR_TIPO_CAMA
--                                                        ,NATID_TIPO_AISLAMIENTO
--                                                        ,DESCR_TIPO_AISLAMIENTO
--                                                        ,NATID_EPISODIO
--                                                        ,NATID_UNIDAD_FUNCIONAL3_RESP
--                                                        ,NATID_CONTROL_ENFERMERIA
--                                                        ,NATID_NUHSA
--                                                        ,ETL_ERROR_DESCR FROM ' || C1.TABLE_NAME;
--                                END;
--                                END LOOP;

    DBMS_APPLICATION_INFO.set_module ('P_001', 'Modificando tabla MSTR_DET_INGRESOS_HISTORICO');
    MARK_TABLE_READ_WRITE (p_table_name => 'MSTR_DET_INGRESOS_HISTORICO');
    
     DROP_IDX(p_table_name => 'MSTR_DET_INGRESOS_HISTORICO', p_index_name => 'MSTR_DET_INGRESOS_HISTORICO_I6');
     DROP_IDX(p_table_name => 'MSTR_DET_INGRESOS_HISTORICO', p_index_name => 'MSTR_DET_INGRESOS_HISTORICO_I7');
    DROP_CONSTRAINT (p_table_name => 'MSTR_DET_INGRESOS_HISTORICO', p_constraint_name => 'MSTR_DET_INGRESOS_HISTORICO_R2');--, p_parent_table => 'MSTR_MAE_CENTROS', p_columns => 'NATID_CENTRO');
    DROP_CONSTRAINT (p_table_name => 'MSTR_DET_INGRESOS_HISTORICO', p_constraint_name => 'MSTR_DET_INGRESOS_HISTORICO_R3');--, p_parent_table => 'MSTR_MAE_UNIDADES_FUNCIONALES3', p_columns => 'NATID_UNIDAD_FUNCIONAL3');
    DROP_CONSTRAINT (p_table_name => 'MSTR_DET_INGRESOS_HISTORICO', p_constraint_name => 'MSTR_DET_INGRESOS_HISTORICO_R4');--, p_parent_table => 'MSTR_MAE_UNIDADES_FUNCIONALES3', p_columns => 'NATID_UNIDAD_FUNCIONAL3_RESP', p_parent_columns => 'NATID_UNIDAD_FUNCIONAL3');
    DROP_CONSTRAINT (p_table_name => 'MSTR_DET_INGRESOS_HISTORICO', p_constraint_name => 'MSTR_DET_INGRESOS_HISTORICO_R5');--, p_parent_table => 'MSTR_MAE_CONTROLES_ENFERMERIA', p_columns => 'NATID_CONTROL_ENFERMERIA');
    

FOR C1 IN (  SELECT TABLE_NAME
                                         FROM USER_TABLES
                                        WHERE TABLE_NAME LIKE 'TEMP_INGRESOS_A1%'
                                 ORDER BY 1) LOOP
                                 BEGIN
                                    DBMS_APPLICATION_INFO.set_module ('P_001', 'Insertando en MSTR_DET_INGRESOS_HISTORICO datos de '||C1.TABLE_NAME);
                                    EXECUTE IMMEDIATE 'MERGE /*+ parallel(MSTR_DET_INGRESOS_HISTORICO) */ INTO MSTR_DET_INGRESOS_HISTORICO H
                     USING (SELECT ETL_ERROR_DESCR
                                                ,IND_MEDICO_QUIRURGICO
                                                ,IND_MODALIDAD_ASISTENCIAL
                                                ,IND_PROCEDENTE_DE
                                                ,IND_URGENTE_PROGRAMADO
                                                ,NATID_ADMISION
                                                ,NATID_AREA_HOSPITALARIA
                                                ,NATID_CAMA
                                                ,NATID_CENTRO
                                                ,NATID_CONTROL_ENFERMERIA
                                                ,NATID_EPISODIO
                                                ,NATID_FECHA
                                                ,NATID_FECHA_ULTIMO_REFRESCO
                                                ,NATID_NUHSA
                                                ,NATID_UNIDAD_FUNCIONAL3
                                                ,NATID_UNIDAD_FUNCIONAL3_RESP
                                                ,CIE9_DIAGNOSTICO_INGRESO
                                        FROM '|| C1.TABLE_NAME||') T
                            ON (H.NATID_AREA_HOSPITALARIA = T.NATID_AREA_HOSPITALARIA AND H.NATID_ADMISION = T.NATID_ADMISION)
            WHEN MATCHED THEN
                UPDATE SET H.ETL_ERROR_DESCR = T.ETL_ERROR_DESCR
                                    ,H.IND_MEDICO_QUIRURGICO = T.IND_MEDICO_QUIRURGICO
                                    ,H.IND_MODALIDAD_ASISTENCIAL = T.IND_MODALIDAD_ASISTENCIAL
                                    ,H.IND_PROCEDENTE_DE = T.IND_PROCEDENTE_DE
                                    ,H.IND_URGENTE_PROGRAMADO = T.IND_URGENTE_PROGRAMADO
                                    ,H.NATID_CAMA = T.NATID_CAMA
                                    ,H.NATID_CENTRO = T.NATID_CENTRO
                                    ,H.NATID_CONTROL_ENFERMERIA = T.NATID_CONTROL_ENFERMERIA
                                    ,H.NATID_EPISODIO = T.NATID_EPISODIO
                                    ,H.NATID_FECHA = T.NATID_FECHA
                                    ,H.NATID_FECHA_ULTIMO_REFRESCO = T.NATID_FECHA_ULTIMO_REFRESCO
                                    ,H.NATID_NUHSA = T.NATID_NUHSA
                                    ,H.NATID_UNIDAD_FUNCIONAL3 = T.NATID_UNIDAD_FUNCIONAL3
                                    ,H.NATID_UNIDAD_FUNCIONAL3_RESP = T.NATID_UNIDAD_FUNCIONAL3_RESP
                                    ,H.CIE9_DIAGNOSTICO_INGRESO = T.CIE9_DIAGNOSTICO_INGRESO
            WHEN NOT MATCHED THEN
                INSERT         (H.ETL_ERROR_DESCR
                                     ,H.IND_MEDICO_QUIRURGICO
                                     ,H.IND_MODALIDAD_ASISTENCIAL
                                     ,H.IND_PROCEDENTE_DE
                                     ,H.IND_URGENTE_PROGRAMADO
                                     ,H.NATID_ADMISION
                                     ,H.NATID_AREA_HOSPITALARIA
                                     ,H.NATID_CAMA
                                     ,H.NATID_CENTRO
                                     ,H.NATID_CONTROL_ENFERMERIA
                                     ,H.NATID_EPISODIO
                                     ,H.NATID_FECHA
                                     ,H.NATID_FECHA_ULTIMO_REFRESCO
                                     ,H.NATID_NUHSA
                                     ,H.NATID_UNIDAD_FUNCIONAL3
                                     ,H.NATID_UNIDAD_FUNCIONAL3_RESP
                                     ,H.CIE9_DIAGNOSTICO_INGRESO)
                        VALUES (T.ETL_ERROR_DESCR
                                     ,T.IND_MEDICO_QUIRURGICO
                                     ,T.IND_MODALIDAD_ASISTENCIAL
                                     ,T.IND_PROCEDENTE_DE
                                     ,T.IND_URGENTE_PROGRAMADO
                                     ,T.NATID_ADMISION
                                     ,T.NATID_AREA_HOSPITALARIA
                                     ,T.NATID_CAMA
                                     ,T.NATID_CENTRO
                                     ,T.NATID_CONTROL_ENFERMERIA
                                     ,T.NATID_EPISODIO
                                     ,T.NATID_FECHA
                                     ,T.NATID_FECHA_ULTIMO_REFRESCO
                                     ,T.NATID_NUHSA
                                     ,T.NATID_UNIDAD_FUNCIONAL3
                                     ,T.NATID_UNIDAD_FUNCIONAL3_RESP
                                     ,T.CIE9_DIAGNOSTICO_INGRESO)';
                        EXCEPTION --WHEN DUP_VAL_ON_INDEX THEN
                            --NULL;
                        WHEN OTHERS THEN
                                   INSERT INTO MSTR_UTL_LOG_CARGAS (TS_LOG, RESULT, LOG, NATID_AREA_HOSPITALARIA)
            VALUES (systimestamp, 'Error en la instrucción MERGE: '|| C1.TABLE_NAME|| '. '||v_module_name, v_action_name ||' -> '||DBMS_UTILITY.FORMAT_ERROR_STACK ||' -> ' || DBMS_UTILITY.format_error_backtrace, 'ALL');
                            RAISE;        
                 
                        END;
            END LOOP;
            
            
--             DBMS_APPLICATION_INFO.set_module ('P_001', 'Creando índices en MSTR_DET_CAMAS_DEL_DIA');
--            CREATE_IDX(p_table_name => 'MSTR_DET_CAMAS_DEL_DIA', p_index_name => 'MSTR_DET_CAMAS_DEL_DIA_IDX01', p_columns => 'NATID_AREA_HOSPITALARIA');
----            CREATE_IDX(p_table_name => 'MSTR_DET_CAMAS_DEL_DIA', p_index_name => 'MSTR_DET_CAMAS_DEL_DIA_IDX02', p_columns => 'NATID_CENTRO');
----            CREATE_IDX(p_table_name => 'MSTR_DET_CAMAS_DEL_DIA', p_index_name => 'MSTR_DET_CAMAS_DEL_DIA_IDX03', p_columns => 'NATID_UNIDAD_FUNCIONAL3');
----            CREATE_IDX(p_table_name => 'MSTR_DET_CAMAS_DEL_DIA', p_index_name => 'MSTR_DET_CAMAS_DEL_DIA_IDX04', p_columns => 'NATID_UNIDAD_FUNCIONAL3_RESP');
----            CREATE_IDX(p_table_name => 'MSTR_DET_CAMAS_DEL_DIA', p_index_name => 'MSTR_DET_CAMAS_DEL_DIA_IDX05', p_columns => 'NATID_CONTROL_ENFERMERIA');
--            CREATE_IDX(p_table_name => 'MSTR_DET_CAMAS_DEL_DIA', p_index_name => 'MSTR_DET_CAMAS_DEL_DIA_IDX06', p_columns => 'NATID_EPISODIO');
--
--            --CREATE_FK (p_table_name => 'MSTR_DET_CAMAS_DEL_DIA', p_constraint_name => 'MSTR_DET_CAMAS_DEL_DIA_R01', p_parent_table, p_columns => 'NATID_AREA_HOSPITALARIA');
--            CREATE_FK (p_table_name => 'MSTR_DET_CAMAS_DEL_DIA', p_constraint_name => 'MSTR_DET_CAMAS_DEL_DIA_R02', p_parent_table => 'MSTR_MAE_CENTROS', p_columns => 'NATID_CENTRO');
--            CREATE_FK (p_table_name => 'MSTR_DET_CAMAS_DEL_DIA', p_constraint_name => 'MSTR_DET_CAMAS_DEL_DIA_R03', p_parent_table => 'MSTR_MAE_UNIDADES_FUNCIONALES3', p_columns => 'NATID_UNIDAD_FUNCIONAL3');
--            CREATE_FK (p_table_name => 'MSTR_DET_CAMAS_DEL_DIA', p_constraint_name => 'MSTR_DET_CAMAS_DEL_DIA_R04', p_parent_table => 'MSTR_MAE_UNIDADES_FUNCIONALES3', p_columns => 'NATID_UNIDAD_FUNCIONAL3_RESP', p_parent_columns => 'NATID_UNIDAD_FUNCIONAL3');
--            CREATE_FK (p_table_name => 'MSTR_DET_CAMAS_DEL_DIA', p_constraint_name => 'MSTR_DET_CAMAS_DEL_DIA_R05', p_parent_table => 'MSTR_MAE_CONTROLES_ENFERMERIA', p_columns => 'NATID_CONTROL_ENFERMERIA');
        
             DBMS_APPLICATION_INFO.set_module ('P_001', 'Creando índices en MSTR_DET_INGRESOS_HISTORICO');
            --CREATE_IDX(p_table_name => 'MSTR_DET_CAMAS_HISTORICO', p_index_name => 'MSTR_DET_CAMAS_DEL_DIA_IDX01', p_columns => 'NATID_AREA_HOSPITALARIA');
--            CREATE_IDX(p_table_name => 'MSTR_DET_CAMAS_DEL_DIA', p_index_name => 'MSTR_DET_CAMAS_DEL_DIA_IDX02', p_columns => 'NATID_CENTRO');
--            CREATE_IDX(p_table_name => 'MSTR_DET_CAMAS_DEL_DIA', p_index_name => 'MSTR_DET_CAMAS_DEL_DIA_IDX03', p_columns => 'NATID_UNIDAD_FUNCIONAL3');
--            CREATE_IDX(p_table_name => 'MSTR_DET_CAMAS_DEL_DIA', p_index_name => 'MSTR_DET_CAMAS_DEL_DIA_IDX04', p_columns => 'NATID_UNIDAD_FUNCIONAL3_RESP');
--            CREATE_IDX(p_table_name => 'MSTR_DET_CAMAS_DEL_DIA', p_index_name => 'MSTR_DET_CAMAS_DEL_DIA_IDX05', p_columns => 'NATID_CONTROL_ENFERMERIA');
            CREATE_IDX(p_table_name => 'MSTR_DET_INGRESOS_HISTORICO', p_index_name => 'MSTR_DET_INGRESOS_HISTORICO_I6', p_columns => 'NATID_EPISODIO');
            CREATE_IDX(p_table_name => 'MSTR_DET_INGRESOS_HISTORICO', p_index_name => 'MSTR_DET_INGRESOS_HISTORICO_I7', p_columns => 'NATID_FECHA');

            --CREATE_FK (p_table_name => 'MSTR_DET_CAMAS_DEL_DIA', p_constraint_name => 'MSTR_DET_CAMAS_DEL_DIA_R01', p_parent_table, p_columns => 'NATID_AREA_HOSPITALARIA');
            CREATE_FK (p_table_name => 'MSTR_DET_INGRESOS_HISTORICO', p_constraint_name => 'MSTR_DET_INGRESOS_HISTORICO_R2', p_parent_table => 'MSTR_MAE_CENTROS', p_columns => 'NATID_CENTRO');
            CREATE_FK (p_table_name => 'MSTR_DET_INGRESOS_HISTORICO', p_constraint_name => 'MSTR_DET_INGRESOS_HISTORICO_R3', p_parent_table => 'MSTR_MAE_UNIDADES_FUNCIONALES3', p_columns => 'NATID_UNIDAD_FUNCIONAL3');
            CREATE_FK (p_table_name => 'MSTR_DET_INGRESOS_HISTORICO', p_constraint_name => 'MSTR_DET_INGRESOS_HISTORICO_R4', p_parent_table => 'MSTR_MAE_UNIDADES_FUNCIONALES3', p_columns => 'NATID_UNIDAD_FUNCIONAL3_RESP', p_parent_columns => 'NATID_UNIDAD_FUNCIONAL3');
            --CREATE_FK (p_table_name => 'MSTR_DET_INGRESOS_HISTORICO', p_constraint_name => 'MSTR_DET_INGRESOS_HISTORICO_R5', p_parent_table => 'MSTR_MAE_CONTROLES_ENFERMERIA', p_columns => 'NATID_CONTROL_ENFERMERIA');

--            MARK_TABLE_READ_ONLY (p_table_name => 'MSTR_DET_CAMAS_DEL_DIA');
--            DBMS_APPLICATION_INFO.set_module ('P_001', 'Generando estadísticas de MSTR_DET_CAMAS_DEL_DIA');
--            COMPUTE_STATS  (p_table_name => 'MSTR_DET_CAMAS_DEL_DIA');

            MARK_TABLE_READ_ONLY (p_table_name => 'MSTR_DET_INGRESOS_HISTORICO');
            DBMS_APPLICATION_INFO.set_module ('P_001', 'Generando estadísticas de MSTR_DET_INGRESOS_HISTORICO');
            COMPUTE_STATS  (p_table_name => 'MSTR_DET_INGRESOS_HISTORICO');
            
            DBMS_APPLICATION_INFO.set_module ('P_001', 'Limpiando papelera');
            EXECUTE IMMEDIATE 'PURGE RECYCLEBIN';

            v_fin_ts := SYSTIMESTAMP;
            
            INSERT INTO MSTR_UTL_LOG_CARGAS (TS_LOG, RESULT, INT_DS_ELAPSED, NATID_AREA_HOSPITALARIA) VALUES (v_fin_ts, 'Completada carga Ingresos'/*, DBMS_UTILITY.format_error_backtrace*/, (v_fin_ts - v_inicio_ts), 'ALL');

--        EXCEPTION
--        WHEN OTHERS THEN
--        --v_fin_ts := SYSDATE;
--        DBMS_APPLICATION_INFO.READ_MODULE ( v_module_name , v_action_name ); 
--                    INSERT INTO MSTR_UTL_LOG_CARGAS (TS_LOG, RESULT, LOG, NATID_AREA_HOSPITALARIA) 
--                        VALUES (SYSTIMESTAMP, 'Error carga Camas '||v_module_name, v_action_name ||' -> '||DBMS_UTILITY.FORMAT_ERROR_STACK ||' -> ' || DBMS_UTILITY.format_error_backtrace, 'ALL');
--                    COMMIT;
--                    RAISE;

--		v_inicio_ts := SYSDATE;
--
--		--SELECT NATID_AREA_HOSPITALARIA INTO v_area_hospitalaria FROM MSTR_UTL_CODIGOS;
--
--		DBMS_SNAPSHOT.REFRESH ('MSTR_DET_CAMAS_DEL_DIA', 'C');
--
--		DBMS_STATS.gather_table_stats ('MSTR_HOSPITALIZACION', 'MSTR_DET_CAMAS_DEL_DIA');
--		COMMIT;
--
--		INSERT INTO MSTR_DET_HISTORICO_CAMAS
--			SELECT NATID_FECHA
--						,NATID_CAMA
--						,DESCR_CAMA
--						,LDESC_CAMA
--						,DESCR_TIPO_AISLAMIENTO
--						,NATID_EPISODIO
--						,NATID_USUARIO
--						,NATID_NUHSA
--						,GEO_CODIGO_POSTAL
--						,NVL (NATID_UNIDAD_FUNCIONAL3_RESP, -1)
--						,IND_ECTOPICO
--						,NATID_ESTADO
--						,IND_HABILITADA
--						,NATID_TIPO_CAMA
--						,NATID_CENTRO
--						,NATID_UNIDAD_FUNCIONAL3
--						,NATID_CONTROL_ENFERMERIA
--						,LAST_REFRESH_DATE
--						,CASE WHEN NATID_UNIDAD_FUNCIONAL3_RESP = -1 THEN NULL /* no hay paciente*/
--																																	ELSE CASE WHEN NATID_UNIDAD_FUNCIONAL3_RESP <> NATID_UNIDAD_FUNCIONAL3 THEN 1 ELSE 0 END END IND_ECTOPICO_UF
--				FROM MSTR_DET_CAMAS_DEL_DIA;
--
--		COMMIT;
--		DBMS_STATS.gather_table_stats ('MSTR_HOSPITALIZACION', 'MSTR_DET_HISTORICO_CAMAS');
--		DBMS_STATS.gather_table_stats ('MSTR_HOSPITALIZACION', 'MSTR_DET_CAMAS_DEL_DIA');
--
--		SELECT MAX (LAST_REFRESH_DATE) INTO v_last_refresh FROM MSTR_DET_CAMAS_DEL_DIA;
--
--		v_fin_ts := SYSDATE;
--		v_elapsed := (v_fin_ts - v_inicio_ts) * 24 * 60;
--	-- MSTR.PANDAS_090_POST_TO_SHAREP_v3.RETRY_N_TIMES (
--	-- 3
--	-- ,'{ Title: "Carga Censo de Camas", Content: "'
--	-- || '<table border=''1'' cellpadding=''3''><tr><td bgcolor=''#CEA539''>Última Ejecución</td><td bgcolor=''#CEA539''>Duración (min.)</td><td bgcolor=''#CEA539''>Fecha Replica</td></tr><tr><td bgcolor=''#232325''>'
--	-- || TO_CHAR (SYSDATE, 'dd-mon hh24:mi')
--	-- || '</td><td>'
--	-- || ROUND (v_elapsed, 2)
--	-- || '</td><td>'
--	-- || TO_CHAR (v_last_refresh, 'dd-mon hh24:mi')
--	-- || '</td></tr></table> '
--	-- || '", Result: "SUCCESS"  }');
--	-- MSTR.PANDAS_093_TWIT.POST_STATUS (TO_CHAR (SYSDATE, 'hh24"h"mi') || '+' || v_area_hospitalaria || '+Carga+Censo+de+Camas+completada+#ProyectoPandas', 'PANDAS_HOSPI');
--	EXCEPTION
--		WHEN OTHERS THEN
--			BEGIN
--				RAISE;
--			-- MSTR.PANDAS_093_TWIT.POST_STATUS (
--			-- 'Camas+'
--			-- || TO_CHAR (SYSDATE, 'hh24"h"mi')
--			-- || '+'
--			-- || v_area_hospitalaria
--			-- || '+'
--			-- || SUBSTR (REPLACE (REPLACE (REPLACE (SQLERRM, ' ', '+'), ',', ''), CHR (10), '+'), 1, 90)
--			-- || '...#ProyectoPandas'
--			-- ,'PANDAS_ERROR');
--			END;
--
--			RAISE;
	END P_001;
--
	PROCEDURE CREATE_SYNONYMS (p_DB_LINK_REPLICA IN VARCHAR2) IS
	BEGIN
		EXECUTE IMMEDIATE 'DROP SYNONYM ADM_ADMISION';
		EXECUTE IMMEDIATE 'CREATE SYNONYM ADM_ADMISION FOR REP_HIS_OWN.ADM_ADMISION@' || p_DB_LINK_REPLICA;

		EXECUTE IMMEDIATE 'DROP SYNONYM ADM_EPIS_DETALLE';
		EXECUTE IMMEDIATE 'CREATE SYNONYM ADM_EPIS_DETALLE FOR REP_HIS_OWN.ADM_EPIS_DETALLE@' || p_DB_LINK_REPLICA;

		EXECUTE IMMEDIATE 'DROP SYNONYM COM_USUARIO';
		EXECUTE IMMEDIATE 'CREATE SYNONYM COM_USUARIO FOR REP_HIS_OWN.COM_USUARIO@' || p_DB_LINK_REPLICA;

		EXECUTE IMMEDIATE 'DROP SYNONYM CENTROS_AH';
		EXECUTE IMMEDIATE 'CREATE SYNONYM CENTROS_AH FOR REP_PRO_EST.CENTROS_AH@' || p_DB_LINK_REPLICA;

		EXECUTE IMMEDIATE 'DROP SYNONYM ALL_MVIEWS';
		EXECUTE IMMEDIATE 'CREATE SYNONYM ALL_MVIEWS FOR SYS.ALL_MVIEWS@' || p_DB_LINK_REPLICA;

		EXECUTE IMMEDIATE 'DROP SYNONYM ADM_M_MODAL_ASIST';
		EXECUTE IMMEDIATE 'CREATE SYNONYM ADM_M_MODAL_ASIST FOR REP_HIS_OWN.ADM_M_MODAL_ASIST@' || p_DB_LINK_REPLICA;

		EXECUTE IMMEDIATE 'DROP SYNONYM ADM_M_PROCEDENCIA';
		EXECUTE IMMEDIATE 'CREATE SYNONYM ADM_M_PROCEDENCIA FOR REP_HIS_OWN.ADM_M_PROCEDENCIA@' || p_DB_LINK_REPLICA;

		EXECUTE IMMEDIATE 'DROP SYNONYM ADM_M_MOTIVO_INGRESO';
		EXECUTE IMMEDIATE 'CREATE SYNONYM ADM_M_MOTIVO_INGRESO FOR REP_HIS_OWN.ADM_M_MOTIVO_INGRESO@' || p_DB_LINK_REPLICA;

--		EXECUTE IMMEDIATE 'DROP SYNONYM ADM_ADMISION';
--		EXECUTE IMMEDIATE 'CREATE SYNONYM ADM_ADMISION FOR REP_HIS_OWN.ADM_ADMISION@' || p_DB_LINK_REPLICA;
--
--		EXECUTE IMMEDIATE 'DROP SYNONYM COM_USUARIO';
--		EXECUTE IMMEDIATE 'CREATE SYNONYM COM_USUARIO FOR REP_HIS_OWN.COM_USUARIO@' || p_DB_LINK_REPLICA;
	END CREATE_SYNONYMS;
    
    PROCEDURE DROP_TABLE (p_table_name IN VARCHAR2)
    IS
        TABLE_DOESNT_EXIST EXCEPTION;
        PRAGMA EXCEPTION_INIT(TABLE_DOESNT_EXIST, -00942);

        BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE '||p_table_name;
        EXCEPTION
            WHEN TABLE_DOESNT_EXIST
            THEN
            NULL;
        WHEN OTHERS THEN RAISE;
        END DROP_TABLE;
    PROCEDURE MARK_TABLE_READ_ONLY (p_table_name IN VARCHAR2)
    AS
    BEGIN
        EXECUTE IMMEDIATE 'ALTER TABLE '||p_table_name||' READ ONLY';
        EXCEPTION WHEN OTHERS THEN
        NULL;
    END MARK_TABLE_READ_ONLY;

    PROCEDURE MARK_TABLE_READ_WRITE (p_table_name IN VARCHAR2)
    AS
    BEGIN
        EXECUTE IMMEDIATE 'ALTER TABLE '||p_table_name||' READ WRITE';
        EXCEPTION WHEN OTHERS THEN
        NULL;
     END MARK_TABLE_READ_WRITE;

    PROCEDURE COMPUTE_STATS (p_table_name IN VARCHAR2)
    IS
    BEGIN
        SYS.DBMS_STATS.GATHER_TABLE_STATS (OwnName => USER
                                                                            ,TabName => p_table_name
                                                                            ,Estimate_Percent => NULL --SYS.DBMS_STATS.AUTO_SAMPLE_SIZE
                                                                            ,Method_Opt => 'FOR ALL COLUMNS SIZE SKEWONLY '
                                                                            ,Degree => DBMS_STATS.DEFAULT_DEGREE
                                                                            ,Cascade => DBMS_STATS.AUTO_CASCADE
                                                                            ,No_Invalidate => DBMS_STATS.AUTO_INVALIDATE);
    END COMPUTE_STATS;
    PROCEDURE CREATE_PK(p_table_name IN VARCHAR2, p_columns IN VARCHAR2)
    IS
    BEGIN
        EXECUTE IMMEDIATE 'ALTER TABLE '||p_table_name||' ADD
        CONSTRAINT MSTR_'||p_table_name||'_PK
         PRIMARY KEY ('||p_columns||') DISABLE';
         
        EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX '||p_table_name||'_PK ON MSTR_SIGLO.MSTR_MAE_CATALOGO_N0 
          ('||p_columns||')
          NOLOGGING  PARALLEL
          STORAGE ( BUFFER_POOL KEEP )';
          
        EXECUTE IMMEDIATE 'ALTER TABLE '||p_table_name||' ENABLE PRIMARY KEY';

    EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(p_table_name||' '||p_columns);
        RAISE;
END CREATE_PK;
PROCEDURE CREATE_FK (p_table_name IN VARCHAR2, p_constraint_name IN VARCHAR2, p_parent_table IN VARCHAR2, p_columns IN VARCHAR2)
IS
        PARENT_KEY_NOT_FOUND EXCEPTION;
        PRAGMA EXCEPTION_INIT(PARENT_KEY_NOT_FOUND, -02298);
BEGIN
    BEGIN 
     EXECUTE IMMEDIATE 'ALTER TABLE '|| p_table_name|| ' ADD
CONSTRAINT '||p_constraint_name||'
 FOREIGN KEY ('||p_columns||')
 REFERENCES '||p_parent_table||' ('||p_columns||')
 ENABLE
 VALIDATE';
     EXCEPTION WHEN PARENT_KEY_NOT_FOUND THEN
--        DBMS_APPLICATION_INFO.set_module ('P_001', 'Modificando a -1 clave foránea no encontrada');
        DBMS_APPLICATION_INFO.READ_MODULE ( v_module_name , v_action_name );
        INSERT INTO MSTR_UTL_LOG_CARGAS (TS_LOG, RESULT, LOG, NATID_AREA_HOSPITALARIA)
            VALUES (systimestamp, 'Error clave foránea '||v_module_name, v_action_name ||' -> '||DBMS_UTILITY.FORMAT_ERROR_STACK ||' -> ' || DBMS_UTILITY.format_error_backtrace, 'ALL');
        EXECUTE IMMEDIATE 'UPDATE ' || p_table_name|| '
             SET '||REPLACE(p_columns,', ',' = ''-1'', ')||' = ''-1'', ETL_ERROR_DESCR = ''clave foránea no encontrada: '||p_columns||'''
         WHERE ('||p_columns||') NOT IN (SELECT '||p_columns||' FROM '||p_parent_table||')';
             EXECUTE IMMEDIATE 'ALTER TABLE '|| p_table_name|| ' ADD
        CONSTRAINT '||p_constraint_name||'
         FOREIGN KEY ('||p_columns||')
         REFERENCES '||p_parent_table||' ('||p_columns||')
         ENABLE
         VALIDATE';
    END; 

 EXECUTE IMMEDIATE 'CREATE INDEX '||p_constraint_name||' ON '||p_table_name||'
('||p_columns||')
NOLOGGING
PARALLEL
STORAGE ( BUFFER_POOL KEEP )';
 
EXCEPTION WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE(p_table_name||' '||p_constraint_name ||' '||p_parent_table||' '||p_columns);
RAISE;

 END CREATE_FK;
PROCEDURE CREATE_FK (p_table_name IN VARCHAR2, p_constraint_name IN VARCHAR2, p_parent_table IN VARCHAR2, p_columns IN VARCHAR2, p_parent_columns IN VARCHAR2)
IS
        PARENT_KEY_NOT_FOUND EXCEPTION;
        PRAGMA EXCEPTION_INIT(PARENT_KEY_NOT_FOUND, -02298);
BEGIN

    BEGIN 
             EXECUTE IMMEDIATE 'ALTER TABLE '|| p_table_name|| ' ADD
        CONSTRAINT '||p_constraint_name||'
         FOREIGN KEY ('||p_columns||')
         REFERENCES '||p_parent_table||' ('||p_parent_columns||')
         ENABLE
         VALIDATE';
    EXCEPTION WHEN PARENT_KEY_NOT_FOUND THEN
--        DBMS_APPLICATION_INFO.set_module ('P_001', 'Modificando a -1 clave foránea no encontrada');
        DBMS_APPLICATION_INFO.READ_MODULE ( v_module_name , v_action_name );
        INSERT INTO MSTR_UTL_LOG_CARGAS (TS_LOG, RESULT, LOG, NATID_AREA_HOSPITALARIA)
            VALUES (systimestamp, 'Error clave foránea '||v_module_name, v_action_name ||' -> '||DBMS_UTILITY.FORMAT_ERROR_STACK ||' -> ' || DBMS_UTILITY.format_error_backtrace, 'ALL');
        EXECUTE IMMEDIATE 'UPDATE ' || p_table_name|| '
             SET '||REPLACE(p_columns,', ',' = ''-1'', ')||' = ''-1'', ETL_ERROR_DESCR = ''clave foránea no encontrada: '||p_columns||'''
         WHERE ('||p_columns||') NOT IN (SELECT '||p_parent_columns||' FROM '||p_parent_table||')';
                 EXECUTE IMMEDIATE 'ALTER TABLE '|| p_table_name|| ' ADD
            CONSTRAINT '||p_constraint_name||'
             FOREIGN KEY ('||p_columns||')
             REFERENCES '||p_parent_table||' ('||p_parent_columns||')
             ENABLE
             VALIDATE';
    END; 
 EXECUTE IMMEDIATE 'CREATE INDEX '||p_constraint_name||' ON '||p_table_name||'
('||p_columns||')
NOLOGGING
PARALLEL
STORAGE ( BUFFER_POOL KEEP )';
 
EXCEPTION WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE(p_table_name||' '||p_constraint_name ||' '||p_parent_table||' '||p_columns);
RAISE;

 END CREATE_FK;
PROCEDURE CREATE_IDX(p_table_name IN VARCHAR2, p_index_name IN VARCHAR2, p_columns IN VARCHAR2)
IS
BEGIN
--EXECUTE IMMEDIATE 'ALTER TABLE '||p_table_name||' ADD
--CONSTRAINT MSTR_'||p_table_name||'_PK
-- PRIMARY KEY ('||p_columns||') DISABLE';
 
EXECUTE IMMEDIATE 'CREATE INDEX '||p_index_name||' ON '||p_table_name ||'('||p_columns||')
  NOLOGGING  PARALLEL';
  
--EXECUTE IMMEDIATE 'ALTER TABLE '||p_table_name||' ENABLE PRIMARY KEY';

EXCEPTION WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE(p_table_name||' '||p_columns);
RAISE;
END CREATE_IDX;

PROCEDURE DROP_IDX(p_table_name IN VARCHAR2, p_index_name IN VARCHAR2)
IS
BEGIN
--EXECUTE IMMEDIATE 'ALTER TABLE '||p_table_name||' ADD
--CONSTRAINT MSTR_'||p_table_name||'_PK
-- PRIMARY KEY ('||p_columns||') DISABLE';
 
EXECUTE IMMEDIATE 'DROP INDEX '||p_index_name;-- ON '||p_table_name ||'('||p_columns||')
 -- NOLOGGING  PARALLEL';
  
--EXECUTE IMMEDIATE 'ALTER TABLE '||p_table_name||' ENABLE PRIMARY KEY';

EXCEPTION WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE(p_table_name);
--RAISE;
END DROP_IDX;

PROCEDURE DROP_CONSTRAINT (p_table_name IN VARCHAR2, p_constraint_name IN VARCHAR2)
IS
INDEX_DOESNT_EXIST EXCEPTION;
CONSTR_DOESNT_EXIST EXCEPTION;
PRAGMA EXCEPTION_INIT(CONSTR_DOESNT_EXIST, -02443);
PRAGMA EXCEPTION_INIT(INDEX_DOESNT_EXIST, -01418);

BEGIN
BEGIN
         EXECUTE IMMEDIATE 'DROP INDEX '|| p_constraint_name;
            EXCEPTION
               WHEN INDEX_DOESNT_EXIST
               THEN
                  NULL;
                  WHEN OTHERS
                  THEN RAISE;
END;
BEGIN
         EXECUTE IMMEDIATE 'ALTER TABLE '||p_table_name||' DROP CONSTRAINT '|| p_constraint_name;

EXCEPTION
 WHEN CONSTR_DOESNT_EXIST
 THEN NULL;
 WHEN OTHERS
 THEN
DBMS_OUTPUT.PUT_LINE(p_table_name||' '||p_constraint_name);
RAISE;
END;
END DROP_CONSTRAINT;

END;
/

