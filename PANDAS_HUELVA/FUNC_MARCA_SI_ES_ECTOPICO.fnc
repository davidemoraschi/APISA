/* Formatted on 03/05/2013 10:20:46 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FUNCTION MSTR_HOSPITALIZACION.FUNC_MARCA_SI_ES_ECTOPICO (UBI_CODIGO       IN VARCHAR2,
                                                                           UNID_FUNC_RESP   IN VARCHAR2,
                                                                           USUARIO          IN NUMBER)
   RETURN NUMBER
IS
   ind_ectopico         NUMBER := 0;
   CONTROL_ENFERMERIA   NUMBER;
   nEDAD                NUMBER;
   v_count              NUMBER;
BEGIN
   /* Identifica el control de enfermería asociado a la cama*/
   SELECT C.NATID_CONTROL_ENFERMERIA
     INTO CONTROL_ENFERMERIA
     FROM MSTR_MAE_CAMAS C
    WHERE C.NATID_CAMA = UBI_CODIGO;

   BEGIN
      /* Busca si el control de enfermeria combinado con la unidad funcional responsable del paciente tiene indicador de ectópico */
      SELECT E.IND_BAJA_FRECUENTACION
        INTO ind_ectopico
        FROM MSTR_UTL_CONTROL_ECTOPICOS E
       WHERE E.NATID_CONTROL_ENFERMERIA = CONTROL_ENFERMERIA AND E.NATID_UNIDAD_FUNCIONAL = UNID_FUNC_RESP;

      /* BAJA FRECUENTACIÓN */
      /* En Valme la única unidad funcional que cambia con la baja frecuentación es Medicina Interna  --(UNID_FUNC_RESP = '000489')*/
      SELECT COUNT (DISTINCT NATID_UNIDAD_FUNCIONAL)
        INTO v_count
        FROM MSTR_UTL_CONTROL_ECTOPICOS
       WHERE IND_BAJA_FRECUENTACION = 1 AND NATID_UNIDAD_FUNCIONAL = UNID_FUNC_RESP;

      IF (v_count > 0)
         /* Si estamos en fechas de BAJA*/
         /* Fechas de BAJA frecuentación entre 1 de Abril y 30 de Noviembre */
         AND (TRUNC (SYSDATE) BETWEEN (ADD_MONTHS (TRUNC (SYSDATE, 'YEAR'), 3))
                                  AND (ADD_MONTHS (TRUNC (SYSDATE, 'YEAR'), 11) - 1))
         AND (ind_ectopico = 1)
      THEN
         ind_ectopico := 0;
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         /* Si el control de enfermeria combinado con la unidad funcional responsable del paciente no aparece en la lista de los permitidos entonces es ectópico*/
         ind_ectopico := 1;
   END;

   /* En Valme los niños menores de 14 años que duermen en Pediatría pero vienen de otra unidad funcional no se consideran ectópicos ('45665', '45664')*/
   SELECT COUNT (DISTINCT NATID_UNIDAD_FUNCIONAL)
     INTO v_count
     FROM MSTR_UTL_CONTROL_ECTOPICOS
    WHERE IND_PEDIATRIA = 1 AND NATID_CONTROL_ENFERMERIA = CONTROL_ENFERMERIA;

   IF (v_count > 0) AND (ind_ectopico = 1)
   /*(CONTROL_ENFERMERIA IN ('45665', '45664'))*/
   /* Si el paciente ectópico está en Pediatría y la edad es menor de 14 años, entonces no es ectópico*/
   THEN
      SELECT MONTHS_BETWEEN (TRUNC (SYSDATE), FECHA_NACIMIENTO) / 12
        INTO nEDAD
        FROM REP_HIS_OWN.COM_USUARIO@EXP
       WHERE ID_USUARIO = USUARIO;

      IF nEDAD < 14
      THEN
         ind_ectopico := 0;
      END IF;
   END IF;

   RETURN ind_ectopico;
END;
/