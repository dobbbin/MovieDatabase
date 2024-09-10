DROP VIEW IF EXISTS MovieGenreList CASCADE;
DROP VIEW IF EXISTS MovieGenres CASCADE;
DROP VIEW IF EXISTS MovieAndGenre CASCADE;

DROP MATERIALIZED VIEW IF EXISTS MovieProductionList CASCADE;
DROP MATERIALIZED VIEW IF EXISTS MovieProducers CASCADE;
DROP MATERIALIZED VIEW IF EXISTS MovieAndProducer CASCADE;
DROP MATERIALIZED VIEW IF EXISTS NumProduced CASCADE;

DROP TABLE IF EXISTS AverageProfitByGenre CASCADE;
DROP TABLE IF EXISTS AverageProfitByCompany CASCADE;

CREATE INDEX idx_movieinfo_id ON MovieInfo(id);
CREATE INDEX idx_movieinfo_production_companies ON MovieInfo(production_companies);


CREATE TABLE AverageProfitByGenre(
    genre VARCHAR(50),
    average_profit INT,
    num_movies INT
);

CREATE TABLE AverageProfitByCompany(
    producer VARCHAR(500),
    average_profit BIGINT,
    num_movies INT
);


--Create table for Movie Id, Genre
CREATE VIEW MovieGenreList AS
SELECT id, ('{'||genres||'}')::text[] as genre_list
FROM MovieInfo;


CREATE VIEW MovieGenres AS
SELECT DISTINCT UNNEST(genre_list) as genre
FROM MovieGenreList;


CREATE VIEW MovieAndGenre AS 
SELECT id, genre
FROM MovieGenreList a JOIN MovieGenres b ON b.genre = ANY (a.genre_list);


--Create table for Movie ID, Production Company
CREATE MATERIALIZED VIEW MovieProductionList AS
SELECT id, ('{'||production_companies||'}')::text[] as producers 
FROM MovieInfo;


CREATE MATERIALIZED VIEW MovieProducers AS
SELECT UNNEST(producers) as producer
FROM MovieProductionList;

CREATE MATERIALIZED VIEW MovieAndProducer AS 
SELECT id as mid, producer
FROM MovieProductionList a JOIN MovieProducers b ON b.producer = ANY (a.producers);

CREATE INDEX idx_movieandproducer_mid ON MovieAndProducer(mid);
CREATE INDEX idx_movieandproducer_producer ON MovieAndProducer(producer);

CREATE MATERIALIZED VIEW NumProduced AS
SELECT producer, count(*) as count
FROM MovieAndProducer
GROUP BY producer;


--Movie Profits by Genre
INSERT INTO AverageProfitByGenre
SELECT genre, AVG(revenue-budget) as average_profit, COUNT(a.id) as num_movies
FROM MovieInfo a Join MovieAndGenre b ON a.id = b.id
GROUP BY genre
ORDER BY average_profit DESC;

--Movie Profits by Production Companies (Top 10) who have produced at least 5 movies
INSERT INTO AverageProfitByCompany
SELECT producer, AVG(revenue-budget) as average_profit, COUNT(DISTINCT id) as num_movies
FROM MovieInfo a JOIN (
    SELECT mid, c.producer
    FROM MovieAndProducer c JOIN NumProduced d ON c.producer = d.producer
    WHERE d.count >= 5) b ON a.id = b.mid
GROUP BY producer
ORDER BY average_profit DESC
LIMIT 10;

