/* Formatted on 07/05/2013 13:46:04 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW MSTR_MAE_ESPECIALIDADES
AS
   SELECT ES_CODIGO NATID_ESPECIALIDAD,
          ES_DESCRIPCION DESCR_ESPECIALIDAD,
          ES_DECRETO IND_DECRETO,
          ES_PRIMARIA IND_PRIMARIA
     FROM REP_PRO_EST.ESPECIALIDADES@VAL;