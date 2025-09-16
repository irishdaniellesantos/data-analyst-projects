-- Exploratory Data Analysis
-- Exploring the data and find trends or patterns or anything interesting like outliers
-- Usually in EDA we know what to look for  
-- Here we’ll just explore and see what we find

SELECT *
FROM world_layoffs.layoffs_staging2;

-- Easier Queries

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM world_layoffs.layoffs_staging2;

-- -- Examining % for layoff scale

SELECT MAX(percentage_laid_off),  MIN(percentage_laid_off)
FROM world_layoffs.layoffs_staging2
WHERE  percentage_laid_off IS NOT NULL;

-- -- Companies with 100% layoffs (mostly startups that shut down)

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off = 1;

-- -- Order by funds_raised_millions to see company size;

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;


-- Companies with a biggest single layoff

SELECT company, total_laid_off
FROM world_layoffs.layoffs_staging2
ORDER BY total_laid_off DESC
LIMIT 5;


-- Companies with the most total layoffs

SELECT company, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY company 
ORDER BY SUM(total_laid_off) DESC
LIMIT 10;

-- total laidoff in the past 3 years  in the dataset
-- By location
SELECT location, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY location
ORDER BY SUM(total_laid_off) DESC;


SELECT MIN(date), MAX(date)
FROM world_layoffs.layoffs_staging2;

-- By country
SELECT country, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY country
ORDER BY SUM(total_laid_off) DESC;

-- By year
SELECT YEAR(date), SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY YEAR(date)
ORDER BY SUM(total_laid_off) DESC;

-- By industry
SELECT industry, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY industry
ORDER BY SUM(total_laid_off) DESC;

-- By stage
SELECT stage, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY stage
ORDER BY SUM(total_laid_off) DESC;


-- Now lets look per year

SELECT company, YEAR(date) AS Years, SUM(total_laid_off) AS total_laid_off
FROM world_layoffs.layoffs_staging2
GROUP BY company, YEAR(date)
ORDER BY 3 DESC;

-- Top 5 companies with the most layoffs per year

WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(date), SUM(total_laid_off) 
FROM world_layoffs.layoffs_staging2
GROUP BY company, YEAR(date)
),
Company_Year_Rank AS 
(
	SELECT *,
    DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
    FROM Company_Year
    WHERE years IS NOT NULL
)
select * 
FROM Company_Year_Rank
WHERE Ranking <=5;
   


-- Monthly cumulative layoffs  

SELECT SUBSTRING(date, 1, 7) AS dates, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
WHERE SUBSTRING(date, 1, 7) IS NOT NULL
GROUP BY dates 
ORDER BY 1 ASC;

-- Now put it in a CTE so we can query it

WITH Rolling_Total AS 
(
SELECT SUBSTRING(date, 1, 7) AS dates, SUM(total_laid_off) as total_laid_off
FROM world_layoffs.layoffs_staging2
WHERE SUBSTRING(date, 1, 7) IS NOT NULL
GROUP BY dates 
ORDER BY 1 ASC
)
SELECT dates, total_laid_off, SUM(total_laid_off) OVER (ORDER BY dates) AS Rolling_Total_Layoffs
FROM Rolling_Total 
ORDER BY dates ASC;













