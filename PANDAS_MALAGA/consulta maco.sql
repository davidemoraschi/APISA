/* Formatted on 6/3/2014 12:43:28 (QP5 v5.163.1008.3004) */
SELECT PER_NOMBRE,
       PER_APELLIDO1,
       PER_APELLIDO2,
       OPE_USER,
       PERFIL,
       TIPO_UNIDAD,
       UF_NOMBRE,
       AH_DESCRIPCION
  FROM REP_PRO_MAC.OPERADORUNIDADFUNCIONAL
       LEFT JOIN REP_PRO_EST.UNIDADES_FUNCIONALES
          ON (UNIDAD = UF_CODIGO)
       LEFT JOIN REP_PRO_EST.AREAS_HOSPITALARIAS AH1
          ON (UNIDAD = AH1.AH_CODIGO)
       JOIN REP_PRO_MAC.PERSONAS
          ON (OPERADOR = PER_CODIGO)
       JOIN REP_PRO_MAC.OPERADOR
          ON (PERSONAS.PER_CODIGO = OPERADOR.OPE_PER_CODIGO)
 WHERE MODULO = 402