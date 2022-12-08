-- *******************************************
-- 00067621 - Melvin Armando Aguilar Hernández
-- *******************************************

---------------
-- Ejercicio 1
---------------
-- Usuario: "admin" (ejemplo admin00091610) 
-- Password: elegido por el estudiante 
-- Tablespace por defecto: USERS Cuota: 10M Tablespace tempora: TEMP
CREATE USER admin00067621 
    IDENTIFIED BY admin00067621 
    DEFAULT TABLESPACE USERS 
    TEMPORARY TABLESPACE TEMP 
    QUOTA 10M ON USERS;

-- Usuario 2: Usuario: "aux" (ejemplo aux00091610) 
-- Password: elegido por el estudiante 
-- Tablespace por defecto: USERS 
-- Cuota: 10M Tablespace tempora: TEMP
CREATE USER aux00067621 
    IDENTIFIED BY aux00067621 
    DEFAULT TABLESPACE USERS 
    TEMPORARY TABLESPACE TEMP 
    QUOTA 10M ON USERS;

-- Asignar los siguientes privilegios: 
-- Crear sesión a ambos usuarios y Crear tablas al usuario admin
GRANT CREATE SESSION TO admin00067621;
GRANT CREATE SESSION TO aux00067621;
GRANT CREATE TABLE TO admin00067621;

-- Activar la auditoria de sesión para los usuarios creados en el punto 1.
AUDIT SESSION BY admin00067621;
AUDIT SESSION BY aux00067621;

-- Sin cerrar la conexión del usuario SYS (la utilizaremos más adelante),
-- iniciar una conexión con el usuario admin creado en el punto 1.
-- Verificar desde la conexión del usuario SYS la vista dba_audit_trail.
SELECT USERNAME, EXTENDED_TIMESTAMP, ACTION_NAME, COMMENT_TEXT, PRIV_USED
FROM DBA_AUDIT_TRAIL
WHERE USERNAME = 'ADMIN00067621'
ORDER BY EXTENDED_TIMESTAMP ASC;

-- Verificar desde la conexión del usuario admin el de la siguiente instrucción:
SELECT USERNAME, USERHOST, EXTENDED_TIMESTAMP, ACTION_NAME
FROM USER_AUDIT_SESSION
ORDER BY EXTENDED_TIMESTAMP ASC;

---------------
-- Ejercicio 2
---------------

-- En la conexión del usuario SYS: auditar la creación de tablas al usuario admin.
AUDIT CREATE ANY TABLE BY admin00067621;

-- En la conexión del usuario admin, crear el siguiente modelo de datos.
CREATE TABLE ESCRITOR(
    id INT PRIMARY KEY,
    nombre VARCHAR2(50),
    fecha_nacimiento DATE NULL,
    fecha_muerte DATE NULL
);

CREATE TABLE OBRA(
    id INT PRIMARY KEY,
    titulo VARCHAR2(50),
    fecha_edicion DATE,
    precio FLOAT
);

CREATE TABLE OBRAXESCRITOR(
    id_obra INT NOT NULL,
    id_escritor INT NOT NULL
);

-- Insertar datos en las tablas principales.
INSERT INTO ESCRITOR VALUES(1, 'Ahmed Hancock', '25-10-1963', '30-04-1991');
INSERT INTO ESCRITOR VALUES(2, 'Stella Eaton', '20-2-1977', '30-01-1995');
INSERT INTO ESCRITOR VALUES(3, 'Richard Mccarthy' , '30-09-1965', '11-02-1994');
INSERT INTO OBRA VALUES(1, 'convallis', '25-01-2017' , 35.86);
INSERT INTO OBRA VALUES(2, 'ut', '03-05-2010' , 63.44);
INSERT INTO OBRA VALUES(3, 'bibedum', '21-02-2017', 56.09);
INSERT INTO OBRA VALUES(4, 'egestas rhoncus', '15-03-2011' , 37.04);
INSERT INTO OBRA VALUES(5, 'euismod', '23-09-2013' , 39.05);
COMMIT;

-- En la conexión del usuario SYS, realizar la siguiente consulta para verificar 
-- los registros generados por el usuario.
SELECT OBJ_NAME, ACTION_NAME, OS_USERNAME, PRIV_USED, USERNAME, USERHOST,
    TIMESTAMP, OWNER, EXTENDED_TIMESTAMP, SCN
FROM DBA_AUDIT_OBJECT
WHERE USERNAME = 'ADMIN00067621';


---------------
-- Ejercicio 3
---------------

-- En la conexión del usuario SYS: Auditar por acceso las acciones con resultado exitoso o no,
-- de las consultas SELECT, INSERT, DELETE y UPDATE sobre las tablas: ESCRITOR, OBRA; OBRAXESCRITOR.
AUDIT SELECT, INSERT, DELETE, UPDATE ON ADMIN00067621.ESCRITOR BY ACCESS WHENEVER SUCCESSFUL;
AUDIT SELECT, INSERT, DELETE, UPDATE ON ADMIN00067621.ESCRITOR BY ACCESS WHENEVER NOT SUCCESSFUL;

AUDIT SELECT, INSERT, DELETE, UPDATE ON ADMIN00067621.OBRA BY ACCESS WHENEVER SUCCESSFUL;
AUDIT SELECT, INSERT, DELETE, UPDATE ON ADMIN00067621.OBRA BY ACCESS WHENEVER NOT SUCCESSFUL;

AUDIT SELECT, INSERT, DELETE, UPDATE ON ADMIN00067621.OBRAXESCRITOR BY ACCESS WHENEVER SUCCESSFUL;
AUDIT SELECT, INSERT, DELETE, UPDATE ON ADMIN00067621.OBRAXESCRITOR BY ACCESS WHENEVER NOT SUCCESSFUL;

-- Desde la conexión del usuario admin, otorgar los siguientes permisos al usuario aux:
-- SELECT sobre las tablas OBRA y ESCRITOR
-- SELECT, INSERT, DELETE y UPDATE sobre la tabla OBRAXESCRITOR.
GRANT SELECT ON ADMIN00067621.OBRA TO AUX00067621;
GRANT SELECT ON ADMIN00067621.ESCRITOR TO AUX00067621;
GRANT SELECT, INSERT, DELETE, UPDATE ON ADMIN00067621.OBRAXESCRITOR TO AUX00067621;

-- Iniciar una conexión con el usuario aux y consultar las tablas OBRA, ESCRITOR y OBRAXESCRITOR.
SELECT * FROM ADMIN00067621.OBRA;
SELECT * FROM ADMIN00067621.ESCRITOR;
SELECT * FROM ADMIN00067621.OBRAXESCRITOR;

-- En la conexión del usuario aux, insertar los siguientes datos en la tabla OBRAXESCRITOR:
INSERT INTO ADMIN00067621.OBRAXESCRITOR VALUES(1, 1);
INSERT INTO ADMIN00067621.OBRAXESCRITOR VALUES(2, 2);
INSERT INTO ADMIN00067621.OBRAXESCRITOR VALUES(3, 3);
INSERT INTO ADMIN00067621.OBRAXESCRITOR VALUES(3, 2);
INSERT INTO ADMIN00067621.OBRAXESCRITOR VALUES(4, 2);
INSERT INTO ADMIN00067621.OBRAXESCRITOR VALUES(4, 3);
INSERT INTO ADMIN00067621.OBRAXESCRITOR VALUES(5, 3);
INSERT INTO ADMIN00067621.OBRAXESCRITOR VALUES(1, 1);
COMMIT;

-- En la conexión del usuario SYS, realizar la siguiente consulta para verificar los registros
-- generados por el usuario.
SELECT OBJ_NAME, ACTION_NAME, RETURNCODE, OS_USERNAME, PRIV_USED, USERNAME,
    USERHOST, TIMESTAMP, OWNER, EXTENDED_TIMESTAMP, SCN
FROM DBA_AUDIT_OBJECT
WHERE OBJ_NAME IN ('ESCRITOR', 'OBRA', 'OBRAXESCRITOR')
ORDER BY EXTENDED_TIMESTAMP DESC;

-- En la conexión del usuario SYS, auditar todas las acciones sobre la tabla OBRA:
AUDIT ALL ON ADMIN00067621.OBRA BY ACCESS;
