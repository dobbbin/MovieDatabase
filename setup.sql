--The original CSV file contained several duplicate entries 

WITH DuplicateRows AS (
    SELECT 
        id,
        ROW_NUMBER() OVER (PARTITION BY id ORDER BY id) AS RowNum
    FROM 
        TempMovieInfo
)
DELETE FROM TempMovieInfo
WHERE id IN (
    SELECT id
    FROM DuplicateRows
    WHERE RowNum > 1
);



INSERT INTO MovieInfo
SELECT id, title, vote_average, vote_count, release_date, revenue, runtime, budget, original_language, genres, production_companies
FROM TempMovieInfo
WHERE revenue IS NOT NULL and budget IS NOT NULL and EXTRACT(YEAR FROM release_date) < 2024 AND 
adult = FALSE AND budget > 1000000 AND revenue > 0 and EXTRACT(YEAR FROM release_date) >= 1975;

DROP Table TempMovieInfo;
