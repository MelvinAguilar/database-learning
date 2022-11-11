-- **********************************************************************************
-- Melvin Armando Aguilar Hernandez - 00067621
-- 
-- Base de datos fuente: Airport_Management_Databank.sql
-- **********************************************************************************


--
-- Ejercicio 1
--
-- Los clientes VIP tienen acceso a una serie de servicios adicionales en los distintos aeropuertos que visitan, 
-- por lo que se solicita que defina la lista de clientes VIP.
-- El criterio de evaluación consiste en verificar que el promedio de las reservas realizadas por un cliente sea mayor a 1799.00.
-- En la evaluación se debe tener en cuenta todos los servicios extra que incluyan los clientes en las reservas.
-- Restricción : El ejercicio debe realizarse en una consulta SELECT, sin utilizar la sentencia INTO, 
-- tablas temporales o bloques de programación (bloques anónimos, funciones o procedimientos almacenados).
--
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
    GROUP BY p.id,p.nombre,r.costo
) detalle_reserva
GROUP BY detalle_reserva.id, detalle_reserva.nombre
HAVING AVG(detalle_reserva.subtotal) > 1799.00
ORDER BY detalle_reserva.id;

--
-- Ejercicio 2
-- Cada reserva tiene una fecha en la que fue realizada, una solicitud del departamento de finanzas del consorcio
-- requiere la ganancia del mes de abril de 2021, pero los datos deben estar organizados por días. 
-- Como parte de la solicitud, se requiere que la fecha sea mostrada en un formato especial.
-- Para calcular el valor de una reserva se debe tomar en cuenta tanto el precio de la reserva como la suma de todos los servicios extras incluidos.
--
SELECT CONVERT(VARCHAR, detalle_reserva.fecha, 6) AS 'fecha', SUM(detalle_reserva.subtotal) AS 'ganancia_del_dia'
FROM (
    SELECT r.id, r.fecha, (r.costo + SUM(ISNULL(s.precio,0))) 'subtotal'
    FROM RESERVA r 
        LEFT JOIN EXTRA x 
            ON x.id_reserva = r.id
        LEFT JOIN SERVICIO s
            ON x.id_servicio = s.id
    WHERE MONTH(r.fecha) = 4
    GROUP BY r.id,r.fecha,r.costo
) detalle_reserva
GROUP BY detalle_reserva.fecha;

--
-- Ejercicio 3
-- La legislación internacional exige incluir un impuesto que depende de la clase seleccionada para cada reserva,
-- la distribución actual impone los siguientes porcentajes:
-- economica - 7 %
-- ejecutiva - 11 %
-- primera clase - 15%
--
-- Por lo que se requiere mostrar las reservas realizadas, pero incluyendo el precio de cada reserva más el impuesto 
-- aplicado según la clase. Se deben mostrar los siguientes campos: el id de la reserva, la fecha, el id de la clase, 
-- el nombre de la clase, el total de la reserva sin impuesto aplicado y el total con el impuesto aplicado. 
-- Debe recordar que el total de la reserva se define a partir del precio de la reserva 
-- más la suma de todos los servicios extras incluidos.
--
SELECT r.id 'id_reserva', r.fecha, c.id 'id_clase', c.clase, (r.costo + SUM(ISNULL(s.precio,0))) 'total_(sin_impuesto)',
    CASE 
        WHEN c.clase = 'Clase econ?mica' OR c.clase = 'Clase económica' THEN
            CAST((r.costo + SUM(ISNULL(s.precio,0))) * 1.07 AS FLOAT)
        WHEN c.clase = 'Clase ejecutiva' THEN
            CAST((r.costo + SUM(ISNULL(s.precio,0))) * 1.11 AS FLOAT)
        WHEN c.clase = 'Primera clase' THEN
            CAST((r.costo + SUM(ISNULL(s.precio,0))) * 1.15 AS FLOAT)
    END AS 'total_(con_impuesto_incluido)'
FROM RESERVA r 
    INNER JOIN CLASE c 
        ON r.id_clase = c.id
    LEFT JOIN EXTRA x 
        ON x.id_reserva = r.id
    LEFT JOIN SERVICIO s
        ON x.id_servicio = s.id
WHERE MONTH(r.fecha) = 4
GROUP BY r.id, r.fecha, c.id, c.clase, r.costo
ORDER BY r.id;
