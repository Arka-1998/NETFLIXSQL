--NETFLIX PROJECT


DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
	show_id	VARCHAR(50),
	type    VARCHAR(10),
	title	VARCHAR(250),
	director VARCHAR(550),
	casts	VARCHAR(1050),
	country	VARCHAR(550),
	date_added	VARCHAR(55),
	release_year	INT,
	rating	VARCHAR(15),
	duration	VARCHAR(15),
	listed_in	VARCHAR(250),
	description VARCHAR(550)
);

SELECT * FROM netflix;

-- 15 Business Problems & Solutions

1. Count the number of Movies vs TV Shows


SELECT 
    type,
    COUNT(*)
FROM netflix
GROUP BY 1;


--2. Find the most common rating for movies and TV shows

SELECT 
	TYPE,
	RATING
FROM 
(
SELECT
	TYPE,
	RATING,
	COUNT(*),
	RANK() OVER(PARTITION BY TYPE ORDER BY COUNT(*) DESC) AS RANKING
FROM netflix
GROUP BY 1,2
) AS X1
WHERE 
	RANKING=1

--3. List all movies released in a specific year (e.g., 2020)

SELECT *FROM netflix
WHERE 
	RELEASE_YEAR=2020
	AND
	TYPE='Movie';

--4. Find the top 5 countries with the most content on Netflix

SELECT 
	UNNEST(STRING_TO_ARRAY(COUNTRY,',')) AS NEW_COUNTRY,
	COUNT (show_id) AS TOTAL_COUNT

FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--5. Identify the longest movie

SELECT 
	TITLE,
	DURATION
FROM netflix
WHERE 
	TYPE='Movie'
	AND
	DURATION = (SELECT MAX(DURATION) FROM netflix);


--6. Find content added in the last 5 years

SELECT * FROM netflix 
WHERE 
	TO_DATE(DATE_ADDED,'MONTH DD, YYYY') >= CURRENT_DATE - INTERVAL '5 YEARS';


--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT * FROM netflix
WHERE
	DIRECTOR LIKE '%Rajiv Chilaka%';

--8. List all TV shows with more than 5 seasons

SELECT 
	TITLE,
	DURATION
FROM netflix
WHERE 
	TYPE='TV Show'
	AND
	SPLIT_PART(DURATION,' ',1)::NUMERIC >5;

--9. Count the number of content items in each genre

SELECT
	UNNEST(STRING_TO_ARRAY(LISTED_IN,',')) AS GENRE,
	COUNT (show_id) 
FROM netflix
GROUP BY 1;

--10.Find each year and the average numbers of content release in India on netflix.return top 5 year with highest avg content release!

SELECT
	EXTRACT(YEAR FROM TO_DATE(DATE_ADDED,'MONTH DD, YYYY')) AS YEAR,
	COUNT(*),
	ROUND(COUNT(*)::NUMERIC/(SELECT COUNT(*) FROM NETFLIX WHERE COUNTRY LIKE '%India%')::NUMERIC*100,2) PERCENTAGE
FROM netflix
WHERE COUNTRY LIKE '%India%'
GROUP BY 1;


--11. List all movies that are documentaries

SELECT * FROM netflix
WHERE 
	LISTED_IN LIKE '%Documentaries%'
	AND
	TYPE = 'Movie';

--12. Find all content without a director

SELECT * FROM netflix
WHERE 
	DIRECTOR IS NULL;

--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT * FROM netflix
WHERE 
	CASTS LIKE '%Salman Khan%'
	AND
	TYPE = 'Movie'
	AND
	TO_DATE(DATE_ADDED,'MONTH DD, YYYY') >= CURRENT_DATE - INTERVAL '10 YEARS';


--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT 
	UNNEST(STRING_TO_ARRAY(CASTS,',')) AS ACTOR,
	COUNT(*)
FROM netflix
WHERE COUNTRY LIKE '%India%'
GROUP BY 1
ORDER BY 2 DESC
limit 10;

--15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.


WITH NEW_TABLE
AS(
SELECT 

	case
		when
			DESCRIPTION ILIKE '%kill%'
		OR
			DESCRIPTION ILIKE '%violence%'
		THEN 'GOOD'	
		ELSE 'BAD'
	END CATEGORY	
FROM netflix
)
SELECT 
	 CATEGORY,
	 COUNT(*) AS TOTAL_CONTENT
FROM NEW_TABLE
GROUP BY 1;
	 
	 
	 
