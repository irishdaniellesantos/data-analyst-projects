-- SQL Project - Data Cleaning


SELECT *
FROM world_layoffs.layoffs;


-- First, we create a staging table to clean the data while keeping the raw data safe as backup.


CREATE TABLE world_layoffs.layoffs_staging
LIKE world_layoffs.layoffs;


INSERT layoffs_staging
SELECT *
FROM world_layoffs.layoffs;


SELECT *
FROM world_layoffs.layoffs_staging;

-- Data cleaning steps:
-- 1. Remove duplicates
-- 2. Standardize data and fix errors
-- 3. Handle null values
-- 4. Drop unnecessary rows/columns

-- First, Lets check for dups


SELECT *
FROM world_layoffs.layoffs_staging;



SELECT *,
ROW_NUMBER() OVER (PARTITION BY company, location, total_laid_off, percentage_laid_off, `date`,
	stage, country, funds_raised_millions) AS row_num
FROM world_layoffs.layoffs_staging; 



SELECT *
FROM (
    SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, location, total_laid_off, percentage_laid_off, `date`,
stage, country, funds_raised_millions) AS row_num
FROM world_layoffs.layoffs_staging
) duplicates
WHERE row_num > 1;


-- Check the data of the company to confirm
-- I will try 'Casper'

SELECT *
FROM world_layoffs.layoffs_staging
WHERE company = 'Casper';

-- Confirmed: duplicates exist, rows with row_num > 1 can be removed

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, location, total_laid_off, percentage_laid_off, `date`,
stage, country, funds_raised_millions) AS row_num
FROM world_layoffs.layoffs_staging
) 
SELECT *
FROM duplicate_cte
WHERE row_num > 1;	


-- I added a new extra column to help remove duplicates

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;


INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, location, total_laid_off, percentage_laid_off, `date`,
stage, country, funds_raised_millions) AS row_num
FROM world_layoffs.layoffs_staging;


DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2;


-- 2. Standardize Data

SELECT *
FROM world_layoffs.layoffs_staging2;


-- Remove extra spaces so all company names look consistent

SELECT company, TRIM(company)
FROM world_layoffs.layoffs_staging2;

UPDATE world_layoffs.layoffs_staging2
SET company = TRIM(company);

-- Check industry column for null or empty values

SELECT DISTINCT industry
FROM world_layoffs.layoffs_staging2
ORDER BY industry;

-- 'Crypto' has different variations, so I standardized them all to 'Crypto' for consistency

SELECT DISTINCT industry
FROM world_layoffs.layoffs_staging2
ORDER BY industry;

SELECT DISTINCT industry
FROM world_layoffs.layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE world_layoffs.layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT industry
FROM world_layoffs.layoffs_staging2
ORDER BY industry;

SELECT *
FROM world_layoffs.layoffs_staging2;

-- Found 'United States' with and without a period, standardize to one format

SELECT DISTINCT country
FROM world_layoffs.layoffs_staging2
ORDER BY country;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM world_layoffs.layoffs_staging2
ORDER BY country;

UPDATE world_layoffs.layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country);

-- Fix the date column (currently stored as text)
-- We can use STR_TO_DATE() to update this column

SELECT *
FROM world_layoffs.layoffs_staging2;

SELECT `date`, 
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM world_layoffs.layoffs_staging2;

UPDATE world_layoffs.layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

SELECT `date`
FROM world_layoffs.layoffs_staging2;

-- Now we can convert the column to the correct data type

ALTER TABLE world_layoffs.layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT * 
FROM world_layoffs.layoffs_staging2;

-- lets check again the industry column for null and blank values

 SELECT DISTINCT industry
FROM world_layoffs.layoffs_staging2
ORDER BY industry; 

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE industry IS NULL 
OR industry = ''
ORDER BY industry;

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE company = 'Airbnb';

-- Set blanks to NULL for easier handling

UPDATE world_layoffs.layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- 3. Handling Null or Blank values
-- Next we need to populate those nulls if possible

SELECT t1.industry, t2.industry
FROM world_layoffs.layoffs_staging2 t1
JOIN world_layoffs.layoffs_staging2 t2
ON t1.company = t2.company
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL; 

UPDATE world_layoffs.layoffs_staging2 t1
JOIN world_layoffs.layoffs_staging2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT *
FROM world_layoffs.layoffs_staging2;

-- Nulls in total_laid_off, percentage_laid_off, and funds_raised_millions look fine
-- Keeping them as NULL makes calculations easier for EDA
-- No changes needed

-- 4. Remove unnecessary columns and rows

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL;

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Delete useless data we can't really use

DELETE
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS  NULL
AND percentage_laid_off IS NULL;

ALTER TABLE world_layoffs.layoffs_staging2
DROP COLUMN row_num;

SELECT *
FROM world_layoffs.layoffs_staging2;

-- Data Cleaning Completed






















































































