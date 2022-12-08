-- *******************************************
-- 00067621 - Melvin Armando Aguilar Hernández
-- *******************************************

--
-- Ejercicio 1:
-- Mostrar el top 5 de los autores más populares en la primera quincena de enero de 2018. 
-- (NOTA: la popularidad de un libro se define en cuantas veces se ha vendido)
--
SELECT A.idautor, A.nombre, COUNT(FD.idfactura) ventas
FROM AUTOR A
	INNER JOIN LIBROXAUTOR LA
		ON LA.idautor = A.idautor
	INNER JOIN FACTURADETALLE FD
		ON FD.codlibro = LA.codlibro
	INNER JOIN FACTURA F
		ON F.idfactura = FD.idfactura
WHERE F.fecha BETWEEN TO_DATE('01/01/2018','DD/MM/YYYY') AND TO_DATE('15/01/2018','DD/MM/YYYY') 
GROUP BY A.idautor, A.nombre
ORDER BY ventas DESC
FETCH FIRST 5 ROWS ONLY;

--
-- Ejercicio 2:
-- Mostrar el detalle de cada factura, incluir el nombre del cliente, 
-- el título de libro, el precio y la cantidad comprada.
--
SELECT F.idfactura, F.fecha, C.nombre nombre_cliente, L.titulo titulo_libro, L.precio, fd.cantidad
FROM FACTURA F, facturadetalle FD, CLIENTE C, LIBRO L
WHERE C.idcliente = F.idcliente
	AND F.idfactura = FD.idfactura 
	AND L.codlibro = FD.codlibro
ORDER BY f.idfactura ASC, L.precio DESC;

--
-- Ejercicio 3:
-- Mostrar la lista de facturas con el precio total resultante de realizar el siguiente cálculo.
-- NOTA: Muestra total como multiplicación de precio y cantidad
--
SELECT F.idfactura, F.fecha, C.nombre nombre_cliente, SUM( L.precio * FD.cantidad ) total
FROM FACTURA F, facturadetalle FD, CLIENTE C, LIBRO L
WHERE C.idcliente = F.idcliente
	AND F.idfactura = FD.idfactura
	AND L.codlibro = FD.codlibro
GROUP BY F.idfactura, F.fecha, C.nombre
ORDER BY F.idfactura;

--
-- Ejercicio 4
-- Definir la lista de clientes frecuentes del mes. Para ello, es necesario definir la cantidad de libros
-- que cada cliente ha comprado, un cliente se considera frecuente si ha comprado 10 o más libros.
--
SELECT C.idcliente, C.nombre, COUNT(FD.codlibro) CANTIDAD
FROM CLIENTE C, FACTURA F, FACTURADETALLE FD
WHERE F.idcliente = C.idcliente 
	AND FD.idfactura = F.idfactura 
GROUP BY C.idcliente, C.nombre
HAVING COUNT(FD.codlibro) >= 10
ORDER BY C.nombre;
