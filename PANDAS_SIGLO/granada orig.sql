/* Formatted on 24/01/2014 20:40:18 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducción Total o Parcial. */
SET VERIFY OFF
SET PAUSE OFF
SET FEEDBACK OFF
SET HEADING OFF
SET TRIMS ON
SET TRIM ON tab OFF
SET COLSEP |
SET ECHO OFF
SET TERMOUT OFF
SET LIN 5000
SET PAGESIZE 0
SET SERVEROUTPUT OFF

--SPOOL e:\quiterian\etl\siglo\script_oracle_consumos.txt

DROP TABLE tmp_consumos;

CREATE TABLE tmp_consumos
(
	id NUMBER (10)
 ,idarticulo NUMBER (10)
 ,genericocentro VARCHAR (6)
 ,codigo VARCHAR (255)
 ,cantidad NUMBER (22, 2)
 ,importe NUMBER (22, 6)
 ,centroconsumo VARCHAR (100)
 ,descentroconsumo VARCHAR (255)
 ,fechamovimiento DATE
 ,codigoaplicacion VARCHAR (255)
 ,organogestor NUMBER (10)
 ,descentro VARCHAR (255)
 ,servicio VARCHAR (20)
 ,desservicio VARCHAR (255)
 ,ugc VARCHAR (20)
 ,desugc VARCHAR (255)
 ,porcentaje NUMBER (22, 4)
);

DROP TABLE tmp_reparto_servicio;

CREATE TABLE tmp_reparto_servicio
(
	id NUMBER (10)
 ,contador NUMBER (10)
);

--Centros de consumos que están repartidos en más de un servicio
INSERT INTO tmp_reparto_servicio (id, contador)
		SELECT cc.id, COUNT (*)
			FROM rep_pro_siglo.org_centroconsumo@syg cc
					 INNER JOIN rep_pro_siglo.org_serviciocc@syg sc
						 ON sc.centroconsumo = cc.id
					 INNER JOIN rep_pro_siglo.org_servicio@syg s
						 ON s.id = sc.servicio AND s.estado = 'CONFIRMADO'
		 WHERE organica IN (SELECT id
													FROM rep_pro_siglo.org_organogestor@syg
												 WHERE plataforma = 17550)
					 AND sc.estado = 'CONFIRMADO'
	GROUP BY cc.id
		HAVING COUNT (*) > 1;

DROP TABLE tmp_reparto_ugc;

CREATE TABLE tmp_reparto_ugc
(
	id NUMBER (10)
 ,contador NUMBER (10)
);

	 --Centros de consumo que están repartidos den más de una UGC
INSERT INTO tmp_reparto_ugc (id, contador)
		SELECT cc.id, COUNT (*)
			FROM rep_pro_siglo.org_centroconsumo@syg cc, rep_pro_siglo.org_unidadgestionclinicacc@syg sc, rep_pro_siglo.org_unidadgestionclinica@syg u
		 WHERE		 sc.centroconsumo = cc.id
					 AND u.id = sc.unidadgestionclinica
					 AND u.estado = 'CONFIRMADO'
					 AND cc.organica IN (SELECT id
																 FROM rep_pro_siglo.org_organogestor@syg
																WHERE plataforma = 17550)
					 AND sc.estado = 'CONFIRMADO'
	GROUP BY cc.id
		HAVING COUNT (*) > 1;

DECLARE
	vid NUMBER (10);
	vidarticulo NUMBER (10);
	vgenericocentro VARCHAR (6);
	vcodigo VARCHAR (255);
	vcantidad NUMBER (22, 2);
	vimporte NUMBER (22, 6);
	vcentroconsumo VARCHAR (100);
	vdescentroconsumo VARCHAR (255);
	vfechamovimiento DATE;
	vcodigoaplicacion VARCHAR (255);
	vorganogestor NUMBER (10);
	vdescentro VARCHAR (255);
	vservicio VARCHAR (20);
	vdesservicio VARCHAR (255);
	vugc VARCHAR (20);
	vdesugc VARCHAR (255);
	vporcentaje NUMBER (22, 4);

	vcantidad1 NUMBER (22, 2);
	vimporte1 NUMBER (22, 6);

	vidcentroconsumo NUMBER (10);
	vidservicio NUMBER (10);
	vidugc NUMBER (10);

	var_plataforma NUMBER (10) := 17550;

	CURSOR c_consumos IS
			SELECT s.id
						,a.id
						,a.codigo
						,a.codclasific
						,s.cantidadsalida
						,s.importesalida
						,cc.id
						,cc.codigo
						,cc.nombre
						,s.fecha
						,ac.codigoconcatenado
						,o.id
						,o.descripcion
				FROM rep_pro_siglo.alm_salidaalmacen@syg s
						 INNER JOIN rep_pro_siglo.cat_articulo@syg a
							 ON a.id = s.articulo
						 INNER JOIN rep_pro_siglo.org_centroconsumo@syg cc
							 ON cc.id = s.centroconsumo
						 INNER JOIN rep_pro_siglo.org_organogestor@syg o
							 ON o.id = cc.organica AND o.plataforma = var_plataforma
						 INNER JOIN rep_pro_siglo.cat_articuloclasif@syg ac
							 ON (ac.articulo = a.id AND ac.defecto = 'T')
						 INNER JOIN rep_pro_siglo.cat_nivelvalor@syg n
							 ON (n.id = ac.nivelvalor AND n.clasificacion = 4)
			 WHERE (s.fecha <= ac.fechafinvalidez OR ac.fechafinvalidez IS NULL) AND (cc.id NOT IN (SELECT id FROM tmp_reparto_servicio) AND cc.id NOT IN (SELECT id FROM tmp_reparto_ugc))
		GROUP BY s.id
						,a.id
						,a.codigo
						,a.codclasific
						,s.cantidadsalida
						,s.importesalida
						,cc.id
						,cc.codigo
						,cc.nombre
						,s.fecha
						,ac.codigoconcatenado
						,o.id
						,o.descripcion;

	CURSOR c_consumos_servicio IS
			SELECT s.id
						,a.id
						,a.codigo
						,a.codclasific
						,s.cantidadsalida
						,s.importesalida
						,cc.id
						,cc.codigo
						,cc.nombre
						,s.fecha
						,ac.codigoconcatenado
						,o.id
						,o.descripcion
				FROM rep_pro_siglo.alm_salidaalmacen@syg s
						 INNER JOIN rep_pro_siglo.cat_articulo@syg a
							 ON a.id = s.articulo
						 INNER JOIN rep_pro_siglo.org_centroconsumo@syg cc
							 ON cc.id = s.centroconsumo
						 INNER JOIN rep_pro_siglo.org_organogestor@syg o
							 ON o.id = cc.organica AND o.plataforma = var_plataforma
						 INNER JOIN rep_pro_siglo.cat_articuloclasif@syg ac
							 ON (ac.articulo = a.id AND ac.defecto = 'T')
						 INNER JOIN rep_pro_siglo.cat_nivelvalor@syg n
							 ON (n.id = ac.nivelvalor AND n.clasificacion = 4)
			 WHERE (s.fecha <= ac.fechafinvalidez OR ac.fechafinvalidez IS NULL) AND cc.id IN (SELECT id FROM tmp_reparto_servicio)
		GROUP BY s.id
						,a.id
						,a.codigo
						,a.codclasific
						,s.cantidadsalida
						,s.importesalida
						,cc.id
						,cc.codigo
						,cc.nombre
						,s.fecha
						,ac.codigoconcatenado
						,o.id
						,o.descripcion;

	CURSOR c_consumos_ugc IS
			SELECT s.id
						,a.id
						,a.codigo
						,a.codclasific
						,s.cantidadsalida
						,s.importesalida
						,cc.id
						,cc.codigo
						,cc.nombre
						,s.fecha
						,ac.codigoconcatenado
						,o.id
						,o.descripcion
				FROM rep_pro_siglo.alm_salidaalmacen@syg s
						 INNER JOIN rep_pro_siglo.cat_articulo@syg a
							 ON a.id = s.articulo
						 INNER JOIN rep_pro_siglo.org_centroconsumo@syg cc
							 ON cc.id = s.centroconsumo
						 INNER JOIN rep_pro_siglo.org_organogestor@syg o
							 ON o.id = cc.organica AND o.plataforma = var_plataforma
						 INNER JOIN rep_pro_siglo.cat_articuloclasif@syg ac
							 ON (ac.articulo = a.id AND ac.defecto = 'T')
						 INNER JOIN rep_pro_siglo.cat_nivelvalor@syg n
							 ON (n.id = ac.nivelvalor AND n.clasificacion = 4)
			 WHERE (s.fecha <= ac.fechafinvalidez OR ac.fechafinvalidez IS NULL) AND cc.id IN (SELECT id FROM tmp_reparto_ugc)
		GROUP BY s.id
						,a.id
						,a.codigo
						,a.codclasific
						,s.cantidadsalida
						,s.importesalida
						,cc.id
						,cc.codigo
						,cc.nombre
						,s.fecha
						,ac.codigoconcatenado
						,o.id
						,o.descripcion;

	CURSOR c_servicio IS
		SELECT servicio, porcentaje
			FROM org_serviciocc
		 WHERE centroconsumo = vidcentroconsumo AND estado = 'CONFIRMADO';

	CURSOR c_ugc IS
		SELECT unidadgestionclinica, porcentaje
			FROM org_unidadgestionclinicacc
		 WHERE centroconsumo = vidcentroconsumo AND estado = 'CONFIRMADO';
BEGIN
	--Se calcula el consumo para los CC que se encuentran repartidos en más de un servicio
	OPEN c_consumos_servicio;
	LOOP
		FETCH c_consumos_servicio
		INTO vid
				,vidarticulo
				,vgenericocentro
				,vcodigo
				,vcantidad
				,vimporte
				,vidcentroconsumo
				,vcentroconsumo
				,vdescentroconsumo
				,vfechamovimiento
				,vcodigoaplicacion
				,vorganogestor
				,vdescentro;
		EXIT WHEN c_consumos_servicio%NOTFOUND;

		OPEN c_servicio;
		LOOP
			FETCH c_servicio
			INTO vidservicio, vporcentaje;
			EXIT WHEN c_servicio%NOTFOUND;

			BEGIN
				SELECT u.codigo, u.descripcion
					INTO vugc, vdesugc
					FROM org_unidadgestionclinica u INNER JOIN org_unidadgestionclinicasrv us ON us.unidadgestionclinica = u.id
				 WHERE us.servicio = vidservicio;
			EXCEPTION
				WHEN NO_DATA_FOUND THEN
					vugc := NULL;
					vdesugc := NULL;
			END;

			SELECT codigo, descripcion
				INTO vservicio, vdesservicio
				FROM org_servicio
			 WHERE id = vidservicio;

			vcantidad1 := (vcantidad * vporcentaje) / 100;
			vimporte1 := (vimporte * vporcentaje) / 100;

			INSERT INTO tmp_consumos (id
															 ,idarticulo
															 ,genericocentro
															 ,codigo
															 ,cantidad
															 ,importe
															 ,centroconsumo
															 ,descentroconsumo
															 ,fechamovimiento
															 ,codigoaplicacion
															 ,organogestor
															 ,descentro
															 ,servicio
															 ,desservicio
															 ,ugc
															 ,desugc
															 ,porcentaje)
					 VALUES (vid
									,vidarticulo
									,vgenericocentro
									,vcodigo
									,vcantidad1
									,vimporte1
									,vcentroconsumo
									,vdescentroconsumo
									,vfechamovimiento
									,vcodigoaplicacion
									,vorganogestor
									,vdescentro
									,vservicio
									,vdesservicio
									,vugc
									,vdesugc
									,vporcentaje);
		END LOOP;
		COMMIT;
		CLOSE c_servicio;
	END LOOP;
	CLOSE c_consumos_servicio;

	--Se calcula el consumo para los CC que se encuentran repartidos en más de una UGC
	OPEN c_consumos_ugc;
	LOOP
		FETCH c_consumos_ugc
		INTO vid
				,vidarticulo
				,vgenericocentro
				,vcodigo
				,vcantidad
				,vimporte
				,vidcentroconsumo
				,vcentroconsumo
				,vdescentroconsumo
				,vfechamovimiento
				,vcodigoaplicacion
				,vorganogestor
				,vdescentro;
		EXIT WHEN c_consumos_ugc%NOTFOUND;

		OPEN c_ugc;
		LOOP
			FETCH c_ugc
			INTO vidugc, vporcentaje;
			EXIT WHEN c_ugc%NOTFOUND;

			BEGIN
				SELECT s.codigo, s.descripcion
					INTO vservicio, vdesservicio
					FROM org_servicio s INNER JOIN org_unidadgestionclinicasrv us ON us.servicio = s.id
				 WHERE us.unidadgestionclinica = vidugc AND ROWNUM = 1;
			EXCEPTION
				WHEN NO_DATA_FOUND THEN
					vservicio := NULL;
					vdesservicio := NULL;
			END;

			SELECT codigo, descripcion
				INTO vugc, vdesugc
				FROM org_unidadgestionclinica
			 WHERE id = vidugc;

			vcantidad1 := (vcantidad * vporcentaje) / 100;
			vimporte1 := (vimporte * vporcentaje) / 100;

			INSERT INTO tmp_consumos (id
															 ,idarticulo
															 ,genericocentro
															 ,codigo
															 ,cantidad
															 ,importe
															 ,centroconsumo
															 ,descentroconsumo
															 ,fechamovimiento
															 ,codigoaplicacion
															 ,organogestor
															 ,descentro
															 ,servicio
															 ,desservicio
															 ,ugc
															 ,desugc
															 ,porcentaje)
					 VALUES (vid
									,vidarticulo
									,vgenericocentro
									,vcodigo
									,vcantidad1
									,vimporte1
									,vcentroconsumo
									,vdescentroconsumo
									,vfechamovimiento
									,vcodigoaplicacion
									,vorganogestor
									,vdescentro
									,vservicio
									,vdesservicio
									,vugc
									,vdesugc
									,vporcentaje);
		END LOOP;
		CLOSE c_ugc;
	END LOOP;
	COMMIT;
	CLOSE c_consumos_ugc;

	--Se calcula el consumo del resto de CC que no tienen ninguna repartición
	OPEN c_consumos;
	LOOP
		FETCH c_consumos
		INTO vid
				,vidarticulo
				,vgenericocentro
				,vcodigo
				,vcantidad
				,vimporte
				,vidcentroconsumo
				,vcentroconsumo
				,vdescentroconsumo
				,vfechamovimiento
				,vcodigoaplicacion
				,vorganogestor
				,vdescentro;
		EXIT WHEN c_consumos%NOTFOUND;

		BEGIN
			SELECT s.id
						,s.codigo
						,s.descripcion
						,rc.porcentaje
				INTO vidservicio
						,vservicio
						,vdesservicio
						,vporcentaje
				FROM org_servicio s INNER JOIN org_serviciocc rc ON rc.servicio = s.id AND rc.estado = 'CONFIRMADO'
			 WHERE rc.centroconsumo = vidcentroconsumo;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				vidservicio := NULL;
			WHEN TOO_MANY_ROWS THEN
				DBMS_OUTPUT.put_line ('Devuelve más de una servicio para el CC:' || TO_CHAR (vidcentroconsumo));
		END;

		BEGIN
			SELECT u.id
						,u.codigo
						,u.descripcion
						,rc.porcentaje
				INTO vidugc
						,vugc
						,vdesugc
						,vporcentaje
				FROM org_unidadgestionclinica u INNER JOIN org_unidadgestionclinicacc rc ON rc.unidadgestionclinica = u.id AND rc.estado = 'CONFIRMADO'
			 WHERE rc.centroconsumo = vidcentroconsumo;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				vidugc := NULL;
			WHEN TOO_MANY_ROWS THEN
				DBMS_OUTPUT.put_line ('Devuelve más de un UGC para el CC:' || TO_CHAR (vidcentroconsumo));
		END;

		IF ( (vidugc IS NULL) AND (vidservicio IS NULL)) THEN
			vugc := NULL;
			vdesugc := NULL;
			vservicio := NULL;
			vdesservicio := NULL;
			vporcentaje := 100;
		END IF;

		IF ( (vidugc IS NULL) AND (vidservicio IS NOT NULL)) THEN
			BEGIN
				SELECT u.codigo, u.descripcion
					INTO vugc, vdesugc
					FROM org_unidadgestionclinica u INNER JOIN org_unidadgestionclinicasrv ru ON ru.unidadgestionclinica = u.id AND ru.estado = 'CONFIRMADO'
				 WHERE ru.servicio = vidservicio;
			EXCEPTION
				WHEN NO_DATA_FOUND THEN
					vugc := NULL;
					vdesugc := NULL;
				WHEN TOO_MANY_ROWS THEN
					DBMS_OUTPUT.put_line ('Devuelve más de un UGC para el servicio:' || TO_CHAR (vidservicio));
			END;
		ELSIF ( (vidugc IS NOT NULL) AND (vidservicio IS NULL)) THEN
			BEGIN
				SELECT s.codigo, s.descripcion
					INTO vservicio, vdesservicio
					FROM org_servicio s INNER JOIN org_unidadgestionclinicasrv ru ON ru.servicio = s.id AND ru.estado = 'CONFIRMADO'
				 WHERE ru.unidadgestionclinica = vidugc;
			EXCEPTION
				WHEN NO_DATA_FOUND THEN
					vservicio := NULL;
					vdesservicio := NULL;
				WHEN TOO_MANY_ROWS THEN
					DBMS_OUTPUT.put_line ('Devuelve más de un servicio para el UGC:' || TO_CHAR (vidugc));
			END;
		END IF;

		INSERT INTO tmp_consumos (id
														 ,idarticulo
														 ,genericocentro
														 ,codigo
														 ,cantidad
														 ,importe
														 ,centroconsumo
														 ,descentroconsumo
														 ,fechamovimiento
														 ,codigoaplicacion
														 ,organogestor
														 ,descentro
														 ,servicio
														 ,desservicio
														 ,ugc
														 ,desugc
														 ,porcentaje)
				 VALUES (vid
								,vidarticulo
								,vgenericocentro
								,vcodigo
								,vcantidad
								,vimporte
								,vcentroconsumo
								,vdescentroconsumo
								,vfechamovimiento
								,vcodigoaplicacion
								,vorganogestor
								,vdescentro
								,vservicio
								,vdesservicio
								,vugc
								,vdesugc
								,vporcentaje);
	END LOOP;
	COMMIT;
	CLOSE c_consumos;
END;
/

SPOOL OFF;
SET FEEDBACK ON
SET HEADING ON

QUIT;