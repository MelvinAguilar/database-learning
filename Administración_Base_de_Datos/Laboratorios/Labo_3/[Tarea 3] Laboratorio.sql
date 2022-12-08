-- *******************************************
-- 00067621 - Melvin Armando Aguilar Hernández
-- *******************************************

SELECT * FROM DBA_TABLESPACES;
SELECT * FROM DBA_DATA_FILES;

-- 1)   Crear un tablespace auto expandible, asignar un datafile de 8 megabytes 
--      y que será guardado en el disco C. El tamaño máximo será de 36 Megabytes 
--      con extensiones de 4 Megabytes.
-- Docker linux: DATAFILE '/opt/oracle/oradata/ORCLCDB/datafile_lb3.dbf' SIZE 8M
CREATE TABLESPACE TB_00067621
    DATAFILE 'C:/datafile_lb3.dbf' SIZE 8M
    AUTOEXTEND ON NEXT 4M MAXSIZE 36M;
    
-- 2)   Añadir un nuevo datafile al tablespace creado en el ejercicio 1. 
--      El tamaño será 10 Megabytes y será almacenado en el disco C
-- Docker linux: ADD DATAFILE '/opt/oracle/oradata/ORCLCDB/datafile_lb3_2.dbf' SIZE 10M AUTOEXTEND OFF;
ALTER TABLESPACE TB_00067621
    ADD DATAFILE 'C:/datafile_lb3_2.dbf' SIZE 10M AUTOEXTEND OFF;
    
-- 3)   Redimensionar el segundo datafile creado a 16 Megabytes. 
-- Docker linux: ALTER DATABASE DATAFILE '/opt/oracle/oradata/ORCLCDB/datafile_lb3_2.dbf' RESIZE 16M;
ALTER DATABASE DATAFILE 'C:/datafile_lb3_2.dbf' RESIZE 16M;

-- 4)   Crear un usuario, Asignar como tablespace por defecto el creado en el ejercicio 1, 
--      y como tablespace temporal "TEMP". Definir una cuota de 5MB de uso de espacio 
--      en el tablespace por defecto.
-- ALTER SESSION SET "_ORACLE_SCRIPT"=true;  
CREATE USER user00067621
    IDENTIFIED BY pass123
    DEFAULT TABLESPACE TB_00067621
    TEMPORARY TABLESPACE TEMP
    QUOTA 5M ON TB_00067621;

-- 5)   Crear Rol "programador" y asignar privilegios:
--      - Poder conectarse a la base de datos (CONNECT).
--      - Poder crear objetos (RESOURCE).
--      Asignar el rol al usuario creado en el ejercicio 4.
CREATE ROLE Programador;

GRANT CONNECT, RESOURCE TO Programador;
GRANT Programador TO user00067621;

-- 6. Crear el perfil FCLD con los siguientes parámetros:
-- Máximo número de intentos de login: 5.
-- Tiempo de vida de la contraseña: 60.
-- Número máximo de reutilización de una contraseña: 3.
-- Tiempo de gracia de una contraseña: 5.
CREATE PROFILE FCLD
    LIMIT FAILED_LOGIN_ATTEMPTS 5
    PASSWORD_LIFE_TIME          60
    PASSWORD_REUSE_MAX          5
    PASSWORD_GRACE_TIME         5;

ALTER USER user00067621 PROFILE FCLD;
