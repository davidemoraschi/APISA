--DROP VIEW MSTR_TIME_DYNAMIC_DATES
/

/* Formatted on 4/30/2014 9:30:26 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW MSTR_TIME_DYNAMIC_DATES
(
   NATID_FECHA_DYNAMIC_DATE,
   NATID_DYNAMIC_DATE,
   DESCR_DYNAMIC_DATE,
   LDESC_DYNAMIC_DATE
)
AS
   SELECT date_genera_fechas_v2.hoy,
          1,
          TO_CHAR(date_genera_fechas_v2.hoy, 'DD Mon YYYY'),
          'Hoy ('||TO_CHAR(date_genera_fechas_v2.hoy, 'DD Mon')||')'
     FROM DUAL
   UNION ALL
   SELECT date_genera_fechas_v2.ayer,
          2,
          TO_CHAR(date_genera_fechas_v2.ayer, 'DD Mon YYYY'),
          'Ayer ('||TO_CHAR(date_genera_fechas_v2.ayer, 'DD Mon')||')'
     FROM DUAL
   UNION ALL
   SELECT COLUMN_VALUE,
          3,
          TO_CHAR (COLUMN_VALUE, 'Mon YYYY'),
          'Mes en curso ('|| TO_CHAR (COLUMN_VALUE, 'Mon YYYY')||')'
     FROM TABLE (date_genera_fechas_v2.todos_dias_de_este_mes)
   UNION ALL
   SELECT COLUMN_VALUE,
          4,
          TO_CHAR (COLUMN_VALUE, 'Mon YYYY'),
          'Mes anterior ('|| TO_CHAR (COLUMN_VALUE, 'Mon YYYY')||')'
     FROM TABLE (date_genera_fechas_v2.todos_dias_del_mes_anterior)
   UNION ALL
   SELECT COLUMN_VALUE,
          5,
          TO_CHAR (COLUMN_VALUE, 'YYYY'),
          'Año en curso ('||TO_CHAR (COLUMN_VALUE, 'YYYY')||')'
     FROM TABLE (date_genera_fechas_v2.todos_dias_de_este_año_solar)
   UNION ALL
   SELECT COLUMN_VALUE,
          6,
          TO_CHAR (COLUMN_VALUE, 'YYYY'),
          'Año anterior ('||TO_CHAR (COLUMN_VALUE, 'YYYY')||')'
     FROM TABLE (date_genera_fechas_v2.todos_dias_año_solar_anterior)
/
