-- Part 1: Exploring the dataset
--------------------------------------------------------------------------------------------------------------------------------
--total records

SELECT COUNT(*) as total_rows
FROM
bike-behaviour-project.bike_data.london_merged
-- time range od the data
SELECT MIN(timestamp) as start_date,
       MAX(timestamp) as end_date
FROM
bike-behaviour-project.bike_data.london_merged

--Average and peak values for bikes rented

SELECT MIN(cnt) AS min_rides,
       MAX(cnt) AS max_rides,
       AVG(cnt) AS avg_rides
FROM
bike-behaviour-project.bike_data.london_merged
---------------------------------------------------------------------------------------------------------------------------------
---Part 2: time-based analysis

--Average rides by hour

SELECT 
  EXTRACT (HOUR FROM timestamp) AS hour_of_the_day,
  AVG(cnt) AS avg_rides
  FROM bike-behaviour-project.bike_data.london_merged
  GROUP BY hour_of_the_day
  ORDER BY hour_of_the_day

  --- Weekday vs weekend
SELECT 
EXTRACT(HOUR FROM timestamp) AS hour_of_the_day, 
  is_weekend,
AVG(cnt) AS avg_rides 
FROM bike-behaviour-project.bike_data.london_merged
GROUP BY hour_of_the_day, is_weekend
ORDER BY is_weekend,hour_of_the_day

-- Seasonal behavior

SELECT season,
AVG(CNT) AS avg_rides 
FROM bike-behaviour-project.bike_data.london_merged
GROUP BY season
ORDER BY season
----------------------------------------------------------------------------------------------------------------------------------
---Part 3: Weather-based analysis

--Temperature and average ride

SELECT ROUND(t1,2) AS temperature,
       ROUND(AVG(cnt),2) AS avg_rides
FROM bike-behaviour-project.bike_data.london_merged
GROUP BY temperature
ORDER BY temperature

--Humidity and average ride

SELECT ROUND(hum,2) AS humidity,
       ROUND(AVG(cnt),2) AS avg_rides
FROM bike-behaviour-project.bike_data.london_merged
GROUP BY humidity
ORDER BY humidity

--Wind Speed and Average ride count

SELECT ROUND(wind_speed,2) AS windspeed,
       ROUND(AVG(cnt),2) AS avg_rides
FROM bike-behaviour-project.bike_data.london_merged
GROUP BY windspeed
ORDER BY windspeed

-- Temperature * Humididty Impact

SELECT ROUND(t1,2) as temperature, 
ROUND(hum,1) AS humidity,
ROUND(AVG(cnt),2) AS avg_rides
FROM bike-behaviour-project.bike_data.london_merged
GROUP BY temperature,humidity
ORDER BY temperature,humidity

---Weather & wind impact

SELECT
CASE 
WHEN weather_code IN (7,10.26) THEN 'Severe'
WHEN weather_code IN (3,4) THEN 'Cloudy'
ELSE 'Clear' END AS weather_group,
ROUND (wind_speed,1) AS wind,
ROUND (AVG(cnt),1) AS avg_rides
FROM
bike-behaviour-project.bike_data.london_merged
GROUP BY weather_group, wind
ORDER BY weather_group, wind

---Rides Lost due to bad weather

--Average ride on clear days
SELECT AVG(cnt) AS clear_day_avg
FROM bike-behaviour-project.bike_data.london_merged
WHERE weather_code = 1

-- Rides lost due to bad weather days
SELECT 
weather_code,
COUNT(*) AS num_hours,
AVG(cnt) AS avg_rides,
(SELECT AVG(cnt) 
FROM bike-behaviour-project.bike_data.london_merged
WHERE weather_code = 1) - AVG(cnt) AS rides_lost_per_hour
FROM bike-behaviour-project.bike_data.london_merged
WHERE weather_code In (7,10,26,94) 
GROUP BY weather_code
ORDER BY rides_lost_per_hour DESC

--table for rides lost due to bad weather
WITH clear_weather_avg AS (
  SELECT
    ROUND(AVG(cnt), 1) AS avg_clear_rides
  FROM bike-behaviour-project.bike_data.london_merged
  WHERE weather_code = 1
),

bad_weather_stats AS (
  SELECT
    weather_code,
    COUNT(*) AS hours,
    ROUND(AVG(cnt), 1) AS avg_rides_bad_weather
  FROM bike-behaviour-project.bike_data.london_merged
  WHERE weather_code IN (7, 10, 26, 94) -- bad weather types
  GROUP BY weather_code
),

rides_lost_calc AS (
  SELECT
    b.weather_code,
    b.hours,
    b.avg_rides_bad_weather,
    c.avg_clear_rides,
    ROUND((c.avg_clear_rides - b.avg_rides_bad_weather), 1) AS rides_lost_per_hour,
    ROUND((c.avg_clear_rides - b.avg_rides_bad_weather) * b.hours, 0) AS total_rides_lost
  FROM bad_weather_stats b
  CROSS JOIN clear_weather_avg c
)

SELECT
  *,
  ROUND(SUM(total_rides_lost) OVER (), 0) AS total_rides_lost_all_weather
FROM rides_lost_calc
ORDER BY total_rides_lost DESC

--clear weather hourly pattern

SELECT EXTRACT(HOUR FROM timestanmp) AS hour,
AVG(cnt) AS avg_rides
FROM bike-behaviour-project.bike_data.london_merged
WHERE weather_code = 1
GROUP BY hour
ORDER BY hour

--Rainy weather hourly pattern

SELECT EXTRACT(HOUR FROM timestamp) AS hour,
AVG(cnt) AS avg_rides
FROM bike-behaviour-project.bike_data.london_merged
WHERE weather_code = 1
GROUP BY hour
ORDER BY hour
