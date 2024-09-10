SET search_path to MOVIES;

DROP TABLE IF EXISTS AverageProfit CASCADE;
DROP TABLE IF EXISTS AverageProfitByLanguage CASCADE;
DROP TABLE IF EXISTS AverageProfitByMonth CASCADE;
DROP TABLE IF EXISTS AverageProfitByYear CASCADE;
DROP TABLE IF EXISTS MaxProfit CASCADE;
DROP TABLE IF EXISTS MinProfit CASCADE;

CREATE TABLE AverageProfit (
    average_profit INT,
    num_movies INT
);

CREATE TABLE AverageProfitByLanguage(
    original_language VARCHAR(50),
    average_profit INT,
    num_movies INT
);


CREATE TABLE AverageProfitByMonth(
    month VARCHAR(50),
    average_profit INT,
    num_movies INT
);

CREATE TABLE AverageProfitByYear(
    year VARCHAR(50),
    average_profit INT,
    num_movies INT
);

CREATE TABLE MaxProfit(
    id INT,
    title  VARCHAR(3000),
    year INT,
    revenue BIGINT,
    budget INT,
    profit BIGINT
);

CREATE TABLE MinProfit(
    id INT,
    title  VARCHAR(3000),
    year INT,
    revenue INT,
    budget INT,
    profit INT
);

--Only considering movies which have revenue reported

-- Average profit of a movie in this data set
INSERT INTO AverageProfit
SELECT AVG(revenue-budget) as average_profit, count(id) as num_movies
FROM MovieInfo;

--Average Profit of a movie based on what the original language was
INSERT INTO AverageProfitByLanguage
SELECT original_language, AVG(revenue-budget) as average_profit, count(id) as num_movies
FROM MovieInfo
GROUP BY original_language
ORDER BY original_language;

--Average Profit of a movie based on what month it was released in
INSERT INTO AverageProfitByMonth
SELECT EXTRACT(MONTH FROM release_date) as month, AVG(revenue-budget) as average_profit, count(id) as num_movies
FROM MovieInfo
WHERE release_date IS NOT NULL
GROUP BY EXTRACT(MONTH FROM release_date)
ORDER BY month;


--Average Profit of a movie based on what year it was released in 
INSERT INTO AverageProfitByYear
SELECT EXTRACT(YEAR FROM release_date) as year, AVG(revenue-budget) as average_profit, count(id) as num_movies
FROM MovieInfo
WHERE release_date IS NOT NULL
GROUP BY EXTRACT(YEAR FROM release_date)
ORDER BY year;


--Most Profitable Movie
INSERT INTO MaxProfit
SELECT id, title, EXTRACT(YEAR FROM release_date) as year, revenue, budget, revenue-budget as profit
FROM (SELECT MAX(revenue-budget) as profit 
        FROM MovieInfo
        WHERE EXTRACT(YEAR FROM release_date) < 2024) a JOIN 
        (SELECT id, title, release_date, revenue, budget, (revenue-budget) as profit 
        FROM MovieInfo
        WHERE EXTRACT(YEAR FROM release_date) < 2024) b ON a.profit = b.profit
WHERE EXTRACT(YEAR FROM release_date) < 2024;

--Least Profitable Movie
INSERT INTO MinProfit
SELECT id, title, EXTRACT(YEAR FROM release_date) as year, revenue, budget, revenue-budget as profit
FROM (SELECT MIN(revenue-budget) as profit 
        FROM MovieInfo
        WHERE EXTRACT(YEAR FROM release_date) < 2024) a JOIN 
        (SELECT  id, title, release_date, revenue, budget, (revenue-budget) as profit 
        FROM MovieInfo
        WHERE EXTRACT(YEAR FROM release_date) < 2024) b ON a.profit = b.profit
WHERE EXTRACT(YEAR FROM release_date) < 2024;