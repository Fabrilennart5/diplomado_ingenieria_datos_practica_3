-- CONSULTAS:
--1.- Join entre GAME y CLASS:
--Obtener el nombre del juego, su descripción y la descripción de la clase a la que pertenece.
SELECT
  g.name,
  g.description,
  c.description
FROM
  GAME AS g
  LEFT JOIN CLASS AS c ON g.id_CLASS = c.id_CLASS;

--2.- Conteo de comentarios por juego:
--Contar cuántos comentarios tiene cada juego.
SELECT
  g.name,
  COUNT(c.id_COMMENTARY)
FROM
  COMMENTARY AS c
  LEFT JOIN GAME AS g ON c.id_Game = g.id_Game
GROUP BY
  g.name;

--3.- Promedio de votos por juego:
--Calcular el promedio de valoración de cada juego.
SELECT
  g.name,
  ROUND(AVG(v.value))
FROM
  VOTE AS v
  LEFT JOIN GAME AS g ON v.id_Game = g.id_Game
GROUP BY
  g.name;

--4.- Lista de usuarios que han completado juegos:
--Mostrar los nombres de los usuarios que han completado al menos un juego.
SELECT
  u.first_name || " " || u.last_name,
  p.completed
FROM
  SYSTEM_USER AS u
  LEFT JOIN PLAY AS p ON u.id_SYSTEM_USER = p.id_SYSTEM_USER
WHERE
  p.completed = 1;

--5.- Unión de comentarios y sugerencias:
--Combinar los correos electrónicos de los usuarios que han hecho comentarios
--con los correos electrónicos de los usuarios que han sugerido juegos.
SELECT DISTINCT
  (s.email)
FROM
  SUGGEST AS s
  LEFT JOIN COMMENTARY AS c ON s.id_SYSTEM_USER = c.id_SYSTEM_USER;

--6.- Juegos sin comentarios:
--Mostrar los juegos que no tienen ningún comentario.
SELECT
  g.name,
  c.commentary
FROM
  GAME AS g
  LEFT JOIN COMMENTARY AS c ON g.id_GAME = c.id_GAME
WHERE
  c.commentary IS NULL;

--7.- Usuarios que han votado y jugado:
--Mostrar los nombres de los usuarios que han votado y 
--también han jugado al menos un juego.
SELECT
  s.id_SYSTEM_USER,
  s.first_name || " " || s.last_name as nombre_completo
FROM
  SYSTEM_USER AS s
  INNER JOIN VOTE AS v ON s.id_SYSTEM_USER = v.id_SYSTEM_USER
WHERE
  s.id_SYSTEM_USER IN (
    SELECT
      id_SYSTEM_USER
    from
      play
  );

--8.- Clases con la cantidad de juegos asociados:
--Mostrar las descripciones de las clases junto con la cantidad de juegos que tienen asociados.
SELECT
  c.description,
  count(g.id_game)
FROM
  CLASS AS c
  LEFT JOIN GAME AS g ON c.id_CLASS = g.id_ClASS
GROUP BY
  c.description;

--9.- Comentarios más recientes por juego:
--Mostrar el comentario más reciente para cada juego, junto con su fecha.
SELECT
  g.name,
  MAX(c.last_date) AS ultimo_comentario
FROM
  COMMENT AS c
  LEFT JOIN GAME AS g ON c.id_game = g.id_game
GROUP BY
  g.name;

--10.- Eliminar datos antiguos:
--Eliminar los comentarios que tengan más de un año de antigüedad.
-- Creando una copia
CREATE TABLE
  comment_respaldo (
    id_game INTEGER,
    id_system_user TEXT,
    first_date TEXT,
    last_date TEXT
  );

INSERT INTO
  comment_respaldo
SELECT
  *
FROM
  comment;

-- Desactivando las restricciones
PRAGMA foreign_keys = off;

-- Eliminando los registros
DELETE FROM comment
WHERE
  last_date < '2021-01-01';

-- Activando las restricciones
PRAGMA foreign_keys = on