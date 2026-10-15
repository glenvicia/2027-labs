Note: All outputs are listed here. To run the queries, refer to queries.sql.

## Part 2 — Five claims about the data (25%)

### Claim 1: Every `movieId` appearing in `ratings.csv` also appears in `movies.csv`.

Answer: True. The query is counting the number of ratings that do not match `movie_id` from `movie`, i.e., orphan rating. As there are no orphan ratings after doing a left join on the table `rating` with `movie`, it means the claim is true.

Output:

| num_orphan_rating |
| ----------------- |
| 0                 |

### Claim 2: No two films share exactly the same title.

Answer: False. There are 5 movie titles that have at least 2 distinct movie_id.

Output:

| title                                  | count |
| -------------------------------------- | ----- |
| Eros (2004)                            | 2     |
| Saturn 3 (1980)                        | 2     |
| Confessions of a Dangerous Mind (2002) | 2     |
| Emma (1996)                            | 2     |
| War of the Worlds (2005)               | 2     |

### Claim 3: Every film has received at least one rating.

Answer: False. After taking `movie` and doing a left join with `rating`, there are 18 instances where `r.movie_id` is null which means that the `movie_id` originally in the `movie` table did not have any entries in `rating`.

Output:

| movie_id | title                                        |
| -------- | -------------------------------------------- |
| 1076     | Innocents, The (1961)                        |
| 6668     | Road Home, The (Wo de fu qin mu qin) (1999)  |
| 6849     | Scrooge (1970)                               |
| 26085    | Mutiny on the Bounty (1962)                  |
| 5721     | Chosen, The (1981)                           |
| 3456     | Color of Paradise, The (Rang-e khoda) (1999) |
| 32371    | Call Northside 777 (1948)                    |
| 25855    | Roaring Twenties, The (1939)                 |
| 3338     | For All Mankind (1989)                       |
| 30892    | In the Realms of the Unreal (2004)           |
| 4194     | I Know Where I'm Going! (1945)               |
| 32160    | Twentieth Century (1934)                     |
| 34482    | Browning Version, The (1951)                 |
| 7020     | Proof (1991)                                 |
| 7792     | Parallax View, The (1974)                    |
| 2939     | Niagara (1953)                               |
| 8765     | This Gun for Hire (1942)                     |
| 85565    | Chalet Girl (2011)                           |

### Claim 4: Every film has at least one genre.

Answer: False. After taking `movie` and doing a left join with `movie_genre`, there are 34 instances where `mg.movie_id` is null. For such entries, the `movie_id` originally in the `movie` table did not have any entries in `movie_genre`.

Output:

| movie_id | title                                                                               |
| -------- | ----------------------------------------------------------------------------------- |
| 114335   | La cravate (1957)                                                                   |
| 122888   | Ben-hur (2016)                                                                      |
| 122896   | Pirates of the Caribbean: Dead Men Tell No Tales (2017)                             |
| 129250   | Superfast! (2015)                                                                   |
| 132084   | Let It Be Me (1995)                                                                 |
| 134861   | Trevor Noah: African American (2013)                                                |
| 141131   | Guardians (2016)                                                                    |
| 141866   | Green Room (2015)                                                                   |
| 142456   | The Brand New Testament (2015)                                                      |
| 143410   | Hyena Road                                                                          |
| 147250   | The Adventures of Sherlock Holmes and Doctor Watson                                 |
| 149330   | A Cosmic Christmas (1977)                                                           |
| 152037   | Grease Live (2016)                                                                  |
| 155589   | Noin 7 veljestä (1968)                                                             |
| 156605   | Paterson                                                                            |
| 159161   | Ali Wong: Baby Cobra (2016)                                                         |
| 159779   | A Midsummer Night's Dream (2016)                                                    |
| 161008   | The Forbidden Dance (1990)                                                          |
| 165489   | Ethel & Ernest (2016)                                                               |
| 166024   | Whiplash (2013)                                                                     |
| 167570   | The OA                                                                              |
| 169034   | Lemonade (2016)                                                                     |
| 171495   | Cosmos                                                                              |
| 171631   | Maria Bamford: Old Baby                                                             |
| 171749   | Death Note: Desu nôto (2006–2007)                                                 |
| 171891   | Generation Iron 2                                                                   |
| 172497   | T2 3-D: Battle Across Time (1996)                                                   |
| 172591   | The Godfather Trilogy: 1972-1990 (1992)                                             |
| 173535   | The Adventures of Sherlock Holmes and Doctor Watson: The Hunt for the Tiger (1980) |
| 174403   | The Putin Interviews (2017)                                                         |
| 176601   | Black Mirror                                                                        |
| 181413   | Too Funny to Fail: The Life and Death of The Dana Carvey Show (2017)                |
| 181719   | Serving in Silence: The Margarethe Cammermeyer Story (1995)                         |
| 182727   | A Christmas Story Live! (2017)                                                      |

### Claim 5: Every rating value is a whole number between 1 and 5.

Answer: False. A distribution of the ratings show that there are plenty of ratings with a half star, including 1,370 ratings below 1.

Output:

| rating | count |
| ------ | ----- |
| 0.5    | 1370  |
| 1      | 2811  |
| 1.5    | 1791  |
| 2      | 7551  |
| 2.5    | 5550  |
| 3      | 20047 |
| 3.5    | 13136 |
| 4      | 26818 |
| 4.5    | 8551  |
| 5      | 13211 |

## Part 3 — Four queries (25%)

### Query 1: The number of records in each table in your database.

```SQL
SELECT (SELECT COUNT(*) FROM movie)       AS movie,
       (SELECT COUNT(*) FROM genre)       AS genre,
       (SELECT COUNT(*) FROM movie_genre) AS movie_genre,
       (SELECT COUNT(*) FROM app_user)    AS app_user,
       (SELECT COUNT(*) FROM rating)      AS rating;
```

Output:

| movie | genre | movie_genre | app_user | rating |
| ----- | ----- | ----------- | -------- | ------ |
| 9742  | 19    | 22050       | 610      | 100836 |

### Query 2: The 20 films with the highest average rating, counting only films with at least 1,000 ratings (or 100 if you are using the small dataset). Return the title, the average rating and the number of ratings, ordered by average rating descending.

Output:

| title                                                                           | avg_rating | num_ratings |
| ------------------------------------------------------------------------------- | ---------- | ----------- |
| Shawshank Redemption, The (1994)                                                | 4.43       | 317         |
| Godfather, The (1972)                                                           | 4.29       | 192         |
| Fight Club (1999)                                                               | 4.27       | 218         |
| Godfather: Part II, The (1974)                                                  | 4.26       | 129         |
| Departed, The (2006)                                                            | 4.25       | 107         |
| Goodfellas (1990)                                                               | 4.25       | 126         |
| Casablanca (1942)                                                               | 4.24       | 100         |
| Dark Knight, The (2008)                                                         | 4.24       | 149         |
| Usual Suspects, The (1995)                                                      | 4.24       | 204         |
| Princess Bride, The (1987)                                                      | 4.23       | 142         |
| Star Wars: Episode IV - A New Hope (1977)                                       | 4.23       | 251         |
| Schindler's List (1993)                                                         | 4.23       | 220         |
| Apocalypse Now (1979)                                                           | 4.22       | 107         |
| American History X (1998)                                                       | 4.22       | 129         |
| Star Wars: Episode V - The Empire Strikes Back (1980)                           | 4.22       | 211         |
| Raiders of the Lost Ark (Indiana Jones and the Raiders of the Lost Ark) (1981) | 4.21       | 200         |
| One Flew Over the Cuckoo's Nest (1975)                                          | 4.2        | 133         |
| Reservoir Dogs (1992)                                                           | 4.2        | 131         |
| Pulp Fiction (1994)                                                             | 4.2        | 307         |
| Matrix, The (1999)                                                              | 4.19       | 278         |

### Query 3: The most frequent genres, with the number of films in each, ordered by frequency decreasing.

Output:

| name        | num_movies |
| ----------- | ---------- |
| Drama       | 4361       |
| Comedy      | 3756       |
| Thriller    | 1894       |
| Action      | 1828       |
| Romance     | 1596       |
| Adventure   | 1263       |
| Crime       | 1199       |
| Sci-Fi      | 980        |
| Horror      | 978        |
| Fantasy     | 779        |
| Children    | 664        |
| Animation   | 611        |
| Mystery     | 573        |
| Documentary | 440        |
| War         | 382        |
| Musical     | 334        |
| Western     | 167        |
| IMAX        | 158        |
| Film-Noir   | 87         |

### Query 4: The average rating per genre, with the number of ratings each average is based on, ordered by average descending.

Output:

| name        | num_ratings | avg_rating |
| ----------- | ----------- | ---------- |
| Film-Noir   | 870         | 3.92       |
| War         | 4859        | 3.81       |
| Documentary | 1219        | 3.8        |
| Crime       | 16681       | 3.66       |
| Drama       | 41928       | 3.66       |
| Mystery     | 7674        | 3.63       |
| Animation   | 6988        | 3.63       |
| IMAX        | 4145        | 3.62       |
| Western     | 1930        | 3.58       |
| Musical     | 4138        | 3.56       |
| Adventure   | 24161       | 3.51       |
| Romance     | 18124       | 3.51       |
| Thriller    | 26452       | 3.49       |
| Fantasy     | 11834       | 3.49       |
| Sci-Fi      | 17243       | 3.46       |
| Action      | 30635       | 3.45       |
| Children    | 9208        | 3.41       |
| Comedy      | 39053       | 3.38       |
| Horror      | 7291        | 3.26       |

## Part 4 — Defend the design (15%)

**Why these tables**

* `movie`: one row per film, where the primary key is `movie_id`. The title cannot be a key because show titles repeat (as verified in Claim 2).
* `genre` and `movie_genre`: the CSV packs genres into one pipe-separated cell (e.g.,`Comedy|Drama|Action`), which breaks first normal form. Genres are a many-to-many relationship, so `genre` acts as a lookup table, while `movie_genre` functions  as a junction table. This allows Queries 3 and 4 to use plain joins.
* `rating`: one row per (user, film) pair, with `(user_id, movie_id)` as the composite primary key. This also enforces that a user rates a film only once.
* `app_user`: the data has only a `userId` and no other user attributes.

**Decisions I was unsure about**

* *Whether `genre` needed a separate table since genre names are already unique*. I created a `genre` table anyway so that it would be easier to spot typos and avoid the typo being classified as another genre.
* *Whether an`app_user` table was needed since `user_id`and `rating`  already formed a unique pair in `rating` table.* I eventually kept the  `app_user` table so the foreign key is enforced and the application can later add user attributes without restructuring. The cost is a nearly empty table today. I named it `app_user`because`user` is a reserved word in PostgreSQL.
* *Films with `(no genres listed)`.* I treated this as “no genre” rather than a genre called “(no genres listed)”. These films have no `movie_genre` rows, which is why Claim 4 returns 34 films.
* *`rating` as `NUMERIC(2,1)` with a CHECK, vs. `REAL` or `INTEGER`.* `INTEGER` would lose the half-star values. `REAL` could actually represent these particular values exactly, but it is an approximate type, so correctness would depend on the data happening to be multiples of 0.5. `NUMERIC(2,1)` is exact, documents the intended precision, and works directly with the aggregate functions I use.

**Explanations the code needs**

* Tables are dropped in reverse dependency order, so `schema.sql` can be re-run.
* `\copy` paths assume the CSVs are in `/tmp`.
* `SELECT DISTINCT` in the `movie_genre` insert guards against duplicate genre labels within a cell.
