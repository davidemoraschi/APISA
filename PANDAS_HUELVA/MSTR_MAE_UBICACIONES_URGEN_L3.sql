/* Formatted on 20/03/2013 11:53:55 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW MSTR_MAE_UBICACIONES_URGEN_L3
AS
   SELECT L,
          NATID_UBICACION_URGEN,
          DESCR_UBICACION_URGEN,
          NATID_UBICACION_URGEN_PADRE,
          IND_TIENE_DEPENDIENTES,
          NATID_TIPO_UBICACION,
          NATID_CENTRO,
          DECODE (NATID_UBICACION_URGEN,
                  '24935', 'Traumatológicas',
                  '48053', 'Obstetricoginecológicas',
                  --               '002084', 'Obstetricoginecológicas',
                  '24928', 'Pediatricas',
                  --               '000507', 'Pediatricas',
                  --               '003700', 'Pediatricas',
                  'Otras')
             UF_SUB_BLOQUE,
          DECODE (NATID_UBICACION_URGEN,                                                  --               '24935', 'Traumatológicas',
                                    '48053', 'Obstetricoginecológicas',     --               '002084', 'Obstetricoginecológicas',
                                                                        '24928', 'Pediatricas', --               '000507', 'Pediatricas',
                                                                                                 --               '003700', 'Pediatricas',
                                                                                                 'Generales') UF_BLOQUE
     FROM MSTR_MAE_UBICACIONES_URGEN
    WHERE L = 3
   UNION ALL
   SELECT 3,
          NATID_UBICACION_URGEN,
          DESCR_UBICACION_URGEN,
          NATID_UBICACION_URGEN_PADRE,
          IND_TIENE_DEPENDIENTES,
          NATID_TIPO_UBICACION,
          NATID_CENTRO,
          DECODE (NATID_UBICACION_URGEN,
                  '24935', 'Traumatológicas',
                  '48053', 'Obstetricoginecológicas',
                  --               '002084', 'Obstetricoginecológicas',
                  '24928', 'Pediatricas',
                  --               '000507', 'Pediatricas',
                  --               '003700', 'Pediatricas',
                  'Otras')
             UF_SUB_BLOQUE,
          DECODE (NATID_UBICACION_URGEN,                                                  --               '24935', 'Traumatológicas',
                                    '48053', 'Obstetricoginecológicas',     --               '002084', 'Obstetricoginecológicas',
                                                                        '24928', 'Pediatricas', --               '000507', 'Pediatricas',
                                                                                                 --               '003700', 'Pediatricas',
                                                                                                 'Generales') UF_BLOQUE
     FROM MSTR_MAE_UBICACIONES_URGEN
    WHERE L = 1
   UNION ALL
   SELECT 3,
          NATID_UBICACION_URGEN,
          DESCR_UBICACION_URGEN,
          NATID_UBICACION_URGEN_PADRE,
          IND_TIENE_DEPENDIENTES,
          NATID_TIPO_UBICACION,
          NATID_CENTRO,
          DECODE (NATID_UBICACION_URGEN,
                  '24935', 'Traumatológicas',
                  '48053', 'Obstetricoginecológicas',
                  --               '002084', 'Obstetricoginecológicas',
                  '24928', 'Pediatricas',
                  --               '000507', 'Pediatricas',
                  --               '003700', 'Pediatricas',
                  'Otras')
             UF_SUB_BLOQUE,
          DECODE (NATID_UBICACION_URGEN,                                                  --               '24935', 'Traumatológicas',
                                    '48053', 'Obstetricoginecológicas',     --               '002084', 'Obstetricoginecológicas',
                                                                        '24928', 'Pediatricas', --               '000507', 'Pediatricas',
                                                                                                 --               '003700', 'Pediatricas',
                                                                                                 'Generales') UF_BLOQUE
     FROM MSTR_MAE_UBICACIONES_URGEN
    WHERE L = 2;
