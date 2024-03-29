﻿-- First, let's count the number of rows of the table we created

SELECT
  COUNT(*)
FROM
  my-project-19297-401423.case_study_cyclist.divvy_tripdata_2023;

-- The result is 5,719,877 rows

-- Now, let's proceed to the data cleaning step. Based on the initial exploration and analysis performed on each individual table using Microsoft Excel, we know that there are numerous null values, as well as some inconsistent ones.

DROP TABLE IF EXISTS my-project-19297-401423.case_study_cyclist.divvy_tripdata_2023_cleaned;

--Here we are going to create a new table for the cleaned data

CREATE TABLE IF NOT EXISTS my-project-19297-401423.case_study_cyclist.divvy_tripdata_2023_cleaned AS (
  SELECT 
    divvy.ride_id, rideable_type, started_at, ended_at, 
    ride_length,
    CASE EXTRACT(DAYOFWEEK FROM started_at) 
      WHEN 1 THEN 'SUN'
      WHEN 2 THEN 'MON'
      WHEN 3 THEN 'TUES'
      WHEN 4 THEN 'WED'
      WHEN 5 THEN 'THURS'
      WHEN 6 THEN 'FRI'
      WHEN 7 THEN 'SAT'    
    END AS day_of_week,
    CASE EXTRACT(MONTH FROM started_at)
      WHEN 1 THEN 'JAN'
      WHEN 2 THEN 'FEB'
      WHEN 3 THEN 'MAR'
      WHEN 4 THEN 'APR'
      WHEN 5 THEN 'MAY'
      WHEN 6 THEN 'JUN'
      WHEN 7 THEN 'JUL'
      WHEN 8 THEN 'AUG'
      WHEN 9 THEN 'SEP'
      WHEN 10 THEN 'OCT'
      WHEN 11 THEN 'NOV'
      WHEN 12 THEN 'DEC'
    END AS month,
    start_station_name, end_station_name, 
    start_lat, start_lng, end_lat, end_lng, member_casual
  FROM my-project-19297-401423.case_study_cyclist.divvy_tripdata_2023 AS divvy
  JOIN (
    SELECT ride_id, (
      EXTRACT(HOUR FROM (ended_at - started_at)) * 60 +
      EXTRACT(MINUTE FROM (ended_at - started_at)) +
      EXTRACT(SECOND FROM (ended_at - started_at)) / 60) AS ride_length
    FROM my-project-19297-401423.case_study_cyclist.divvy_tripdata_2023
  ) divvy_2
  ON divvy.ride_id = divvy_2.ride_id
  WHERE 
    start_station_name IS NOT NULL AND
    end_station_name IS NOT NULL AND
    end_lat IS NOT NULL AND
    end_lng IS NOT NULL AND
    ride_length > 1 AND ride_length < 1440
);

--Next, we have to set ride_id as a primary key
ALTER TABLE my-project-19297-401423.case_study_cyclist.divvy_tripdata_2023_cleaned
ADD PRIMARY KEY(ride_id) NOT ENFORCED;

--Lastly, lets count the rows of our new clean table

SELECT
  COUNT(*) AS number_of_rows
FROM
  my-project-19297-401423.case_study_cyclist.divvy_tripdata_2023_cleaned

--The result is 4,243,432 rows. Meaning 1,476,445 rows were deleted.