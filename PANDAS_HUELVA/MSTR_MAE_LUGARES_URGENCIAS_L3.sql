/* Formatted on 20/03/2013 11:18:49 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW MSTR_MAE_LUGARES_URGENCIAS_L3
(
   L,
   UBI_IDENTIFICADOR,
   UBI_NOMBRE,
   UBI_PADRE,
   UBI_UBICACIONES_DEP,
   UBI_TIP_UBICACION,
   UBI_CENTRO,
   UF_SUB_BLOQUE,
   UF_BLOQUE
)
AS
   SELECT L,
          UBI_IDENTIFICADOR,
          UBI_NOMBRE,
          UBI_PADRE,
          UBI_UBICACIONES_DEP,
          UBI_TIP_UBICACION,
          UBI_CENTRO,
          DECODE (UBI_IDENTIFICADOR,
                  '24935', 'Traumatológicas',
                  '48053', 'Obstetricoginecológicas',
                  --               '002084', 'Obstetricoginecológicas',
                  '24928', 'Pediatricas',
                  --               '000507', 'Pediatricas',
                  --               '003700', 'Pediatricas',
                  'Otras')
             UF_SUB_BLOQUE,
          DECODE (UBI_IDENTIFICADOR,                                                  --               '24935', 'Traumatológicas',
                                    '48053', 'Obstetricoginecológicas',     --               '002084', 'Obstetricoginecológicas',
                                                                        '24928', 'Pediatricas', --               '000507', 'Pediatricas',
                                                                                         --               '003700', 'Pediatricas',
            'Generales') UF_BLOQUE
     FROM MSTR_MAE_UBICACIONES_URGENCIAS
    WHERE L = 3
   UNION ALL
   SELECT 3,
          UBI_IDENTIFICADOR,
          UBI_NOMBRE,
          UBI_IDENTIFICADOR,
          UBI_UBICACIONES_DEP,
          UBI_TIP_UBICACION,
          UBI_CENTRO,
          DECODE (UBI_IDENTIFICADOR,
                  '24935', 'Traumatológicas',
                  '48053', 'Obstetricoginecológicas',
                  --               '002084', 'Obstetricoginecológicas',
                  '24928', 'Pediatricas',
                  --               '000507', 'Pediatricas',
                  --               '003700', 'Pediatricas',
                  'Otras')
             UF_SUB_BLOQUE,
          DECODE (UBI_IDENTIFICADOR,                                                  --               '24935', 'Traumatológicas',
                                    '48053', 'Obstetricoginecológicas',     --               '002084', 'Obstetricoginecológicas',
                                                                        '24928', 'Pediatricas', --               '000507', 'Pediatricas',
                                                                                         --               '003700', 'Pediatricas',
            'Generales') UF_BLOQUE
     FROM MSTR_MAE_UBICACIONES_URGENCIAS
    WHERE L = 1
   UNION ALL
   SELECT 3,
          UBI_IDENTIFICADOR,
          UBI_NOMBRE,
          UBI_IDENTIFICADOR,
          UBI_UBICACIONES_DEP,
          UBI_TIP_UBICACION,
          UBI_CENTRO,
          DECODE (UBI_IDENTIFICADOR,
                  '24935', 'Traumatológicas',
                  '48053', 'Obstetricoginecológicas',
                  --               '002084', 'Obstetricoginecológicas',
                  '24928', 'Pediatricas',
                  --               '000507', 'Pediatricas',
                  --               '003700', 'Pediatricas',
                  'Otras')
             UF_SUB_BLOQUE,
          DECODE (UBI_IDENTIFICADOR,                                                  --               '24935', 'Traumatológicas',
                                    '48053', 'Obstetricoginecológicas',     --               '002084', 'Obstetricoginecológicas',
                                                                        '24928', 'Pediatricas', --               '000507', 'Pediatricas',
                                                                                         --               '003700', 'Pediatricas',
            'Generales') UF_BLOQUE
     FROM MSTR_MAE_UBICACIONES_URGENCIAS
    WHERE L = 2;


/* Formatted on 20/03/2013 11:18:49 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW MSTR_MAE_LUGARES_URGENCIAS_L4
(
   L,
   UBI_IDENTIFICADOR,
   UBI_NOMBRE,
   UBI_PADRE,
   UBI_UBICACIONES_DEP,
   UBI_TIP_UBICACION,
   UBI_CENTRO
)
AS
   SELECT L,
          UBI_IDENTIFICADOR,
          UBI_NOMBRE,
          UBI_PADRE,
          UBI_UBICACIONES_DEP,
          UBI_TIP_UBICACION,
          UBI_CENTRO
     FROM MSTR_MAE_UBICACIONES_URGENCIAS
    WHERE L = 4
   UNION ALL
   SELECT 4,
          UBI_IDENTIFICADOR,
          UBI_NOMBRE,
          UBI_IDENTIFICADOR,
          UBI_UBICACIONES_DEP,
          UBI_TIP_UBICACION,
          UBI_CENTRO
     FROM MSTR_MAE_UBICACIONES_URGENCIAS
    WHERE L = 1
   UNION ALL
   SELECT 4,
          UBI_IDENTIFICADOR,
          UBI_NOMBRE,
          UBI_IDENTIFICADOR,
          UBI_UBICACIONES_DEP,
          UBI_TIP_UBICACION,
          UBI_CENTRO
     FROM MSTR_MAE_UBICACIONES_URGENCIAS
    WHERE L = 2
   UNION ALL
   SELECT 4,
          UBI_IDENTIFICADOR,
          UBI_NOMBRE,
          UBI_IDENTIFICADOR,
          UBI_UBICACIONES_DEP,
          UBI_TIP_UBICACION,
          UBI_CENTRO
     FROM MSTR_MAE_UBICACIONES_URGENCIAS
    WHERE L = 3;
