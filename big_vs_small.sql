SET search_path to MOVIES;

DROP TABLE IF EXISTS BigVsSmallBudgetProfit CASCADE;
DROP TABLE IF EXISTS BigVsMediumVsSmallBudgetProfit CASCADE;
DROP TABLE IF EXISTS TenYearBudgetSize CASCADE;

CREATE TABLE BigVsSmallBudgetProfit (
    big_budget_profit INT,
    low_budget_profit INT
);

CREATE TABLE BigVsMediumVsSmallBudgetProfit (
    big_budget_profit INT,
    med_budget_profit INT,
    low_budget_profit INT
);

CREATE TABLE TenYearBudgetSize (
    year INT,
    count_big INT,
    big_budget_profit INT,
    big_budget_percent_profit INT,
    count_mid INT,
    med_budget_profit INT,
    med_budget_percent_profit INT,
    count_low INT,
    low_budget_profit INT,
    low_budget_percent_profit INT
);

-- Movie Budgets over 200M vs less than 200M
INSERT INTO BigVsSmallBudgetProfit
SELECT AVG(CASE WHEN budget >= 200000000 THEN revenue-budget END) as big_budget_profit, 
AVG(CASE WHEN budget < 200000000 THEN revenue-budget END) as low_budget_profit
FROM MovieInfo
WHERE revenue != 0 and budget!= 0;


-- Movie Budgets over 200M vs 100M to 199.999M 
INSERT INTO BigVsMediumVsSmallBudgetProfit
SELECT AVG(CASE WHEN budget >= 200000000 THEN revenue-budget END) as big_budget_profit, 
AVG(CASE WHEN budget < 200000000 AND budget >= 100000000 THEN revenue-budget END) as med_budget_profit,
AVG(CASE WHEN budget < 100000000 THEN revenue-budget END) as low_budget_profit
FROM MovieInfo
WHERE revenue != 0 and budget!= 0;


--Movie Budgets <100M , [100M,200M), >200M for each year of the past 10 years
INSERT INTO TenYearBudgetSize
SELECT EXTRACT(YEAR FROM release_date) as year, COUNT(CASE WHEN budget >= 200000000 THEN id END) AS count_big, 
AVG(CASE WHEN budget >= 200000000 THEN revenue-budget END) as big_budget_profit,
AVG(CASE WHEN budget >= 200000000 THEN (revenue/budget)*100 END) as big_budget_percent_profit,
COUNT(CASE WHEN budget < 200000000 AND budget >= 100000000 THEN id END) as count_mid,
AVG(CASE WHEN budget < 200000000 AND budget >= 100000000 THEN revenue-budget END) as med_budget_profit,
AVG(CASE WHEN budget < 200000000 AND budget >= 100000000 THEN (revenue/budget)*100 END) as med_budget_percent_profit,
COUNT(CASE WHEN budget < 100000000 THEN id END) as count_low,
AVG(CASE WHEN budget < 100000000 THEN revenue-budget END) as low_budget_profit,
AVG(CASE WHEN budget < 100000000 THEN (revenue/budget)*100 END) as low_budget_percent_profit 
FROM MovieInfo
WHERE revenue != 0 and budget!= 0
GROUP BY EXTRACT(YEAR FROM release_date)
HAVING EXTRACT(YEAR FROM release_date) > 2013 AND EXTRACT(YEAR FROM release_date) < 2024;




