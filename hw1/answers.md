## Part 2 — Five claims about the data (25%)

Claim 1: Every `movieId` appearing in `ratings.csv` also appears in `movies.csv`.

Answer: True, as there are no orphan ratings after doing a left join on the table `rating` with `movie`.

```SQL
```sql 
SELECT COUNT(*) AS num_orphan_rating
FROM rating r
LEFT JOIN movie m ON m.movie_id = r.movie_id
WHERE m.movie_id IS NULL;
```

Output:

```
num_orphan_rating
0
```



Claim 2: No two films share exactly the same title.

Answer: False. There are 9,742 movies (counted by n_movie_id), but only 9,737 unique titles (counted by n_distinct_title), which means some films have the same title.

```SQL
SELECT COUNT(DISTINCT title) AS n_distinct_titles,
       COUNT(*)              AS n_movie_id
FROM movie;
```

Output:

```
n_distinct_title	n_movie_id
9737				9742
```




Claim 3: Every film has received at least one rating.

Answer: False. After taking `movie` and doing a left join with `rating`, there are 18 instances where `r.movie_id` is null which means that the `movie_id` originally in the `movie` table did not have any entries in `rating`.


```SQL
SELECT m.movie_id, m.title
FROM movie m
LEFT JOIN rating r ON r.movie_id = m.movie_id
WHERE r.movie_id IS NULL;
```

Output:

```
movie_id	title
1076	Innocents, The (1961)
6668	Road Home, The (Wo de fu qin mu qin) (1999)
6849	Scrooge (1970)
26085	Mutiny on the Bounty (1962)
5721	Chosen, The (1981)
3456	Color of Paradise, The (Rang-e khoda) (1999)
32371	Call Northside 777 (1948)
25855	Roaring Twenties, The (1939)
3338	For All Mankind (1989)
30892	In the Realms of the Unreal (2004)
4194	I Know Where I'm Going! (1945)
32160	Twentieth Century (1934)
34482	Browning Version, The (1951)
7020	Proof (1991)
7792	Parallax View, The (1974)
2939	Niagara (1953)
8765	This Gun for Hire (1942)
85565	Chalet Girl (2011)
```



Claim 4: Every film has at least one genre.

Answer: False. After taking `movie` and doing a left join with `movie_genre`, there are 34 instances where `mg.movie_id` is null which means that the `movie_id` originally in the `movie` table did not have any entries in `movie_genre`.


```SQL
SELECT m.movie_id, m.title
FROM movie m
LEFT JOIN movie_genre mg ON mg.movie_id = m.movie_id
WHERE mg.movie_id IS NULL;
```

Output:

```
movie_id	title
114335	La cravate (1957)
122888	Ben-hur (2016)
122896	Pirates of the Caribbean: Dead Men Tell No Tales (2017)
129250	Superfast! (2015)
132084	Let It Be Me (1995)
134861	Trevor Noah: African American (2013)
141131	Guardians (2016)
141866	Green Room (2015)
142456	The Brand New Testament (2015)
143410	Hyena Road
147250	The Adventures of Sherlock Holmes and Doctor Watson
149330	A Cosmic Christmas (1977)
152037	Grease Live (2016)
155589	Noin 7 veljestÃ¤ (1968)
156605	Paterson
159161	Ali Wong: Baby Cobra (2016)
159779	A Midsummer Night's Dream (2016)
161008	The Forbidden Dance (1990)
165489	Ethel & Ernest (2016)
166024	Whiplash (2013)
167570	The OA
169034	Lemonade (2016)
171495	Cosmos
171631	Maria Bamford: Old Baby
171749	Death Note: Desu nÃ´to (2006â€“2007)
171891	Generation Iron 2
172497	T2 3-D: Battle Across Time (1996)
172591	The Godfather Trilogy: 1972-1990 (1992)
173535	The Adventures of Sherlock Holmes and Doctor Watson: The Hunt for the Tiger (1980)
174403	The Putin Interviews (2017)
176601	Black Mirror
181413	Too Funny to Fail: The Life and Death of The Dana Carvey Show (2017)
181719	Serving in Silence: The Margarethe Cammermeyer Story (1995)
182727	A Christmas Story Live! (2017)
```


Claim 5: Every rating value is a whole number between 1 and 5.

Answer: False. There are 30,398 ratings that do not fulfill the criteria of being a whole number between 1 and 5.


```SQL
SELECT COUNT(*) as num_non_whole_1_5 --testing for whole numbers and out of range
FROM rating r
WHERE r.rating%1 <> 0 OR r.rating<1 OR r.rating >5;
```

Output:

```
num_non_whole_1_5
30398
```

## Part 3 — Four queries (25%)

Query 1: The number of records in each table in your database.

```SQL
SELECT (SELECT COUNT(*) FROM movie)       AS movie,
       (SELECT COUNT(*) FROM genre)       AS genre,
       (SELECT COUNT(*) FROM movie_genre) AS movie_genre,
       (SELECT COUNT(*) FROM app_user)    AS app_user,
       (SELECT COUNT(*) FROM rating)      AS rating;
```

Output:

```
movie	genre	movie_genre	app_user	rating
9742	19		22050		610			100836

```

Query 2: The 20 films with the highest average rating, counting only films with at least 1,000 ratings (or 100 if you are using the small dataset). Return the title, the average rating and the number of ratings, ordered by average rating descending.

```SQL
  
SELECT m.title,
		COUNT(*) as num_ratings, 
		ROUND(AVG(r.rating),2) AS avg_rating
FROM rating r
JOIN movie m ON m.movie_id = r.movie_id
GROUP BY m.movie_id
HAVING COUNT(*) >= 100
ORDER BY AVG(r.rating) DESC
LIMIT 20;
```

Output:

```
title																				num_ratings		avg_rating
Shawshank Redemption, The (1994)													317				4.43
Godfather, The (1972)																192				4.29
Fight Club (1999)																	218				4.27
Godfather: Part II, The (1974)														129				4.26
Departed, The (2006)																107				4.25
Goodfellas (1990)																	126				4.25
Casablanca (1942)																	100				4.24
Dark Knight, The (2008)																149				4.24
Usual Suspects, The (1995)															204				4.24
Princess Bride, The (1987)															142				4.23
Star Wars: Episode IV - A New Hope (1977)											251				4.23
Schindler's List (1993)																220				4.23
Apocalypse Now (1979)																107				4.22
American History X (1998)															129				4.22
Star Wars: Episode V - The Empire Strikes Back (1980)								211				4.22
Raiders of the Lost Ark (Indiana Jones and the Raiders of the Lost Ark) (1981)		200				4.21
One Flew Over the Cuckoo's Nest (1975)												133				4.2
Reservoir Dogs (1992)																131				4.2
Pulp Fiction (1994)																	307				4.2
Matrix, The (1999)																	278				4.19

```


Query 3: The most frequent genres, with the number of films in each, ordered by frequency decreasing.

```SQL
```

Query 4: The average rating per genre, with the number of ratings each average is based on, ordered by average descending.

```SQL

```
