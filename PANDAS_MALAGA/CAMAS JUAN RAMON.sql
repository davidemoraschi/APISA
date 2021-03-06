SELECT 
NATID_AREA_HOSPITALARIA, NATID_FECHA, NATID_FECHA_ULTIMO_REFRESCO, 
   NATID_CENTRO, NATID_UNIDAD_FUNCIONAL3, NATID_CAMA, 
   DESCR_CAMA, LDESC_CAMA, NATID_TIPO_CAMA, 
   DESCR_TIPO_CAMA, NATID_TIPO_AISLAMIENTO, DESCR_TIPO_AISLAMIENTO, 
   NATID_EPISODIO, NATID_UNIDAD_FUNCIONAL3_RESP, NATID_CONTROL_ENFERMERIA, 
   NATID_NUHSA, ETL_ERROR_DESCR
FROM MSTR_DET_CAMAS_HISTORICO
WHERE NATID_FECHA = '22-APR-2014'
AND NATID_CENTRO = 10142
AND NATID_EPISODIO <> -1
--AND DESCR_TIPO_CAMA = 'Cama'
--AND NATID_UNIDAD_FUNCIONAL3_RESP IS NULL