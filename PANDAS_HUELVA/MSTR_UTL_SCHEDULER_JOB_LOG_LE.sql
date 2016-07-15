/* Formatted on 03/06/2013 12:42:16 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE VIEW MSTR_UTL_SCHEDULER_JOB_LOG_LE
AS
   SELECT 'Carga censo de Camas' "Title",
          "Fecha_inicio_tarea",
          "Duracion",
          "Carga",
          "Resultado",
          "Informacion",
          "Clave_log"
     FROM (  SELECT TO_CHAR (a11.FECHA_INICIO_TAREA, 'DD/MM/YYYY HH24:MI') "Fecha_inicio_tarea",
                    a11.DURACION "Duracion",
                    a11.JOB_NAME "Carga",
                    a11.OPERACION "Operacion",
                    a11.RESULTADO "Resultado",
                    --('<![CDATA[' || a11.INFORMACION || ']]>') INFORMACION,
                    a11.INFORMACION "Informacion",
                    MAX (a11.CLAVE_PRIMARIA_LOG) "Clave_log",
                    RANK () OVER (ORDER BY MAX (a11.CLAVE_PRIMARIA_LOG) DESC NULLS LAST) WJXBFS2
               FROM MSTR_UTL_SCHEDULER_JOB_LOG a11
           GROUP BY a11.FECHA_INICIO_TAREA,
                    a11.DURACION,
                    a11.JOB_NAME,
                    a11.OPERACION,
                    a11.RESULTADO,
                    --('<![CDATA[' || a11.INFORMACION || ']]>')
                    a11.INFORMACION)
    WHERE WJXBFS2 = 1