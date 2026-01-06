-- World Life Expectancy Data Cleaning Project
USE world_life_expectancy;
SELECT * FROM worldlifeexpectancy;


--IDENTIFYING AND REMOVING DUPLICATES
-- identifying duplicates by concatenating Country and Year
-- (No primary key exists, so we create a composite key)
SELECT 
    Country,
    Year,
    CONCAT(Country, Year) AS composite_key,
    COUNT(CONCAT(Country, Year)) AS duplicate_count
FROM worldlifeexpectancy
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1;

-- find ROW_ID of duplicate records
SELECT * 
FROM (
    SELECT 
        ROW_ID,
        CONCAT(Country, Year) AS composite_key,
        ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS row_num
    FROM worldlifeexpectancy
) AS row_table 
WHERE row_num > 1;

-- delete duplicate records
DELETE FROM worldlifeexpectancy 
WHERE ROW_ID IN (
    SELECT ROW_ID 
    FROM (
        SELECT 
            ROW_ID,
            CONCAT(Country, Year) AS composite_key,
            ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS row_num
        FROM worldlifeexpectancy
    ) AS row_table 
    WHERE row_num > 1
);

SELECT * FROM worldlifeexpectancy;


--MISSING STATUS VALUES
-- check distinct Status values
SELECT DISTINCT(Status) 
FROM worldlifeexpectancy
WHERE Status <> '';

-- Identify countries marked as 'Developing'
SELECT DISTINCT(Country) 
FROM worldlifeexpectancy
WHERE Status = 'Developing';

-- update blank Status to 'Developing' where country has been marked as Developing before
UPDATE worldlifeexpectancy 
SET Status = 'Developing' 
WHERE Country IN (
    SELECT DISTINCT(Country)
    FROM (
        SELECT DISTINCT(Country) 
        FROM worldlifeexpectancy
        WHERE Status = 'Developing'
    ) AS developing_countries
);

-- update blank Status to 'Developed' where country has been marked as Developed before
UPDATE worldlifeexpectancy 
SET Status = 'Developed' 
WHERE Country IN (
    SELECT DISTINCT(Country)
    FROM (
        SELECT DISTINCT(Country) 
        FROM worldlifeexpectancy
        WHERE Status = 'Developed'
    ) AS developed_countries
);


--IMPUTING MISSING LIFE EXPECTANCY VALUES
-- identify records with missing Life Expectancy
-- calculate average of previous year and next year to fill gaps
SELECT 
    t1.Country,
    t1.Year,
    t1.`Life expectancy` AS current_life_exp,
    t2.Country,
    t2.Year,
    t2.`Life expectancy` AS prev_year_life_exp,
    t3.Country,
    t3.Year,
    t3.`Life expectancy` AS next_year_life_exp,
    ROUND((t2.`Life expectancy` + t3.`Life expectancy`) / 2, 1) AS imputed_value
FROM worldlifeexpectancy t1
JOIN worldlifeexpectancy t2
    ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN worldlifeexpectancy t3
    ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
WHERE t1.`Life expectancy` = '';

-- Update missing Life Expectancy values with calculated average
UPDATE worldlifeexpectancy t1 
JOIN worldlifeexpectancy t2
    ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN worldlifeexpectancy t3
    ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy` + t3.`Life expectancy`) / 2, 1)
WHERE t1.`Life expectancy` = '';


SELECT * FROM worldlifeexpectancy;
