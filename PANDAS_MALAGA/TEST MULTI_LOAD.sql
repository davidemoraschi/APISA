BEGIN
 --ETL_LOAD_ESTRUCTURA.P_001;
 ETL_LOAD_CAMAS_DEL_DIA.P_001_MULTI_AREA ('02026');
END;


EXEC ETL_LOAD_CAMAS_DEL_DIA.CREATE_SYNONYMS ('SEE42DAE');


DECLARE
p_DB_LINK_REPLICA VARCHAR2(100):= 'SEE42DAE';
BEGIN
    --BEGIN
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

END;