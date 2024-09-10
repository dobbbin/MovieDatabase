DROP SCHEMA IF EXISTS Movies CASCADE;
CREATE SCHEMA Movies;
SET search_path TO MOVIES;
SET CLIENT_ENCODING TO 'utf8';

--imdb not unique since dataset doesn't have imdb_ids for all movies
CREATE TABLE TempMovieInfo (
  id SERIAL, 
  title VARCHAR(3000), 
  vote_average REAL, 
  vote_count INT, 
  is_released VARCHAR(15),  
  release_date DATE, 
  revenue BIGINT, 
  runtime INT, 
  adult BOOLEAN, 
  backdrop_path TEXT, 
  budget INT, 
  homepage TEXT, 
  imdb_id VARCHAR(10), 
  original_language VARCHAR(50), 
  original_title VARCHAR(300), 
  overview TEXT, 
  popularity FLOAT,
  poster_path TEXT, 
  tagline VARCHAR(500), 
  genres TEXT, 
  production_companies TEXT, 
  production_counties TEXT, 
  spoken_languages TEXT, keywords TEXT);


\copy TempMovieInfo FROM 'C:\Path\To\TMDB_movie_dataset_v11.csv' WITH (FORMAT CSV,HEADER TRUE, NULL '', delimiter ',', FORCE_NULL (release_date));

CREATE TABLE MovieInfo (
  id SERIAL PRIMARY KEY, 
  title VARCHAR(3000), 
  vote_average REAL, 
  vote_count INT, 
  release_date DATE, 
  revenue BIGINT, 
  runtime INT,  
  budget INT, 
  original_language VARCHAR(50),
  genres TEXT, 
  production_companies TEXT
  );
