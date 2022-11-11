-- **********************************************************************************
-- Melvin Armando Aguilar Hernandez - 00067621
-- 
-- Base de datos fuente: Airport_Management_Databank.sql
-- **********************************************************************************

--
-- Ejercicio 1
-- Crear una función que reciba como parámetros 2 fechas y que retorne una tabla.
-- La función deberá retornar el detalle de los vuelos en ese rango de fechas, incluyendo el nombre de los aeropuertos de destino 
-- y origen, así como el avión que se utilizará para realizar el vuelo.
--
CREATE OR ALTER FUNCTION DETALLE_VUELOS(@from VARCHAR(10), @to VARCHAR(10))
RETURNS TABLE
AS RETURN 
    SELECT V.id, AO.nombre AS 'aeropuero_origen', AD.nombre AS 'aeropuero_destino', 
    V.fecha_salida, V.fecha_llegada, A.avion AS 'avion'
    FROM VUELO V
        INNER JOIN AEROPUERTO AO
            ON V.id_origen = AO.id
        INNER JOIN AEROPUERTO AD 
            ON V.id_destino = AD.id
        INNER JOIN AVION A
            ON V.id_avion = A.id
        WHERE 
            ((CONVERT(DATE, @from, 103) >= V.fecha_salida AND CONVERT(DATE, @to, 103) <= V.fecha_llegada) OR
            (CONVERT(DATE, @from, 103) < V.fecha_salida AND CONVERT(DATE, @to, 103) > V.fecha_llegada ) OR
            (CONVERT(DATE, @from, 103) < V.fecha_salida AND (CONVERT(DATE, @to, 103) BETWEEN V.fecha_salida AND V.fecha_llegada)) OR
            ((CONVERT(DATE, @from, 103) BETWEEN V.fecha_salida AND V.fecha_llegada) AND CONVERT(DATE, @to, 103) > V.fecha_llegada))

-- SELECT * FROM dbo.DETALLE_VUELOS('01/05/2021','06/05/2021');




--
-- Ejercicio 2
-- 
-- ALTER TABLE PASAJERO ADD vip INT; -- ****** agregar nueva columna ******
--
-- Los clientes VIP tienen acceso a una serie de servicios adicionales en los distintos aeropuertos que visitan,
-- por lo que se solicita que defina la lista de clientes VIP. El criterio de evaluación consiste en verificar que el promedio 
-- de las reservas realizadas por un cliente sea mayor a 1799.00. 
-- En la evaluación se debe tener en cuenta todos los servicios extra que incluyan los clientes en las reservas.
--
-- Actualizar la tabla PASAJERO incluyendo una columna con el nombre VIP de tipo entero, actualizar con “0” a la columna VIP 
-- de todos los pasajeros. Crear un procedimiento almacenado que calcule la lista de pasajeros VIP que almacenará en un cursor 
-- (Se sugiere realizar este paso basándose en el criterio y solución del ejercicio 1 del laboratorio 4), 
-- luego, el procedimiento almacenado recorrerá el cursor y actualizará la columna VIP de todos los pasajeros en la tabla PASAJERO con el valor de “1”.
--
CREATE OR ALTER PROCEDURE ACTUALIZAR_VIP
AS
BEGIN
    --Decaracion de variables
    DECLARE @condicion INT;
    DECLARE @id INT, @nombre VARCHAR(50), @promedio_reserva FLOAT;

    DECLARE CURSOR_PASAJEROS CURSOR FOR
        SELECT detalle_reserva.id 'id_pasajero', detalle_reserva.nombre 'nombre_pasajero', 
            AVG(detalle_reserva.subtotal) 'promedio_de_reservas'
        FROM (
            SELECT p.id, p.nombre, (r.costo + SUM(ISNULL(s.precio,0))) 'subtotal'
            FROM RESERVA r 
                INNER JOIN PASAJERO p
                    ON r.id_pasajero = p.id
                LEFT JOIN EXTRA x 
                    ON x.id_reserva = r.id
                LEFT JOIN SERVICIO s
                    ON x.id_servicio = s.id
            GROUP BY p.id,p.nombre, r.costo
        ) detalle_reserva
        GROUP BY detalle_reserva.id, detalle_reserva.nombre
        HAVING AVG(detalle_reserva.subtotal) > 1799.00
        ORDER BY detalle_reserva.id;

    -- Procesamiento de datos
    UPDATE PASAJERO SET vip = 0;

    SELECT @condicion = COUNT(id) FROM PASAJERO;

    OPEN CURSOR_PASAJEROS;
    WHILE @condicion > 0 BEGIN
        FETCH CURSOR_PASAJEROS INTO @id, @nombre, @promedio_reserva;
        UPDATE PASAJERO SET vip = 1 WHERE id = @id;
        SET @condicion = @condicion - 1;
    END;
    CLOSE CURSOR_PASAJEROS;
    DEALLOCATE CURSOR_PASAJEROS;
END;

-- EXEC ACTUALIZAR_VIP;
-- SELECT * FROM PASAJERO;
