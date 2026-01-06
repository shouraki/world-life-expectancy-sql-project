# World Life Expectancy SQL Analysis

## Overview
I analysed global life expectancy data spanning 2007 to 2022, looking at how GDP and development status relate to health outcomes across 193 countries.

I wanted to dig into questions like: which countries have improved the most over 15 years? Is there a GDP threshold where life expectancy jumps significantly? And what's the actual gap between developed and developing nations?

## Tools & Technologies
* MySQL Workbench
* SQL (Window Functions, Self-Joins, CTEs, CASE Statements)

## Dataset
* **Source:** World Life Expectancy dataset (2007-2022)
* **Records:** 2,943 rows
* **Countries:** 193
* **Key Variables:** Life Expectancy, GDP, Adult Mortality, BMI, Development Status

## What I Did

### Data Cleaning (`01_data_cleaning.sql`)
The raw data needed some work, there were duplicates and missing values scattered throughout. I used `ROW_NUMBER()` to identify and remove duplicate records, filled in missing country status values by looking at patterns, and imputed missing life expectancy data by averaging adjacent years with self-joins.

### Exploratory Analysis (`02_exploratory_analysis.sql`)
Once the data was clean, I looked at which countries saw the biggest changes over the 15year period, how GDP relates to life expectancy, and the differences between developed and developing nations. I also calculated rolling totals of adult mortality to spot trends.

Business Questions

Which countries have seen the largest increases in life expectancy over 15 years?
How does GDP correlate with life expectancy?
What is the life expectancy gap between Developed and Developing countries?
Is there a GDP threshold where life expectancy significantly improves?
How has adult mortality changed over time by country?

## What I Found
* There's a clear GDP threshold around £1,500 where life expectancy jumps noticeably
* The gap between developed and developing countries is still substantial
* Some countries managed to increase life expectancy by 15+ years in just 15 years (which is pretty remarkable)
* GDP is a strong predictor, though it's not the whole story

## SQL Techniques Used
* Window functions (`ROW_NUMBER()`, `SUM() OVER()`)
* Self-joins for imputing missing data
* Subqueries and CTEs
* Aggregate functions with GROUP BY
* CASE statements for conditional logic

## How to Run
1. Import `WorldLifeExpectancy.csv` into MySQL
2. Execute `01_data_cleaning.sql` to prepare the data
3. Run `02_exploratory_analysis.sql` to generate insights

## Possible Next Steps
If I extend this, I'd probably visualise the time series trends in Tableau, and bring in healthcare spending data to see how that factors in. Regional breakdowns by continent could be interesting too.
