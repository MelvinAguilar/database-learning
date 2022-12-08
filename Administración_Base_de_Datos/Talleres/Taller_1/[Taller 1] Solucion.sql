-- ----------------------------------------------------------
-- Melvin Armando Aguilar Hernandez 00067621
-- ----------------------------------------------------------

-- ----------------------------------------------------------
-- Tarea 1. Asignación lideres
-- ----------------------------------------------------------
CREATE OR REPLACE PROCEDURE ASIGNACION_LIDERES
IS 
    id_aleatorio INT;
BEGIN
    -- Actualizar todos los lideres a nulo para evitar inconsistencias
    UPDATE INTEGRANTE SET id_lider = NULL;
    
    -- Para cada fila en equipo
    FOR fila IN (
         SELECT * FROM EQUIPO
    ) LOOP
        -- Seleccionar un integrante aleatorio
        -- Selecciona un id ordenandolo por un num aleatorio, asi si se eliminara algun integrante siempre elegira uno que exista
        SELECT RANDOM.id into id_aleatorio
        FROM( 
            SELECT id FROM INTEGRANTE
            WHERE id_equipo = fila.id
            ORDER BY DBMS_RANDOM.VALUE
        ) RANDOM
        WHERE ROWNUM = 1;
        
        -- Actualizar todos los registros de ese equipo para que tengan el id del lider
        UPDATE INTEGRANTE SET id_lider = id_aleatorio WHERE id_equipo = fila.id;
        -- Actualizar el id_lider de mi lider escogido aleatoriamente
        UPDATE INTEGRANTE SET id_lider = NULL WHERE id = id_aleatorio;
    END LOOP;
    COMMIT;
END;

EXEC ASIGNACION_LIDERES;
SELECT * FROM INTEGRANTE;


-- ----------------------------------------------------------
-- Tarea 2. Mostrando resultados
-- ----------------------------------------------------------

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
CREATE OR REPLACE FUNCTION mostrar_resultados
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
SELECT * FROM TABLE(mostrar_resultados()) ORDER BY id ;







