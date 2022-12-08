-- *******************************************
-- 00067621 - Melvin Armando Aguilar Hernández
-- *******************************************

-- ****************************************************************************
-- Ejercicio 1
-- 1)  Crear una función que reciba como parámetros dos números enteros, el primer parámetro 
--     "venta_objetivo" puede tomar el valor de 5, 10 o 15. El segundo "descuento",
--     se trata de un numero flotante que puede tomar los valores 0.1, 0.15 o 0.20. 
--     La función deberá mostrar la siguiente información de las compras: el id de la factura, 
--     el id y nombre del cliente, el id y nombre del empleado, la fecha de la compra y el total de la compra.
--     Además, se debe incluir un criterio extra: para cada compra que cumpla con la cantidad de libros comprados
--     en la "venta_objetivo" o más, se aplicará un valor establecido en el parámetro "descuento".
--     Por ejemplo, si los parámetros son (5, 0.1), a todas las facturas que tengan una compra de al menos 5 libros
--     se les aplicará un 10% de descuento. La columna muestra el descuento aplicable en cada factura.
-- ****************************************************************************

-- [1]: crear un tipo de dato "fila" para almacenar cada una de las filas de la consulta
CREATE OR REPLACE TYPE fila_fact_descuento AS OBJECT (
    idfactura INT,
    idcliente INT,
    nombre VARCHAR2(64),
    fecha DATE,
    libros_comprados INT,
    total FLOAT,
    total_descuento FLOAT
);

-- [2]: crear un tipo de dato "coleccion" para almacenar las filas que creamos en el paso 1
CREATE OR REPLACE TYPE coleccion_fact_descuento AS TABLE OF fila_fact_descuento;

-- [3]: crear la funcion que va a recorrer la consulta y va a crear cada fila
CREATE OR REPLACE FUNCTION factura_descuento
   (venta_objetivo INT, descuento FLOAT)
RETURN coleccion_fact_descuento PIPELINED
IS
    descuento_valor FLOAT;
BEGIN
    FOR fila IN (
        SELECT F.idfactura, F.idcliente, C.nombre, F.fecha, SUM(fd.cantidad) libros_comprados, SUM(fd.cantidad*L.precio) total
        FROM FACTURA F, facturadetalle FD ,CLIENTE C, LIBRO L
        WHERE F.idcliente = C.idcliente 
            AND FD.idfactura = F.idfactura
            AND L.codlibro = FD.codlibro
        GROUP BY F.idfactura, F.idcliente, C.nombre, F.fecha
    ) LOOP
        descuento_valor := 0;
        IF fila.libros_comprados >= venta_objetivo THEN
            descuento_valor := fila.total * descuento;
        END IF;
        
        PIPE row( fila_fact_descuento( fila.idfactura, fila.idcliente, fila.nombre, fila.fecha, fila.libros_comprados, fila.total, descuento_valor ) );
    END LOOP;
END;

-- [4]: mostrar la coleccion teniendo en cuenta que es necesario hacer casting explicito de la "coleccion" a formato "tabla"
SELECT * FROM TABLE(factura_descuento(10, 0.1)) ORDER BY idfactura;
