DROP TYPE t_tf_row_replicas;

CREATE OR REPLACE TYPE t_tf_row_replicas AS OBJECT
       (natid_area_hospitalaria VARCHAR2 (5),
        descr_area_hospitalaria VARCHAR2 (50),
        descr_instancia VARCHAR2 (20),
        descr_replica VARCHAR2 (20),
        ultimo_dato_disponible_min DATE,
        ultimo_dato_disponible_max DATE);
/
