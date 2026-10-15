--------------------
------ Part 2 ------
--------------------

-- Claim 1: Every `movieId` appearing in `ratings.csv` also appears in `movies.csv`.
SELECT COUNT(*) AS num_orphan_rating
FROM rating r
LEFT JOIN movie m ON m.movie_id = r.movie_id
WHERE m.movie_id IS NULL;

-- Claim 2: No two films share exactly the same title.
SELECT COUNT(DISTINCT title) AS n_distinct_titles,
       COUNT(*)              AS n_movie_id
FROM movie;

-- Claim 3: Every film has received at least one rating.
SELECT m.movie_id, m.title
FROM movie m
LEFT JOIN rating r ON r.movie_id = m.movie_id
WHERE r.movie_id IS NULL;

-- Claim 4: Every film has at least one genre.
SELECT m.movie_id, m.title
FROM movie m
LEFT JOIN movie_genre mg ON mg.movie_id = m.movie_id
WHERE mg.movie_id IS NULL;

-- Claim 5: Every rating value is a whole number between 1 and 5.
SELECT COUNT(*) as num_non_whole_1_5 --testing for whole numbers and out of range
FROM rating r
WHERE r.rating%1 <> 0 OR r.rating<1 OR r.rating >5;

--------------------
------ Part 3 ------
--------------------

-- Query 1: The number of records in each table in your database.
SELECT (SELECT COUNT(*) FROM movie)       AS movie,
       (SELECT COUNT(*) FROM genre)       AS genre,
       (SELECT COUNT(*) FROM movie_genre) AS movie_genre,
       (SELECT COUNT(*) FROM app_user)    AS app_user,
       (SELECT COUNT(*) FROM rating)      AS rating;

-- Query 2: The 20 films with the highest average rating, counting only films with at least 1,000 ratings (or 100 if you are using the small dataset). 
-- Return the title, the average rating and the number of ratings, ordered by average rating descending.
SELECT m.title,
		COUNT(*) as num_ratings, 
		ROUND(AVG(r.rating),2) AS avg_rating
FROM rating r
JOIN movie m ON m.movie_id = r.movie_id
GROUP BY m.movie_id
HAVING COUNT(*) >= 100
ORDER BY AVG(r.rating) DESC,  COUNT(*) DESC, m.title
LIMIT 20;

-- Query 3: The most frequent genres, with the number of films in each, ordered by frequency decreasing.
SELECT g.name, COUNT(*) AS num_movies
FROM movie_genre mg
JOIN genre g ON mg.genre_id = g.genre_id
GROUP BY g.genre_id
ORDER BY num_movies DESC, g.name;

-- Query 4: The average rating per genre, with the number of ratings each average is based on, ordered by average descending.
SELECT g.name, COUNT(*) AS num_ratings, ROUND(AVG(r.rating),2) as avg_rating
FROM movie_genre mg
JOIN genre g ON mg.genre_id = g.genre_id
JOIN rating r ON mg.movie_id = r.movie_id
GROUP BY g.genre_id
ORDER BY avg_rating DESC;

SELECT g.name,
       COUNT(*)                AS num_ratings,
       ROUND(AVG(r.rating), 2) AS avg_rating
FROM genre g
JOIN movie_genre mg ON mg.genre_id = g.genre_id
JOIN rating r       ON r.movie_id  = mg.movie_id
GROUP BY g.genre_id, g.name
ORDER BY AVG(r.rating) DESC, g.name;