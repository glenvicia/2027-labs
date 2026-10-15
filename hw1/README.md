# 23D021 Data Management - hw1 - glenvicia

## Dataset

This assignment uses GroupLens' smaller MovieLens dataset, [ml-latest-small](https://files.grouplens.org/datasets/movielens/ml-latest-small.zip). I completed this assignment in the 2027-labs repository.

Since the CSVs are not stored in this repository, please download and extract them locally from the repository root using PowerShell:

```powershell
New-Item -ItemType Directory -Force .\hw1\data | Out-Null
Invoke-WebRequest `
  -Uri https://files.grouplens.org/datasets/movielens/ml-latest-small.zip `
  -OutFile .\hw1\movielens.zip
Expand-Archive `
  -Path .\hw1\movielens.zip `
  -DestinationPath .\hw1\data `
  -Force
```

The SQL load uses `movies.csv` and `ratings.csv` from `hw1\data\ml-latest-small`. The download, extracted files, and any copies of the CSVs are ignored by Git and should not be committed.

## Run the SQL files

Install and start Docker Desktop, then run these commands from the repository root. The CSVs and SQL scripts are copied into the PostgreSQL container so that the `\copy` commands in `load.sql` can read them:

```powershell
docker compose up -d postgres

docker compose cp .\hw1\data\ml-latest-small\movies.csv postgres:/tmp/movies.csv
docker compose cp .\hw1\data\ml-latest-small\ratings.csv postgres:/tmp/ratings.csv
docker compose cp .\hw1\schema.sql postgres:/tmp/schema.sql
docker compose cp .\hw1\load.sql postgres:/tmp/load.sql
docker compose cp .\hw1\queries.sql postgres:/tmp/queries.sql

docker compose exec postgres psql -v ON_ERROR_STOP=1 -U labs -d labs -f /tmp/schema.sql
docker compose exec postgres psql -v ON_ERROR_STOP=1 -U labs -d labs -f /tmp/load.sql
docker compose exec postgres psql -v ON_ERROR_STOP=1 -U labs -d labs -f /tmp/queries.sql
```

The local PostgreSQL connection is `localhost:5432`, database `labs`, username `labs`, password `labs`. Optionally, start pgAdmin with `docker compose up -d pgadmin` and open [http://localhost:5050](http://localhost:5050); it is preconfigured to connect to the database. Use psql for `load.sql`.

Running `schema.sql` drops and recreates the assignment tables. To stop the database without removing its data, run `docker compose stop postgres`.

## Dataset note

MovieLens' `movies.csv` includes movies that have a rating or a tag. This assignment loads ratings but not tags, so some movies have no ratings; that explains the result of Claim 3.
