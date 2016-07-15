/* Formatted on 4/21/2014 13:00:37 (QP5 v5.163.1008.3004) */
-- Create the types to support the table function.
DROP TYPE T_TF_TAB_REPLICAS;
DROP TYPE t_tf_row_replicas;

CREATE OR REPLACE TYPE t_tf_row_replicas AS OBJECT
       (natid_area_hospitalaria VARCHAR2 (5),
        descr_area_hospitalaria VARCHAR2 (50),
        descr_instancia VARCHAR2 (20),
        descr_replica VARCHAR2 (20),
        num_tablas INTEGER,
        ultimo_dato_disponible_min DATE,
        ultimo_dato_disponible_max DATE,
        ESTADISTICA_MAS_ANTIGUA DATE,
        ESTADISTICA_MAS_RECIENTE DATE);
/


CREATE TYPE t_tf_tab_replicas IS TABLE OF t_tf_row_replicas;