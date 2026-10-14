DROP TABLE IF EXISTS rating;
DROP TABLE IF EXISTS movie_genre;
DROP TABLE IF EXISTS app_user;
DROP TABLE IF EXISTS genre;
DROP TABLE IF EXISTS movie;

-- Make movie_id as the primary key as titles may be repeated
CREATE TABLE movie (
    movie_id INTEGER PRIMARY KEY,
    title TEXT NOT NULL
);

-- Assign a genre_id for each genre
CREATE TABLE genre (
    genre_id  SERIAL PRIMARY KEY,
    name      TEXT NOT NULL UNIQUE
);

-- This table uses two foreign keys (movie_id and genre_id) to form a primary key
-- One row per movie-genre; If a movie has three genres, there will be three rows for the movie
CREATE TABLE movie_genre (
    movie_id  INTEGER NOT NULL REFERENCES movie(movie_id),
    genre_id  INTEGER NOT NULL REFERENCES genre(genre_id),
    PRIMARY KEY (movie_id, genre_id)
);

CREATE TABLE app_user (
    user_id  INTEGER PRIMARY KEY
);

-- As each user rates a movie once, user_id and movie_id can form a primary key
CREATE TABLE rating (
    user_id   INTEGER NOT NULL REFERENCES app_user(user_id),
    movie_id  INTEGER NOT NULL REFERENCES movie(movie_id),
    rating    NUMERIC(2,1) NOT NULL
              CHECK (rating BETWEEN 0.5 AND 5.0 AND rating * 2 = ROUND(rating * 2)), -- Checking that ratings fall between the range, and are in intervals of 0.5
    rated_at  TIMESTAMP NOT NULL,
    PRIMARY KEY (user_id, movie_id)
);