DROP TABLE IF EXISTS stage_ratings;
DROP TABLE IF EXISTS stage_movies;

CREATE TABLE stage_movies (
	movie_id  INTEGER,
	title     TEXT,
	genres    TEXT
);

CREATE TABLE stage_ratings (
	user_id     INTEGER,
	movie_id    INTEGER,
	rating      NUMERIC,
	time_stamp  BIGINT
);

\copy stage_movies FROM '/tmp/movies.csv' CSV HEADER
\copy stage_ratings FROM '/tmp/ratings.csv' CSV HEADER

--#1. movie: copy directly
INSERT INTO movie (movie_id, title)
SELECT movie_id, title
FROM stage_movies;

-- #2. genre: split each pipe-separated cell, keep each distinct label once
INSERT INTO genre (name)
SELECT DISTINCT unnest(string_to_array(genres, '|'))
FROM stage_movies
WHERE genres <> '(no genres listed)'
ORDER BY 1;

-- #3. movie_genre: one row per (movie, genre) pair
INSERT INTO movie_genre (movie_id, genre_id)
SELECT DISTINCT m.movie_id, g.genre_id
FROM stage_movies AS m
CROSS JOIN LATERAL unnest(string_to_array(m.genres, '|')) AS x(name)
JOIN genre AS g ON g.name = x.name;

-- #4. app_user: the distinct users found in the ratings
INSERT INTO app_user (user_id)
SELECT DISTINCT user_id
FROM stage_ratings;

-- 5. rating: convert ts into a real timestamp
INSERT INTO rating (user_id, movie_id, rating, rated_at)
SELECT user_id, movie_id, rating, to_timestamp(time_stamp)
FROM stage_ratings;

-- staging tables are no longer needed
DROP TABLE stage_ratings;
DROP TABLE stage_movies;