CREATE TABLE categoria(
	id INT PRIMARY KEY,
	tipo VARCHAR2(30)
);

CREATE TABLE empleado(
	id INT PRIMARY KEY,
	nombre VARCHAR2(64),
	dui CHAR(10),
	direccion VARCHAR2(150),
	salario NUMBER(5,2),
	id_categoria INT
);

CREATE TABLE proyecto(
	id INT PRIMARY KEY,
	nombre VARCHAR2(50),
	descripcion VARCHAR2(100),
	poblacion_objetivo VARCHAR2(50),
	id_coordinador INT
);

CREATE TABLE proyectoxempleado(
	id_proyecto INT,
	id_empleado INT
);

CREATE TABLE donacion(
	id INT PRIMARY KEY,
	fecha DATE,
	entidad_donadora VARCHAR2(50)
);

CREATE TABLE proyectoxdonacion(
	id_proyecto INT,
	id_donacion INT,
	cantidad FLOAT,
	fecha DATE
);

CREATE TABLE VOLUNTARIO(
	id INT PRIMARY KEY,
	nombre VARCHAR2(64),
	dirección VARCHAR2(150),
	telefono CHAR(9),
	entidad_origen VARCHAR2(50)
);

CREATE TABLE proyectoxvoluntario(
	id_proyecto INT,
	id_voluntario INT
);

CREATE TABLE actividad_asistente(
	id INT PRIMARY KEY,
	id_proyecto INT,
	id_empleado INT,
	descripcion VARCHAR2(100),
	confirmacion_coordinador INT DEFAULT 0
);
--------------------------------------------------------------------------
-- Relaciones 
--
ALTER TABLE empleado ADD FOREIGN KEY (id_categoria) REFERENCES categoria(id);
ALTER TABLE proyecto ADD FOREIGN KEY (id_coordinador) REFERENCES empleado(id);
ALTER TABLE proyectoxempleado ADD FOREIGN KEY (id_empleado) REFERENCES empleado(id);
ALTER TABLE proyectoxempleado ADD FOREIGN KEY (id_proyecto) REFERENCES proyecto(id);
ALTER TABLE proyectoxdonacion ADD FOREIGN KEY (id_proyecto) REFERENCES proyecto(id);
ALTER TABLE proyectoxdonacion ADD FOREIGN KEY (id_donacion) REFERENCES donacion(id);
ALTER TABLE proyectoxvoluntario ADD FOREIGN KEY (id_proyecto) REFERENCES proyecto(id);
ALTER TABLE proyectoxvoluntario ADD FOREIGN KEY (id_voluntario) REFERENCES voluntario(id);
ALTER TABLE actividad_asistente ADD FOREIGN KEY (id_proyecto) REFERENCES proyecto(id);
ALTER TABLE actividad_asistente ADD FOREIGN KEY (id_empleado) REFERENCES empleado(id);
--------------------------------------------------------------------------
-- DROP
--
DROP TABLE proyectoxdonacion;
DROP TABLE donacion;
DROP TABLE proyectoxvoluntario;
DROP TABLE voluntario;
DROP TABLE actividad_asistente;
DROP TABLE proyectoxempleado;
DROP TABLE proyecto;
DROP TABLE empleado;
DROP TABLE categoria;




