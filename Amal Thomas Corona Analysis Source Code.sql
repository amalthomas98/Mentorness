-- Q1. Write a code to check NULL values
SELECT count(*) as Total_null_values
FROM customers.project
WHERE Province IS NULL
OR `Country/Region` IS NULL 
OR Latitude IS NULL 
OR Longitude IS NULL 
OR Dates IS NULL 
OR Confirmed IS NULL 
OR Deaths IS NULL 
OR Recovered IS NULL;
 
 -- Q2.If NULL values are present, update them with zeros for all columns. 
UPDATE customers.project
SET Province = COALESCE(Province, 0),
    `Country/Region` = COALESCE(`Country/Region`, '0'),
    Latitude = COALESCE(Latitude, 0),
    Longitude = COALESCE(Longitude, 0),
    Dates = COALESCE(Dates, 0),
    Confirmed = COALESCE(Confirmed, 0),
    Deaths = COALESCE(Deaths, 0),
    Recovered = COALESCE(Recovered, 0)
WHERE Province IS NULL
   OR `Country/Region` IS NULL
   OR Latitude IS NULL
   OR Longitude IS NULL
   OR Dates IS NULL
   OR Confirmed IS NULL
   OR Deaths IS NULL
   OR Recovered IS NULL;
   
-- Q3. check total number of rows 
SELECT COUNT(*) FROM customers.project;

-- Create a new column called dates 
ALTER TABLE  customers.project ADD COLUMN Dates DATE;
-- Update dates column data type and transfer data from  old to new columnn
UPDATE customers.project SET Dates = STR_TO_DATE(Date, '%d-%m-%Y');
-- Drop old date column
ALTER TABLE customers.project DROP COLUMN date_column;


-- Q4.Check what is start_date and end_date
SELECT MIN(Dates) AS Start_date, MAX(Dates) AS End_date
FROM customers.project;

-- Q5. Number of month present in dataset
SELECT COUNT(DISTINCT (month(dates))) as num_of_months
FROM customers.project;

-- Q6. Find monthly average for confirmed, deaths, recovered
SELECT 
month (dates) as month_number,
year(dates) as year,
ROUND(avg(confirmed),2) as confirmed_avg,
ROUND(avg(deaths),2) as deaths_avg,
ROUND(avg(recovered),2) as recovered_avg
FROM customers.project
GROUP BY 1,2;

-- Q7. Find most frequent value for confirmed, deaths, recovered each month 
WITH FrequentValues AS (
SELECT
	month (Dates) AS month,
	YEAR (Dates) AS year,
	Confirmed,
	Deaths,
	Recovered,
	RANK() OVER (PARTITION BY month (Dates), YEAR (Dates) ORDER BY COUNT(*) DESC) AS rnk
    FROM customers.project
    GROUP BY 1,2,3,4,5
)
SELECT
    month,year,Confirmed,Deaths,Recovered
FROM FrequentValues
WHERE rnk = 1;


-- Q8. Find minimum values for confirmed, deaths, recovered per year
SELECT 
	year(dates) as year,
	min(confirmed) as minimum_confirmed_value,
    min(deaths)as minimum_death_value,
    min(recovered) as minimum_recovered_value
FROM customers.project
GROUP BY 1;
    

-- Q9. Find maximum values of confirmed, deaths, recovered per year
SELECT 
	year(dates) as year,
	max(confirmed) as maximum_confirmed_value,
    max(deaths)as maximum_death_value,
    max(recovered) as maximum_recovered_value
FROM customers.project
GROUP BY 1;


-- Q10. The total number of case of confirmed, deaths, recovered each month
SELECT 
	year(dates) as year,
	month(dates) as month,
	sum(confirmed) as total_confirmed_value,
    sum(deaths)as total_death_value,
    sum(recovered) as total_recovered_value
FROM customers.project
GROUP BY 1,2;


-- Q11. Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 	
	sum(confirmed) as total_confirmed_cases,
    ROUND(avg(confirmed),2) as average_of_confirmed_cases,
    ROUND(variance(confirmed)) as variance_of_confirmed_cases,
    ROUND(stddev(confirmed)) as STDEV_of_confirmed_cases
FROM customers.project;

-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 	
	year(dates) as year,
    month(dates) as year,
	sum(deaths) as total_death_cases,
    ROUND(avg(deaths),2) as average_of_death_cases,
    ROUND(variance(deaths)) as variance_of_death_cases,
    ROUND(stddev(deaths)) as STDEV_of_death_cases
FROM customers.project
GROUP BY 1,2;

-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 	
	sum(recovered) as total_recovered_cases,
    ROUND(avg(recovered),2) as average_of_recovered_cases,
    ROUND(variance(recovered)) as variance_of_recovered_cases,
    ROUND(stddev(recovered)) as STDEV_of_recovered_cases
FROM customers.project;

-- Q14. Find Country having highest number of the Confirmed case
SELECT 
	`Country/Region`,
    SUM(Confirmed) as Total_Confirmed_cases
FROM customers.project
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- Q15. Find Country having lowest number of the death case
SELECT 
	`Country/Region`,
    SUM(Deaths) as Total_deaths_cases
FROM customers.project
GROUP BY 1
ORDER BY 2 ASC
LIMIT 1;


-- Q16. Find top 5 countries having highest recovered case
SELECT  
	`Country/Region`,
    SUM(recovered) as Total_recovered_cases
FROM customers.project
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;















































