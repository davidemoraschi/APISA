/* Formatted on 31/05/2013 8:04:14 (QP5 v5.163.1008.3004) */
CREATE TABLE temp_xml (A1 CLOB);

SELECT A1 FROM temp_xml;

SELECT xmltype (A1).EXTRACT ('diraya_respuesta/contenido_msj/citas/area/centro/unidad') FROM temp_xml;

SELECT EXTRACTVALUE (COLUMN_VALUE, '/cita/@cita_id') natid_cita,
       xmltype (A1).EXTRACT ('diraya_respuesta/contenido_msj/citas/area/centro/unidad') unidad,
       COLUMN_VALUE
  FROM temp_xml,
       TABLE (XMLSEQUENCE (EXTRACT (xmltype (A1,
                                             NULL,
                                             1,
                                             1),
                                    'diraya_respuesta/contenido_msj/citas/area/centro/unidad/agenda/tramo/subtramo/cita')));