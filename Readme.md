**London Bike Sharing**

---

**Introduction**

---

This project analyzes London's bike sharing data to uncover patterns in bike usage relative to weather conditions and temporal factors.

**Dataset overview**

---

**Source:** London bike sharing dataset on Kaggle (https://www.kaggle.com/datasets/hmavrodiev/london-bike-sharing-dataset)

**Data size:** ~17000 hourly records

**Columns:**:

- **Timestamp**: Timestamp of rental
- **Cnt**: total bikes rented
- **t1** - real temperature in C
- **t2** - temperature in C "feels like"
- **hum** - humidity in percentage
- **windspeed** - wind speed in km/h
- **weathercode** - category of the weather (1 - Clear ; mostly clear but have some values with haze/fog/patches of fog/ fog in vicinity; 2 - scattered clouds / few clouds; 3 - Broken clouds; 4 - Cloudy; 7 - Rain/ light Rain shower/ Light rain; 10 - rain with thunderstorm; 26 - snowfall)
- **isholiday** - Boolean field : 1 holiday / 0 non holiday
- **isweekend** - Boolean field - 1 if the day is weekend
- **season** - category (0-spring ; 1-summer; 2-fall; 3-winter)

**Project Structure**

---

```sql
london-bike-analysis/
│
├── data/
│   └── london-merged.csv
│
├── queries/
│   └── bike sharing analysis.sql
│
├── README.md
```

**Tools Used**

---

SQL : For data querying and aggregation

Excel: for initial data exploration, rounding values and visualizations

**Part 1: Exploring the dataset**

---

- What's the size of this dataset? (i.e., how many trips)

There are approximately 17000 records in this dataset. and the data spans from January 2015 to January 2017.

- What are the overall average and peak values of total number of rides in any hour?

on average, 1143 bikes are rented every hour with 7860 being the ,maximum number of rides rented in an hour from January 2015 to January 2017 and 0 being the least number of bikes rented in an hour during the period. 

**Part 2: Time-based Behavior**

---

- Average Rides by hour

Calculate average number of rides grouped by hour ( extract hour from the timestamp column). 

Peak riding hours occur at 8 am ( approx. 2882 average rides) and 5-6 pm (approximately 2829 average rides from 5-6 pm and 2629 average rides from 6-7 pm), these finding align with the commute times for employees and students. 

The lowest activity is seen between 3-5 am with only 73 bikes rented on average from 4 -5 am showing minimal overnight usage.

![Average rides by hour.png](attachment:9a6a0d29-69b5-497a-bf18-efe2bce21280:Average_rides_by_hour.png)

- Weekday vs weekend

Calculated average number of rides grouped by hour and Boolean indicator for weekend (is_weekend). 

On weekdays,  there are sharp spikes at 8 am and 5-6 pm, confirming their role in commuter transportation.

On weekends, ridership is more evenly spread with a rise from 10 am to 4 pm and peaking around 2-3 pm and tapering off in the evening.

The difference in peak times and intensity between weekday and weekend users emphasizes how context drives mobility behavior.

![Weekdays v_s Weekend.png](attachment:49d74bbe-c43c-440b-8b14-7fba3d529c07:Weekdays_v_s_Weekend.png)

- Seasonal

Average number of rides grouped by season.

Summer shows the highest average ridership followed by spring and autumn which also show relatively high usage. Winters sees a sharp decline in ridership.

**Part 3: Weather Impact on Ride Behavior**

---

- Ride Average & Temperature

Ridership increases as temperature rises, peaking in the range of 20 degree Celsius to 24 degree Celsius which appears to be the optimal comfort zone for cyclists.

Below 10 degrees, ride activity drops significantly, likely due to discomfort from cold conditions.

Above 26-28 degrees, usage also tapers off slightly, suggesting that excessive heat discourages riders.

- Ride Average & Humidity

Rounded Humidity values and computed the average rides per level.

Ridership remains relatively constant until about 70-75% humidity, after which it starts declining.

At humidity levels above 85%, ridership drops significantly. 

- Ride Average & Wind Speed

Grouped by windspeed (rounded) and calculated average ride counts.

While light wind (0 - 10 km/h) has minimal effect, riding drops steadily as wind speed increases, especially after 20+ km/h.

- Temperature & Humidity

The reason for exploring this combination is to understand which temperature-humidity combinations are ideal for riders and to understand the combined impact of these variables on rider behavior.

Most rides happen in moderate temperatures(18-24 degree Celsius) and low-mid humidity (40-65%). 

- Weather & Wind Impact

We group weather in three categories ‘Severe’, ‘Cloudy’ and ‘Clear’ and group them with wind speed to understand the combined impact.

While clear skies generally support higher ridership, the presence of moderate to strong winds significantly dampens activity, especially when combined with rain or other severe weather types.

Our breakdown shows that in bad weather conditions, even a moderate wind speed of 10–15 km/h correlates with substantial declines in hourly ride volume. The effect is nonlinear — the same wind speed during clear days has minimal impact, suggesting a compounding discomfort effect when wind is paired with poor weather.

- Rides lost due to Bad weather

Estimated expected rides using clear day hourly average, then compared against bad weather hours. 

There is a significant drop in ridership during bad weather conditions. Compared to clear days, average rides per hour decrease sharply when it rains, snows or when there is fog or thunderstorms.

For instance, rain with thunder (weather code 10) and snow (code 26) leads to a 40-60% reduction in average hourly rides. 

- Does bad weather delay peak hours?

Estimating this to check if ridership peaks later in the day during bad weather compared to clear weather days.

During clear days, peak ridership occurs sharply at 8 AM and again between 5-6 PM. 

On rainy days, morning ridership is more evenly spread across 8-10 AM, indicating a delayed or flexible commute. Evening peak also appears softened. This suggests riders adjust their commute timings when faced with wet conditions.

**Conclusion**

---

This project explored how time and weather affect bike usage in London. We found that ridership peaks during weekday commute hours and drops late at night. Weather has a strong impact — especially rain, snow, and thunderstorms, which lead to a big drop in rides. Riders prefer cycling in mild temperatures and low to medium humidity. These patterns can help improve planning and service for bike-sharing systems.
