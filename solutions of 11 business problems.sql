
--Netflix project--
CREATE DATABASE NETFLIX
USE NETFLIX


--Here table name is netflix--
SELECT * FROM netflix

--Count how many rows are there--
select count(*) from netflix

--Here we are the finding the solutions using sql queries--
-- 11 Business Problems & Solutions--

1. Count the number of Movies vs TV Shows
2. Find the most common rating for movies and TV shows
3. List all movies released in a specific year (e.g., 2020)
4. Find the top 5 countries with the most content on Netflix
5. Identify the longest movie
6. Find content added in the last 5 years
7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
8. List all TV shows with more than 5 seasons
9. Count the number of content items in each genre
10. List all movies that are documentaries
11. Find all content without a director



-- Netflix Data Analysis using SQL--
-- 1. Count the number of Movies vs TV Shows--
SELECT 
	type,
	COUNT(*)
FROM netflix
GROUP BY type

-- 2. Find the most common rating for movies and TV shows--

WITH RatingCounts AS (
    SELECT 
        type,
        rating,
        COUNT(*) AS rating_count
    FROM netflix
    GROUP BY type, rating
),
RankedRatings AS (
    SELECT 
        type,
        rating,
        rating_count,
        RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rank
    FROM RatingCounts
)
SELECT 
    type,
    rating AS most_frequent_rating
FROM RankedRatings
WHERE rank = 1;


-- 3. List all movies released in a specific year (e.g., 2020)

SELECT * 
FROM netflix
WHERE release_year = 2020


-- 4. Find the top 5 countries with the most content on Netflix


SELECT TOP 5 
    TRIM(value) AS country,
    COUNT(*) AS total_content
FROM netflix
CROSS APPLY STRING_SPLIT(country, ',')
WHERE country IS NOT NULL
GROUP BY TRIM(value)
ORDER BY total_content DESC;


-- 5. Identify the longest movie

SELECT TOP 1 *
FROM netflix
WHERE type = 'Movie'
ORDER BY 
    TRY_CAST(LEFT(duration, CHARINDEX(' ', duration + ' ') - 1) AS INT) DESC;



-- 6. Find content added in the last 5 years
SELECT *
FROM netflix
WHERE TRY_CONVERT(DATE, date_added, 107) >= DATEADD(YEAR, -5, GETDATE());


-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

select*from netflix where director= 'Rajiv Chilaka'


-- 8. List all TV shows with more than 5 seasons
SELECT *
FROM netflix
WHERE TYPE = 'TV Show'
  AND CAST(LEFT(duration, CHARINDEX(' ', duration) - 1) AS INT) > 5;



-- 9. Count the number of content items in each genre

SELECT 
    genre, 
    COUNT(*) as total_content
FROM
    (
        SELECT value AS genre
        FROM netflix
		 CROSS APPLY STRING_SPLIT(listed_in, ',')
       
    ) AS genres
GROUP BY genre;



-- 10. List all movies that are documentaries--
SELECT * FROM netflix
WHERE listed_in like '%Documentaries'



-- 11. Find all content without a director--

SELECT *
FROM netflix
WHERE director IS NULL OR LTRIM(RTRIM(director)) = ''


-- End of reports





