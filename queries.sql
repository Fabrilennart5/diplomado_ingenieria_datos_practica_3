-- 1) Encuentra todos los juegos de la clase "Aventura" cuyo nivel sea mayor o igual a 5.
-- Muestra el nombre del juego, la descripción y el nivel.

SELECT g.name,
       c.description,
       l.description
  FROM GAME AS g
       LEFT JOIN
       CLASS AS c ON g.id_CLASS = c.id_CLASS
       LEFT JOIN
       LEVEL_GAME AS l ON c.id_level = l.id_level
 WHERE l.id_level > 5 AND 
       c.description = "Adventure";

-- 2) Calcula el número total de comentarios por juego.
-- Muestra el nombre del juego y la cantidad de comentarios,
-- ordenados de mayor a menor cantidad de comentarios.

SELECT g.name,
       COUNT(c.id_COMMENTARY) AS total
  FROM COMMENTARY AS c
       LEFT JOIN
       GAME AS g ON c.id_GAME = g.id_GAME
 GROUP BY g.name
 ORDER BY total;

-- 3) Encuentra todos los juegos que no hayan sido sugeridos
--  por ningún usuario. Muestra el nombre del juego y la descripción.


SELECT g.name,
       g.description
  FROM GAME AS g
       LEFT JOIN
       SUGGEST AS s ON g.id_GAME = s.id_GAME
       LEFT JOIN
       SYSTEM_USER AS sy ON s.id_SYSTEM_USER = sy.id_SYSTEM_USER
 WHERE g.id_GAME NOT IN (
           SELECT s.id_GAME
             FROM SUGGEST
       );


 
-- 4) Encuentra todos los usuarios que hayan completado al menos 5 juegos.
-- Muestra el nombre completo del usuario y la cantidad de juegos completados.
-- Solo incluye usuarios que hayan completado al menos 5 juegos.

SELECT s.first_name || ' ' || s.last_name AS complete_name,
       COUNT(p.completed) AS games_completed
  FROM SYSTEM_USER AS s
       LEFT JOIN
       PLAY AS p ON s.id_SYSTEM_USER = p.id_SYSTEM_USER
 WHERE p.completed = 1
 GROUP BY complete_name
HAVING COUNT(p.completed) >= 5;


-- 5) Encuentra el promedio de votos para cada juego.
-- Muestra el nombre del juego y el promedio de votos, redondeado a dos decimales.

SELECT g.id_Game,
       g.name,
       ROUND(AVG(v.value), 2) AS avg_value
  FROM GAME AS g
       LEFT JOIN
       VOTE AS v ON g.id_GAME = v.id_GAME
 GROUP BY g.id_Game;


-- 6) Encuentra todos los juegos que tengan comentarios o sugerencias.
-- Muestra el nombre del juego y si tiene comentarios o sugerencias.

SELECT g.name,
       c.COMMENTARY,
       s.email
  FROM GAME AS g
       INNER JOIN
       COMMENTARY AS c ON g.id_GAME = c.id_GAME
       INNER JOIN
       SUGGEST AS s ON g.id_GAME = s.id_GAME;

-- 7) Encuentra todos los juegos cuya fecha de primer comentario esté entre el 2014-01-01 y el 2021-10-14.
-- Muestra el nombre del juego y la fecha del primer comentario, ordenados por fecha.

SELECT g.name,
       c.id_COMMENTARY,
       c.comment_date
  FROM GAME AS g
       LEFT JOIN
       COMMENTARY AS c ON g.id_GAME = c.id_GAME
 WHERE c.comment_date BETWEEN '2014-01-01' AND [2021-10-14];




-- 8) Calcula la cantidad total de comentarios por año.
-- Muestra el año y la cantidad total de comentarios, ordenados cronológicamente.

SELECT strftime('%Y', comment_date) AS year,
       COUNT(id_COMMENTARY) AS count_of_comments
  FROM COMMENTARY
 GROUP BY year
 ORDER BY  year ASC;



-- 9) Encuentra todos los juegos que hayan sido jugados por el usuario con ID 123. 
-- Muestra el nombre del juego, la descripción y si fue completado por el usuario.

SELECT g.name,
       g.description,
       p.completed
  FROM GAME AS g
       LEFT JOIN
       PLAY AS p ON g.id_GAME = p.id_Game
 WHERE p.id_SYSTEM_USER = 123;


 