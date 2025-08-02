# 🎬 IMDB Movie Database Analysis — SQL Project 📊

## 📖 Project Overview:
This project involves comprehensive SQL-based analysis on an IMDB-style movie dataset. The objective is to extract business insights such as top-rated movies, director productivity, genre performance, and global movie trends using advanced SQL querying techniques. This project demonstrates my ability to handle normalized databases, write complex SQL queries, and solve real-world data problems.

---

## 🗂️ Dataset Structure:
The dataset consists of multiple interconnected tables:
- **movie** — (id, title, year, date_published, duration, country, worldwide_gross_income, languages, production_company)
- **genre** — (movie_id, genre)
- **names** — (id, name, height, date_of_birth, known_for_movies)
- **director_mapping** — (movie_id, name_id)
- **role_mapping** — (movie_id, name_id, category)
- **ratings** — (movie_id, avg_rating, total_votes, median_rating)

---

## 🛠️ SQL Techniques Used:
- Multi-table **JOINs** (INNER JOIN, LEFT JOIN)
- **Common Table Expressions (CTEs)** for modular queries
- **Window Functions** — RANK(), LEAD(), LAG() for time-based analysis
- Aggregation with **GROUP BY**
- **Subqueries** and derived tables
- Data cleaning using **SQL Functions** (NULL handling, type casting)

---

## 📌 Business Questions Solved:
1. Top 10 Movies based on average rating (with vote count filter)
2. Most productive directors based on number of movies
3. Genre-wise average ratings and movie counts
4. Movies with the largest gap between releases by the same director
5. Movies with high ratings but low popularity (hidden gems)
6. Country-wise production trends
7. Correlation analysis of worldwide income vs average ratings

---

## 📄 Files Included:
- `IMDB_dataset.sql` — SQL script to create and populate tables
- `imdb_analysis_queries.sql` — SQL queries for all analysis and insights
- `README.md` — Project documentation (this file)

---

## 🌟 Key Learning Outcomes:
- Handling normalized relational datasets
- Writing optimized analytical SQL queries
- Using advanced SQL techniques (CTEs, Window Functions)
- Solving business-driven data problems with SQL
- Presenting project insights in a clean, structured format


