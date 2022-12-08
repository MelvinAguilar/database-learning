-- ----------------------------------------------------------
-- Melvin Armando Aguilar Hernandez 00067621
-- ----------------------------------------------------------

-- ----------------------------------------------------------------------------------------
-- ----------------------------------   EJERCICIO 1   -------------------------------------
-- ----------------------------------------------------------------------------------------

-- *****************************************************
-- TAREA 1.1. Asignación de aeropuertos de coordinación
-- *****************************************************

CREATE OR REPLACE PROCEDURE asignar_aeropuertos_coordinacion(
    id_aeropuerto_1 INT,
    id_aeropuerto_2 INT,
    id_aeropuerto_3 INT
) IS
    id_aleatorio INT;
    -- Cursor
    CURSOR cursor_aeropuertos IS
        SELECT id
        FROM aeropuerto;
    fila cursor_aeropuertos%ROWTYPE;
BEGIN 
    -- Actualizar todos los lideres a nulo para evitar inconsistencias
    UPDATE AEROPUERTO SET id_principal = NULL;

    -- Recorrer todos los registros de la tabla aeropuerto
    OPEN cursor_aeropuertos;
    LOOP
        FETCH cursor_aeropuertos INTO fila;
        EXIT WHEN cursor_aeropuertos%NOTFOUND;
        -- entre los 3 aeropuertos, asignar uno aleatoriamente
        id_aleatorio := DBMS_RANDOM.VALUE(1, 3);

        -- Si el aeropuerto no es alguno de los 3 seleccionados, asignar el id del aeropuerto coordinaddor aleatorio
        IF fila.id NOT IN (id_aeropuerto_1, id_aeropuerto_2, id_aeropuerto_3) THEN
            UPDATE AEROPUERTO SET id_principal = CASE
                WHEN id_aleatorio = 1 THEN id_aeropuerto_1
                WHEN id_aleatorio = 2 THEN id_aeropuerto_2
                WHEN id_aleatorio = 3 THEN id_aeropuerto_3
            END WHERE id = fila.id;
        END IF;
    END LOOP;
    CLOSE cursor_aeropuertos;
END;

-- Ejecucion
EXEC asignar_aeropuertos_coordinacion(1, 2, 5);
SELECT * FROM AEROPUERTO;


-- *****************************************************
-- TAREA 1.2. Mostrando resultados.
-- *****************************************************

-- [1]: crear un tipo de dato "fila" para almacenar cada una de las filas de la consulta
CREATE OR REPLACE TYPE fila_aeropuerto AS OBJECT (
    id INT,
    aeropuerto VARCHAR2(50),
    pais VARCHAR2(50),
    id_coordinador INT,
    aeropuerto_coordinador VARCHAR2(50)
);

-- [2]: crear un tipo de dato "coleccion" para almacenar las filas que creamos en el paso 1
CREATE OR REPLACE TYPE colecion_fila_aeropuerto AS TABLE OF fila_aeropuerto;


-- [3]: crear la funcion que va a recorrer la consulta y va a crear cada fila
CREATE OR REPLACE FUNCTION mostrar_aeropuertos_coordinados(
    id_coordinador INT
) RETURN colecion_fila_aeropuerto PIPELINED
IS
BEGIN
    FOR fila IN (
        SELECT A.id, A.nombre aeropuerto, P.nombre pais, A.id_principal, COORDINADOR.nombre aeropuerto_coordinador
        FROM AEROPUERTO A
            INNER JOIN PAIS P 
                ON A.id_pais = P.id
            INNER JOIN AEROPUERTO COORDINADOR 
                ON A.id_principal = COORDINADOR.id
        WHERE A.id_principal = id_coordinador
    ) LOOP
        PIPE ROW( fila_aeropuerto(fila.id, fila.aeropuerto, fila.pais, 
            fila.id_principal, fila.aeropuerto_coordinador) );
    END LOOP;
END;

-- [4]: mostrar la coleccion teniendo en cuenta que es necesario hacer casting explicito de la "coleccion" a formato "tabla"
SELECT * FROM TABLE(mostrar_aeropuertos_coordinados(2)) ORDER BY id ; --El numero 2 puede cambiar


-- ----------------------------------------------------------------------------------------
-- ----------------------------------   EJERCICIO 2   -------------------------------------
-- ----------------------------------------------------------------------------------------

-- *****************************************************
-- TAREA 2.1. Asignación lideres
-- *****************************************************


CREATE OR REPLACE PROCEDURE ASIGNACION_LIDERES
IS 
    id_aleatorio INT;
    -- Cursor
    CURSOR cursor_equipos IS
        SELECT id
        FROM equipo;
    fila cursor_equipos%ROWTYPE;
BEGIN
    -- Actualizar todos los lideres a nulo para evitar inconsistencias
    UPDATE INTEGRANTE SET id_lider = NULL;

    -- Recorrer todos los equipos
    OPEN cursor_equipos;
    LOOP
        FETCH cursor_equipos INTO fila;
        EXIT WHEN cursor_equipos%NOTFOUND;
        
        -- Seleccionar un integrante aleatorio
        SELECT id INTO id_aleatorio FROM (
            SELECT id 
            FROM INTEGRANTE 
            WHERE id_equipo = fila.id 
            ORDER BY DBMS_RANDOM.RANDOM
        ) WHERE ROWNUM = 1;
        
         -- Actualizar todos los registros de ese equipo para que tengan el id del lider, mientras no sea el lider
        UPDATE INTEGRANTE SET id_lider = id_aleatorio WHERE id_equipo = fila.id AND id <> id_aleatorio;
    END LOOP;
    CLOSE cursor_equipos;
END;

-- Ejecucion
EXEC ASIGNACION_LIDERES;
SELECT * FROM INTEGRANTE;

-- *****************************************************
-- TAREA 2.2 Mostrando resultados.
-- *****************************************************

-- [1]: crear un tipo de dato "fila" para almacenar cada una de las filas de la consulta
CREATE OR REPLACE TYPE fila_integrante AS OBJECT (
    id INT, 
    nombre VARCHAR(64), 
    oficina INT, 
    id_cargo INT,  
    id_equipo INT,
    nombre_equipo VARCHAR2(32),
    id_lider INT,
    nombre_lider VARCHAR(64)
);

-- [2]: crear un tipo de dato "coleccion" para almacenar las filas que creamos en el paso 1
CREATE OR REPLACE TYPE colecion_fila_integrante AS TABLE OF fila_integrante;

-- [3]: crear la funcion que va a recorrer la consulta y va a crear cada fila
CREATE OR REPLACE FUNCTION mostrar_integrantes
RETURN colecion_fila_integrante PIPELINED
IS
BEGIN
    FOR fila IN (
        SELECT I.id, I.nombre, I.oficina, I.id_cargo, E.id ID_EQUIPO, E.nombre NOMBRE_EQUIPO, 
            I.id_lider, LIDER.nombre NOMBRE_LIDER
        FROM INTEGRANTE I
            INNER JOIN EQUIPO E
                ON I.id_equipo = E.id
            LEFT JOIN INTEGRANTE LIDER
                ON I.id_lider = LIDER.id
        ORDER BY I.id
    ) LOOP
        PIPE row( fila_integrante(fila.id, fila.nombre, fila.oficina, fila.id_cargo, 
            fila.id_equipo, fila.nombre_equipo, fila.id_lider, fila.nombre_lider) );
    END LOOP;
END;

-- [4]: mostrar la coleccion teniendo en cuenta que es necesario hacer casting explicito de la "coleccion" a formato "tabla"
SELECT * FROM TABLE(mostrar_integrantes()) ORDER BY id ;


-- ----------------------------------------------------------------------------------------
-- ----------------------------------   EJERCICIO 3   -------------------------------------
-- ----------------------------------------------------------------------------------------

-- *****************************************************
-- TAREA 3.1. Asignación de rutas.
-- *****************************************************


CREATE OR REPLACE PROCEDURE ASIGNACION_RUTAS
IS
    id_aleatorio_origen INT;
    id_aleatorio_destino INT;
    area_origen INT;
    area_destino INT;
    -- Cursor
    CURSOR cursor_ambulancias IS
        SELECT id
        FROM ambulancia;
    fila cursor_ambulancias%ROWTYPE;
BEGIN
    -- Actualizar todos los hospitales a nulo para evitar inconsistencias
    UPDATE AMBULANCIA SET id_origen = NULL, id_destino = NULL;

    -- Recorrer todas las ambulancias
    OPEN cursor_ambulancias;
    LOOP
        FETCH cursor_ambulancias INTO fila;
        EXIT WHEN cursor_ambulancias%NOTFOUND;
            
        -- Seleccionar un hospital aleatorio para el origen
        SELECT id INTO id_aleatorio_origen FROM (
            SELECT id 
            FROM HOSPITAL 
            ORDER BY DBMS_RANDOM.RANDOM
        ) WHERE ROWNUM = 1;

        -- Seleccionar un hospital aleatorio para el destino
        SELECT id INTO id_aleatorio_destino FROM (
            SELECT id 
            FROM HOSPITAL 
            ORDER BY DBMS_RANDOM.RANDOM
        ) WHERE ROWNUM = 1;

        -- Seleccionar el area del hospital de origen
        SELECT area INTO area_origen FROM HOSPITAL WHERE id = id_aleatorio_origen;

        -- Seleccionar el area del hospital de destino
        SELECT area INTO area_destino FROM HOSPITAL WHERE id = id_aleatorio_destino;

        -- Validar que el origen y el destino sean diferentes y ademas que sean de distintas areas
        WHILE (id_aleatorio_origen = id_aleatorio_destino OR area_origen = area_destino) LOOP
            -- Seleccionar otro hospital aleatorio para el destino y area hasta que se cumpla la condicion
            SELECT id, area INTO id_aleatorio_destino, area_destino FROM (
                SELECT id, area
                FROM HOSPITAL 
                ORDER BY DBMS_RANDOM.RANDOM
            ) WHERE ROWNUM = 1;
        END LOOP;

        -- Actualizar la ambulancia con el origen y el destino
        UPDATE AMBULANCIA SET id_origen = id_aleatorio_origen, id_destino = id_aleatorio_destino WHERE id = fila.id;
    END LOOP;
    CLOSE cursor_ambulancias;
END;

-- Ejecucion
EXEC ASIGNACION_RUTAS;
SELECT * FROM AMBULANCIA;


-- *****************************************************
-- TAREA 3.2. Mostrando resultados.
-- *****************************************************


-- [1]: crear un tipo de dato "fila" para almacenar cada una de las filas de la consulta
CREATE OR REPLACE TYPE fila_ambulancia AS OBJECT (
    id INT,
    placa CHAR(6),
    id_conductor INT,
    id_origen INT,
    hospital_origen VARCHAR2(256),
    id_destino INT,
    hospital_destino VARCHAR2(256)
);


-- [2]: crear un tipo de dato "coleccion" para almacenar las filas que creamos en el paso 1
CREATE OR REPLACE TYPE colecion_fila_ambulancia AS TABLE OF fila_ambulancia;

-- [3]: crear la funcion que va a recorrer la consulta y va a crear cada fila
CREATE OR REPLACE FUNCTION mostrar_rambulancias
RETURN colecion_fila_ambulancia PIPELINED
IS
BEGIN
    FOR fila IN (
        SELECT A.id, A.placa, A.id_conductor, 
        A.id_origen, ORIGEN.nombre AS hospital_origen,
        A.id_destino, DESTINO.nombre AS hospital_destino
        FROM AMBULANCIA A
            INNER JOIN HOSPITAL ORIGEN ON A.id_origen = ORIGEN.id
            INNER JOIN HOSPITAL DESTINO ON A.id_destino = DESTINO.id
        ORDER BY A.id
    ) LOOP
        PIPE row( fila_ambulancia(fila.id, fila.placa, fila.id_conductor, fila.id_origen,
         fila.hospital_origen, fila.id_destino, fila.hospital_destino) );
    END LOOP;
END;

-- [4]: mostrar la coleccion teniendo en cuenta que es necesario hacer casting explicito de la "coleccion" a formato "tabla"
SELECT * FROM TABLE(mostrar_rambulancias()) ORDER BY id;


-- ----------------------------------------------------------------------------------------
-- ----------------------------------   EJERCICIO 4   -------------------------------------
-- ----------------------------------------------------------------------------------------

-- *****************************************************
-- TAREA 4.1. Asignación de coordinador de equipos
-- *****************************************************
CREATE OR REPLACE PROCEDURE asignar_coordinador
IS
    id_coordinador_aleatorio INT;
    id_coordinador_vigilante INT; -- Guardar el ID del vigilante que se selecciono como coordinador
    -- Cursor
    CURSOR cursor_vigilantes IS
        SELECT id
        FROM VIGILANTE;
    fila cursor_vigilantes%ROWTYPE;
BEGIN
    -- [CASO LIMPIAR*] Actualizar todos los registros de la tabla VIGILANTE con el valor NULL en el campo ID_COORDINADOR
    UPDATE VIGILANTE SET id_coordinador = NULL;

    OPEN cursor_vigilantes;
    LOOP
        FETCH cursor_vigilantes INTO fila;
        EXIT WHEN cursor_vigilantes%NOTFOUND;
        
        -- Seleccionar un coordinador aleatorio
        SELECT id, id_coordinador INTO id_coordinador_aleatorio, id_coordinador_vigilante FROM (
            SELECT id, id_coordinador
            FROM VIGILANTE
            WHERE id_categoria IN (4, 5) AND id <> fila.id
            ORDER BY DBMS_RANDOM.RANDOM
        ) WHERE ROWNUM = 1;
        
        -- Actualizar el campo ID_COORDINADOR del vigilante
        UPDATE VIGILANTE SET id_coordinador = id_coordinador_aleatorio WHERE id = fila.id;

        -- Si el vigilante seleccionado aletatoriamente como coordinador tiene un un coordinador, lo elimino para evitar jerarquias
       IF id_coordinador_vigilante IS NOT NULL THEN
            UPDATE VIGILANTE SET id_coordinador = NULL WHERE id = id_coordinador_aleatorio;
        END IF;
    END LOOP;
    CLOSE cursor_vigilantes;
END;

-- Ejecucion
EXEC asignar_coordinador;
SELECT * FROM VIGILANTE;


-- *****************************************************
-- TAREA 4.2. Registrando coordinadores.
-- *****************************************************

CREATE OR REPLACE TRIGGER registro_coordinadores
AFTER UPDATE OF ID_COORDINADOR ON VIGILANTE
FOR EACH ROW
DECLARE 
    id_vigilante_registrado INT;
BEGIN
    -- Si al actualizar estoy seleccionando un nuevo coordinador y no limpiendo como en [CASO LIMPIAR*] del procedimiento
    IF :NEW.ID_COORDINADOR IS NOT NULL THEN
        BEGIN
            -- Selecciono si ya existe en el registro
            SELECT coordinador INTO id_vigilante_registrado 
            FROM REGISTRO_COORDINADORES 
            WHERE coordinador = :NEW.ID_COORDINADOR;
        EXCEPTION
            -- Si genera error es porque no tiene registros la tabla de ese coordinador y establezco a null su valor
            WHEN NO_DATA_FOUND THEN
            id_vigilante_registrado := NULL;
        END;
        
        -- Si no existe el vigilante en REGISTRO_COORDINADORES lo agrego
        IF id_vigilante_registrado IS NULL THEN
            INSERT INTO REGISTRO_COORDINADORES VALUES (:NEW.ID_COORDINADOR, SYSDATE);
        END IF;
    END IF;
END;

-- Revisar registros
SELECT * FROM REGISTRO_COORDINADORES;

