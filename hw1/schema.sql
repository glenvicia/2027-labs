DROP TABLE IF EXISTS rating;
DROP TABLE IF EXISTS movie_genre;
DROP TABLE IF EXISTS app_user;
DROP TABLE IF EXISTS genre;
DROP TABLE IF EXISTS movie;

CREATE TABLE movie (
    movie_id INTEGER PRIMARY KEY,
    title TEXT NOT NULL
);

CREATE TABLE genre (
    genre_id  SERIAL PRIMARY KEY,
    name      TEXT NOT NULL UNIQUE
);

CREATE TABLE movie_genre (
    movie_id  INTEGER NOT NULL REFERENCES movie(movie_id),
    genre_id  INTEGER NOT NULL REFERENCES genre(genre_id),
    PRIMARY KEY (movie_id, genre_id)
);

CREATE TABLE app_user (
    user_id  INTEGER PRIMARY KEY
);

CREATE TABLE rating (
    user_id   INTEGER NOT NULL REFERENCES app_user(user_id),
    movie_id  INTEGER NOT NULL REFERENCES movie(movie_id),
    rating    NUMERIC(2,1) NOT NULL
              CHECK (rating BETWEEN 0.5 AND 5.0 AND rating * 2 = ROUND(rating * 2)), 
    rated_at  TIMESTAMP NOT NULL,
    PRIMARY KEY (user_id, movie_id)
);