# Netflix Movies and TV Shows Data Analysis using SQL
![](https://github.com/Arka-1998/NETFLIXSQL/blob/main/BrandAssets_Logos_02-NSymbol.jpg)
## Overview

This project entails doing a thorough study of Netflix's movie and TV program data using SQL.  The purpose is to extract important insights and answer various business issues using the information.  The README below contains a full summary of the project's aims, business challenges, solutions, findings, and conclusions.

## Objective

- Analyse the distribution of content kinds (movies against TV series).
- Determine the most frequent ratings for films and television shows.
- List and analyse material by release year, country, and duration.
- Explore and categorise information using particular parameters and keywords.

## Dataset

- link: [NETFLIX DATA](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema
```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
	show_id	VARCHAR(5),
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
```

## Business Problems and Solutions


## 1. Count the number of Movies vs TV Shows.

```sql
SELECT 
    type,
    COUNT(*)
FROM netflix
GROUP BY 1;
```
**Objective:** Determine the distribution of content types on Netflix.


## 2. Find the most common rating for movies and TV shows.

```sql
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
	RANKING=1;
```
**Objective:** Identify the most frequently occurring rating for each type of content.

## 3. List all movies released in a specific year (e.g., 2020).

```sql
SELECT *FROM netflix
WHERE 
	RELEASE_YEAR=2020
	AND
	TYPE='Movie';
```
**Objective:** Retrieve all movies released in a specific year.

## 4. Find the top 5 countries with the most content on Netflix.
```sql
SELECT 
	UNNEST(STRING_TO_ARRAY(COUNTRY,',')) AS NEW_COUNTRY,
	COUNT (show_id) AS TOTAL_COUNT

FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```
**Objective:** Identify the top 5 countries with the highest number of content items.

## 5. Identify the longest movie.
```sql
SELECT 
	TITLE,
	DURATION
FROM netflix
WHERE 
	TYPE='Movie'
	AND
	DURATION = (SELECT MAX(DURATION) FROM netflix);

```
**Objective:** Find the movie with the longest duration.

## 6. Find content added in the last 5 years.
```sql
SELECT * FROM netflix 
WHERE 
	TO_DATE(DATE_ADDED,'MONTH DD, YYYY') >= CURRENT_DATE - INTERVAL '5 YEARS';
```
**Objective:** Retrieve content added to Netflix in the last 5 years.

## 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
```sql
SELECT * FROM netflix
WHERE
	DIRECTOR LIKE '%Rajiv Chilaka%';
```
**Objective:** List all content directed by 'Rajiv Chilaka'.
## 8. List all TV shows with more than 5 seasons.
```sql
SELECT 
	TITLE,
	DURATION
FROM netflix
WHERE 
	TYPE='TV Show'
	AND
	SPLIT_PART(DURATION,' ',1)::NUMERIC >5;
```
**Objective:** Identify TV shows with more than 5 seasons.

## 9. Count the number of content items in each genre.
```sql
SELECT
	UNNEST(STRING_TO_ARRAY(LISTED_IN,',')) AS GENRE,
	COUNT (show_id) 
FROM netflix
GROUP BY 1;
```
**Objective:** Count the number of content items in each genre.

## 10.Find percentage of content release in India every year on netflix.
```sql
SELECT
	EXTRACT(YEAR FROM TO_DATE(DATE_ADDED,'MONTH DD, YYYY')) AS YEAR,
	COUNT(*),
	ROUND(COUNT(*)::NUMERIC/(SELECT COUNT(*) FROM NETFLIX WHERE COUNTRY LIKE '%India%')::NUMERIC*100,2) PERCENTAGE
FROM netflix
WHERE COUNTRY LIKE '%India%'
GROUP BY 1;

```
**Objective:** Calculate and rank years by the percent of content releases by India.

## 11. List all movies that are documentaries.
```sql
SELECT * FROM netflix
WHERE 
	LISTED_IN LIKE '%Documentaries%'
	AND
	TYPE = 'Movie';
```
**Objective:** Retrieve all movies classified as documentaries.

## 12. Find all content without a director.
```sql
SELECT * FROM netflix
WHERE 
	DIRECTOR IS NULL;
```
**Objective:** List content that does not have a director.

## 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
```sql
SELECT * FROM netflix
WHERE 
	CASTS LIKE '%Salman Khan%'
	AND
	TYPE = 'Movie'
	AND
	TO_DATE(DATE_ADDED,'MONTH DD, YYYY') >= CURRENT_DATE - INTERVAL '10 YEARS';
```
**Objective:** Count the number of movies featuring a perticular actor in the last 10 years.

## 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
```sql
SELECT 
	UNNEST(STRING_TO_ARRAY(CASTS,',')) AS ACTOR,
	COUNT(*)
FROM netflix
WHERE COUNTRY LIKE '%India%'
GROUP BY 1
ORDER BY 2 DESC
limit 10;
```
**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

## 15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in

the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.

```sql
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
```	 
**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.
	 

## Findings and Conclusion

- **Content Distribution:** The dataset includes a wide range of films and television series of varied ratings and genres.
- **popular Ratings:** Insights on the most popular ratings help to determine the content's intended demographic.
- **Geographical Insights:** The top nations and average content releases from India demonstrate regional content distribution.
- **Content Categorisation:** Categorising content based on certain keywords aids in identifying the type of content accessible on Netflix.
- **Production Insights:** Insight into the number of appearances of each actor or director on the Netflix platform, as well as the most frequently seen faces of actors in a certain nation on the Netflix platform.





