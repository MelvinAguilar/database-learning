-- ***************************************************************************
-- Consultas para el módulo de Ejemplares en el proyecto final de BDD y POO
-- Base de datos y población en: ProyectoBDD_POO_Databank.sql
-- 	    00067621 - Melvin Aguilar
-- ***************************************************************************

-- Todos
SELECT e.id, e.nombre, e.imagen, e.isbn, e.issn, e.doi, e.fecha_publicacion,
    ed.editorial, f.formato, i.idioma, c.nombre
FROM EJEMPLAR e
    INNER JOIN EDITORIAL ed
        ON e.id_editorial = ed.id
    INNER JOIN FORMATO f
        ON e.id_formato = f.id
    INNER JOIN IDIOMA i
        ON e.id_idioma = i.id
    INNER JOIN COLECCION c
        ON e.id_coleccion = c.id

-- Búsqueda por título completo de ejemplares (búsqueda exacta)
SELECT e.id, e.nombre, e.imagen, e.isbn, e.issn, e.doi, e.fecha_publicacion,
    ed.editorial, f.formato, i.idioma, c.nombre
FROM EJEMPLAR e
    INNER JOIN EDITORIAL ed
        ON e.id_editorial = ed.id
    INNER JOIN FORMATO f
        ON e.id_formato = f.id
    INNER JOIN IDIOMA i
        ON e.id_idioma = i.id
    INNER JOIN COLECCION c
        ON e.id_coleccion = c.id
WHERE e.nombre = 'El extranjero';

-- Búsqueda por título parcial de ejemplares 
SELECT e.id, e.nombre, e.imagen, e.isbn, e.issn, e.doi, e.fecha_publicacion,
    ed.editorial, f.formato, i.idioma, c.nombre
FROM EJEMPLAR e
    INNER JOIN EDITORIAL ed
        ON e.id_editorial = ed.id
    INNER JOIN FORMATO f
        ON e.id_formato = f.id
    INNER JOIN IDIOMA i
        ON e.id_idioma = i.id
    INNER JOIN COLECCION c
        ON e.id_coleccion = c.id
WHERE e.nombre LIKE '%El%';

-- Búsqueda por palabras clave
SELECT e.id, e.nombre, e.imagen, e.isbn, e.issn, e.doi, e.fecha_publicacion,
    ed.editorial, f.formato, i.idioma, c.nombre, p.palabra
FROM EJEMPLAR e
    INNER JOIN EDITORIAL ed
        ON e.id_editorial = ed.id
    INNER JOIN FORMATO f
        ON e.id_formato = f.id
    INNER JOIN IDIOMA i
        ON e.id_idioma = i.id
    INNER JOIN COLECCION c
        ON e.id_coleccion = c.id
    INNER JOIN EJEMPLAR_X_PALABRA x
        ON x.id_ejemplar = e.id
    INNER JOIN PALABRA_CLAVE p
        ON x.id_palabra_clave = p.id
WHERE p.palabra LIKE 'well-modulated'

-- Búsqueda por palabras clave
SELECT e.id, e.nombre, e.imagen, e.isbn, e.issn, e.doi, e.fecha_publicacion,
    ed.editorial, f.formato, i.idioma, c.nombre, a.autor
FROM EJEMPLAR e
    INNER JOIN EDITORIAL ed
        ON e.id_editorial = ed.id
    INNER JOIN FORMATO f
        ON e.id_formato = f.id
    INNER JOIN IDIOMA i
        ON e.id_idioma = i.id
    INNER JOIN COLECCION c
        ON e.id_coleccion = c.id
    INNER JOIN ESCRITURA x
        ON x.id_ejemplar = e.id
    INNER JOIN AUTOR a
        ON x.id_autor = a.id
WHERE a.autor LIKE 'Elvis Foster'

--Búsquedas filtradas por formato (solo deseo ver los ejemplares digitales o físicos)
SELECT e.id, e.nombre, e.imagen, e.isbn, e.issn, e.doi, e.fecha_publicacion,
    ed.editorial, f.formato, i.idioma, c.nombre
FROM EJEMPLAR e
    INNER JOIN EDITORIAL ed
        ON e.id_editorial = ed.id
    INNER JOIN FORMATO f
        ON e.id_formato = f.id
    INNER JOIN IDIOMA i
        ON e.id_idioma = i.id
    INNER JOIN COLECCION c
        ON e.id_coleccion = c.id
WHERE f.formato LIKE 'Físico'
