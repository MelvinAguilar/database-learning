/* 
 * Melvin Armando Aguilar Hernandez - 00067621
 */

/* ***************************************************************************************** *
 * 								Tarea 1: administración del espacio.						 *
 * ***************************************************************************************** */

-- La primera tarea consiste en definir un espacio en disco específico para el modelo de datos
-- presentado en la sección anterior, para ello, se deberá crear una carpeta en el disco C llamada
-- “taller2”, iniciar una conexión con el usuario SYSTEM y crear el tablespace “TS_ONG”. El tablespace
-- deberá administrar 1 datafile de 8 MB, autoextendible en 4MB hasta llegar al máximo de 512 MB.
-- NOTA: No tengo windows, es docker en linux
-- Docker linux: DATAFILE '/opt/oracle/oradata/ORCLCDB/taller2/TS_ONG.DBF' SIZE 8M
-- alter session set "_ORACLE_SCRIPT"=true;
CREATE TABLESPACE TS_ONG
    -- DATAFILE 'C:\taller2\TS_ONG.DBF' SIZE 8M
    DATAFILE '/opt/oracle/oradata/ORCLCDB/TS_ONG.DBF' SIZE 8M
    AUTOEXTEND ON NEXT 4M MAXSIZE 512M;

-- NOTA cree un perfil para hacerlo mas facil.
-- Contraseña: Debe seguir y asegurar los criterios establecidos por la función: ora12c_strong_verify_function
-- Tablespace por defecto: TS_ONG
-- Tablespace temporal: TEMP
-- Cuota: Ilimitada
-- Conexiones simultaneas: 1
-- Tiempo de conexión: 30 minutos
-- Tiempo de inactividad: 5 minutos
-- Intentos fallidos de inicio de sesión: 3
-- Tiempo de bloque ante intento fallido de inicio de sesión: 3 horas
-- Cambio de contraseña cada: 60 días
CREATE PROFILE PERFIL_ONGDBA
    LIMIT SESSIONS_PER_USER 1
    CONNECT_TIME          	30
    IDLE_TIME           	5
    FAILED_LOGIN_ATTEMPTS	3
    PASSWORD_LOCK_TIME 		3/24
	  PASSWORD_LIFE_TIME 		60
	  PASSWORD_GRACE_TIME 	0
	  PASSWORD_VERIFY_FUNCTION ora12c_strong_verify_function;

-- crear al usuario “ongdba”
CREATE USER ongdba
    IDENTIFIED BY TAller02__22abd
    DEFAULT TABLESPACE TS_ONG
    TEMPORARY TABLESPACE TEMP
    QUOTA UNLIMITED ON TS_ONG
    PROFILE PERFIL_ONGDBA;
   
GRANT dba TO ongdba;
GRANT RESOURCE TO ongdba;
GRANT CONNECT TO ongdba WITH ADMIN OPTION;
GRANT CREATE SESSION TO ongdba WITH ADMIN OPTION;
GRANT CREATE TABLE TO ongdba;
GRANT CREATE PROFILE TO ongdba;

/* ***************************************************************************************** *
 * 								Tarea 2: administración de usuarios							 *
 * ***************************************************************************************** */
 

-- _Todos los usuarios que se crearán utilizarán un perfil llamado “perfil_empleado” con los siguientes parámetros:
-- Contraseña: ora12c_strong_verify_function
-- Conexiones simultaneas 10
-- Tiempo de conexión 1 hora
-- Tiempo de inactividad 10 minutos
-- Intentos fallidos de inicio de sesión 3
-- Tiempo de bloque ante intento fallido de inicio de sesión 24 horas
-- Cambio de contraseña cada 30 día

-- ALTER SESSION SET "_ORACLE_SCRIPT"=true;  
CREATE PROFILE PERFIL_EMPLEADO
    LIMIT SESSIONS_PER_USER 10
    CONNECT_TIME          	60
    IDLE_TIME           	10
    FAILED_LOGIN_ATTEMPTS	3
    PASSWORD_LOCK_TIME 		1
	  PASSWORD_LIFE_TIME 		30
	  PASSWORD_GRACE_TIME 	0
	  PASSWORD_VERIFY_FUNCTION ora12c_strong_verify_function;

-- deberán crearse los siguientes usuarios
CREATE USER director
    IDENTIFIED BY USuarios__20
    DEFAULT TABLESPACE TS_ONG
    TEMPORARY TABLESPACE TEMP
    QUOTA UNLIMITED ON TS_ONG
    PROFILE PERFIL_EMPLEADO;

CREATE USER coordinador
    IDENTIFIED BY USuarios__20
    DEFAULT TABLESPACE TS_ONG
    TEMPORARY TABLESPACE TEMP
    QUOTA 250M ON TS_ONG
    PROFILE PERFIL_EMPLEADO;
    
CREATE USER asistente
    IDENTIFIED BY USuarios__20
    DEFAULT TABLESPACE USERS
    TEMPORARY TABLESPACE TEMP
    QUOTA UNLIMITED ON USERS QUOTA 100M ON TS_ONG
    PROFILE PERFIL_EMPLEADO;

CREATE USER rrhh
    IDENTIFIED BY USuarios__20
    DEFAULT TABLESPACE USERS
    TEMPORARY TABLESPACE TEMP
    QUOTA 0M ON USERS QUOTA 100M ON TS_ONG
    PROFILE PERFIL_EMPLEADO;
  
CREATE USER rree
    IDENTIFIED BY USuarios__20
    DEFAULT TABLESPACE TS_ONG
    TEMPORARY TABLESPACE TEMP
    QUOTA 100M ON TS_ONG
    PROFILE PERFIL_EMPLEADO;


/* ***************************************************************************************** *
 * 								Tarea 3: administración de roles.							 *
 * ***************************************************************************************** */

-- Se gestionan los siguientes permisos
CREATE ROLE r_usuariobd;
GRANT CREATE SESSION TO r_usuariobd;

CREATE ROLE r_director;
GRANT CREATE SESSION TO r_director;
GRANT SELECT ANY TABLE TO r_director;
GRANT INSERT, UPDATE, DELETE ON ongdba.PROYECTO TO r_director;

CREATE ROLE r_coordinador;
GRANT CREATE SESSION TO r_coordinador;
GRANT SELECT ON ongdba.PROYECTO TO r_director; 										                    --Privilegio SELECT sobre la tabla PROYECTO
GRANT SELECT ON ongdba.EMPLEADO TO r_director;											                  --Privilegio SELECT sobre la tabla EMPLEADO
GRANT SELECT, INSERT, UPDATE, DELETE ON ongdba.PROYECTOXEMPLEADO TO r_director;		    --Privilegio SELECT, INSERT, UPDATE, DELETE sobre la tabla PROYECTOXEMPLEADO
GRANT SELECT, INSERT, UPDATE, DELETE ON ongdba.VOLUNTARIO TO r_director;				      --Privilegio SELECT, INSERT, UPDATE, DELETE sobre la tabla VOLUNTARIO
GRANT SELECT, INSERT, UPDATE, DELETE ON ongdba.PROYECTOXVOLUNTARIO TO r_director;		  --Privilegio SELECT, INSERT, UPDATE, DELETE sobre la tabla PROYECTOXVOLUNTARIO
GRANT SELECT ON ongdba.ACTIVIDAD_ASISTENTE TO r_director;								              --Privilegio SELECT sobre la tabla ACTIVIDAD_ASISTENTE
GRANT UPDATE (confirmacion_coordinador) ON ongdba.ACTIVIDAD_ASISTENTE TO r_director;	--Privilegio UPDATE sobre columna “confirmacion_coordinador” de la tabla ACTIVIDAD_ASISTENTE


CREATE ROLE r_asistente;
GRANT CREATE SESSION TO r_asistente;
GRANT SELECT, INSERT, UPDATE, DELETE ON ongdba.ACTIVIDAD_ASISTENTE TO r_asistente;								--Privilegio SELECT, DELETE sobre la tabla ACTIVIDAD_ASISTENTE
GRANT INSERT, UPDATE (id, id_proyecto, id_empleado, descripcion) ON ongdba.ACTIVIDAD_ASISTENTE TO r_asistente;	--Privilegio INSERT, UPDATE sobre las columnas “id”, “id_proyecto”, “id_empleado”, “descripcion” de la tabla ACTIVIDAD_ASISTENTE


CREATE ROLE r_rrhh;
GRANT CREATE SESSION TO r_rrhh;
GRANT SELECT, INSERT, UPDATE, DELETE ON ongdba.EMPLEADO TO r_rrhh;	--Privilegio SELECT, INSERT, UPDATE, DELETE sobre la tabla EMPLEADO
GRANT SELECT ON ongdba.CATEGORIA TO r_rrhh;						    --Privilegio SELECT sobre la tabla CATEGORIA

CREATE ROLE r_rree;
GRANT CREATE SESSION TO r_rree;
GRANT SELECT, INSERT, UPDATE, DELETE ON ongdba.DONACION TO r_rree;			    --Privilegio SELECT, INSERT, UPDATE, DELETE sobre la tabla DONACION
GRANT SELECT, INSERT, UPDATE, DELETE ON ongdba.PROYECTOXDONACION TO r_rree;	--Privilegio SELECT, INSERT, UPDATE, DELETE sobre la tabla PROYECTOXDONACION

-- Asignando roles a los usuarios
GRANT r_director TO director; 		  -- Usuario director - Rol r_director
GRANT r_coordinador TO coordinador; -- Usuario coordinador - Rol r_coordinador
GRANT r_asistente TO asistente; 	  -- Usuario asistente - Rol r_asistente
GRANT r_rrhh TO rrhh; 				      -- Usuario rrhh - Rol r_rrhh
GRANT r_rree TO rree; 				      -- Usuario rree - Rol r_rree

/* End */

/* ***************************************************************************************** *
 * 								Tarea 4. Pruebas.							 *
 * ***************************************************************************************** */

/* ---------------- Puebas de consulta ---------------- */

--El usuario rrhh:
SELECT * FROM CATEGORIA;
SELECT * FROM EMPLEADO;
INSERT INTO EMPLEADO VALUES (1,'coordinador','032131','lorem',2.5,1);
INSERT INTO EMPLEADO VALUES (2,'asistente','0321131','lorem',2.5,1);
INSERT INTO EMPLEADO VALUES (3,'test','0321131','lorem',2.5,1);
UPDATE EMPLEADO SET dui = 'DAS2' WHERE id = 1;
DELETE FROM EMPLEADO WHERE id = 3;
COMMIT;

-- El usuario director:
SELECT * FROM proyectoxdonacion;
SELECT * FROM donacion;
SELECT * FROM proyectoxvoluntario;
SELECT * FROM voluntario;
SELECT * FROM actividad_asistente;
SELECT * FROM proyectoxempleado;
SELECT * FROM proyecto;
SELECT * FROM empleado;
SELECT * FROM categoria;
INSERT INTO proyecto VALUES (1,'test','lorem','jovenes',1);
INSERT INTO proyecto VALUES (2,'evento','lorem','jovenes',1);
INSERT INTO proyecto VALUES (3,'eventotes','lorem','jovenes',1);
UPDATE proyecto SET descripcion = 'DAS2' WHERE id = 1;
DELETE FROM proyecto WHERE id = 2;
COMMIT;

-- El usuario coordinador
SELECT * FROM proyecto;
SELECT * FROM empleado;
SELECT * FROM proyectoxempleado;
INSERT INTO proyectoxempleado VALUES (1,1);
INSERT INTO proyectoxempleado VALUES (1,2);
INSERT INTO proyectoxempleado VALUES (1,3);
UPDATE proyectoxempleado SET id_empleado = 3 WHERE id_empleado = 2;
DELETE FROM proyectoxempleado WHERE id_empleado = 3;

SELECT * FROM VOLUNTARIO;
INSERT INTO VOLUNTARIO VALUES (1,'test', 'sonsonate','762632', 'entidadorg');
INSERT INTO VOLUNTARIO VALUES (2,'test2', 'sonsonate','7632132', 'entidadorg');
INSERT INTO VOLUNTARIO VALUES (3,'test3', 'ahuachapan','7626212', 'entidadorg');
UPDATE VOLUNTARIO SET nombre = 'updated' WHERE id = 1;
DELETE FROM VOLUNTARIO WHERE id = 3;

SELECT * FROM proyectoxvoluntario;
INSERT INTO proyectoxvoluntario VALUES (1,1);
UPDATE proyectoxvoluntario SET id_voluntario = 2 WHERE id_voluntario = 1;
DELETE FROM proyectoxvoluntario WHERE id_voluntario = 2;
INSERT INTO proyectoxvoluntario VALUES (1,1);

SELECT * FROM actividad_asistente;
INSERT INTO actividad_asistente VALUES (1,1,1,'desc', 1);
UPDATE actividad_asistente SET descripcion = 'new' WHERE id = 1;
DELETE FROM actividad_asistente WHERE id = 1;
INSERT INTO actividad_asistente VALUES (1,1,1,'desc', 1);

UPDATE actividad_asistente SET confirmacion_coordinador = 3 WHERE id = 1;
COMMIT;

-- El usuario asistente:
SELECT * FROM actividad_asistente;
DELETE FROM actividad_asistente WHERE id = 1;
INSERT INTO actividad_asistente VALUES (2,1,1,'descss');
UPDATE actividad_asistente SET descripcion = 'new' WHERE id = 2;
COMMIT;

-- El usuario rree:
SELECT * FROM donacion;
INSERT INTO donacion VALUES (1,(TO_DATE('2003/05/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss')),'entity');
UPDATE donacion SET entidad_donadora = 'new' WHERE id = 1;
DELETE FROM donacion WHERE id = 1;
INSERT INTO donacion VALUES (1,(TO_DATE('2003/05/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss')),'entity');
COMMIT;


SELECT * FROM proyectoxdonacion;
INSERT INTO proyectoxdonacion VALUES (1,1,22,(TO_DATE('2003/05/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss')));
UPDATE proyectoxdonacion SET cantidad = 12 WHERE id_proyecto = 1;
DELETE FROM proyectoxdonacion WHERE id_proyecto = 1;
INSERT INTO proyectoxdonacion VALUES (2,(TO_DATE('2003/05/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss')),'entity');
COMMIT;
