-- World Life Expectancy Exploratory Data Analysis
USE world_life_expectancy;

--LIFE EXPECTANCY RANGE BY COUNTRY
-- find maximum and minimum life expectancy for each country
SELECT 
    Country,
    MAX(`Life expectancy`) AS max_life_exp,
    MIN(`Life expectancy`) AS min_life_exp
FROM worldlifeexpectancy 
GROUP BY Country
HAVING MAX(`Life expectancy`) <> 0
    AND MIN(`Life expectancy`) <> 0
ORDER BY Country DESC;


--LIFE EXPECTANCY INCREASE OVER 15 YEARS
-- calculate the change in life expectancy from minimum to maximum year
SELECT 
    Country,
    MAX(`Life expectancy`) AS max_life_exp,
    MIN(`Life expectancy`) AS min_life_exp,
    ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`), 2) AS life_increase
FROM worldlifeexpectancy 
GROUP BY Country
HAVING MAX(`Life expectancy`) <> 0
    AND MIN(`Life expectancy`) <> 0
ORDER BY life_increase DESC;


--RELATIONSHIP BETWEEN GDP AND LIFE EXPECTANCY
-- average life expectancy and GDP by country
SELECT 
    Country,
    ROUND(AVG(`Life expectancy`), 2) AS avg_life_exp,
    ROUND(AVG(GDP), 1) AS avg_gdp
FROM worldlifeexpectancy 
GROUP BY Country
HAVING avg_life_exp > 0
    AND avg_gdp > 0
ORDER BY avg_life_exp;


--LIFE EXPECTANCY BY DEVELOPMENT STATUS
-- compare average life expectancy between Developed and Developing countries
SELECT 
    Status,
    ROUND(AVG(`Life expectancy`), 1) AS avg_life_exp
FROM worldlifeexpectancy
GROUP BY Status;


--GDP THRESHOLD ANALYSIS
-- analyse life expectancy for countries with high GDP (>=1500) vs low GDP
SELECT 
    SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) AS high_gdp_count,
    AVG(CASE WHEN GDP >= 1500 THEN `Life expectancy` ELSE NULL END) AS high_gdp_life_expectancy,
    SUM(CASE WHEN GDP < 1500 THEN 1 ELSE 0 END) AS low_gdp_count,
    AVG(CASE WHEN GDP < 1500 THEN `Life expectancy` ELSE NULL END) AS low_gdp_life_expectancy
FROM worldlifeexpectancy;


-- ROLLING TOTAL OF ADULT MORTALITY
-- calculate cumulative adult mortality by country over time
SELECT 
    Country,
    Year,
    `Life expectancy`,
    `Adult Mortality`,
    SUM(`Adult Mortality`) OVER(PARTITION BY Country ORDER BY Year) AS rolling_total
FROM worldlifeexpectancy;
