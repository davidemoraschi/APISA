/* Formatted on 03/05/2013 8:57:31 (QP5 v5.163.1008.3004) */
SELECT *
  FROM REP_HIS_OWN.COM_UBICACION_GESTION_LOCAL@RND
  JOIN REP_PRO_ESP.UBICACIONES@VAL ON (codigo_estructura = ubi_codigo)
 WHERE codigo_estructura IN (SELECT codigo_estructura
                               FROM    REP_HIS_OWN.COM_UBICACION_GESTION_LOCAL@RND
                                    LEFT JOIN
                                       REP_PRO_ESP.UBICACIONES@VAL
                                    ON (codigo_estructura = ubi_codigo)
                              /*WHERE ubi_cah_codigo = 10004*/)