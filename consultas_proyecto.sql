--2. Muestra los nombres de todas las películas con una clasificación por edades de ‘R’.
SELECT "title"
FROM "film"
WHERE rating = 'R';

--3. Encuentra los nombres de los actores que tengan un “actor_id” entre 30 y 40.
SELECT "first_name", "last_name"
FROM "actor"
WHERE "actor_id" BETWEEN 30 AND 40;

--4. Obtén las películas cuyo idioma coincide con el idioma original.
SELECT "title"
FROM "film"
WHERE "language_id" = "original_language_id";

--5. Ordena las películas por duración de forma ascendente.
SELECT "title", "length"
FROM "film"
ORDER BY "length" ASC;

--6. Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su apellido.
SELECT "first_name", "last_name"
FROM "actor" 
WHERE "last_name" LIKE '%Allen%';

--7. Encuentra la cantidad total de películas en cada clasificación de la tabla “film” y muestra la clasificación junto con el recuento.
SELECT "rating", COUNT(*) AS "total_peliculas"
FROM "film"
GROUP BY "rating";

--8. Encuentra el título de todas las películas que son ‘PG-13’ o tienen una duración mayor a 3 horas en la tabla film.
SELECT "title"
FROM "film"
WHERE "rating" = 'PG-13' OR "length" > 180;

--9. Encuentra la variabilidad de lo que costaría reemplazar las películas.
SELECT ROUND(STDDEV("replacement_cost"), 2) AS "variabilidad_costo_reemplazo"
FROM "film";

--10. Encuentra la mayor y menor duración de una película de nuestra BBDD.
SELECT "title" AS "pelicula_mayor_duracion"
FROM "film"
WHERE "length" = (SELECT MAX(length) FROM film);

SELECT "title" AS "pelicula_menor_duracion"
FROM "film"
WHERE "length" = (SELECT MIN(length) FROM film);

--11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
SELECT "amount"
FROM "payment"
ORDER BY "payment_date" DESC
LIMIT 1 OFFSET 2;

--12. Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC-17’ ni ‘G’ en cuanto a su clasificación.
SELECT "title" 
FROM "film"
WHERE "rating" NOT IN ('NC-17', 'G');  

--13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
SELECT "rating", ROUND(AVG("length"), 2) AS "promedio_duracion"
FROM "film"
GROUP BY "rating";

--14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.
SELECT "title" 
FROM "film"
WHERE "length" > 180;  

--15. ¿Cuánto dinero ha generado en total la empresa?
SELECT SUM(amount) AS "total_generado"
FROM "payment";

--16. Muestra los 10 clientes con mayor valor de id.
SELECT "first_name", "last_name"
FROM "customer"
ORDER BY "customer_id" DESC
LIMIT 10;

--17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’.
SELECT "first_name", "last_name"
FROM "actor"
WHERE "actor_id" IN (
    SELECT "actor_id"
    FROM "film_actor"
    WHERE "film_id" = (
        SELECT "film_id"
        FROM "film"
        WHERE "title" = 'Egg Igby'
    )
);

--18. Selecciona todos los nombres de las películas únicos.
SELECT DISTINCT "title"
FROM "film";

--19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “film”.
SELECT f.title
FROM "film" f
JOIN "film_category" fc ON f."film_id" = fc."film_id"
JOIN "category" c ON fc."category_id" = c."category_id"
WHERE c."name" = 'Comedy'
AND f."length" > 180;

--20. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración.
SELECT c."name" AS "nombre_categoria", ROUND(AVG(f."length"), 2) AS "promedio_duracion"
FROM "film" f
JOIN "film_category" fc ON f."film_id" = fc."film_id"
JOIN "category" c ON fc."category_id" = c."category_id"
GROUP BY c."name"
HAVING AVG(f."length") > 110;

--21. ¿Cuál es la media de duración del alquiler de las películas?
SELECT ROUND(AVG("rental_duration"), 2) AS "duracion_media_alquiler"
FROM "film";

--22. Crea una columna con el nombre y apellidos de todos los actores y actrices.
SELECT "actor_id", CONCAT("first_name", ' ', "last_name") AS "Nombre_completo"
FROM "actor";

--23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.
SELECT "rental_date"::DATE AS "dia_alquiler", COUNT(*) AS "cantidad_alquiler"
FROM "rental"
GROUP BY "dia_alquiler"
ORDER BY "cantidad_alquiler" DESC;

--24. Encuentra las películas con una duración superior al promedio.
SELECT "title", "length"
FROM "film"
WHERE "length" > (SELECT AVG("length") FROM "film");

--25. Averigua el número de alquileres registrados por mes.
SELECT EXTRACT(YEAR FROM "rental_date") AS "year", 
       EXTRACT(MONTH FROM "rental_date") AS "month", 
       COUNT(*) AS "cantidad_alquiler"
FROM "rental"
GROUP BY "year", month
ORDER BY "year", month;

--26. Encuentra el promedio, la desviación estándar y varianza del total pagado.
SELECT 
    ROUND(AVG("amount"), 2) AS "promedio",
    ROUND(STDDEV("amount"), 2) AS "desviacion_estandar",
    ROUND(VARIANCE("amount"), 2) AS "varianza"
FROM "payment";

--27. ¿Qué películas se alquilan por encima del precio medio?
SELECT "title"
FROM "film"
WHERE "rental_rate" > (SELECT AVG("rental_rate") FROM "film");

--28. Muestra el id de los actores que hayan participado en más de 40 películas.
SELECT "actor_id", COUNT(film_id) AS cantidad_peliculas
FROM "film_actor"
GROUP BY "actor_id"
HAVING COUNT(film_id) > 40;

--29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.
SELECT f."title", COUNT(i."inventory_id") AS "available_copies"
FROM "film" f
JOIN "inventory" i ON f."film_id" = i."film_id"
LEFT JOIN "rental" r ON i."inventory_id" = r."inventory_id" AND r."return_date" IS NULL
WHERE r."rental_id" IS NULL
GROUP BY f."title"
ORDER BY "available_copies" DESC;

--30. Obtener los actores y el número de películas en las que ha actuado.
SELECT a."actor_id", 
       CONCAT(a."first_name", ' ', a."last_name") AS "Nombre_actor", 
       COUNT(fa."film_id") AS "film_count"
FROM "actor" a
JOIN "film_actor" fa ON a."actor_id" = fa."actor_id"
GROUP BY a."actor_id", "Nombre_actor"
ORDER BY "film_count" desc;

-- 31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.
SELECT f."title", a."actor_id", CONCAT(a."first_name", ' ', a."last_name") AS "actor_name"
FROM "film" f
LEFT JOIN "film_actor" fa ON f."film_id" = fa."film_id"
LEFT JOIN "actor" a ON fa."actor_id" = a."actor_id";

-- 32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.
SELECT a."actor_id", CONCAT(a."first_name", ' ', a."last_name") AS "actor_name", f."title"
FROM "actor" a
LEFT JOIN "film_actor" fa ON a."actor_id" = fa."actor_id"
LEFT JOIN "film" f ON fa."film_id" = f."film_id";

-- 33. Obtener todas las películas que tenemos y todos los registros de alquiler.
SELECT f."title", r."rental_id", r."rental_date"
FROM "film" f
LEFT JOIN "inventory" i ON f."film_id" = i."film_id"
LEFT JOIN "rental" r ON i."inventory_id" = r."inventory_id";

-- 34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
SELECT c."customer_id", CONCAT(c."first_name", ' ', c."last_name") AS "customer_name", SUM(p."amount") AS "total_spent"
FROM "customer" c
JOIN "payment" p ON c."customer_id" = p."customer_id"
GROUP BY c."customer_id", "customer_name"
ORDER BY "total_spent" DESC
LIMIT 5;

-- 35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.
SELECT * 
FROM "actor" 
WHERE "first_name" = 'Johnny';

-- 36. Renombra la columna “first_name” como Nombre y “last_name” como Apellido.
SELECT "first_name" AS "Nombre", "last_name" AS "Apellido" 
FROM "actor";

-- 37. Encuentra el ID del actor más bajo y más alto en la tabla actor.
SELECT MIN("actor_id") AS "min_actor_id", MAX("actor_id") AS "max_actor_id" 
FROM "actor";

-- 38. Cuenta cuántos actores hay en la tabla “actor”.
SELECT COUNT(*) AS "total_actors" 
FROM "actor";

-- 39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.
SELECT * 
FROM "actor" 
ORDER BY "last_name" ASC;

-- 40. Selecciona las primeras 5 películas de la tabla “film”.
SELECT * 
FROM "film" 
LIMIT 5;

-- 41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre.
SELECT "first_name", COUNT(*) AS "count"
FROM "actor"
GROUP BY "first_name"
ORDER BY "count" DESC;

-- 42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.
SELECT r."rental_id", r."rental_date", CONCAT(c."first_name", ' ', c."last_name") AS "customer_name"
FROM "rental" r
JOIN "customer" c ON r."customer_id" = c."customer_id";

-- 43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.
SELECT c."customer_id", CONCAT(c."first_name", ' ', c."last_name") AS "customer_name", r."rental_id", r."rental_date"
FROM "customer" c
LEFT JOIN "rental" r ON c."customer_id" = r."customer_id";

-- 44. Realiza un CROSS JOIN entre las tablas film y category.
SELECT * 
FROM "film" 
CROSS JOIN "category";

-- 45. Encuentra los actores que han participado en películas de la categoría 'Action'.
SELECT DISTINCT a."actor_id", CONCAT(a."first_name", ' ', a."last_name") AS "Nombre_actor"
FROM "actor" a
JOIN "film_actor" fa ON a."actor_id" = fa."actor_id"
JOIN "film_category" fc ON fa."film_id" = fc."film_id"
JOIN "category" c ON fc."category_id" = c."category_id"
WHERE c."name" = 'Action';

-- 46. Encuentra todos los actores que no han participado en películas.
SELECT a."actor_id", CONCAT(a."first_name", ' ', a."last_name") AS "Nombre_actor"
FROM "actor" a
LEFT JOIN "film_actor" fa ON a."actor_id" = fa."actor_id"
WHERE fa."film_id" IS NULL;

-- 47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.
SELECT CONCAT(a."first_name", ' ', a."last_name") AS "actor_name", COUNT(fa."film_id") AS "cantidad_peliculas"
FROM "actor" a
LEFT JOIN "film_actor" fa ON a."actor_id" = fa."actor_id"
GROUP BY a."actor_id", "actor_name";

-- 48. Crea una vista llamada “actor_num_peliculas”.
CREATE VIEW "actor_num_peliculas" AS
SELECT 
  CONCAT(a."first_name", ' ', a."last_name") AS "actor_name", 
  COUNT(fa."film_id") AS "cantidad_peliculas"
FROM "actor" a
LEFT JOIN "film_actor" fa ON a."actor_id" = fa."actor_id"
GROUP BY a."actor_id", a."first_name", a."last_name";

-- 49. Calcula el número total de alquileres realizados por cada cliente.
SELECT "customer_id", COUNT(*) AS "alquiler_Total" 
FROM "rental" 
GROUP BY "customer_id";

-- 50. Calcula la duración total de las películas en la categoría 'Action'.
SELECT SUM(f."length") AS "duracion_Total"
FROM "film" f
JOIN "film_category" fc ON f."film_id" = fc."film_id"
JOIN "category" c ON fc."category_id" = c."category_id"
WHERE c."name" = 'Action';

-- 51. Crea una tabla temporal para almacenar el total de alquileres por cliente.
CREATE TEMP TABLE "cliente_rentas_temporal" AS
SELECT "customer_id", COUNT(*) AS "alquiler_total"
FROM "rental"
GROUP BY "customer_id";

-- 52. Crea una tabla temporal con películas alquiladas al menos 10 veces.
CREATE TEMP TABLE "peliculas_alquiladas" AS
SELECT f."film_id", f."title", COUNT(r."rental_id") AS "cantidad_alquiler"
FROM "film" f
JOIN "inventory" i ON f."film_id" = i."film_id"
JOIN "rental" r ON i."inventory_id" = r."inventory_id"
GROUP BY f."film_id", f."title"
HAVING COUNT(r."rental_id") >= 10;

-- 53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sanders’ y que aún no se han devuelto.
SELECT DISTINCT f."title"
FROM "film" f
JOIN "inventory" i ON f."film_id" = i."film_id"
JOIN "rental" r ON i."inventory_id" = r."inventory_id"
JOIN "customer" c ON r."customer_id" = c."customer_id"
WHERE CONCAT(c."first_name", ' ', c."last_name") ILIKE 'Tammy Sanders'
  AND r."return_date" IS NULL
ORDER BY f."title";

--54. Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados alfabéticamente por apellido.
SELECT DISTINCT a."first_name", a."last_name"
FROM "actor" a
JOIN "film_actor" fa ON a."actor_id" = fa."actor_id"
JOIN "film" f ON fa."film_id" = f."film_id"
JOIN "film_category" fc ON f."film_id" = fc."film_id"
JOIN "category" c ON fc."category_id" = c."category_id"
WHERE c."name" = 'Sci-Fi'
ORDER BY a."last_name";

--55. Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus Cheaper’ se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido.
SELECT DISTINCT a."first_name", a."last_name"
FROM "actor" a
JOIN "film_actor" fa ON a."actor_id" = fa."actor_id"
JOIN "film" f ON fa."film_id" = f."film_id"
JOIN "inventory" i ON f."film_id" = i."film_id"
JOIN "rental" r ON i."inventory_id" = r."inventory_id"
WHERE r."rental_date" > (
    SELECT MIN(r2."rental_date")
    FROM "rental" r2
    JOIN "inventory" i2 ON r2."inventory_id" = i2."inventory_id"
    JOIN "film" f2 ON i2."film_id" = f2."film_id"
    WHERE f2."title" ILIKE 'Spartacus Cheaper'
)
ORDER BY a."last_name";

--56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Music’.
SELECT a."first_name", a."last_name"
FROM "actor" a
WHERE a."actor_id" NOT IN (
    SELECT fa."actor_id"
    FROM "film_actor" fa
    JOIN "film_category" fc ON fa."film_id" = fc."film_id"
    JOIN "category" c ON fc."category_id" = c."category_id"
    WHERE c."name" = 'Music'
);

--57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.
SELECT DISTINCT f."title"
FROM "rental" r
JOIN "inventory" i ON r."inventory_id" = i."inventory_id"
JOIN "film" f ON i."film_id" = f."film_id"
WHERE r."return_date" IS NOT NULL
  AND r."return_date" - r."rental_date" > INTERVAL '8 days';

--58. Encuentra el título de todas las películas que son de la misma categoría que ‘Animation’.
SELECT DISTINCT f."title"
FROM "film" f
JOIN "film_category" fc1 ON f."film_id" = fc1."film_id"
WHERE fc1."category_id" = (
    SELECT "category_id"
    FROM "category"
    WHERE name = 'Animation'
);

--59. Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Fever’. Ordena los resultados alfabéticamente por título de película.
SELECT "title"
FROM "film"
WHERE "length" = (
    SELECT "length"
    FROM "film"
    WHERE "title" ILIKE 'Dancing Fever'
)
ORDER BY "title";

--60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.
SELECT c."first_name", c."last_name"
FROM "customer" c
JOIN "rental" r ON c."customer_id" = r."customer_id"
JOIN "inventory" i ON r."inventory_id" = i."inventory_id"
JOIN "film" f ON i."film_id" = f."film_id"
GROUP BY c."customer_id", c."first_name", c."last_name"
HAVING COUNT(DISTINCT f."film_id") >= 7
ORDER BY c."last_name";

--61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
SELECT c."name" AS "category_name", COUNT(r."rental_id") AS "total_rentals"
FROM "rental" r
JOIN "inventory" i ON r."inventory_id" = i."inventory_id"
JOIN "film" f ON i."film_id" = f."film_id"
JOIN "film_category" fc ON f."film_id" = fc."film_id"
JOIN "category" c ON fc."category_id" = c."category_id"
GROUP BY c."name";

--62. Encuentra el número de películas por categoría estrenadas en 2006.
SELECT c."name" AS "category_name", COUNT(f."film_id") AS "total_movies"
FROM "film" f
JOIN "film_category" fc ON f."film_id" = fc."film_id"
JOIN "category" c ON fc."category_id" = c."category_id"
WHERE f."release_year" = 2006
GROUP BY c."name";

--63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.
SELECT s."staff_id", s."first_name", s."last_name", st."store_id"
FROM "staff" s
CROSS JOIN "store" st;

--64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
SELECT c."customer_id", c."first_name", c."last_name", COUNT(r."rental_id") AS "total_rentals"
FROM "customer" c
JOIN "rental" r ON c."customer_id" = r."customer_id"
GROUP BY c."customer_id", c."first_name", c."last_name";

