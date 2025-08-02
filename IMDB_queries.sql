-- Segment 1:


-- Q1. Find the total number of rows in each table of the schema?

SELECT count(*) AS total_rows_movie FROM movie;
SELECT count(*) AS total_rows_genre FROM genre;
SELECT count(*) AS total_rows_director_maping FROM director_mapping;
SELECT count(*) AS total_rows_role_mapping FROM role_mapping;
SELECT count(*) AS total_rows_names FROM names;
SELECT count(*) AS total_rows_ratings FROM ratings;





-- Q2. Which columns in the movie table have null values?

SELECT
(SELECT count(*) FROM movie WHERE id IS NULL) AS id,
(SELECT count(*) FROM movie WHERE title IS NULL) AS title,
(SELECT count(*) FROM movie WHERE year  IS NULL) AS year,
(SELECT count(*) FROM movie WHERE date_published  IS NULL) AS date_published,
(SELECT count(*) FROM movie WHERE duration  IS NULL) AS duration,
(SELECT count(*) FROM movie WHERE country  IS NULL) AS year, 
(SELECT count(*) FROM movie WHERE worlwide_gross_income  IS NULL) AS worlwide_gross_income,
(SELECT count(*) FROM movie WHERE languages  IS NULL) AS languages,
(SELECT count(*) FROM movie WHERE production_company  IS NULL) AS production_company;




-- Q3. Find the total number of movies released each year? How does the trend look month wise?

SELECT year, COUNT(title) AS count_movie FROM movie GROUP BY 1;

SELECT MONTH(date_published) AS month_number, MONTHNAME(date_published) AS month, COUNT(title) AS total_movies_monthwise
FROM movie GROUP BY 1,2 ORDER BY 3 DESC;



  
-- Q4. How many movies were produced in the USA or India in the year 2019??

SELECT COUNT(*) FROM movie WHERE (country LIKE '%USA%' OR country LIKE '%INDIA%') AND year = '2019';




-- Q5. Find the unique list of the genres present in the dataset?

SELECT DISTINCT(genre) FROM genre;




-- Q6.Which genre had the highest number of movies produced overall?

SELECT COUNT(movie_id) AS number_of_movies, genre FROM genre GROUP BY 2 ORDER BY 1 DESC LIMIT 1;




-- Q7. How many movies belongs to only one genre?

WITH cte AS(
SELECT movie_id, COUNT(genre) AS total_genre
FROM genre
GROUP BY 1
)
SELECT COUNT(*) AS movies_belongs_to_one_genre FROM cte where total_genre = 1;




-- Q8.What is the average duration of movies in each genre? 

SELECT ROUND(AVG(duration),2) AS avg_duration, genre FROM genre g JOIN movie m ON g.movie_id = m.id GROUP BY 2;




-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 

WITH cte AS(
SELECT
genre, COUNT(movie_id) AS movie_count, RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS genre_rank
FROM genre
GROUP BY 1
)
SELECT * FROM cte WHERE genre = 'Thriller';




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?

SELECT 
   MIN(avg_rating)    AS min_avg_rating,
   MAX(avg_rating)    AS max_avg_rating,
   MIN(total_votes)   AS min_total_votes,
   MAX(total_votes)   AS max_total_votes,
   MIN(median_rating) AS min_median_rating,
   MAX(median_rating) AS max_median_rating
FROM ratings;




-- Q11. Which are the top 10 movies based on average rating?
SELECT title, avg_rating, DENSE_RANK() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM ratings r INNER JOIN movie m ON r.movie_id = m.id
LIMIT 10;

SELECT 
  title,
  ROUND(AVG(avg_rating), 2) AS avg_rating,
  RANK() OVER (ORDER BY AVG(avg_rating) DESC) AS movie_rank
FROM ratings r inner join movie m on r.movie_id = m.id
GROUP BY title
ORDER BY avg_rating DESC
LIMIT 10;




-- Q12. Summarise the ratings table based on the movie counts by median ratings.

SELECT median_rating, COUNT(movie_id) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY 1;




-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??

SELECT production_company, COUNT(title) AS movie_count, DENSE_RANK() OVER(ORDER BY COUNT(title) DESC) AS prod_company_rank
FROM movie m
INNER JOIN ratings r ON m.id = r.movie_id
WHERE avg_rating > 8 AND production_company IS NOT NULL
GROUP BY 1 ORDER BY 2 DESC;




-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?

SELECT genre, COUNT(title) AS movie_count
FROM genre g
INNER JOIN movie m ON g.movie_id = m.id
INNER JOIN ratings r ON m.id = r.movie_id
WHERE date_published
BETWEEN '2017-03-01' AND '2017-03-31'
AND country LIKE '%USA%'
AND total_votes >1000
GROUP BY 1 ORDER BY 2 DESC;




-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?

SELECT title, avg_rating, genre
FROM movie m
INNER JOIN ratings r ON m.id = r.movie_id
INNER JOIN genre g ON g.movie_id = m.id
WHERE title LIKE 'The%'
AND avg_rating > 8;




-- Q16. Which of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?

SELECT title, date_published
FROM movie m INNER JOIN ratings r ON m.id = r.movie_id
WHERE date_published BETWEEN '2018-04-01' AND '2019-04-01'
AND median_rating = 8
ORDER BY 2;




-- Q17. Do German movies get more votes than Italian movies? 

SELECT country, SUM(total_votes) AS total_votes
FROM movie m
INNER JOIN ratings r ON m.id=r.movie_id
WHERE country = 'germany' OR country = 'italy'
GROUP BY country;

-- Answer is YES.




-- Segment 3:



-- Q18. Which columns in the names table have null values??

SELECT
(SELECT COUNT(*) FROM names WHERE name IS NULL) AS name_nulls,
(SELECT COUNT(*) FROM names WHERE height IS NULL) AS height_nulls,
(SELECT COUNT(*) FROM names WHERE date_of_birth IS NULL) AS date_of_birth_nulls,
(SELECT COUNT(*) FROM names WHERE known_for_movies IS NULL) AS known_for_movies_nulls;




-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?

WITH top_3_genres AS(
    SELECT genre, COUNT(m.id) AS movie_count, DENSE_RANK() OVER(ORDER BY COUNT(m.id) DESC) AS genre_rank
    FROM movie m
	INNER JOIN genre g ON m.id = g.movie_id
	INNER JOIN ratings r ON r.movie_id = m.id  
    WHERE avg_rating > 8
    GROUP BY genre LIMIT 3 
    )

SELECT name AS director_name, COUNT(dm.movie_id) AS movie_count
FROM director_mapping dm
INNER JOIN genre g USING (movie_id)
INNER JOIN names n ON n.id = dm.name_id
INNER JOIN top_3_genres USING (genre)
INNER JOIN ratings USING (movie_id)
WHERE avg_rating > 8
GROUP BY name
ORDER BY movie_count DESC LIMIT 3;




-- Q20. Who are the top two actors whose movies have a median rating >= 8?

SELECT name AS actor_name, COUNT(DISTINCT rm.movie_id) AS movie_count
FROM names n
INNER JOIN role_mapping rm ON n.id = rm.name_id
INNER JOIN ratings r ON r.movie_id = rm.movie_id
WHERE median_rating >= 8
GROUP BY 1 ORDER BY 2 DESC
LIMIT 2;




-- Q21. Which are the top three production houses based on the number of votes received by their movies?

SELECT production_company, SUM(total_votes) AS vote_count, DENSE_RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM movie m
INNER JOIN ratings r ON m.id = r.movie_id
GROUP BY 1 ORDER BY 2 DESC
LIMIT 3;




-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 

SELECT name AS actor_name, SUM(total_votes) AS total_votes,
COUNT(DISTINCT m.id) AS movie_count, ROUND(AVG(avg_rating),2) AS actor_avg_rating,
DENSE_RANK() OVER(ORDER BY SUM(total_votes) DESC) AS actor_rank
FROM names n
INNER JOIN role_mapping rm ON n.id = rm.name_id
INNER JOIN movie m ON  rm.movie_id = m.id
INNER JOIN ratings r ON r.movie_id = m.id
WHERE country LIKE '%India%' AND category = 'actor'
GROUP BY 1
HAVING COUNT(DISTINCT m.id) >= 5
ORDER BY 5;




-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 

SELECT n.name AS actress_name, SUM(r.total_votes) AS total_votes,
COUNT(DISTINCT m.id) AS movie_count,
ROUND(AVG(r.avg_rating), 2) AS actress_avg_rating,
RANK() OVER (ORDER BY AVG(r.avg_rating) DESC) AS actress_rank
FROM names n
INNER JOIN role_mapping rm ON n.id = rm.name_id
INNER JOIN movie m ON rm.movie_id = m.id
INNER JOIN ratings r ON m.id = r.movie_id
WHERE rm.category = 'actress' AND m.country LIKE '%India%' AND m.languages LIKE '%Hindi%'
GROUP BY n.id, n.name
HAVING COUNT(DISTINCT m.id) >= 3
ORDER BY actress_rank
LIMIT 5;




/* Q24. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
   the following categories:  

			Rating > 8: Superhit
			Rating between 7 and 8: Hit
			Rating between 5 and 7: One-time-watch
			Rating < 5: Flop
	
    Note: Sort the output by average ratings (desc).
--------------------------------------------------------------------------------------------*/

SELECT DISTINCT title AS movie_name, avg_rating, total_votes,
CASE
	WHEN avg_rating > 8 THEN 'Superhit'
	WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit'
	WHEN avg_rating BETWEEN 5 AND 7 THEN 'One_time_watch'
    ELSE 'Flop' END AS movie_category
FROM movie m
INNER JOIN ratings r ON m.id = r.movie_id
INNER JOIN genre USING (movie_id)
WHERE genre = 'Thriller' AND total_votes >= 25000
ORDER BY 2 DESC;




-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 

WITH genre_durations AS (
SELECT g.genre, AVG(m.duration) AS avg_duration
FROM genre g
JOIN movie m ON g.movie_id = m.id
WHERE m.duration IS NOT NULL
GROUP BY g.genre
)
SELECT genre,
ROUND(avg_duration, 2) AS avg_duration,
ROUND(SUM(avg_duration) OVER (ORDER BY genre ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS running_total_duration,
ROUND(AVG(avg_duration) OVER (ORDER BY genre ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS moving_avg_duration
FROM genre_durations;




-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

WITH top_3_genres AS (
    SELECT genre,
	COUNT(m.id) AS movie_count,
	RANK() OVER (ORDER BY COUNT(m.id) DESC) AS genre_rank
    FROM movie AS m
    INNER JOIN genre AS g ON g.movie_id = m.id
    INNER JOIN ratings AS r ON r.movie_id = m.id
    GROUP BY genre
), 
movie_summary AS (
    SELECT genre, year, title AS movie_name, 
	CAST(REPLACE(REPLACE(IFNULL(worlwide_gross_income, '0'), 'INR', ''), '$', '') AS DECIMAL(15,2)) AS worlwide_gross_income,
	DENSE_RANK() OVER (PARTITION BY year ORDER BY 
	CAST(REPLACE(REPLACE(IFNULL(worlwide_gross_income, '0'), 'INR', ''), '$', '') AS DECIMAL(15,2)) DESC) AS movie_rank
    FROM movie AS m
    INNER JOIN genre AS g ON m.id = g.movie_id
    WHERE genre IN (SELECT genre FROM top_3_genres WHERE genre_rank <= 3)  -- Corrected filtering
    GROUP BY movie_name, genre, year, worlwide_gross_income
)
SELECT * FROM movie_summary
WHERE movie_rank <= 5
ORDER BY year;




-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?

WITH production_company_detail AS (
	SELECT production_company,
	COUNT(*) AS movie_count
	FROM movie AS m
	INNER JOIN ratings AS r ON r.movie_id = m.id
	WHERE median_rating >= 8 AND production_company IS NOT NULL AND POSITION(',' IN languages) > 0
	GROUP BY production_company
	ORDER BY movie_count DESC
    )
SELECT *, Rank() over( ORDER BY movie_count DESC) AS prod_comp_rank
FROM production_company_detail
LIMIT 2;




-- Q28. Who are the top 3 actresses based on the number of Super Hit movies (Superhit movie: average rating of movie > 8) in 'drama' genre?
-- Note: Consider only superhit movies to calculate the actress average ratings.

WITH actress_summary AS(
	SELECT n.name AS actress_name,
	SUM(total_votes) AS total_votes,
	COUNT(r.movie_id) AS movie_count,
	ROUND(SUM(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating
	FROM movie AS m
	INNER JOIN ratings AS r ON m.id=r.movie_id
	INNER JOIN role_mapping AS rm ON m.id = rm.movie_id
	INNER JOIN names AS n ON rm.name_id = n.id
	INNER JOIN GENRE AS g ON g.movie_id = m.id
	WHERE category = 'Actress' AND avg_rating>8 AND genre = "Drama"
	GROUP BY name
    )
SELECT *, Rank() OVER(ORDER BY movie_count DESC) AS actress_rank
FROM actress_summary
LIMIT 3;




/* Q29. Get the following details for top 9 directors (based on number of movies)
	a) Director id
	b) Name
	c) Number of movies
	d) Average inter movie duration in days
	e) Average movie ratings
	f) Total votes
	g) Min rating
	h) Max rating
	i) total movie durations
*/

WITH director_movies AS (
    SELECT dm.name_id AS director_id,
	n.name, m.id AS movie_id,
	m.date_published,
	m.duration, r.avg_rating,
	r.total_votes
    FROM director_mapping dm
    JOIN names n ON dm.name_id = n.id
    JOIN movie m ON dm.movie_id = m.id
    JOIN ratings r ON m.id = r.movie_id
    WHERE m.date_published IS NOT NULL
),

ranked_directors AS (
    SELECT director_id, name,
	COUNT(*) AS movie_count
    FROM director_movies
    GROUP BY director_id, name
    ORDER BY movie_count DESC
    LIMIT 9
),

movies_with_gaps AS (
    SELECT dm.director_id,
	dm.name, dm.movie_id,
	dm.date_published,
	dm.duration, dm.avg_rating,
	dm.total_votes,
	DATEDIFF(dm.date_published, LAG(dm.date_published) OVER (PARTITION BY dm.director_id ORDER BY dm.date_published)) AS inter_movie_days
    FROM director_movies dm
    JOIN ranked_directors rd ON dm.director_id = rd.director_id
),

final_data AS (
    SELECT director_id, name,
	COUNT(movie_id) AS number_of_movies,
	ROUND(AVG(inter_movie_days), 2) AS avg_inter_movie_days,
	ROUND(AVG(avg_rating), 2) AS average_movie_rating,
	SUM(total_votes) AS total_votes,
	MIN(avg_rating) AS min_rating,
	MAX(avg_rating) AS max_rating,
	SUM(duration) AS total_movie_duration
    FROM movies_with_gaps
    GROUP BY director_id, name
)

SELECT director_id, name,
number_of_movies,
avg_inter_movie_days,
average_movie_rating,
total_votes,
min_rating, max_rating,
total_movie_duration
FROM final_data
ORDER BY number_of_movies DESC;
