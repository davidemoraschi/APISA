CREATE OR REPLACE PACKAGE BODY MSTR_HOSPITALIZACION.ETL_LOAD_ESTRUCTURA AS

	PROCEDURE P_001 (Param1 IN NUMBER DEFAULT NULL) IS
        v_inicio_ts TIMESTAMP;
        v_fin_ts TIMESTAMP;
	BEGIN
		v_inicio_ts := SYSTIMESTAMP;

        DROP_TABLE (p_table_name => 'MSTR_MAE_UNIDADES_FUNCIONALES3');
        DROP_TABLE (p_table_name => 'MSTR_MAE_UNIDADES_FUNCIONALES2');
        DROP_TABLE (p_table_name => 'MSTR_MAE_UNIDADES_FUNCIONALES1');
        DROP_TABLE (p_table_name => 'MSTR_MAE_TIPOS_CAMA');
        DROP_TABLE (p_table_name => 'MSTR_MAE_ESTADOS_CAMA');
        DROP_TABLE (p_table_name => 'MSTR_MAE_CONTROLES_ENFERMERIA');
        DROP_TABLE (p_table_name => 'MSTR_MAE_CENTROS');
        DROP_TABLE (p_table_name => 'MSTR_MAE_AREAS_HOSPITALARIAS');
        
        P_N0;
        P_N1;
        P_N2;
        P_N3;
        P_N4;
        P_N5;

        v_fin_ts := SYSTIMESTAMP;
        INSERT INTO MSTR_UTL_LOG_CARGAS (TS_LOG, RESULT, INT_DS_ELAPSED, NATID_AREA_HOSPITALARIA) VALUES (v_fin_ts, 'Completada carga Estructura'/*, DBMS_UTILITY.format_error_backtrace*/, (v_fin_ts - v_inicio_ts), 'ALL');
                
	-- MSTR.PANDAS_090_POST_TO_SHAREP_v3.RETRY_N_TIMES (
	-- 3
	-- ,'{ Title: "Carga Censo de Camas", Content: "'
	-- || '<table border=''1'' cellpadding=''3''><tr><td bgcolor=''#CEA539''>Última Ejecución</td><td bgcolor=''#CEA539''>Duración (min.)</td><td bgcolor=''#CEA539''>Fecha Replica</td></tr><tr><td bgcolor=''#232325''>'
	-- || TO_CHAR (SYSDATE, 'dd-mon hh24:mi')
	-- || '</td><td>'
	-- || ROUND (v_elapsed, 2)
	-- || '</td><td>'
	-- || TO_CHAR (v_last_refresh, 'dd-mon hh24:mi')
	-- || '</td></tr></table> '
	-- || '", Result: "SUCCESS"  }');
	-- MSTR.PANDAS_093_TWIT.POST_STATUS (TO_CHAR (SYSDATE, 'hh24"h"mi') || '+' || v_area_hospitalaria || '+Carga+Censo+de+Camas+completada+#ProyectoPandas', 'PANDAS_HOSPI');
--	EXCEPTION
--		WHEN OTHERS THEN
--			BEGIN
--				RAISE;
			-- MSTR.PANDAS_093_TWIT.POST_STATUS (
			-- 'Camas+'
			-- || TO_CHAR (SYSDATE, 'hh24"h"mi')
			-- || '+'
			-- || v_area_hospitalaria
			-- || '+'
			-- || SUBSTR (REPLACE (REPLACE (REPLACE (SQLERRM, ' ', '+'), ',', ''), CHR (10), '+'), 1, 90)
			-- || '...#ProyectoPandas'
			-- ,'PANDAS_ERROR');
--			END;

--			RAISE;
	END P_001;

   PROCEDURE P_N0
   IS
   BEGIN
   
      EXECUTE IMMEDIATE 'CREATE TABLE MSTR_MAE_AREAS_HOSPITALARIAS
                (
                    NATID_AREA_HOSPITALARIA
                 ,DESCR_AREA_HOSPITALARIA
                 ,CONSTRAINT MAE_AREAS_HOSPITALARIAS_PK PRIMARY KEY (NATID_AREA_HOSPITALARIA)
                )
                ORGANIZATION INDEX
                NOLOGGING
                NOMONITORING
                NOPARALLEL
                STORAGE (BUFFER_POOL KEEP) AS
                SELECT ''-1'' NATID_AREA_HOSPITALARIA, ''n/a'' DESCR_AREA_HOSPITALARIA FROM DUAL
                UNION ALL
                SELECT AH_CODIGO NATID_AREA_HOSPITALARIA, AH_DESCRIPCION DESCR_AREA_HOSPITALARIA FROM REP_PRO_EST.AREAS_HOSPITALARIAS@SEE41DAE
                 WHERE AH_CODIGO IN (SELECT NATID_AREA_HOSPITALARIA FROM MSTR_UTL_LOCAL_CODIGOS)';

    MARK_TABLE_READ_ONLY (p_table_name => 'MSTR_MAE_AREAS_HOSPITALARIAS');
    COMPUTE_STATS  (p_table_name => 'MSTR_MAE_AREAS_HOSPITALARIAS');
   
   END P_N0;

   PROCEDURE P_N1
   IS
   BEGIN
   
      EXECUTE IMMEDIATE 'CREATE TABLE MSTR_MAE_UNIDADES_FUNCIONALES1
                (
                    NATID_AREA_HOSPITALARIA
                 ,NATID_UNIDAD_FUNCIONAL1
                 ,DESCR_UNIDAD_FUNCIONAL1
                 ,CONSTRAINT MAE_UNIDADES_FUNCIONALES1_PK PRIMARY KEY (NATID_UNIDAD_FUNCIONAL1)
                )
                ORGANIZATION INDEX
                NOLOGGING
                NOMONITORING
                NOPARALLEL
                STORAGE (BUFFER_POOL KEEP) AS
                    SELECT ''-1'' NATID_AREA_HOSPITALARIA, ''-1'' NATID_UNIDAD_FUNCIONAL1, ''n/a'' DESCR_UNIDAD_FUNCIONAL1 FROM DUAL
                    UNION ALL
                    SELECT UF_AH_CODIGO NATID_AREA_HOSPITALARIA, UF_CODIGO NATID_UNIDAD_FUNCIONAL1, UF_NOMBRE DESCR_UNIDAD_FUNCIONAL1
                        FROM REP_PRO_EST.UNIDADES_FUNCIONALES@SEE41DAE
                     WHERE UF_UF_CODIGO IS NULL AND UF_AH_CODIGO IN (SELECT NATID_AREA_HOSPITALARIA FROM MSTR_UTL_LOCAL_CODIGOS)';

   CREATE_FK (p_table_name => 'MSTR_MAE_UNIDADES_FUNCIONALES1'
   , p_constraint_name => 'MAE_UNIDADES_FUNCIONALES1_R01'
   , p_parent_table => 'MSTR_MAE_AREAS_HOSPITALARIAS'
   , p_columns => 'NATID_AREA_HOSPITALARIA');

    MARK_TABLE_READ_ONLY (p_table_name => 'MSTR_MAE_UNIDADES_FUNCIONALES1');
    COMPUTE_STATS  (p_table_name => 'MSTR_MAE_UNIDADES_FUNCIONALES1');
   
   END P_N1;
     PROCEDURE P_N2
   IS
   BEGIN
   
      EXECUTE IMMEDIATE
                         'CREATE TABLE MSTR_MAE_UNIDADES_FUNCIONALES2
                (
                    NATID_AREA_HOSPITALARIA
                 ,NATID_UNIDAD_FUNCIONAL2
                 ,DESCR_UNIDAD_FUNCIONAL2
                 ,NATID_UNIDAD_FUNCIONAL1
                 ,CONSTRAINT MAE_UNIDADES_FUNCIONALES2_PK PRIMARY KEY (NATID_UNIDAD_FUNCIONAL2)
                )
                ORGANIZATION INDEX
                NOLOGGING
                NOMONITORING
                NOPARALLEL
                STORAGE (BUFFER_POOL KEEP) AS
                    SELECT ''-1'' NATID_AREA_HOSPITALARIA
                                ,''-1'' NATID_UNIDAD_FUNCIONAL2
                                ,''n/a'' DESCR_UNIDAD_FUNCIONAL2
                                ,''-1'' NATID_UNIDAD_FUNCIONAL1
                        FROM DUAL
                    UNION ALL
                    SELECT UF_AH_CODIGO NATID_AREA_HOSPITALARIA
                                ,UF_CODIGO NATID_UNIDAD_FUNCIONAL2
                                ,UF_NOMBRE DESCR_UNIDAD_FUNCIONAL2
                                ,UF_UF_CODIGO NATID_UNIDAD_FUNCIONAL1
                        FROM REP_PRO_EST.UNIDADES_FUNCIONALES@SEE41DAE
                     WHERE UF_UF_CODIGO IN (SELECT UF_CODIGO
                                                                        FROM REP_PRO_EST.UNIDADES_FUNCIONALES@SEE41DAE
                                                                     WHERE UF_UF_CODIGO IS NULL AND UF_AH_CODIGO IN (SELECT NATID_AREA_HOSPITALARIA FROM MSTR_UTL_LOCAL_CODIGOS))
                    UNION ALL
                    -- Replica Nivel 1 sin hijos
                    SELECT UF_AH_CODIGO NATID_AREA_HOSPITALARIA
                                ,UF_CODIGO NATID_UNIDAD_FUNCIONAL2
                                ,UF_NOMBRE || ''*'' DESCR_UNIDAD_FUNCIONAL2
                                ,UF_CODIGO NATID_UNIDAD_FUNCIONAL1
                        FROM REP_PRO_EST.UNIDADES_FUNCIONALES@SEE41DAE
                     WHERE UF_UF_CODIGO IS NULL AND UF_AH_CODIGO IN (SELECT NATID_AREA_HOSPITALARIA FROM MSTR_UTL_LOCAL_CODIGOS) AND UF_FINAL = ''S''';

   CREATE_FK (p_table_name => 'MSTR_MAE_UNIDADES_FUNCIONALES2'
   , p_constraint_name => 'MAE_UNIDADES_FUNCIONALES2_R01'
   , p_parent_table => 'MSTR_MAE_UNIDADES_FUNCIONALES1'
   , p_columns => 'NATID_UNIDAD_FUNCIONAL1');
    MARK_TABLE_READ_ONLY (p_table_name => 'MSTR_MAE_UNIDADES_FUNCIONALES2');    
    COMPUTE_STATS  (p_table_name => 'MSTR_MAE_UNIDADES_FUNCIONALES2');

END P_N2;
  PROCEDURE P_N3
   IS
   BEGIN
      EXECUTE IMMEDIATE
                             'CREATE TABLE MSTR_MAE_UNIDADES_FUNCIONALES3
                    (
                        NATID_AREA_HOSPITALARIA
                     ,NATID_UNIDAD_FUNCIONAL3
                     ,DESCR_UNIDAD_FUNCIONAL3
                     ,NATID_UNIDAD_FUNCIONAL2
                     ,CONSTRAINT MAE_UNIDADES_FUNCIONALES3_PK PRIMARY KEY (NATID_UNIDAD_FUNCIONAL3)
                    )
                    ORGANIZATION INDEX
                    NOLOGGING
                    NOMONITORING
                    NOPARALLEL
                    STORAGE (BUFFER_POOL KEEP) AS
                        SELECT ''-1'' NATID_AREA_HOSPITALARIA
                                    ,''-1'' NATID_UNIDAD_FUNCIONAL3
                                    ,''n/a'' DESCR_UNIDAD_FUNCIONAL3
                                    ,''-1'' NATID_UNIDAD_FUNCIONAL2
                            FROM DUAL
                        UNION ALL
                        SELECT UF_AH_CODIGO NATID_AREA_HOSPITALARIA
                                    ,UF_CODIGO NATID_UNIDAD_FUNCIONAL3
                                    ,UF_NOMBRE DESCR_UNIDAD_FUNCIONAL3
                                    ,UF_UF_CODIGO NATID_UNIDAD_FUNCIONAL2
                            FROM REP_PRO_EST.UNIDADES_FUNCIONALES@SEE41DAE
                         WHERE UF_UF_CODIGO IN (SELECT UF_CODIGO
                                                                            FROM REP_PRO_EST.UNIDADES_FUNCIONALES@SEE41DAE
                                                                         WHERE UF_UF_CODIGO IN (SELECT UF_CODIGO
                                                                                                                            FROM REP_PRO_EST.UNIDADES_FUNCIONALES@SEE41DAE
                                                                                                                         WHERE UF_UF_CODIGO IS NULL AND UF_AH_CODIGO IN (SELECT NATID_AREA_HOSPITALARIA FROM MSTR_UTL_LOCAL_CODIGOS)))
                        UNION ALL
                        -- Replica Nivel 1 sin hijos
                        SELECT UF_AH_CODIGO NATID_AREA_HOSPITALARIA
                                    ,UF_CODIGO NATID_UNIDAD_FUNCIONAL3
                                    ,UF_NOMBRE || ''**'' DESCR_UNIDAD_FUNCIONAL3
                                    ,UF_CODIGO NATID_UNIDAD_FUNCIONAL2
                            FROM REP_PRO_EST.UNIDADES_FUNCIONALES@SEE41DAE
                         WHERE UF_UF_CODIGO IS NULL AND UF_AH_CODIGO IN (SELECT NATID_AREA_HOSPITALARIA FROM MSTR_UTL_LOCAL_CODIGOS) AND UF_FINAL = ''S''
                        UNION ALL
                        -- Replica Nivel 2 sin hijos
                        SELECT UF_AH_CODIGO NATID_AREA_HOSPITALARIA
                                    ,UF_CODIGO NATID_UNIDAD_FUNCIONAL3
                                    ,UF_NOMBRE || ''*'' DESCR_UNIDAD_FUNCIONAL3
                                    ,UF_CODIGO NATID_UNIDAD_FUNCIONAL2
                            FROM REP_PRO_EST.UNIDADES_FUNCIONALES@SEE41DAE
                         WHERE UF_UF_CODIGO IN (SELECT UF_CODIGO
                                                                            FROM REP_PRO_EST.UNIDADES_FUNCIONALES@SEE41DAE
                                                                         WHERE UF_UF_CODIGO IS NULL AND UF_AH_CODIGO IN (SELECT NATID_AREA_HOSPITALARIA FROM MSTR_UTL_LOCAL_CODIGOS))
                                     AND UF_FINAL = ''S''';

   CREATE_FK (p_table_name => 'MSTR_MAE_UNIDADES_FUNCIONALES3'
   , p_constraint_name => 'MAE_UNIDADES_FUNCIONALES3_R01'
   , p_parent_table => 'MSTR_MAE_UNIDADES_FUNCIONALES2'
   , p_columns => 'NATID_UNIDAD_FUNCIONAL2');
    MARK_TABLE_READ_ONLY (p_table_name => 'MSTR_MAE_UNIDADES_FUNCIONALES3'); 
    COMPUTE_STATS  (p_table_name => 'MSTR_MAE_UNIDADES_FUNCIONALES3');

   END P_N3;
   PROCEDURE P_N4
   IS
   BEGIN
      EXECUTE IMMEDIATE
                         'CREATE TABLE MSTR_MAE_CENTROS
                (
                    NATID_AREA_HOSPITALARIA
                 ,NATID_CENTRO
                 ,DESCR_CENTRO
                 ,CONSTRAINT MSTR_MAE_CENTROS_PK PRIMARY KEY (NATID_CENTRO)
                )
                ORGANIZATION INDEX
                NOLOGGING
                NOMONITORING
                NOPARALLEL
                STORAGE (BUFFER_POOL KEEP) AS
                    SELECT ''-1'' NATID_AREA_HOSPITALARIA, -1 NATID_CENTRO, ''n/a'' DESCR_CENTRO FROM DUAL
                    UNION ALL
                    SELECT CAH_AH_CODIGO NATID_AREA_HOSPITALARIA, CAH_CODIGO NATID_CENTRO, CAH_NOMBRE DESCR_CENTRO
                        FROM REP_PRO_EST.CENTROS_AH@SEE41DAE
                     WHERE CAH_AH_CODIGO IN (SELECT NATID_AREA_HOSPITALARIA FROM MSTR_UTL_LOCAL_CODIGOS)';

   CREATE_FK (p_table_name => 'MSTR_MAE_CENTROS'
   , p_constraint_name => 'MSTR_MAE_CENTROS_R01'
   , p_parent_table => 'MSTR_MAE_AREAS_HOSPITALARIAS'
   , p_columns => 'NATID_AREA_HOSPITALARIA');
    MARK_TABLE_READ_ONLY (p_table_name => 'MSTR_MAE_CENTROS');    
    COMPUTE_STATS  (p_table_name => 'MSTR_MAE_CENTROS');
    
   END P_N4;

   PROCEDURE P_N5
   IS
   BEGIN
      EXECUTE IMMEDIATE
                             'CREATE TABLE MSTR_MAE_CONTROLES_ENFERMERIA
                    (
                        NATID_AREA_HOSPITALARIA
                     ,NATID_CENTRO
                     ,NATID_CONTROL_ENFERMERIA
                     ,DESCR_CONTROL_ENFERMERIA
                     ,LDESC_CONTROL_ENFERMERIA
                     ,CONSTRAINT MAE_CONTROLES_ENFERMERIA_PK PRIMARY KEY (NATID_CONTROL_ENFERMERIA)
                    )
                    ORGANIZATION INDEX
                    NOLOGGING
                    NOMONITORING
                    NOPARALLEL
                    STORAGE (BUFFER_POOL KEEP) AS
                        SELECT ''-1'' NATID_AREA_HOSPITALARIA
                                    ,-1 NATID_CENTRO
                                    ,''-1'' NATID_CONTROL_ENFERMERIA
                                    ,''n/a'' DESCR_CONTROL_ENFERMERIA
                                    ,''n/a'' LDESC_CONTROL_ENFERMERIA
                            --,''-1'' NATID_UBICACION_PADRE
                            --,''n/a'' DESCR_UBICACION_PADRE
                            FROM DUAL --,
                        UNION ALL
                        SELECT MSTR_MAE_CENTROS.NATID_AREA_HOSPITALARIA NATID_AREA_HOSPITALARIA
                                    ,UBICACIONES.UBI_CAH_CODIGO NATID_CENTRO
                                    ,UBICACIONES.UBI_CODIGO NATID_CONTROL_ENFERMERIA
                                    ,UBICACIONES.UBI_NOMBRE DESCR_CONTROL_ENFERMERIA
                                    ,UBICACIONES.UBI_DESCRIPCION LDESC_CONTROL_ENFERMERIA
                            --,UBICACIONES.UBI_UBI_CODIGO NATID_UBICACION_PADRE
                            --,PADRE.UBI_NOMBRE DESCR_UBICACION_PADRE
                            FROM REP_PRO_EST.UBICACIONES@SEE41DAE --JOIN REP_PRO_EST.UBICACIONES@SEE41DAE PADRE
                                                                                                        --ON UBICACIONES.UBI_UBI_CODIGO = PADRE.UBI_CODIGO
                                                                                                        JOIN MSTR_MAE_CENTROS ON (UBICACIONES.UBI_CAH_CODIGO = NATID_CENTRO)
                         WHERE UBICACIONES.UBI_TIP_UBICACION = 20';

   CREATE_FK (p_table_name => 'MSTR_MAE_CONTROLES_ENFERMERIA'
   , p_constraint_name => 'MAE_CONTROLES_ENFERMERIA_R01'
   , p_parent_table => 'MSTR_MAE_CENTROS'
   , p_columns => 'NATID_CENTRO');
    MARK_TABLE_READ_ONLY (p_table_name => 'MSTR_MAE_CONTROLES_ENFERMERIA');    
    COMPUTE_STATS  (p_table_name => 'MSTR_MAE_CONTROLES_ENFERMERIA');

   END P_N5;

 	PROCEDURE CREATE_SYNONYMS (p_DB_LINK_REPLICA IN VARCHAR2) IS
	BEGIN
		EXECUTE IMMEDIATE 'DROP SYNONYM COM_UBICACION_GESTION_LOCAL';
		EXECUTE IMMEDIATE 'CREATE SYNONYM COM_UBICACION_GESTION_LOCAL FOR REP_HIS_OWN.COM_UBICACION_GESTION_LOCAL@' || p_DB_LINK_REPLICA;

		EXECUTE IMMEDIATE 'DROP SYNONYM UBICACIONES';
		EXECUTE IMMEDIATE 'CREATE SYNONYM UBICACIONES FOR REP_PRO_EST.UBICACIONES@' || p_DB_LINK_REPLICA;

		EXECUTE IMMEDIATE 'DROP SYNONYM TIPOS_UBICACION';
		EXECUTE IMMEDIATE 'CREATE SYNONYM TIPOS_UBICACION FOR REP_PRO_EST.TIPOS_UBICACION@' || p_DB_LINK_REPLICA;

		EXECUTE IMMEDIATE 'DROP SYNONYM CENTROS_AH';
		EXECUTE IMMEDIATE 'CREATE SYNONYM CENTROS_AH FOR REP_PRO_EST.CENTROS_AH@' || p_DB_LINK_REPLICA;

		EXECUTE IMMEDIATE 'DROP SYNONYM ALL_MVIEWS';
		EXECUTE IMMEDIATE 'CREATE SYNONYM ALL_MVIEWS FOR SYS.ALL_MVIEWS@' || p_DB_LINK_REPLICA;

		EXECUTE IMMEDIATE 'DROP SYNONYM COM_M_TIPO_AISLAMIENTO';
		EXECUTE IMMEDIATE 'CREATE SYNONYM COM_M_TIPO_AISLAMIENTO FOR REP_HIS_OWN.COM_M_TIPO_AISLAMIENTO@' || p_DB_LINK_REPLICA;

		EXECUTE IMMEDIATE 'DROP SYNONYM COM_UBICACION_AISLADA';
		EXECUTE IMMEDIATE 'CREATE SYNONYM COM_UBICACION_AISLADA FOR REP_HIS_OWN.COM_UBICACION_AISLADA@' || p_DB_LINK_REPLICA;

		EXECUTE IMMEDIATE 'DROP SYNONYM ADM_EPIS_DETALLE';
		EXECUTE IMMEDIATE 'CREATE SYNONYM ADM_EPIS_DETALLE FOR REP_HIS_OWN.ADM_EPIS_DETALLE@' || p_DB_LINK_REPLICA;

		EXECUTE IMMEDIATE 'DROP SYNONYM ADM_ADMISION';
		EXECUTE IMMEDIATE 'CREATE SYNONYM ADM_ADMISION FOR REP_HIS_OWN.ADM_ADMISION@' || p_DB_LINK_REPLICA;

		EXECUTE IMMEDIATE 'DROP SYNONYM COM_USUARIO';
		EXECUTE IMMEDIATE 'CREATE SYNONYM COM_USUARIO FOR REP_HIS_OWN.COM_USUARIO@' || p_DB_LINK_REPLICA;
	END CREATE_SYNONYMS;
    
    PROCEDURE DROP_TABLE (p_table_name IN VARCHAR2)
    IS
        TABLE_DOESNT_EXIST EXCEPTION;
        PRAGMA EXCEPTION_INIT(TABLE_DOESNT_EXIST, -00942);

        BEGIN
        FOR C1 in (SELECT TABLE_NAME, CONSTRAINT_NAME
                    FROM all_constraints
                 WHERE r_constraint_name IN (SELECT constraint_name
                                                             FROM ALL_CONSTRAINTS
                                                            WHERE TABLE_NAME = p_table_name)) LOOP
                                                                DROP_CONSTRAINT(p_table_name => C1.TABLE_NAME, p_constraint_name => C1.CONSTRAINT_NAME);
                                                            END LOOP;
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
    END MARK_TABLE_READ_ONLY;

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
PROCEDURE CREATE_FK (p_table_name IN VARCHAR2, p_constraint_name IN VARCHAR2, p_parent_table IN VARCHAR2, p_columns IN VARCHAR2)
IS
BEGIN
 
     EXECUTE IMMEDIATE 'ALTER TABLE '|| p_table_name|| ' ADD
CONSTRAINT '||p_constraint_name||'
 FOREIGN KEY ('||p_columns||')
 REFERENCES '||p_parent_table||' ('||p_columns||')
 ENABLE
 VALIDATE';
 
 EXECUTE IMMEDIATE 'CREATE INDEX '||p_constraint_name||' ON '||p_table_name||'
('||p_columns||')
NOLOGGING
NOPARALLEL
STORAGE ( BUFFER_POOL KEEP )';
 
EXCEPTION WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE(p_table_name||' '||p_constraint_name ||' '||p_parent_table||' '||p_columns);
RAISE;

 END CREATE_FK;


END;
/

