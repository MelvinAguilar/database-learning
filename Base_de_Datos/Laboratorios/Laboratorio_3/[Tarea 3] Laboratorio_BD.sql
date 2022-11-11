/*
    Melvin Armando Aguilar Hernandez - 00067621
*/


CREATE DATABASE Labo3_BD;
USE Labo3_BD;

CREATE TABLE FABRICANTE(
	id INT IDENTITY PRIMARY KEY NOT NULL,
	fabricante VARCHAR(50) NOT NULL
);

CREATE TABLE MODELO(
	id INT IDENTITY PRIMARY KEY NOT NULL,
	modelo VARCHAR(15) NOT NULL,
	id_fabricante INT NOT NULL
);

ALTER TABLE MODELO ADD CONSTRAINT fk_fabri_modelo FOREIGN KEY (id_fabricante)
	REFERENCES FABRICANTE(id);
    
CREATE TABLE AVION(
	matricula VARCHAR(15) PRIMARY KEY NOT NULL,
	id_modelo INT NOT NULL
);

ALTER TABLE AVION ADD CONSTRAINT fk_modelo_avion FOREIGN KEY (id_modelo)
	REFERENCES MODELO(id);
    
CREATE TABLE CIUDAD(
	id INT IDENTITY PRIMARY KEY NOT NULL,
	ciudad VARCHAR(75) NOT NULL --todo
);

CREATE TABLE PAIS(
	id INT IDENTITY PRIMARY KEY NOT NULL,
	pais VARCHAR(50) NOT NULL
);

CREATE TABLE AEROPUERTO(
	id INT IDENTITY PRIMARY KEY NOT NULL,
	nombre VARCHAR(50) NOT NULL,
	id_ciudad INT NOT NULL,
	id_pais INT NOT NULL
);

ALTER TABLE AEROPUERTO ADD CONSTRAINT fk_ciudad_aero FOREIGN KEY (id_ciudad)
	REFERENCES CIUDAD(id);
ALTER TABLE AEROPUERTO ADD CONSTRAINT fk_pais_aero FOREIGN KEY (id_pais)
	REFERENCES PAIS(id);

CREATE TABLE PILOTO(
	id INT IDENTITY PRIMARY KEY NOT NULL,
	nombre VARCHAR(50) NOT NULL
);

CREATE TABLE VUELO(
	id INT IDENTITY PRIMARY KEY NOT NULL,
	fecha DATETIME NOT NULL,
	id_piloto INT NOT NULL,
	id_aeropuerto_origen INT NOT NULL,
	id_aeropuerto_destino INT NOT NULL,
	id_avion VARCHAR(15) NOT NULL,
);

ALTER TABLE VUELO ADD CONSTRAINT fk_piloto_vuelo FOREIGN KEY (id_piloto)
	REFERENCES PILOTO(id);
ALTER TABLE VUELO ADD CONSTRAINT fk_aero_vuelo_origen FOREIGN KEY (id_aeropuerto_origen)
	REFERENCES AEROPUERTO(id);
ALTER TABLE VUELO ADD CONSTRAINT fk_aero_vuelo_destino FOREIGN KEY (id_aeropuerto_destino)
	REFERENCES AEROPUERTO(id);
ALTER TABLE VUELO ADD CONSTRAINT fk_avion_vuelo FOREIGN KEY (id_avion)
	REFERENCES AVION(matricula);


CREATE TABLE PAIS_PASAJERO(
	id INT IDENTITY PRIMARY KEY NOT NULL,
	pais VARCHAR(50) NOT NULL
);

CREATE TABLE PASAJERO(
	pasaporte VARCHAR(15) PRIMARY KEY NOT NULL,
	nombre VARCHAR(50) NOT NULL,
	fecha_nacimiento DATE NOT NULL,
	correo_electronico VARCHAR(50),
	id_pais_pasajero INT NOT NULL
);

ALTER TABLE PASAJERO ADD CONSTRAINT fk_pais_pasajero FOREIGN KEY (id_pais_pasajero)
	REFERENCES PAIS_PASAJERO(id);
    
    
CREATE TABLE TIPO_RESERVA(
	id INT IDENTITY PRIMARY KEY NOT NULL,
	tipo_reserva VARCHAR(40) NOT NULL,
	CHECK(tipo_reserva IN ('Económica', 'Ejecutiva', 'Primera clase'))
);

CREATE TABLE RESERVA(
	id INT IDENTITY PRIMARY KEY NOT NULL,
	precio MONEY NOT NULL,
	fecha DATE NOT NULL,
	id_tipo_reserva INT NOT NULL,
	id_vuelo INT NOT NULL,
	pasaporte_pasajero VARCHAR(15) NOT NULL
);

ALTER TABLE RESERVA ADD CONSTRAINT fk_tipo_reserva FOREIGN KEY (id_tipo_reserva)
	REFERENCES TIPO_RESERVA(id);
ALTER TABLE RESERVA ADD CONSTRAINT fk_vuelo_reserva FOREIGN KEY (id_vuelo)
	REFERENCES VUELO(id);
ALTER TABLE RESERVA ADD CONSTRAINT fk_pasajero_reserva FOREIGN KEY (pasaporte_pasajero)
	REFERENCES PASAJERO(pasaporte);

CREATE TABLE SERVICIO(
	id INT IDENTITY PRIMARY KEY NOT NULL,
	precio MONEY NOT NULL,
	nombre VARCHAR(50) NOT NULL
);

CREATE TABLE SERVICIO_EXTRA(
	id_servicio INT NOT NULL,
	id_reserva INT NOT NULL
);

ALTER TABLE SERVICIO_EXTRA ADD CONSTRAINT pk_servi_reserva PRIMARY KEY (id_servicio, id_reserva);

ALTER TABLE SERVICIO_EXTRA ADD CONSTRAINT fk_servicio_extra FOREIGN KEY (id_servicio)
	REFERENCES SERVICIO(id);
ALTER TABLE SERVICIO_EXTRA ADD CONSTRAINT fk_reserva_extra FOREIGN KEY (id_reserva)
	REFERENCES RESERVA(id);


-- Insertar registros en tabla del fabricante
INSERT INTO FABRICANTE (fabricante) VALUES ('Airbus');
INSERT INTO FABRICANTE (fabricante) VALUES ('Boeing');
INSERT INTO FABRICANTE (fabricante) VALUES ('Dassault');
INSERT INTO FABRICANTE (fabricante) VALUES ('Northrop');
INSERT INTO FABRICANTE (fabricante) VALUES ('Aviation Industry Corp. of China');
INSERT INTO FABRICANTE (fabricante) VALUES ('General Dynamics');
INSERT INTO FABRICANTE (fabricante) VALUES ('British Aerospace');
INSERT INTO FABRICANTE (fabricante) VALUES ('Antonov');

-- Insertar registros en tabla del modelo
INSERT INTO MODELO (modelo, id_fabricante) VALUES ('Fdozsbq 895', 7);
INSERT INTO MODELO (modelo, id_fabricante) VALUES ('Fgknotc 010', 6);
INSERT INTO MODELO (modelo, id_fabricante) VALUES ('Fndqxch 793', 2);
INSERT INTO MODELO (modelo, id_fabricante) VALUES ('Flozoff 230', 7);
INSERT INTO MODELO (modelo, id_fabricante) VALUES ('Fvbmcrh 330', 4);
INSERT INTO MODELO (modelo, id_fabricante) VALUES ('Flbfqif 923', 1);
INSERT INTO MODELO (modelo, id_fabricante) VALUES ('Fjewgdc 895', 3);
INSERT INTO MODELO (modelo, id_fabricante) VALUES ('Fkiedbk 490', 8);
INSERT INTO MODELO (modelo, id_fabricante) VALUES ('Fcgtfdo 893', 5);
INSERT INTO MODELO (modelo, id_fabricante) VALUES ('Fvvaype 667', 6);

-- Insertar registros en tabla del avion
INSERT INTO AVION (matricula, id_modelo) VALUES ('hk509sj532', 4);
INSERT INTO AVION (matricula, id_modelo) VALUES ('ep992fe634', 9);
INSERT INTO AVION (matricula, id_modelo) VALUES ('yo345fn203', 1);
INSERT INTO AVION (matricula, id_modelo) VALUES ('yj143ge934', 3);
INSERT INTO AVION (matricula, id_modelo) VALUES ('br116lx087', 9);
INSERT INTO AVION (matricula, id_modelo) VALUES ('qw435xd214', 5);
INSERT INTO AVION (matricula, id_modelo) VALUES ('ui868ar856', 7);
INSERT INTO AVION (matricula, id_modelo) VALUES ('ii833ij750', 5);
INSERT INTO AVION (matricula, id_modelo) VALUES ('sb810lm980', 3);
INSERT INTO AVION (matricula, id_modelo) VALUES ('wm304nf124', 9);

-- Insertar registros en tabla del pais
INSERT INTO PAIS (pais) VALUES('El Salvador');
INSERT INTO PAIS (pais) VALUES('Brasil');
INSERT INTO PAIS (pais) VALUES('Chile');
INSERT INTO PAIS (pais) VALUES('Colombia');
INSERT INTO PAIS (pais) VALUES('Argentina');
INSERT INTO PAIS (pais) VALUES('Nicaragua');
INSERT INTO PAIS (pais) VALUES('Mexico');
INSERT INTO PAIS (pais) VALUES('Guyana');
INSERT INTO PAIS (pais) VALUES('Panama');
INSERT INTO PAIS (pais) VALUES('Guatemala');
INSERT INTO PAIS (pais) VALUES('Honduras');
INSERT INTO PAIS (pais) VALUES('Ecuador');
INSERT INTO PAIS (pais) VALUES('Belice');
INSERT INTO PAIS (pais) VALUES('Costa Rica');
INSERT INTO PAIS (pais) VALUES('Bolivia');

-- Insertar registros en tabla de la ciudad
INSERT INTO CIUDAD (ciudad) VALUES ('Bukid');
INSERT INTO CIUDAD (ciudad) VALUES ('Wang’er');
INSERT INTO CIUDAD (ciudad) VALUES ('Huishangang');
INSERT INTO CIUDAD (ciudad) VALUES ('Tcholliré');
INSERT INTO CIUDAD (ciudad) VALUES ('Zhangjiafang');
INSERT INTO CIUDAD (ciudad) VALUES ('Shangyang');
INSERT INTO CIUDAD (ciudad) VALUES ('Watubura');
INSERT INTO CIUDAD (ciudad) VALUES ('Curumaní');
INSERT INTO CIUDAD (ciudad) VALUES ('Belsk Duży');
INSERT INTO CIUDAD (ciudad) VALUES ('Pamarayan');
INSERT INTO CIUDAD (ciudad) VALUES ('Nikolina Gora');
INSERT INTO CIUDAD (ciudad) VALUES ('Ronneby');
INSERT INTO CIUDAD (ciudad) VALUES ('Xomong');
INSERT INTO CIUDAD (ciudad) VALUES ('Sukawaris');
INSERT INTO CIUDAD (ciudad) VALUES ('Tubajon');
INSERT INTO CIUDAD (ciudad) VALUES ('Tanjungbahagia');
INSERT INTO CIUDAD (ciudad) VALUES ('Luofang');
INSERT INTO CIUDAD (ciudad) VALUES ('Daqiao');
INSERT INTO CIUDAD (ciudad) VALUES ('Alcabideche');
INSERT INTO CIUDAD (ciudad) VALUES ('Laofao');

-- Insertar registros en tabla del aeropuerto
INSERT INTO AEROPUERTO (nombre, id_ciudad, id_pais) VALUES ('Kwideo', 11, 10);
INSERT INTO AEROPUERTO (nombre, id_ciudad, id_pais) VALUES ('Yadel', 10, 13);
INSERT INTO AEROPUERTO (nombre, id_ciudad, id_pais) VALUES ('Dabfeed', 20, 5);
INSERT INTO AEROPUERTO (nombre, id_ciudad, id_pais) VALUES ('Demimbu', 3, 5);
INSERT INTO AEROPUERTO (nombre, id_ciudad, id_pais) VALUES ('Wordpedia', 5, 10);
INSERT INTO AEROPUERTO (nombre, id_ciudad, id_pais) VALUES ('Skynoodle', 18, 1);
INSERT INTO AEROPUERTO (nombre, id_ciudad, id_pais) VALUES ('Bluezoom', 11, 7);
INSERT INTO AEROPUERTO (nombre, id_ciudad, id_pais) VALUES ('Photobug', 16, 15);
INSERT INTO AEROPUERTO (nombre, id_ciudad, id_pais) VALUES ('Jabbersphere', 5, 12);
INSERT INTO AEROPUERTO (nombre, id_ciudad, id_pais) VALUES ('Kwilith', 4, 2);
INSERT INTO AEROPUERTO (nombre, id_ciudad, id_pais) VALUES ('Pixonyx', 1, 9);
INSERT INTO AEROPUERTO (nombre, id_ciudad, id_pais) VALUES ('Zoombox', 6, 13);
INSERT INTO AEROPUERTO (nombre, id_ciudad, id_pais) VALUES ('Quaxo', 2, 10);
INSERT INTO AEROPUERTO (nombre, id_ciudad, id_pais) VALUES ('Linkbuzz', 11, 4);
INSERT INTO AEROPUERTO (nombre, id_ciudad, id_pais) VALUES ('Quinu', 1, 11);

-- Insertar registros en tabla del piloto
INSERT INTO PILOTO (nombre) VALUES ('Alane McDermid');
INSERT INTO PILOTO (nombre) VALUES ('Mathias Lanfere');
INSERT INTO PILOTO (nombre) VALUES ('Goddart Gillott');
INSERT INTO PILOTO (nombre) VALUES ('Ryley Pillman');
INSERT INTO PILOTO (nombre) VALUES ('Eugen Antao');
INSERT INTO PILOTO (nombre) VALUES ('Adriano Lowmass');
INSERT INTO PILOTO (nombre) VALUES ('Frederico Isabell');
INSERT INTO PILOTO (nombre) VALUES ('Jewelle Gawen');
INSERT INTO PILOTO (nombre) VALUES ('Ira Danilchik');
INSERT INTO PILOTO (nombre) VALUES ('Janifer Blacker');

-- Insertar registros en tabla del vuelo
INSERT INTO VUELO (fecha, id_piloto, id_aeropuerto_origen, id_aeropuerto_destino, id_avion) VALUES ('2022-05-30', 7, 2, 4, 'yo345fn203');
INSERT INTO VUELO (fecha, id_piloto, id_aeropuerto_origen, id_aeropuerto_destino, id_avion) VALUES ('2022-06-22', 5, 2, 14, 'yj143ge934');
INSERT INTO VUELO (fecha, id_piloto, id_aeropuerto_origen, id_aeropuerto_destino, id_avion) VALUES ('2022-09-18', 9, 5, 2, 'yo345fn203');
INSERT INTO VUELO (fecha, id_piloto, id_aeropuerto_origen, id_aeropuerto_destino, id_avion) VALUES ('2022-10-07', 9, 5, 15, 'yo345fn203');
INSERT INTO VUELO (fecha, id_piloto, id_aeropuerto_origen, id_aeropuerto_destino, id_avion) VALUES ('2022-07-25', 1, 4, 11, 'sb810lm980');
INSERT INTO VUELO (fecha, id_piloto, id_aeropuerto_origen, id_aeropuerto_destino, id_avion) VALUES ('2022-06-15', 10, 8, 5, 'sb810lm980');
INSERT INTO VUELO (fecha, id_piloto, id_aeropuerto_origen, id_aeropuerto_destino, id_avion) VALUES ('2022-08-17', 2, 2, 1, 'sb810lm980');
INSERT INTO VUELO (fecha, id_piloto, id_aeropuerto_origen, id_aeropuerto_destino, id_avion) VALUES ('2022-08-29', 2, 12, 8, 'yj143ge934');
INSERT INTO VUELO (fecha, id_piloto, id_aeropuerto_origen, id_aeropuerto_destino, id_avion) VALUES ('2022-06-16', 1, 1, 9, 'ii833ij750');
INSERT INTO VUELO (fecha, id_piloto, id_aeropuerto_origen, id_aeropuerto_destino, id_avion) VALUES ('2022-06-14', 5, 14, 1, 'wm304nf124');
INSERT INTO VUELO (fecha, id_piloto, id_aeropuerto_origen, id_aeropuerto_destino, id_avion) VALUES ('2022-07-05', 2, 7, 5, 'br116lx087');
INSERT INTO VUELO (fecha, id_piloto, id_aeropuerto_origen, id_aeropuerto_destino, id_avion) VALUES ('2022-06-16', 10, 12, 7, 'yo345fn203');
INSERT INTO VUELO (fecha, id_piloto, id_aeropuerto_origen, id_aeropuerto_destino, id_avion) VALUES ('2022-08-31', 5, 3, 15, 'yo345fn203');
INSERT INTO VUELO (fecha, id_piloto, id_aeropuerto_origen, id_aeropuerto_destino, id_avion) VALUES ('2022-09-07', 2, 12, 4, 'yo345fn203');
INSERT INTO VUELO (fecha, id_piloto, id_aeropuerto_origen, id_aeropuerto_destino, id_avion) VALUES ('2022-05-25', 6, 1, 2, 'ui868ar856');
INSERT INTO VUELO (fecha, id_piloto, id_aeropuerto_origen, id_aeropuerto_destino, id_avion) VALUES ('2022-06-19', 4, 11, 5, 'sb810lm980');
INSERT INTO VUELO (fecha, id_piloto, id_aeropuerto_origen, id_aeropuerto_destino, id_avion) VALUES ('2022-08-28', 9, 4, 9, 'ep992fe634');
INSERT INTO VUELO (fecha, id_piloto, id_aeropuerto_origen, id_aeropuerto_destino, id_avion) VALUES ('2022-07-26', 6, 13, 12, 'ep992fe634');
INSERT INTO VUELO (fecha, id_piloto, id_aeropuerto_origen, id_aeropuerto_destino, id_avion) VALUES ('2022-08-18', 2, 8, 2, 'ii833ij750');
INSERT INTO VUELO (fecha, id_piloto, id_aeropuerto_origen, id_aeropuerto_destino, id_avion) VALUES ('2022-08-22', 10, 1, 1, 'wm304nf124');
INSERT INTO VUELO (fecha, id_piloto, id_aeropuerto_origen, id_aeropuerto_destino, id_avion) VALUES ('2022-09-19', 2, 8, 11, 'ui868ar856');
INSERT INTO VUELO (fecha, id_piloto, id_aeropuerto_origen, id_aeropuerto_destino, id_avion) VALUES ('2022-08-15', 8, 15, 11, 'qw435xd214');
INSERT INTO VUELO (fecha, id_piloto, id_aeropuerto_origen, id_aeropuerto_destino, id_avion) VALUES ('2022-07-13', 10, 13, 6, 'sb810lm980');
INSERT INTO VUELO (fecha, id_piloto, id_aeropuerto_origen, id_aeropuerto_destino, id_avion) VALUES ('2022-06-17', 7, 13, 1, 'ii833ij750');
INSERT INTO VUELO (fecha, id_piloto, id_aeropuerto_origen, id_aeropuerto_destino, id_avion) VALUES ('2022-08-29', 7, 7, 5, 'yo345fn203');

-- Insertar registros en tabla del pais del pasajero
INSERT INTO PAIS_PASAJERO (pais) VALUES('Argentino');
INSERT INTO PAIS_PASAJERO (pais) VALUES('Nicaragüense');
INSERT INTO PAIS_PASAJERO (pais) VALUES('Chileno');
INSERT INTO PAIS_PASAJERO (pais) VALUES('Colombiano');
INSERT INTO PAIS_PASAJERO (pais) VALUES('Guatemalteco');
INSERT INTO PAIS_PASAJERO (pais) VALUES('Boliviano');
INSERT INTO PAIS_PASAJERO (pais) VALUES('Mexicano');
INSERT INTO PAIS_PASAJERO (pais) VALUES('Ecuatoriano');
INSERT INTO PAIS_PASAJERO (pais) VALUES('Italiano');
INSERT INTO PAIS_PASAJERO (pais) VALUES('Brasileño');
INSERT INTO PAIS_PASAJERO (pais) VALUES('Indonesio');
INSERT INTO PAIS_PASAJERO (pais) VALUES('Costarricense');
INSERT INTO PAIS_PASAJERO (pais) VALUES('Panameño');
INSERT INTO PAIS_PASAJERO (pais) VALUES('Hondureño');
INSERT INTO PAIS_PASAJERO (pais) VALUES('Salvadoreño');

-- Insertar registros en tabla del pasajero
INSERT INTO PASAJERO (pasaporte, nombre, fecha_nacimiento, correo_electronico, id_pais_pasajero) VALUES ('z95170792', 'Sissie Le Gall', '1995-07-26', 'sle0@paypal.com', 6);
INSERT INTO PASAJERO (pasaporte, nombre, fecha_nacimiento, correo_electronico, id_pais_pasajero) VALUES ('h46909116', 'Eugenio Hanburry', '2002-08-18', 'ehanburry1@archive.org', 3);
INSERT INTO PASAJERO (pasaporte, nombre, fecha_nacimiento, correo_electronico, id_pais_pasajero) VALUES ('p77363915', 'Ives Trask', '1991-08-25', 'itrask2@tinyurl.com', 10);
INSERT INTO PASAJERO (pasaporte, nombre, fecha_nacimiento, correo_electronico, id_pais_pasajero) VALUES ('a23300974', 'Valaree Adamowicz', '1995-06-26', 'vadamowicz3@bing.com', 7);
INSERT INTO PASAJERO (pasaporte, nombre, fecha_nacimiento, correo_electronico, id_pais_pasajero) VALUES ('m74185295', 'Delmore Dinsale', '1997-08-28', 'ddinsale4@plala.or.jp', 8);
INSERT INTO PASAJERO (pasaporte, nombre, fecha_nacimiento, correo_electronico, id_pais_pasajero) VALUES ('u80931178', 'Faunie Dunmore', '1993-08-18', 'fdunmore5@loc.gov', 2);
INSERT INTO PASAJERO (pasaporte, nombre, fecha_nacimiento, correo_electronico, id_pais_pasajero) VALUES ('x26044465', 'Ashley Banfield', '1990-08-04', 'abanfield6@dedecms.com', 10);
INSERT INTO PASAJERO (pasaporte, nombre, fecha_nacimiento, correo_electronico, id_pais_pasajero) VALUES ('r82341433', 'Adey Gatesman', '1991-08-08', 'agatesman7@typepad.com', 8);
INSERT INTO PASAJERO (pasaporte, nombre, fecha_nacimiento, correo_electronico, id_pais_pasajero) VALUES ('z96475831', 'Bartlett Janczyk', '2003-04-16', 'bjanczyk8@chronoengine.com', 8);
INSERT INTO PASAJERO (pasaporte, nombre, fecha_nacimiento, correo_electronico, id_pais_pasajero) VALUES ('n76740111', 'Dalis Heaseman', '1999-01-11', 'dheaseman9@nsw.gov.au', 2);
INSERT INTO PASAJERO (pasaporte, nombre, fecha_nacimiento, correo_electronico, id_pais_pasajero) VALUES ('m04453699', 'Zaria Flieger', '1996-01-30', 'zfliegera@yahoo.com', 8);
INSERT INTO PASAJERO (pasaporte, nombre, fecha_nacimiento, correo_electronico, id_pais_pasajero) VALUES ('t68792863', 'Hinze Lifsey', '1989-03-28', 'hlifseyb@nationalgeographic.com', 3);
INSERT INTO PASAJERO (pasaporte, nombre, fecha_nacimiento, correo_electronico, id_pais_pasajero) VALUES ('y51403199', 'Robers Inge', '1995-12-31', 'ringec@cdc.gov', 5);
INSERT INTO PASAJERO (pasaporte, nombre, fecha_nacimiento, correo_electronico, id_pais_pasajero) VALUES ('x86057889', 'Oswell Taplin', '1992-11-30', 'otaplind@discovery.com', 3);
INSERT INTO PASAJERO (pasaporte, nombre, fecha_nacimiento, correo_electronico, id_pais_pasajero) VALUES ('l34137741', 'Dido Goves', '1990-02-25', 'dgovese@technorati.com', 10);

-- Insertar registros en tabla de los tipos de reservas
INSERT INTO TIPO_RESERVA (tipo_reserva) VALUES ('Económica');
INSERT INTO TIPO_RESERVA (tipo_reserva) VALUES ('Ejecutiva');
INSERT INTO TIPO_RESERVA (tipo_reserva) VALUES ('Primera clase');

-- Insertar registros en tabla de la reserva
INSERT INTO RESERVA (precio, fecha, id_tipo_reserva, id_vuelo, pasaporte_pasajero) VALUES ('$91.73', '5/12/2022', 1, 20, 'h46909116');
INSERT INTO RESERVA (precio, fecha, id_tipo_reserva, id_vuelo, pasaporte_pasajero) VALUES ('$242.86', '5/21/2022', 3, 13, 'z96475831');
INSERT INTO RESERVA (precio, fecha, id_tipo_reserva, id_vuelo, pasaporte_pasajero) VALUES ('$150.81', '5/4/2022', 3, 10, 'z96475831');
INSERT INTO RESERVA (precio, fecha, id_tipo_reserva, id_vuelo, pasaporte_pasajero) VALUES ('$249.85', '5/29/2022', 1, 11, 'z95170792');
INSERT INTO RESERVA (precio, fecha, id_tipo_reserva, id_vuelo, pasaporte_pasajero) VALUES ('$201.88', '5/29/2022', 1, 5, 't68792863');
INSERT INTO RESERVA (precio, fecha, id_tipo_reserva, id_vuelo, pasaporte_pasajero) VALUES ('$36.17', '5/7/2022', 3, 22, 'a23300974');
INSERT INTO RESERVA (precio, fecha, id_tipo_reserva, id_vuelo, pasaporte_pasajero) VALUES ('$149.70', '5/18/2022', 2, 12, 'p77363915');
INSERT INTO RESERVA (precio, fecha, id_tipo_reserva, id_vuelo, pasaporte_pasajero) VALUES ('$134.54', '5/26/2022', 2, 14, 'a23300974');
INSERT INTO RESERVA (precio, fecha, id_tipo_reserva, id_vuelo, pasaporte_pasajero) VALUES ('$181.97', '5/22/2022', 3, 18, 'a23300974');
INSERT INTO RESERVA (precio, fecha, id_tipo_reserva, id_vuelo, pasaporte_pasajero) VALUES ('$49.78', '5/13/2022', 3, 20, 'z96475831');
INSERT INTO RESERVA (precio, fecha, id_tipo_reserva, id_vuelo, pasaporte_pasajero) VALUES ('$245.84', '5/4/2022', 1, 13, 'r82341433');
INSERT INTO RESERVA (precio, fecha, id_tipo_reserva, id_vuelo, pasaporte_pasajero) VALUES ('$131.40', '5/16/2022', 3, 3, 'r82341433');
INSERT INTO RESERVA (precio, fecha, id_tipo_reserva, id_vuelo, pasaporte_pasajero) VALUES ('$209.26', '5/25/2022', 2, 15, 'x86057889');
INSERT INTO RESERVA (precio, fecha, id_tipo_reserva, id_vuelo, pasaporte_pasajero) VALUES ('$118.43', '5/31/2022', 1, 3, 'z96475831');
INSERT INTO RESERVA (precio, fecha, id_tipo_reserva, id_vuelo, pasaporte_pasajero) VALUES ('$210.28', '5/26/2022', 3, 19, 'x86057889');

-- Insertar registros en tabla del servicio
INSERT INTO SERVICIO (precio, nombre) VALUES ('$15.27', 'Wifi satelital');
INSERT INTO SERVICIO (precio, nombre) VALUES ('$30.70', 'Seguros');
INSERT INTO SERVICIO (precio, nombre) VALUES ('$20.07', 'Maletas extra');
INSERT INTO SERVICIO (precio, nombre) VALUES ('$40.78', 'Transporte de mascotas');
INSERT INTO SERVICIO (precio, nombre) VALUES ('$12.79', 'Entretenimiento');

-- Insertar registros en tabla cruz del servicio con la reserva
INSERT INTO SERVICIO_EXTRA (id_servicio, id_reserva) VALUES (1, 5);
INSERT INTO SERVICIO_EXTRA (id_servicio, id_reserva) VALUES (2, 6);
INSERT INTO SERVICIO_EXTRA (id_servicio, id_reserva) VALUES (4, 8);
INSERT INTO SERVICIO_EXTRA (id_servicio, id_reserva) VALUES (4, 12);
INSERT INTO SERVICIO_EXTRA (id_servicio, id_reserva) VALUES (1, 13);
INSERT INTO SERVICIO_EXTRA (id_servicio, id_reserva) VALUES (2, 14);
INSERT INTO SERVICIO_EXTRA (id_servicio, id_reserva) VALUES (3, 15);
INSERT INTO SERVICIO_EXTRA (id_servicio, id_reserva) VALUES (3, 3);
INSERT INTO SERVICIO_EXTRA (id_servicio, id_reserva) VALUES (4, 4);
INSERT INTO SERVICIO_EXTRA (id_servicio, id_reserva) VALUES (3, 7);
INSERT INTO SERVICIO_EXTRA (id_servicio, id_reserva) VALUES (3, 4);
INSERT INTO SERVICIO_EXTRA (id_servicio, id_reserva) VALUES (4, 5);
INSERT INTO SERVICIO_EXTRA (id_servicio, id_reserva) VALUES (4, 1);
INSERT INTO SERVICIO_EXTRA (id_servicio, id_reserva) VALUES (1, 2);
INSERT INTO SERVICIO_EXTRA (id_servicio, id_reserva) VALUES (2, 3);
INSERT INTO SERVICIO_EXTRA (id_servicio, id_reserva) VALUES (1, 9);
INSERT INTO SERVICIO_EXTRA (id_servicio, id_reserva) VALUES (2, 10);
INSERT INTO SERVICIO_EXTRA (id_servicio, id_reserva) VALUES (3, 11);
INSERT INTO SERVICIO_EXTRA (id_servicio, id_reserva) VALUES (1, 1);
INSERT INTO SERVICIO_EXTRA (id_servicio, id_reserva) VALUES (2, 2);