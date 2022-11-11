-- ****************************************************
-- * Bases de datos: ProyectoBDD&POO
-- * Autor: Grupo: los intergalacticos
-- * Version: 1.08
-- ****************************************************

-- Crear y seleccionar base de datos
CREATE DATABASE ProyectoBDD_POO;
USE ProyectoBDD_POO;
SET DATEFORMAT 'YMD'; --Ejecutar esta sentencia, si no, dara error las fechas

/*
 * 					Parte I
 * Crear estructura de la base de datos
 */

-- Crear tabla piso del area
CREATE TABLE PISO(
	id INT IDENTITY PRIMARY KEY,
	piso VARCHAR(10) NOT NULL
);

-- Crear tabla responsable
CREATE TABLE RESPONSABLE(
	id INT IDENTITY PRIMARY KEY,
	responsable VARCHAR(50) NOT NULL
);

-- Crear tabla Area
CREATE TABLE AREA(
	id INT IDENTITY PRIMARY KEY,
	nombre VARCHAR(50) NOT NULL,
	descripcion TEXT NOT NULL
		DEFAULT 'Sin Descripción',
	horario_publico TEXT NOT NULL,
	id_piso INT NOT NULL,
	id_responsable INT NOT NULL
);

-- Crear tabla Evento
CREATE TABLE EVENTO(
	id INT IDENTITY primary key,
	titulo VARCHAR(100) NOT NULL,
	imagen VARBINARY(max), 
	fecha_inicio DATETIME NOT NULL,
	fecha_finalizacion DATETIME NOT NULL,
	cantidad_asistentes INT NOT NULL
		CHECK (cantidad_asistentes > 0),
	id_area INT NOT NULL
);

-- Crear tabla objetivos del evento
CREATE TABLE OBJETIVO(
	id INT IDENTITY PRIMARY KEY,
	objetivo TEXT NOT NULL,
	id_evento INT NOT NULL
);

-- Crear tabla tipo de la coleccion
CREATE TABLE TIPO(
	id INT IDENTITY PRIMARY KEY,
	tipo VARCHAR(75) NOT NULL
);

-- Crear tabla genero de la coleccion
CREATE TABLE GENERO(
	id INT IDENTITY PRIMARY KEY,
	genero VARCHAR(70) NOT NULL UNIQUE
);

-- Crear tabla coleccion
CREATE TABLE COLECCION(
	id INT IDENTITY PRIMARY KEY,
	nombre VARCHAR(50) NOT NULL UNIQUE,
	id_tipo INT NOT NULL,
	id_genero INT NOT NULL
);

-- Crear tabla editorial
CREATE TABLE EDITORIAL(
	id INT IDENTITY PRIMARY KEY,
	editorial VARCHAR(50) NOT NULL
);

-- Crear tabla formato del ejemplar
CREATE TABLE FORMATO(
	id INT IDENTITY PRIMARY KEY,
	formato VARCHAR(50) NOT NULL UNIQUE
	    CHECK(formato IN ('Digital','Físico'))
);

-- Crear tabla idioma del ejemplar
CREATE TABLE IDIOMA(
	id INT IDENTITY PRIMARY KEY,
	idioma VARCHAR(50) NOT NULL UNIQUE
);

-- Crear tabla ejemplar
CREATE TABLE EJEMPLAR(
	id INT IDENTITY PRIMARY KEY,
	nombre VARCHAR(75) NOT NULL,
	imagen VARBINARY(max),
	isbn VARCHAR(20) NULL,
	issn VARCHAR(20) NULL,
	doi VARCHAR(20) NULL,
	fecha_publicacion DATE NOT NULL,
	id_editorial INT NOT NULL,
	id_formato INT NOT NULL,
	id_idioma INT NOT NULL,
	id_coleccion INT NOT NULL
);

-- Crear tabla autores
CREATE TABLE AUTOR(
	id INT IDENTITY PRIMARY KEY,
	autor VARCHAR(50) NOT NULL UNIQUE,
);

-- Crear tabla cruz entre autor y ejemplar
CREATE TABLE ESCRITURA(
	id_ejemplar INT NOT NULL,
	id_autor INT NOT NULL
);

-- Crear tabla palabras clave
CREATE TABLE PALABRA_CLAVE(
	id INT IDENTITY PRIMARY KEY,
	palabra VARCHAR(30) NOT NULL UNIQUE
);

-- Crear tabla cruz entre palabra y ejemplar
CREATE TABLE EJEMPLAR_X_PALABRA(
	id_ejemplar INT NOT NULL,
	id_palabra_clave INT NOT NULL
);

-- Crear tabla ocupacion del usuario
CREATE TABLE OCUPACION(
	id INT IDENTITY PRIMARY KEY,
	ocupacion VARCHAR(50) NOT NULL
);

-- Crear tabla institucion del usuario
CREATE TABLE INSTITUCION(
	id INT IDENTITY PRIMARY KEY,
	institucion VARCHAR(75) NOT NULL
);

-- Crear tabla usuario
CREATE TABLE USUARIO(
	codigo_QR VARCHAR(20) PRIMARY KEY,
	nombre VARCHAR(50) NOT NULL,
	direccion VARCHAR(50),
	telefono CHAR(10) NOT NULL UNIQUE
		CHECK(telefono LIKE '[6|7|2][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	fotografia VARBINARY(max),
	correo_electronico VARCHAR(30) UNIQUE
        CHECK(correo_electronico LIKE '%@%.%'),
	id_ocupacion INT NOT NULL DEFAULT 0,
	id_institucion INT NOT NULL DEFAULT 0,
);

-- Crear tabla cruz de reserva de ejemplares
CREATE TABLE RESERVA(
	id INT IDENTITY PRIMARY KEY,
	codigo_QR VARCHAR(20) NOT NULL,
	id_ejemplar INT NOT NULL,
	fecha_solicitud DATETIME NOT NULL,
	fecha_prestamo DATETIME NOT NULL,
	fecha_devolucion DATETIME NOT NULL
);

-- Crear tabla cruz de reserva de ejemplares
CREATE TABLE PRESTAMO(
	id INT IDENTITY PRIMARY KEY,
	codigo_QR VARCHAR(20) NOT NULL,
	id_ejemplar INT NOT NULL,
	fecha_prestamo DATETIME NOT NULL,
	fecha_devolucion DATETIME NOT NULL
);

-- Crear tabla entrada del usuario al area
CREATE TABLE ASISTENCIA(
	id INT IDENTITY PRIMARY KEY,
	id_area INT NOT NULL,
	codigo_QR VARCHAR(20) NOT NULL,
	fecha_hora_entrada DATETIME NOT NULL,
    fecha_hora_salida DATETIME NULL
);

CREATE TABLE USUARIO_LOGIN(
	id INT IDENTITY PRIMARY KEY,
	nombre VARCHAR(50) NOT NULL UNIQUE,
	contrasenia VARCHAR(50) NOT NULL,
)

/*
 * 					       Parte II
 * Crear restricciones de llaves primarias, foreaneas y check
 */

-- Creando llave foranea de Responsable en Area
ALTER TABLE AREA ADD CONSTRAINT fk_responsable_area FOREIGN KEY (id_responsable)
	REFERENCES RESPONSABLE(id)
	ON UPDATE CASCADE
	ON DELETE NO ACTION;
	
-- Creando llave foranea de piso en Area
ALTER TABLE AREA ADD CONSTRAINT fk_piso_area FOREIGN KEY (id_piso)
	REFERENCES PISO(id)
	ON UPDATE CASCADE
	ON DELETE NO ACTION;

-- Creando llave foranea de area hacia evento
ALTER TABLE EVENTO ADD CONSTRAINT fk_area_evento FOREIGN KEY (id_area)
	REFERENCES AREA(id)
	ON UPDATE CASCADE
	ON DELETE NO ACTION;

-- Creando llave foranea de evento hacia objetivo
ALTER TABLE OBJETIVO ADD CONSTRAINT fk_evento_objetivo FOREIGN KEY (id_evento)
	REFERENCES EVENTO(id) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE;

-- Creando llave foranea de tipo hacia coleccion
ALTER TABLE COLECCION ADD CONSTRAINT fk_tipo_coleccion FOREIGN KEY (id_tipo)
	REFERENCES TIPO(id)
	ON UPDATE CASCADE
	ON DELETE NO ACTION;
    
-- Creando llave foranea de genero hacia coleccion
ALTER TABLE COLECCION ADD CONSTRAINT fk_genero_coleccion FOREIGN KEY (id_genero)
	REFERENCES GENERO(id)
	ON UPDATE CASCADE
	ON DELETE NO ACTION;

-- Creando llave foranea de editorial hacia ejemplar
ALTER TABLE EJEMPLAR ADD CONSTRAINT fk_editorial_ejemplar FOREIGN KEY (id_editorial)
	REFERENCES EDITORIAL(id)
	ON UPDATE CASCADE
	ON DELETE NO ACTION;
    
-- Creando llave foranea de formato hacia ejemplar
ALTER TABLE EJEMPLAR ADD CONSTRAINT fk_formato_ejemplar FOREIGN KEY (id_formato)
	REFERENCES FORMATO(id)
	ON UPDATE CASCADE
	ON DELETE NO ACTION;

-- Creando llave foranea de idioma hacia ejemplar
ALTER TABLE EJEMPLAR ADD CONSTRAINT fk_idioma_ejemplar FOREIGN KEY (id_idioma)
	REFERENCES IDIOMA(id)
	ON UPDATE CASCADE
	ON DELETE NO ACTION;
    
-- Creando llave foranea de coleccion hacia ejemplar
ALTER TABLE EJEMPLAR ADD CONSTRAINT fk_coleccion_ejemplar FOREIGN KEY (id_coleccion)
	REFERENCES COLECCION(id)
	ON UPDATE CASCADE
	ON DELETE NO ACTION;

-- Creacion de llave primaria de tabla cruz y llaves foraneas 
ALTER TABLE ESCRITURA ADD CONSTRAINT pk_aut_ej PRIMARY KEY (id_autor, id_ejemplar);

ALTER TABLE ESCRITURA ADD CONSTRAINT fk_autor_extra FOREIGN KEY (id_autor)
	REFERENCES AUTOR(id)
	ON UPDATE CASCADE
	ON DELETE NO ACTION;

ALTER TABLE ESCRITURA ADD CONSTRAINT fk_ejemplar_extra FOREIGN KEY (id_ejemplar)
	REFERENCES EJEMPLAR(id)
	ON UPDATE CASCADE
	ON DELETE CASCADE;

-- Creacion de llave primaria de tabla cruz y llaves foraneas 
ALTER TABLE EJEMPLAR_X_PALABRA ADD CONSTRAINT pk_palabra_ej PRIMARY KEY (id_palabra_clave, id_ejemplar);

ALTER TABLE EJEMPLAR_X_PALABRA ADD CONSTRAINT fk_palabra_tablacruz FOREIGN KEY (id_palabra_clave)
	REFERENCES PALABRA_CLAVE(id)
	ON UPDATE CASCADE
	ON DELETE NO ACTION;

ALTER TABLE EJEMPLAR_X_PALABRA ADD CONSTRAINT fk_ejemplar_tablacruz FOREIGN KEY (id_ejemplar)
	REFERENCES EJEMPLAR(id)
	ON UPDATE CASCADE
	ON DELETE CASCADE;

-- Creando llave foranea de ejemplar hacia usuario
ALTER TABLE USUARIO ADD CONSTRAINT fk_ocupacion_usr FOREIGN KEY (id_ocupacion)
	REFERENCES OCUPACION(id)
	ON UPDATE CASCADE
	ON DELETE SET DEFAULT;

-- Creando llave foranea de institucion hacia usuario
ALTER TABLE USUARIO ADD CONSTRAINT fk_ins_usr FOREIGN KEY (id_institucion)
	REFERENCES INSTITUCION(id)
	ON UPDATE CASCADE
	ON DELETE SET DEFAULT;

-- Creacion de llaves foraneas hacia tabla extra salida
ALTER TABLE RESERVA ADD CONSTRAINT fk_usuario_reserva FOREIGN KEY (codigo_QR)
	REFERENCES USUARIO(codigo_QR)
	ON UPDATE CASCADE
	ON DELETE NO ACTION;

ALTER TABLE RESERVA ADD CONSTRAINT fk_ejemplar_reserva FOREIGN KEY (id_ejemplar)
	REFERENCES EJEMPLAR(id)
	ON UPDATE CASCADE
	ON DELETE NO ACTION;

-- Creacion de llaves foraneas hacia tabla extra salida
ALTER TABLE PRESTAMO ADD CONSTRAINT fk_usuario_prestamo FOREIGN KEY (codigo_QR)
	REFERENCES USUARIO(codigo_QR)
	ON UPDATE CASCADE
	ON DELETE NO ACTION;

ALTER TABLE PRESTAMO ADD CONSTRAINT fk_ejemplar_prestamo FOREIGN KEY (id_ejemplar)
	REFERENCES EJEMPLAR(id)
	ON UPDATE CASCADE
	ON DELETE NO ACTION;

-- Creacion de llaves foraneas hacia tabla extra asistencia
ALTER TABLE ASISTENCIA ADD CONSTRAINT fk_usuario_asist FOREIGN KEY (codigo_QR)
	REFERENCES USUARIO(codigo_QR)
	ON UPDATE CASCADE
	ON DELETE NO ACTION;

ALTER TABLE ASISTENCIA ADD CONSTRAINT fk_area_asist FOREIGN KEY (id_area)
	REFERENCES AREA(id)
	ON UPDATE CASCADE
	ON DELETE NO ACTION;

/*
 * 					Parte III
 * Insertar Datos dentro de la base de datos
 */

SET IDENTITY_INSERT OCUPACION ON ;
    INSERT INTO OCUPACION (id, ocupacion) VALUES (0, 'Sin Ocupación');
SET IDENTITY_INSERT OCUPACION OFF;

SET IDENTITY_INSERT INSTITUCION ON ;
    INSERT INTO INSTITUCION (id, institucion) VALUES (0, 'Sin Institución');
SET IDENTITY_INSERT INSTITUCION OFF;

INSERT INTO USUARIO_LOGIN (nombre, contrasenia) VALUES ('Binaes', 'f688ae26e9cfa3ba6235477831d5122e');

INSERT INTO RESPONSABLE (responsable) VALUES ('Waldo Petrushka');
INSERT INTO RESPONSABLE (responsable) VALUES ('Ivie Scaddon');
INSERT INTO RESPONSABLE (responsable) VALUES ('Kessiah Kleinberer');
INSERT INTO RESPONSABLE (responsable) VALUES ('Twyla Lowdeane');
INSERT INTO RESPONSABLE (responsable) VALUES ('Lou Hughesdon');
INSERT INTO RESPONSABLE (responsable) VALUES ('Ly Southall');
INSERT INTO RESPONSABLE (responsable) VALUES ('Pembroke Cranstoun');
INSERT INTO RESPONSABLE (responsable) VALUES ('Mikol Skirrow');
INSERT INTO RESPONSABLE (responsable) VALUES ('Viv Dix');
INSERT INTO RESPONSABLE (responsable) VALUES ('Domenico Barcroft');
INSERT INTO RESPONSABLE (responsable) VALUES ('Hildy Waslin');
INSERT INTO RESPONSABLE (responsable) VALUES ('Brit Ethelstone');
INSERT INTO RESPONSABLE (responsable) VALUES ('Conny Phizackerly');
INSERT INTO RESPONSABLE (responsable) VALUES ('Jessie Edgeler');
INSERT INTO RESPONSABLE (responsable) VALUES ('Pandora Dighton');
INSERT INTO RESPONSABLE (responsable) VALUES ('Caritta Ardron');
INSERT INTO RESPONSABLE (responsable) VALUES ('Christoper Baddeley');
INSERT INTO RESPONSABLE (responsable) VALUES ('Lee Venable');
INSERT INTO RESPONSABLE (responsable) VALUES ('Clayton Penrith');
INSERT INTO RESPONSABLE (responsable) VALUES ('Aube Pinke');
INSERT INTO RESPONSABLE (responsable) VALUES ('Wilhelm Cowthart');
INSERT INTO RESPONSABLE (responsable) VALUES ('Marigold MacCrachen');
INSERT INTO RESPONSABLE (responsable) VALUES ('Cherie Chamberlayne');
INSERT INTO RESPONSABLE (responsable) VALUES ('Tracy Swidenbank');
INSERT INTO RESPONSABLE (responsable) VALUES ('Joey Stilgoe');
INSERT INTO RESPONSABLE (responsable) VALUES ('Gretchen Inglish');
INSERT INTO RESPONSABLE (responsable) VALUES ('Vivyan Vamplus');
INSERT INTO RESPONSABLE (responsable) VALUES ('Normy Milkin');
INSERT INTO RESPONSABLE (responsable) VALUES ('Chrissy Fihelly');
INSERT INTO RESPONSABLE (responsable) VALUES ('Rebe Barlee');
INSERT INTO RESPONSABLE (responsable) VALUES ('Theodor Faltin');
INSERT INTO RESPONSABLE (responsable) VALUES ('Leonardo Divisek');
INSERT INTO RESPONSABLE (responsable) VALUES ('Lotta Carley');
INSERT INTO RESPONSABLE (responsable) VALUES ('Carolus Storer');
INSERT INTO RESPONSABLE (responsable) VALUES ('Bailie Sherel');
INSERT INTO RESPONSABLE (responsable) VALUES ('Heidie Bodle');
INSERT INTO RESPONSABLE (responsable) VALUES ('Norrie Kelberer');
INSERT INTO RESPONSABLE (responsable) VALUES ('Che Schinetti');
INSERT INTO RESPONSABLE (responsable) VALUES ('Tobe Pedder');
INSERT INTO RESPONSABLE (responsable) VALUES ('Ilario Olive');
INSERT INTO RESPONSABLE (responsable) VALUES ('Jarrid Vasyuchov');
INSERT INTO RESPONSABLE (responsable) VALUES ('Carolynn Dyett');
INSERT INTO RESPONSABLE (responsable) VALUES ('Win Conant');
INSERT INTO RESPONSABLE (responsable) VALUES ('Odo Fidgeon');
INSERT INTO RESPONSABLE (responsable) VALUES ('Jobyna Dimeloe');
INSERT INTO RESPONSABLE (responsable) VALUES ('Maggie Leggan');
INSERT INTO RESPONSABLE (responsable) VALUES ('Neill Ouldred');
INSERT INTO RESPONSABLE (responsable) VALUES ('Ella Sacaze');
INSERT INTO RESPONSABLE (responsable) VALUES ('Claudie Fairholm');
INSERT INTO RESPONSABLE (responsable) VALUES ('Joel Redgewell');

INSERT INTO PISO (piso) VALUES ('Piso 1');
INSERT INTO PISO (piso) VALUES ('Piso 2');
INSERT INTO PISO (piso) VALUES ('Piso 3');
INSERT INTO PISO (piso) VALUES ('Piso 4');

-- Insertar datos dentro de area
INSERT INTO AREA (nombre, descripcion, horario_publico, id_piso, id_responsable) VALUES ('Salones lúdicos [Piso 1]', 'Nam ultrices, libero non mattis pulvinar, a pede ullamcorper augue, a suscipit a elit ac a. Sed vel enim sit amet nunc viverra dapibus. a suscipit ligula in lacus.', '07:00 - 18:00', 1, 1);
INSERT INTO AREA (nombre, descripcion, horario_publico, id_piso, id_responsable) VALUES ('Salones lúdicos [Piso 2]', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel a eget eros elementum pellentesque.', '07:00 - 18:00', 2, 2);
INSERT INTO AREA (nombre, descripcion, horario_publico, id_piso, id_responsable) VALUES ('Auditórium', 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', '07:00 - 18:00', 1, 3);
INSERT INTO AREA (nombre, descripcion, horario_publico, id_piso, id_responsable) VALUES ('Sala de proyección [Piso 2]', 'In congue. Etiam justo. Etiam pretium iaculis justo.', '07:00 - 18:00', 2, 4);
INSERT INTO AREA (nombre, descripcion, horario_publico, id_piso, id_responsable) VALUES ('Sala de proyección [Piso 3]', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. am orci pede, venenatis non, sodales sed, tincidunt eu, felis.', '07:00 - 18:00', 3, 5);
INSERT INTO AREA (nombre, descripcion, horario_publico, id_piso, id_responsable) VALUES ('Sala de proyección [Piso 4]', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. a justo.', '07:00 - 18:00', 4, 6);
INSERT INTO AREA (nombre, descripcion, horario_publico, id_piso, id_responsable) VALUES ('Área de computación [Sala 1][Piso 1]', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. am orci pede, venenatis non, sodales sed, tincidunt eu, felis.', '07:00 - 18:00', 1, 7);
INSERT INTO AREA (nombre, descripcion, horario_publico, id_piso, id_responsable) VALUES ('Área de computación [Sala 2][Piso 1]', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', '07:00 - 18:00', 1, 8);
INSERT INTO AREA (nombre, descripcion, horario_publico, id_piso, id_responsable) VALUES ('Área de computación [Sala 1][Piso 2]', 'am porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', '07:00 - 18:00', 2, 9);
INSERT INTO AREA (nombre, descripcion, horario_publico, id_piso, id_responsable) VALUES ('Área de computación [Sala 2][Piso 2]', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; a dapibus dolor vel est. feugiat et, eros.', '00:00 - 23:59', 2, 10);
INSERT INTO AREA (nombre, descripcion, horario_publico, id_piso, id_responsable) VALUES ('Área de computación [Sala 1][Piso 3]', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. a justo.', '00:00 - 23:59', 3, 11);
INSERT INTO AREA (nombre, descripcion, horario_publico, id_piso, id_responsable) VALUES ('Área de computación [Sala 2][Piso 3]', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', '00:00 - 23:59', 3, 12);
INSERT INTO AREA (nombre, descripcion, horario_publico, id_piso, id_responsable) VALUES ('Área de computación [Sala 1][Piso 4]', 'In congue. Etiam justo. Etiam pretium iaculis justo.', '00:00 - 23:59', 4, 13);
INSERT INTO AREA (nombre, descripcion, horario_publico, id_piso, id_responsable) VALUES ('Área de computación [Sala 2][Piso 4]', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum alij.', '00:00 - 23:59', 4, 14);
INSERT INTO AREA (nombre, descripcion, horario_publico, id_piso, id_responsable) VALUES ('Área de promoción de inclusión [Sala 1][Piso 1]', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', '07:00 - 14:00', 1, 15);
INSERT INTO AREA (nombre, descripcion, horario_publico, id_piso, id_responsable) VALUES ('Área de promoción de inclusión [Sala 2][Piso 1]', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel a eget eros elementum pellentesque.', '07:00 - 14:00', 1, 16);
INSERT INTO AREA (nombre, descripcion, horario_publico, id_piso, id_responsable) VALUES ('Sala de investigación [Sala 1][Piso 4]', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', '00:00 - 23:59', 4, 17);
INSERT INTO AREA (nombre, descripcion, horario_publico, id_piso, id_responsable) VALUES ('Sala de investigación [Sala 2][Piso 4]', 'am porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', '00:00 - 23:59', 4, 18);
INSERT INTO AREA (nombre, descripcion, horario_publico, id_piso, id_responsable) VALUES ('Área de biblioteca [Sala 1][Piso 1]', 'Duis bibendum. Morbi non quam nec dui luctus rutrum. a tellus.', '00:00 - 23:59', 1, 19);
INSERT INTO AREA (nombre, descripcion, horario_publico, id_piso, id_responsable) VALUES ('Área de biblioteca [Sala 2][Piso 1]', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', '00:00 - 23:59', 1, 20);
INSERT INTO AREA (nombre, descripcion, horario_publico, id_piso, id_responsable) VALUES ('Área de biblioteca [Sala 1][Piso 2]', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', '00:00 - 23:59', 2, 21);
INSERT INTO AREA (nombre, descripcion, horario_publico, id_piso, id_responsable) VALUES ('Área de biblioteca [Sala 2][Piso 2]', 'Praesent blandit. Nam a. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', '00:00 - 23:59', 2, 22);
INSERT INTO AREA (nombre, descripcion, horario_publico, id_piso, id_responsable) VALUES ('Área de biblioteca [Sala 1][Piso 3]', 'am porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', '00:00 - 23:59', 3, 23);
INSERT INTO AREA (nombre, descripcion, horario_publico, id_piso, id_responsable) VALUES ('Área de biblioteca [Sala 2][Piso 3]', 'Praesent blandit. Nam a. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', '00:00 - 23:59', 3, 24);
INSERT INTO AREA (nombre, descripcion, horario_publico, id_piso, id_responsable) VALUES ('Área de biblioteca [Sala 1][Piso 4]', 'Praesent blandit. Nam a. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', '00:00 - 23:59', 4, 25);
INSERT INTO AREA (nombre, descripcion, horario_publico, id_piso, id_responsable) VALUES ('Área de biblioteca [Sala 1][Piso 4]', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', '00:00 - 23:59', 4, 26);

INSERT INTO EVENTO (titulo, imagen, fecha_inicio, fecha_finalizacion, cantidad_asistentes, id_area) VALUES ('Zaam-Dox', null, '2021-11-13 18:20:36', '2021-11-13 21:04:36', 175, 6);
INSERT INTO EVENTO (titulo, imagen, fecha_inicio, fecha_finalizacion, cantidad_asistentes, id_area) VALUES ('Prodder', null, '2022-04-01 19:35:44', '2022-04-01 21:30:44', 36, 4);
INSERT INTO EVENTO (titulo, imagen, fecha_inicio, fecha_finalizacion, cantidad_asistentes, id_area) VALUES ('Voyatouch', null, '2022-01-16 03:12:12', '2022-01-16 05:12:12', 148, 2);
INSERT INTO EVENTO (titulo, imagen, fecha_inicio, fecha_finalizacion, cantidad_asistentes, id_area) VALUES ('Cardguard', null, '2021-08-16 01:53:34', '2021-08-16 04:16:34', 29, 5);
INSERT INTO EVENTO (titulo, imagen, fecha_inicio, fecha_finalizacion, cantidad_asistentes, id_area) VALUES ('Ventosanzap', null, '2021-12-13 19:58:04', '2021-12-13 21:35:04', 194, 6);
INSERT INTO EVENTO (titulo, imagen, fecha_inicio, fecha_finalizacion, cantidad_asistentes, id_area) VALUES ('Flexidy', null, '2021-08-11 17:29:05', '2021-08-11 19:36:05', 38, 4);
INSERT INTO EVENTO (titulo, imagen, fecha_inicio, fecha_finalizacion, cantidad_asistentes, id_area) VALUES ('Zaam-Dox', null, '2021-09-04 15:36:27', '2021-09-04 17:34:27', 40, 2);
INSERT INTO EVENTO (titulo, imagen, fecha_inicio, fecha_finalizacion, cantidad_asistentes, id_area) VALUES ('Zamit', null, '2022-03-10 20:51:05', '2022-03-10 23:23:05', 169, 7);
INSERT INTO EVENTO (titulo, imagen, fecha_inicio, fecha_finalizacion, cantidad_asistentes, id_area) VALUES ('FINTOne', null, '2021-11-01 22:31:33', '2021-11-02 01:21:33', 115, 2);
INSERT INTO EVENTO (titulo, imagen, fecha_inicio, fecha_finalizacion, cantidad_asistentes, id_area) VALUES ('Alphazap', null, '2022-01-28 04:50:50', '2022-01-28 07:17:50', 195, 7);
INSERT INTO EVENTO (titulo, imagen, fecha_inicio, fecha_finalizacion, cantidad_asistentes, id_area) VALUES ('Alpha', null, '2021-12-13 15:38:16', '2021-12-13 17:08:16', 172, 3);
INSERT INTO EVENTO (titulo, imagen, fecha_inicio, fecha_finalizacion, cantidad_asistentes, id_area) VALUES ('Tresom', null, '2021-08-12 04:45:27', '2021-08-12 06:29:27', 158, 2);
INSERT INTO EVENTO (titulo, imagen, fecha_inicio, fecha_finalizacion, cantidad_asistentes, id_area) VALUES ('Wrapsafe', null, '2021-12-18 18:02:52', '2021-12-18 20:49:52', 188, 7);
INSERT INTO EVENTO (titulo, imagen, fecha_inicio, fecha_finalizacion, cantidad_asistentes, id_area) VALUES ('Hatity', null, '2021-12-17 12:47:51', '2021-12-17 15:19:51', 179, 1);
INSERT INTO EVENTO (titulo, imagen, fecha_inicio, fecha_finalizacion, cantidad_asistentes, id_area) VALUES ('Y-Solowarm', null, '2022-03-11 19:06:04', '2022-03-11 21:42:04', 38, 1);
INSERT INTO EVENTO (titulo, imagen, fecha_inicio, fecha_finalizacion, cantidad_asistentes, id_area) VALUES ('Konklux', null, '2021-05-24 23:55:28', '2021-05-25 01:35:28', 71, 5);
INSERT INTO EVENTO (titulo, imagen, fecha_inicio, fecha_finalizacion, cantidad_asistentes, id_area) VALUES ('Tres-Zap', null, '2021-11-09 07:43:26', '2021-11-09 10:30:26', 166, 4);
INSERT INTO EVENTO (titulo, imagen, fecha_inicio, fecha_finalizacion, cantidad_asistentes, id_area) VALUES ('Span', null, '2021-11-02 10:07:41', '2021-11-02 12:19:41', 129, 1);
INSERT INTO EVENTO (titulo, imagen, fecha_inicio, fecha_finalizacion, cantidad_asistentes, id_area) VALUES ('Span', null, '2021-11-18 19:40:24', '2021-11-18 21:36:24', 49, 4);
INSERT INTO EVENTO (titulo, imagen, fecha_inicio, fecha_finalizacion, cantidad_asistentes, id_area) VALUES ('Toughjoyfax', null, '2022-03-04 04:31:05', '2022-03-04 06:09:05', 105, 5);
INSERT INTO EVENTO (titulo, imagen, fecha_inicio, fecha_finalizacion, cantidad_asistentes, id_area) VALUES ('Fix San', null, '2021-10-16 22:55:20', '2021-10-17 01:30:20', 57, 5);
INSERT INTO EVENTO (titulo, imagen, fecha_inicio, fecha_finalizacion, cantidad_asistentes, id_area) VALUES ('Bamity', null, '2022-05-11 02:45:21', '2022-05-11 04:31:21', 114, 2);
INSERT INTO EVENTO (titulo, imagen, fecha_inicio, fecha_finalizacion, cantidad_asistentes, id_area) VALUES ('Transcof', null, '2021-11-19 06:15:59', '2021-11-19 08:46:59', 96, 7);
INSERT INTO EVENTO (titulo, imagen, fecha_inicio, fecha_finalizacion, cantidad_asistentes, id_area) VALUES ('Job', null, '2022-01-05 16:06:03', '2022-01-05 18:25:03', 154, 1);
INSERT INTO EVENTO (titulo, imagen, fecha_inicio, fecha_finalizacion, cantidad_asistentes, id_area) VALUES ('Redhold', null, '2022-05-07 05:24:46', '2022-05-07 07:39:46', 151, 7);
INSERT INTO EVENTO (titulo, imagen, fecha_inicio, fecha_finalizacion, cantidad_asistentes, id_area) VALUES ('Bigtax', null, '2021-11-22 15:22:28', '2021-11-22 17:13:28', 138, 6);
INSERT INTO EVENTO (titulo, imagen, fecha_inicio, fecha_finalizacion, cantidad_asistentes, id_area) VALUES ('Zoolab', null, '2021-07-21 02:04:35', '2021-07-21 03:41:35', 46, 4);
INSERT INTO EVENTO (titulo, imagen, fecha_inicio, fecha_finalizacion, cantidad_asistentes, id_area) VALUES ('Bitwolf', null, '2021-12-04 16:57:57', '2021-12-04 19:39:57', 118, 4);
INSERT INTO EVENTO (titulo, imagen, fecha_inicio, fecha_finalizacion, cantidad_asistentes, id_area) VALUES ('Lotlux', null, '2021-11-15 09:50:06', '2021-11-15 12:45:06', 58, 1);
INSERT INTO EVENTO (titulo, imagen, fecha_inicio, fecha_finalizacion, cantidad_asistentes, id_area) VALUES ('Daltfresh', null, '2022-01-04 09:36:20', '2022-01-04 11:20:20', 181, 4);

INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('turpis sed ante vivamus tortor duis mattis egestas metus', 1);
INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('nisi at nibh in hac habitasse platea dictumst aliquam', 2);
INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('ac tellus semper interdum mauris ullamcorper purus sit amet', 3);
INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('justo in hac habitasse platea dictumst', 4);
INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('in eleifend quam a odio in hac habitasse platea dictumst', 5);
INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('congue risus semper porta volutpat quam pede lobortis ligula sit', 6);
INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('at ipsum ac tellus semper interdum mauris ullamcorper purus sit', 7);
INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('vel nulla eget eros elementum pellentesque quisque', 8);
INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('curabitur convallis duis consequat dui nec nisi volutpat eleifend donec', 9);
INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('proin at turpis a pede posuere nonummy integer non', 10);
INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('neque vestibulum eget vulputate ut ultrices', 11);
INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('ridiculus mus vivamus vestibulum sagittis sapien cum sociis', 12);
INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('cras mi pede malesuada in imperdiet et commodo vulputate', 13);
INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('et ultrices posuere cubilia curae nulla dapibus', 14);
INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('nulla nisl nunc nisl duis bibendum felis', 15);
INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('ac neque duis bibendum morbi non quam nec', 16);
INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('pellentesque quisque porta volutpat erat quisque erat eros viverra eget', 17);
INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('duis bibendum felis sed interdum venenatis', 18);
INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('orci luctus et ultrices posuere cubilia', 19);
INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('ultrices enim lorem ipsum dolor sit', 20);
INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('tristique fusce congue diam id ornare imperdiet sapien', 21);
INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('sapien placerat ante nulla justo aliquam quis turpis eget elit', 22);
INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('morbi sem mauris laoreet ut', 23);
INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('ante ipsum primis in faucibus orci', 24);
INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('sem fusce consequat nulla nisl', 25);
INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('libero nullam sit amet turpis elementum ligula vehicula consequat morbi', 26);
INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('duis faucibus accumsan odio curabitur convallis duis consequat dui', 27);
INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('neque aenean auctor gravida sem praesent id massa', 28);
INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('id justo sit amet sapien dignissim vestibulum vestibulum ante', 29);
INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('id sapien in sapien iaculis congue vivamus metus', 30);
INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('congue vivamus metus arcu adipiscing molestie hendrerit at', 1);
INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('et eros vestibulum ac est lacinia nisi venenatis tristique', 2);
INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('pretium iaculis diam erat fermentum', 3);
INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('nisi nam ultrices libero non mattis', 4);
INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('lectus pellentesque eget nunc donec quis', 5);
INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('cras non velit nec nisi vulputate nonummy maecenas tincidunt lacus', 6);
INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('lectus suspendisse potenti in eleifend quam', 7);
INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('metus aenean fermentum donec ut mauris eget massa tempor convallis', 8);
INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('platea dictumst morbi vestibulum velit', 9);
INSERT INTO OBJETIVO (objetivo, id_evento) VALUES ('sit amet turpis elementum ligula vehicula consequat morbi', 10);

-- Insertar datos dentro del tipo de coleccion
INSERT INTO TIPO (tipo) VALUES ('Libros');
INSERT INTO TIPO (tipo) VALUES ('Revistas');
INSERT INTO TIPO (tipo) VALUES ('Periódicos');
INSERT INTO TIPO (tipo) VALUES ('Memorias');
INSERT INTO TIPO (tipo) VALUES ('Albumes');
INSERT INTO TIPO (tipo) VALUES ('Tesis');
INSERT INTO TIPO (tipo) VALUES ('Audio');
INSERT INTO TIPO (tipo) VALUES ('Video');

-- Insertar datos dentro del genero de la coleccion
INSERT INTO GENERO (genero) VALUES ('Especiales');
INSERT INTO GENERO (genero) VALUES ('Referencia');
INSERT INTO GENERO (genero) VALUES ('Asuntos publicos');
INSERT INTO GENERO (genero) VALUES ('Multimedia');

-- Insertar datos dentro de coleccion
INSERT INTO COLECCION (nombre, id_tipo, id_genero) VALUES ('Salvadoreña', 1, 2);
INSERT INTO COLECCION (nombre, id_tipo, id_genero) VALUES ('Reserva', 1, 3);
INSERT INTO COLECCION (nombre, id_tipo, id_genero) VALUES ('Compañía de Jesús', 8, 1);
INSERT INTO COLECCION (nombre, id_tipo, id_genero) VALUES ('Biblioteca de Música', 7, 4);

INSERT INTO EDITORIAL (editorial) VALUES ('Yambee');
INSERT INTO EDITORIAL (editorial) VALUES ('Buzzshare');
INSERT INTO EDITORIAL (editorial) VALUES ('Rhycero');
INSERT INTO EDITORIAL (editorial) VALUES ('Flipbug');
INSERT INTO EDITORIAL (editorial) VALUES ('Mita');
INSERT INTO EDITORIAL (editorial) VALUES ('Trunyx');
INSERT INTO EDITORIAL (editorial) VALUES ('Einti');
INSERT INTO EDITORIAL (editorial) VALUES ('Edgepulse');
INSERT INTO EDITORIAL (editorial) VALUES ('Browsebug');
INSERT INTO EDITORIAL (editorial) VALUES ('Thoughtstorm');
INSERT INTO EDITORIAL (editorial) VALUES ('Quatz');
INSERT INTO EDITORIAL (editorial) VALUES ('Jabbersphere');
INSERT INTO EDITORIAL (editorial) VALUES ('Topiczoom');
INSERT INTO EDITORIAL (editorial) VALUES ('Feedfish');
INSERT INTO EDITORIAL (editorial) VALUES ('Vinder');

-- Insertar datos dentro del formato del ejemplar
INSERT INTO FORMATO (formato) VALUES ('Digital');
INSERT INTO FORMATO (formato) VALUES ('Físico');
  
-- Insertar datos dentro del idioma del ejemplar
INSERT INTO IDIOMA (idioma) VALUES ('Español');
INSERT INTO IDIOMA (idioma) VALUES ('Ingles');
INSERT INTO IDIOMA (idioma) VALUES ('Frances');
INSERT INTO IDIOMA (idioma) VALUES ('Italiano');
INSERT INTO IDIOMA (idioma) VALUES ('Ruso');

INSERT INTO EJEMPLAR (nombre, imagen, isbn, issn, doi, fecha_publicacion, id_editorial, id_formato, id_idioma, id_coleccion) VALUES ('Todo se desmorona', NULL, NULL, '201696217-8', NULL, '2020/9/25', 2, 2, 3, 1);
INSERT INTO EJEMPLAR (nombre, imagen, isbn, issn, doi, fecha_publicacion, id_editorial, id_formato, id_idioma, id_coleccion) VALUES ('El extranjero', NULL, '304335514-8', '005971381-X', NULL, '2012/8/23', 14, 1, 5, 2);
INSERT INTO EJEMPLAR (nombre, imagen, isbn, issn, doi, fecha_publicacion, id_editorial, id_formato, id_idioma, id_coleccion) VALUES ('Los hermanos Karamazov', NULL, '071069428-8', NULL, '048965397-9', '2012/5/22', 3, 2, 5, 3);
INSERT INTO EJEMPLAR (nombre, imagen, isbn, issn, doi, fecha_publicacion, id_editorial, id_formato, id_idioma, id_coleccion) VALUES ('Odisea', NULL, NULL, '873921131-2', NULL, '2015/5/4', 14, 1, 1, 4);
INSERT INTO EJEMPLAR (nombre, imagen, isbn, issn, doi, fecha_publicacion, id_editorial, id_formato, id_idioma, id_coleccion) VALUES ('Gente independiente', NULL, NULL, '451011995-X', NULL, '2013/4/28', 6, 1, 2, 2);
INSERT INTO EJEMPLAR (nombre, imagen, isbn, issn, doi, fecha_publicacion, id_editorial, id_formato, id_idioma, id_coleccion) VALUES ('El hombre sin atributos', NULL, NULL, NULL, '324447962-6', '2008/6/10', 1, 1, 4, 3);
INSERT INTO EJEMPLAR (nombre, imagen, isbn, issn, doi, fecha_publicacion, id_editorial, id_formato, id_idioma, id_coleccion) VALUES ('Hijos de la medianoche', NULL, NULL, '816105667-6', NULL, '2019/1/21', 9, 1, 5, 4);
INSERT INTO EJEMPLAR (nombre, imagen, isbn, issn, doi, fecha_publicacion, id_editorial, id_formato, id_idioma, id_coleccion) VALUES ('Edipo rey', NULL, '006915298-5', NULL, NULL, '2012/10/29', 3, 2, 2, 2);
INSERT INTO EJEMPLAR (nombre, imagen, isbn, issn, doi, fecha_publicacion, id_editorial, id_formato, id_idioma, id_coleccion) VALUES ('Guerra y paz', NULL, '759133095-0', NULL, '832579142-X', '2012/5/15', 11, 1, 4, 2);
INSERT INTO EJEMPLAR (nombre, imagen, isbn, issn, doi, fecha_publicacion, id_editorial, id_formato, id_idioma, id_coleccion) VALUES ('Ramayana', NULL, NULL, '013565877-2', '815274142-6', '2014/9/6', 5, 1, 3, 3);
INSERT INTO EJEMPLAR (nombre, imagen, isbn, issn, doi, fecha_publicacion, id_editorial, id_formato, id_idioma, id_coleccion) VALUES ('Memorias de Adriano', NULL, '251674696-2', NULL, '752726202-8', '2009/2/22', 7, 1, 2, 4);
INSERT INTO EJEMPLAR (nombre, imagen, isbn, issn, doi, fecha_publicacion, id_editorial, id_formato, id_idioma, id_coleccion) VALUES ('En busca del tiempo perdido', NULL, NULL, '095783575-2', '124959435-9', '2008/9/12', 12, 1, 5, 2);
INSERT INTO EJEMPLAR (nombre, imagen, isbn, issn, doi, fecha_publicacion, id_editorial, id_formato, id_idioma, id_coleccion) VALUES ('Cuentos', NULL, NULL, '794536850-6', NULL, '2020/3/31', 7, 2, 2, 3);
INSERT INTO EJEMPLAR (nombre, imagen, isbn, issn, doi, fecha_publicacion, id_editorial, id_formato, id_idioma, id_coleccion) VALUES ('La conciencia de Zeno', NULL, NULL, NULL, '584713322-7', '2009/3/7', 2, 1, 4, 4);
INSERT INTO EJEMPLAR (nombre, imagen, isbn, issn, doi, fecha_publicacion, id_editorial, id_formato, id_idioma, id_coleccion) VALUES ('Hijos de nuestro barrio', NULL, NULL, '995953908-3', NULL, '2020/8/11', 4, 2, 4, 1);

INSERT INTO AUTOR (autor) VALUES ('Ava Fischer');
INSERT INTO AUTOR (autor) VALUES ('Tanner Short');
INSERT INTO AUTOR (autor) VALUES ('Randall Riddle');
INSERT INTO AUTOR (autor) VALUES ('Heidi Rowe');
INSERT INTO AUTOR (autor) VALUES ('Carly Newman');
INSERT INTO AUTOR (autor) VALUES ('Scott Love');
INSERT INTO AUTOR (autor) VALUES ('Elvis Foster');
INSERT INTO AUTOR (autor) VALUES ('Jeremy Butler');
INSERT INTO AUTOR (autor) VALUES ('Tatyana Curry');
INSERT INTO AUTOR (autor) VALUES ('Mia Mcfarland');
INSERT INTO AUTOR (autor) VALUES ('Jin Spence');
INSERT INTO AUTOR (autor) VALUES ('Jerome Suarez');
INSERT INTO AUTOR (autor) VALUES ('Keefe Miles');
INSERT INTO AUTOR (autor) VALUES ('Mikayla O brien');
INSERT INTO AUTOR (autor) VALUES ('Clio Franco');
INSERT INTO AUTOR (autor) VALUES ('Josiah Freeman');
INSERT INTO AUTOR (autor) VALUES ('Samuel Gillespie');
INSERT INTO AUTOR (autor) VALUES ('Caryn Schneider');
INSERT INTO AUTOR (autor) VALUES ('Ivory Shepard');
INSERT INTO AUTOR (autor) VALUES ('Hyatt Dalton');
INSERT INTO AUTOR (autor) VALUES ('Brennan Gray');
INSERT INTO AUTOR (autor) VALUES ('Cally Delaney');
INSERT INTO AUTOR (autor) VALUES ('Uta Delgado');
INSERT INTO AUTOR (autor) VALUES ('Ivy Clark');
INSERT INTO AUTOR (autor) VALUES ('Shannon Hunt');
INSERT INTO AUTOR (autor) VALUES ('Jonah Bridges');
INSERT INTO AUTOR (autor) VALUES ('Macaulay Benjamin');
INSERT INTO AUTOR (autor) VALUES ('Allegra Bailey');
INSERT INTO AUTOR (autor) VALUES ('Hall Peters');
INSERT INTO AUTOR (autor) VALUES ('Chaney Small');
INSERT INTO AUTOR (autor) VALUES ('Dexter Bryant');
INSERT INTO AUTOR (autor) VALUES ('Urielle Patel');
INSERT INTO AUTOR (autor) VALUES ('Ivy Lara');
INSERT INTO AUTOR (autor) VALUES ('Laith Robles');
INSERT INTO AUTOR (autor) VALUES ('Odysseus Merritt');
INSERT INTO AUTOR (autor) VALUES ('Otto Summers');
INSERT INTO AUTOR (autor) VALUES ('Gregory Fletcher');
INSERT INTO AUTOR (autor) VALUES ('Lillith Fleming');
INSERT INTO AUTOR (autor) VALUES ('Nicholas Mejia');
INSERT INTO AUTOR (autor) VALUES ('Danielle Burt');
INSERT INTO AUTOR (autor) VALUES ('Camilla Ray');
INSERT INTO AUTOR (autor) VALUES ('Tanner Townsend');
INSERT INTO AUTOR (autor) VALUES ('Fiona Odom');
INSERT INTO AUTOR (autor) VALUES ('Nerea Wilkerson');
INSERT INTO AUTOR (autor) VALUES ('Rhonda Roth');
INSERT INTO AUTOR (autor) VALUES ('Derek Knowles');
INSERT INTO AUTOR (autor) VALUES ('Hunter Mullen');
INSERT INTO AUTOR (autor) VALUES ('Dawn Sosa');
INSERT INTO AUTOR (autor) VALUES ('Alisa Richmond');
INSERT INTO AUTOR (autor) VALUES ('Allegra Wong');

INSERT INTO ESCRITURA (id_autor, id_ejemplar) VALUES (1, 3);
INSERT INTO ESCRITURA (id_autor, id_ejemplar) VALUES (2, 4);
INSERT INTO ESCRITURA (id_autor, id_ejemplar) VALUES (3, 5);
INSERT INTO ESCRITURA (id_autor, id_ejemplar) VALUES (4, 6);
INSERT INTO ESCRITURA (id_autor, id_ejemplar) VALUES (5, 7);
INSERT INTO ESCRITURA (id_autor, id_ejemplar) VALUES (6, 8);
INSERT INTO ESCRITURA (id_autor, id_ejemplar) VALUES (7, 9);
INSERT INTO ESCRITURA (id_autor, id_ejemplar) VALUES (8, 10);
INSERT INTO ESCRITURA (id_autor, id_ejemplar) VALUES (9, 11);
INSERT INTO ESCRITURA (id_autor, id_ejemplar) VALUES (10, 12);
INSERT INTO ESCRITURA (id_autor, id_ejemplar) VALUES (11, 13);
INSERT INTO ESCRITURA (id_autor, id_ejemplar) VALUES (12, 14);
INSERT INTO ESCRITURA (id_autor, id_ejemplar) VALUES (13, 15);
INSERT INTO ESCRITURA (id_autor, id_ejemplar) VALUES (14, 3);
INSERT INTO ESCRITURA (id_autor, id_ejemplar) VALUES (15, 4);
INSERT INTO ESCRITURA (id_autor, id_ejemplar) VALUES (16, 5);
INSERT INTO ESCRITURA (id_autor, id_ejemplar) VALUES (17, 6);
INSERT INTO ESCRITURA (id_autor, id_ejemplar) VALUES (18, 7);
INSERT INTO ESCRITURA (id_autor, id_ejemplar) VALUES (19, 8);
INSERT INTO ESCRITURA (id_autor, id_ejemplar) VALUES (20, 9);
INSERT INTO ESCRITURA (id_autor, id_ejemplar) VALUES (21, 10);
INSERT INTO ESCRITURA (id_autor, id_ejemplar) VALUES (22, 11);
INSERT INTO ESCRITURA (id_autor, id_ejemplar) VALUES (23, 12);
INSERT INTO ESCRITURA (id_autor, id_ejemplar) VALUES (24, 13);
INSERT INTO ESCRITURA (id_autor, id_ejemplar) VALUES (25, 14);
INSERT INTO ESCRITURA (id_autor, id_ejemplar) VALUES (1, 1);
INSERT INTO ESCRITURA (id_autor, id_ejemplar) VALUES (2, 2);

INSERT INTO PALABRA_CLAVE (palabra) VALUES ('complexity');
INSERT INTO PALABRA_CLAVE (palabra) VALUES ('well-modulated');
INSERT INTO PALABRA_CLAVE (palabra) VALUES ('function');
INSERT INTO PALABRA_CLAVE (palabra) VALUES ('Focused');
INSERT INTO PALABRA_CLAVE (palabra) VALUES ('matrix');
INSERT INTO PALABRA_CLAVE (palabra) VALUES ('core');
INSERT INTO PALABRA_CLAVE (palabra) VALUES ('zero defect');
INSERT INTO PALABRA_CLAVE (palabra) VALUES ('utilisation');
INSERT INTO PALABRA_CLAVE (palabra) VALUES ('3rd generation');
INSERT INTO PALABRA_CLAVE (palabra) VALUES ('regional');
INSERT INTO PALABRA_CLAVE (palabra) VALUES ('4th generation');
INSERT INTO PALABRA_CLAVE (palabra) VALUES ('Streamlined');
INSERT INTO PALABRA_CLAVE (palabra) VALUES ('transitional');
INSERT INTO PALABRA_CLAVE (palabra) VALUES ('didactic');
INSERT INTO PALABRA_CLAVE (palabra) VALUES ('extranet');
INSERT INTO PALABRA_CLAVE (palabra) VALUES ('incremental');
INSERT INTO PALABRA_CLAVE (palabra) VALUES ('pais');
INSERT INTO PALABRA_CLAVE (palabra) VALUES ('Reactive');
INSERT INTO PALABRA_CLAVE (palabra) VALUES ('extarten');
INSERT INTO PALABRA_CLAVE (palabra) VALUES ('website');
INSERT INTO PALABRA_CLAVE (palabra) VALUES ('portal');
INSERT INTO PALABRA_CLAVE (palabra) VALUES ('Removible');
INSERT INTO PALABRA_CLAVE (palabra) VALUES ('Pre-emptive');
INSERT INTO PALABRA_CLAVE (palabra) VALUES ('encoding');
INSERT INTO PALABRA_CLAVE (palabra) VALUES ('executive');
INSERT INTO PALABRA_CLAVE (palabra) VALUES ('Compatible');
INSERT INTO PALABRA_CLAVE (palabra) VALUES ('framework');
INSERT INTO PALABRA_CLAVE (palabra) VALUES ('toolset');
INSERT INTO PALABRA_CLAVE (palabra) VALUES ('Assimilated');
INSERT INTO PALABRA_CLAVE (palabra) VALUES ('clear-thinking');
INSERT INTO PALABRA_CLAVE (palabra) VALUES ('foreground');
INSERT INTO PALABRA_CLAVE (palabra) VALUES ('bottom-line');
INSERT INTO PALABRA_CLAVE (palabra) VALUES ('Function-based');
INSERT INTO PALABRA_CLAVE (palabra) VALUES ('motivating');
INSERT INTO PALABRA_CLAVE (palabra) VALUES ('Progressive');
INSERT INTO PALABRA_CLAVE (palabra) VALUES ('tool');
INSERT INTO PALABRA_CLAVE (palabra) VALUES ('secured line');
INSERT INTO PALABRA_CLAVE (palabra) VALUES ('sum');
INSERT INTO PALABRA_CLAVE (palabra) VALUES ('Monitored');
INSERT INTO PALABRA_CLAVE (palabra) VALUES ('exuding');

INSERT INTO EJEMPLAR_X_PALABRA (id_ejemplar, id_palabra_clave) VALUES (1, 1);
INSERT INTO EJEMPLAR_X_PALABRA (id_ejemplar, id_palabra_clave) VALUES (2, 2);
INSERT INTO EJEMPLAR_X_PALABRA (id_ejemplar, id_palabra_clave) VALUES (3, 3);
INSERT INTO EJEMPLAR_X_PALABRA (id_ejemplar, id_palabra_clave) VALUES (4, 4);
INSERT INTO EJEMPLAR_X_PALABRA (id_ejemplar, id_palabra_clave) VALUES (5, 5);
INSERT INTO EJEMPLAR_X_PALABRA (id_ejemplar, id_palabra_clave) VALUES (6, 6);
INSERT INTO EJEMPLAR_X_PALABRA (id_ejemplar, id_palabra_clave) VALUES (7, 7);
INSERT INTO EJEMPLAR_X_PALABRA (id_ejemplar, id_palabra_clave) VALUES (8, 8);
INSERT INTO EJEMPLAR_X_PALABRA (id_ejemplar, id_palabra_clave) VALUES (9, 9);
INSERT INTO EJEMPLAR_X_PALABRA (id_ejemplar, id_palabra_clave) VALUES (10, 10);
INSERT INTO EJEMPLAR_X_PALABRA (id_ejemplar, id_palabra_clave) VALUES (11, 11);
INSERT INTO EJEMPLAR_X_PALABRA (id_ejemplar, id_palabra_clave) VALUES (12, 12);
INSERT INTO EJEMPLAR_X_PALABRA (id_ejemplar, id_palabra_clave) VALUES (13, 13);
INSERT INTO EJEMPLAR_X_PALABRA (id_ejemplar, id_palabra_clave) VALUES (14, 14);
INSERT INTO EJEMPLAR_X_PALABRA (id_ejemplar, id_palabra_clave) VALUES (15, 15);
INSERT INTO EJEMPLAR_X_PALABRA (id_ejemplar, id_palabra_clave) VALUES (1, 16);
INSERT INTO EJEMPLAR_X_PALABRA (id_ejemplar, id_palabra_clave) VALUES (2, 17);
INSERT INTO EJEMPLAR_X_PALABRA (id_ejemplar, id_palabra_clave) VALUES (3, 18);
INSERT INTO EJEMPLAR_X_PALABRA (id_ejemplar, id_palabra_clave) VALUES (4, 19);
INSERT INTO EJEMPLAR_X_PALABRA (id_ejemplar, id_palabra_clave) VALUES (5, 20);
INSERT INTO EJEMPLAR_X_PALABRA (id_ejemplar, id_palabra_clave) VALUES (6, 21);
INSERT INTO EJEMPLAR_X_PALABRA (id_ejemplar, id_palabra_clave) VALUES (10, 25);
INSERT INTO EJEMPLAR_X_PALABRA (id_ejemplar, id_palabra_clave) VALUES (11, 26);
INSERT INTO EJEMPLAR_X_PALABRA (id_ejemplar, id_palabra_clave) VALUES (15, 30);
INSERT INTO EJEMPLAR_X_PALABRA (id_ejemplar, id_palabra_clave) VALUES (1, 31);
INSERT INTO EJEMPLAR_X_PALABRA (id_ejemplar, id_palabra_clave) VALUES (2, 32);
INSERT INTO EJEMPLAR_X_PALABRA (id_ejemplar, id_palabra_clave) VALUES (3, 33);
INSERT INTO EJEMPLAR_X_PALABRA (id_ejemplar, id_palabra_clave) VALUES (4, 34);
INSERT INTO EJEMPLAR_X_PALABRA (id_ejemplar, id_palabra_clave) VALUES (8, 38);
INSERT INTO EJEMPLAR_X_PALABRA (id_ejemplar, id_palabra_clave) VALUES (9, 39);
INSERT INTO EJEMPLAR_X_PALABRA (id_ejemplar, id_palabra_clave) VALUES (10, 40);
INSERT INTO EJEMPLAR_X_PALABRA (id_ejemplar, id_palabra_clave) VALUES (11, 1);
INSERT INTO EJEMPLAR_X_PALABRA (id_ejemplar, id_palabra_clave) VALUES (12, 2);
INSERT INTO EJEMPLAR_X_PALABRA (id_ejemplar, id_palabra_clave) VALUES (1, 6);
INSERT INTO EJEMPLAR_X_PALABRA (id_ejemplar, id_palabra_clave) VALUES (2, 7);

INSERT INTO OCUPACION (ocupacion) VALUES ('Profesor');
INSERT INTO OCUPACION (ocupacion) VALUES ('Estudiante');
INSERT INTO OCUPACION (ocupacion) VALUES ('Reportero');
INSERT INTO OCUPACION (ocupacion) VALUES ('Seguridad');
INSERT INTO OCUPACION (ocupacion) VALUES ('Otro');

INSERT INTO INSTITUCION (institucion) VALUES ('Universidad Centroamericana José Simeón Cañas');
INSERT INTO INSTITUCION (institucion) VALUES ('Universidad de El Salvador UES');
INSERT INTO INSTITUCION (institucion) VALUES ('Universidad Tecnológica de El Salvador');
INSERT INTO INSTITUCION (institucion) VALUES ('Universidad Don Bosco');
INSERT INTO INSTITUCION (institucion) VALUES ('Bachillerato');
INSERT INTO INSTITUCION (institucion) VALUES ('Escuela primaria');
INSERT INTO INSTITUCION (institucion) VALUES ('Prensa');

INSERT INTO USUARIO (codigo_QR, nombre, direccion, telefono, fotografia, correo_electronico, id_ocupacion, id_institucion) VALUES ('33375305520', 'Katrinka Worvell', '7 Mandrake Way', '71234133', NULL, 'kworvell0@walmart.com', 1, 1);
INSERT INTO USUARIO (codigo_QR, nombre, direccion, telefono, fotografia, correo_electronico, id_ocupacion, id_institucion) VALUES ('30786278562', 'Thorndike Durnford', '0 Continental Road', '73566778', NULL, 'tdurnford1@umich.edu', 2, 2);
INSERT INTO USUARIO (codigo_QR, nombre, direccion, telefono, fotografia, correo_electronico, id_ocupacion, id_institucion) VALUES ('00445017784', 'Ulysses Dulinty', '01918 Hollow Ridge Junction', '75654175', NULL, 'udulinty2@usa.gov', 3, 3);
INSERT INTO USUARIO (codigo_QR, nombre, direccion, telefono, fotografia, correo_electronico, id_ocupacion, id_institucion) VALUES ('14277481492', 'Lynnell Van Der Walt', '96001 Fair Oaks Crossing', '71992901', NULL, 'lvan3@cdc.gov', 4, 4);
INSERT INTO USUARIO (codigo_QR, nombre, direccion, telefono, fotografia, correo_electronico, id_ocupacion, id_institucion) VALUES ('52988591027', 'Chase Need', '1457 Grasskamp Circle', '72053322', NULL, 'cneed4@wufoo.com', 5, 5);
INSERT INTO USUARIO (codigo_QR, nombre, direccion, telefono, fotografia, correo_electronico, id_ocupacion, id_institucion) VALUES ('44878627716', 'Jodi Guiraud', '067 Chinook Center', '71960762', NULL, 'jguiraud5@google.de', 1, 6);
INSERT INTO USUARIO (codigo_QR, nombre, direccion, telefono, fotografia, correo_electronico, id_ocupacion, id_institucion) VALUES ('43894341279', 'Ange Shew', '60035 Bowman Alley', '71697226', NULL, 'ashew6@cocolog-nifty.com', 2, 7);
INSERT INTO USUARIO (codigo_QR, nombre, direccion, telefono, fotografia, correo_electronico, id_ocupacion, id_institucion) VALUES ('44656692451', 'Vickie Geater', '0674 Burning Wood Lane', '72660491', NULL, 'vgeater7@marketwatch.com', 3, 1);
INSERT INTO USUARIO (codigo_QR, nombre, direccion, telefono, fotografia, correo_electronico, id_ocupacion, id_institucion) VALUES ('83569860199', 'Ali Waddicor', '99695 Derek Place', '75557230', NULL, 'awaddicor8@macromedia.com', 4, 2);
INSERT INTO USUARIO (codigo_QR, nombre, direccion, telefono, fotografia, correo_electronico, id_ocupacion, id_institucion) VALUES ('71951119808', 'Beverlee Amy', '48058 Lake View Street', '75943640', NULL, 'bamy9@google.it', 5, 3);
INSERT INTO USUARIO (codigo_QR, nombre, direccion, telefono, fotografia, correo_electronico, id_ocupacion, id_institucion) VALUES ('55937374750', 'Anitra Duckering', '22 Thompson Circle', '71398320', NULL, 'aduckeringa@wiley.com', 1, 4);
INSERT INTO USUARIO (codigo_QR, nombre, direccion, telefono, fotografia, correo_electronico, id_ocupacion, id_institucion) VALUES ('01427033992', 'Ronny Elstow', '02850 Bunker Hill Circle', '73885114', NULL, 'relstowb@uol.com.br', 2, 5);
INSERT INTO USUARIO (codigo_QR, nombre, direccion, telefono, fotografia, correo_electronico, id_ocupacion, id_institucion) VALUES ('25166469320', 'Vinnie Smithend', '44641 Cherokee Junction', '72183691', NULL, 'vsmithendc@tinypic.com', 3, 6);
INSERT INTO USUARIO (codigo_QR, nombre, direccion, telefono, fotografia, correo_electronico, id_ocupacion, id_institucion) VALUES ('25863200994', 'Archaimbaud Balffye', '06 Susan Street', '79743501', NULL, 'abalffyed@dedecms.com', 4, 7);
INSERT INTO USUARIO (codigo_QR, nombre, direccion, telefono, fotografia, correo_electronico, id_ocupacion, id_institucion) VALUES ('30122575890', 'Sonnnie Karpol', '440 Sunfield Parkway', '78909679', NULL, 'skarpole@4shared.com', 5, 1);
INSERT INTO USUARIO (codigo_QR, nombre, direccion, telefono, fotografia, correo_electronico, id_ocupacion, id_institucion) VALUES ('79701571344', 'Kaylyn Pomeroy', '6387 Old Gate Plaza', '74719114', NULL, 'kpomeroyf@huffingtonpost.com', 1, 2);
INSERT INTO USUARIO (codigo_QR, nombre, direccion, telefono, fotografia, correo_electronico, id_ocupacion, id_institucion) VALUES ('64121917437', 'Jeremie Simoncelli', '16 High Crossing Road', '79441301', NULL, 'jsimoncellig@baidu.com', 2, 3);
INSERT INTO USUARIO (codigo_QR, nombre, direccion, telefono, fotografia, correo_electronico, id_ocupacion, id_institucion) VALUES ('51997347636', 'Massimo Gallen', '67 Anniversary Way', '74001629', NULL, 'mgallenh@craigslist.org', 3, 4);
INSERT INTO USUARIO (codigo_QR, nombre, direccion, telefono, fotografia, correo_electronico, id_ocupacion, id_institucion) VALUES ('23798517572', 'Matti Carlisi', '56667 Golf Alley', '77549528', NULL, 'mcarlisii@live.com', 4, 5);
INSERT INTO USUARIO (codigo_QR, nombre, direccion, telefono, fotografia, correo_electronico, id_ocupacion, id_institucion) VALUES ('68519926184', 'Albertina Pigeon', '423 Crowley Trail', '74898930', NULL, 'apigeonj@usa.gov', 5, 6);
INSERT INTO USUARIO (codigo_QR, nombre, direccion, telefono, fotografia, correo_electronico, id_ocupacion, id_institucion) VALUES ('70474854474', 'Patrick Vines', '596 Hagan Parkway', '79298083', NULL, 'pvinesk@va.gov', 1, 7);
INSERT INTO USUARIO (codigo_QR, nombre, direccion, telefono, fotografia, correo_electronico, id_ocupacion, id_institucion) VALUES ('27622733686', 'Sal Tomicki', '8409 Burrows Junction', '71510450', NULL, 'stomickil@redcross.org', 2, 1);
INSERT INTO USUARIO (codigo_QR, nombre, direccion, telefono, fotografia, correo_electronico, id_ocupacion, id_institucion) VALUES ('59842535954', 'Lianna Gomersal', '40 Knutson Pass', '71487807', NULL, 'lgomersalm@google.com.au', 3, 2);
INSERT INTO USUARIO (codigo_QR, nombre, direccion, telefono, fotografia, correo_electronico, id_ocupacion, id_institucion) VALUES ('75892359202', 'Maryanne Habert', '5 Monica Park', '79884006', NULL, 'mhabertn@blogs.com', 4, 3);
INSERT INTO USUARIO (codigo_QR, nombre, direccion, telefono, fotografia, correo_electronico, id_ocupacion, id_institucion) VALUES ('89683539311', 'Siobhan Stringer', '8670 Hoepker Pass', '70595533', NULL, 'sstringero@tinypic.com', 5, 4);
INSERT INTO USUARIO (codigo_QR, nombre, direccion, telefono, fotografia, correo_electronico, id_ocupacion, id_institucion) VALUES ('12539840439', 'Marroquin', '99695 Derek Place', '75354330', NULL, 'marromarro@google.it', 2, 1);

INSERT INTO RESERVA (codigo_QR, id_ejemplar, fecha_solicitud, fecha_prestamo, fecha_devolucion) VALUES ('25166469320', 8, '2022-06-26 05:50:00', '2022-07-26 15:24:00', '2022-09-01 13:59:00');
INSERT INTO RESERVA (codigo_QR, id_ejemplar, fecha_solicitud, fecha_prestamo, fecha_devolucion) VALUES ('79701571344', 6, '2022-06-26 14:35:00', '2022-09-30 02:30:32', '2022-10-02 01:14:32');
INSERT INTO RESERVA (codigo_QR, id_ejemplar, fecha_solicitud, fecha_prestamo, fecha_devolucion) VALUES ('30786278562', 4, '2022-06-26 17:32:00', '2022-10-02 18:58:27', '2022-10-07 15:40:27');
INSERT INTO RESERVA (codigo_QR, id_ejemplar, fecha_solicitud, fecha_prestamo, fecha_devolucion) VALUES ('55937374750', 15, '2022-06-27 12:06:00', '2022-09-08 10:40:20', '2022-09-12 06:40:20');
INSERT INTO RESERVA (codigo_QR, id_ejemplar, fecha_solicitud, fecha_prestamo, fecha_devolucion) VALUES ('64121917437', 10, '2022-06-27 12:32:00', '2022-11-27 06:40:18', '2022-12-03 04:08:18');

INSERT INTO PRESTAMO (codigo_QR, id_ejemplar, fecha_prestamo, fecha_devolucion) VALUES ('52988591027', 8, '2022-06-25 05:50:00', '2022-08-28 16:30:37');
INSERT INTO PRESTAMO (codigo_QR, id_ejemplar, fecha_prestamo, fecha_devolucion) VALUES ('79701571344', 7, '2022-06-25 05:50:00', '2022-11-04 15:18:40');
INSERT INTO PRESTAMO (codigo_QR, id_ejemplar, fecha_prestamo, fecha_devolucion) VALUES ('52988591027', 6, '2022-06-26 05:50:00', '2022-09-28 22:17:38');
INSERT INTO PRESTAMO (codigo_QR, id_ejemplar, fecha_prestamo, fecha_devolucion) VALUES ('68519926184', 11, '2022-06-26 05:50:00', '2022-07-07 16:19:43');
INSERT INTO PRESTAMO (codigo_QR, id_ejemplar, fecha_prestamo, fecha_devolucion) VALUES ('68519926184', 10, '2022-06-27 05:50:00', '2022-07-07 16:19:43');

INSERT INTO ASISTENCIA (id_area, codigo_QR, fecha_hora_entrada, fecha_hora_salida) VALUES (1, '83569860199', '2022-06-25 05:50:00', '2022-06-25 12:10:00');
INSERT INTO ASISTENCIA (id_area, codigo_QR, fecha_hora_entrada, fecha_hora_salida) VALUES (12, '44656692451', '2022-06-25 14:50:00', '2022-06-25 16:03:00');
INSERT INTO ASISTENCIA (id_area, codigo_QR, fecha_hora_entrada, fecha_hora_salida) VALUES (16, '71951119808', '2022-06-25 03:20:00', '2022-06-25 05:52:00');
INSERT INTO ASISTENCIA (id_area, codigo_QR, fecha_hora_entrada, fecha_hora_salida) VALUES (4, '83569860199', '2022-06-15 13:20:00', '2022-06-25 16:20:00');
INSERT INTO ASISTENCIA (id_area, codigo_QR, fecha_hora_entrada, fecha_hora_salida) VALUES (2, '83569860199', '2022-06-27 05:55:00', '2022-06-27 07:55:00');
INSERT INTO ASISTENCIA (id_area, codigo_QR, fecha_hora_entrada, fecha_hora_salida) VALUES (7, '83569860199', '2022-06-27 12:30:00', '2022-06-27 13:30:00');