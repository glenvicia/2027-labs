-- Part 2, claim 1: Every `movieId` appearing in `ratings.csv` also appears in `movies.csv`.
SELECT COUNT(*) AS num_orphan_rating
FROM rating r
LEFT JOIN movie m ON m.movie_id = r.movie_id
WHERE m.movie_id IS NULL;