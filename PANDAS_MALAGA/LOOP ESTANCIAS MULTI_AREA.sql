/* Formatted on 24/06/2014 12:44:35 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducción Total o Parcial. */
BEGIN

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
                                                ,NATID_CENTRO_PRIMER_TRASLADO
                                                ,NATID_CAMA_PRIMER_TRASLADO
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
                                    ,H.NATID_CENTRO_PRIMER_TRASLADO = T.NATID_CENTRO_PRIMER_TRASLADO
                                    ,H.NATID_CAMA_PRIMER_TRASLADO = T.NATID_CAMA_PRIMER_TRASLADO
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
                                     ,H.CIE9_DIAGNOSTICO_INGRESO
                                     ,H.NATID_CENTRO_PRIMER_TRASLADO
                                     ,H.NATID_CAMA_PRIMER_TRASLADO)
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
                                     ,T.CIE9_DIAGNOSTICO_INGRESO
                                     ,T.NATID_CENTRO_PRIMER_TRASLADO
                                     ,T.NATID_CAMA_PRIMER_TRASLADO)';
                                     END;
END LOOP;
END;