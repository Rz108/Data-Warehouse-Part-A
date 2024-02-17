USE Practical_AI;

-- Query 1
SELECT 
    v_AgeGroup as 'Car Age Group', 
    COUNT(DISTINCT s.bookingID) AS 'Total Trips', 
    SUM(CASE WHEN s.label = 1 THEN 1 ELSE 0 END) AS Dangerous_trips,
    ROUND((SUM(CASE WHEN s.label = 1 THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(DISTINCT s.bookingID), 0)), 2) AS percentage,
    ROUND(AVG(CAST(sd.Average_Speed AS FLOAT)), 2) AS 'Mean Speed by Age Group',
    ROUND(AVG(CAST(Driver.rating AS FLOAT)), 2) AS 'Mean Rating By Age Group'
FROM safety_labels s
JOIN Driver ON s.driver_id = Driver.id
LEFT JOIN
(
    SELECT bookingID, AVG(speed) AS Average_Speed  FROM Sensor GROUP BY bookingID
) sd ON s.bookingID = sd.bookingID
CROSS APPLY (
    SELECT CASE 
        WHEN car_model_year IS NULL THEN 'Unknown'
        WHEN (2023 - car_model_year) <= 5 THEN 'Between 0-5 years'
        WHEN (2023 - car_model_year) <= 10 THEN 'Between 6-10 years'
        WHEN (2023 - car_model_year) <= 15 THEN 'Between 11-15 years'
        ELSE 'Over 15 years'
    END AS v_AgeGroup
) AS v
GROUP BY v_AgeGroup
ORDER BY Dangerous_trips DESC;


-- Query 2
SELECT 
    TripDuration.trip_duration_bucket,
    COUNT(DISTINCT l.bookingID) as total_trips,
	COUNT(CASE WHEN l.label = 1 THEN 1 END) as 'Dangerous Trips',
ROUND((COUNT(CASE WHEN l.label = 1 THEN 1 END) * 100.0) / COUNT(*), 2) as Danger_percentage
FROM (
    SELECT 
        bookingID, 
        (MAX(second) - MIN(second)) / 60 as trip_duration, 
        CASE
            WHEN (MAX(second) - MIN(second)) / 60 <= 10 THEN '0-10'
            WHEN (MAX(second) - MIN(second)) / 60 <= 20 THEN '11-20'
            WHEN (MAX(second) - MIN(second)) / 60 <= 30 THEN '21-30'
            ELSE '30+' 
        END as trip_duration_bucket
    FROM 
        sensor
    GROUP BY 
        bookingID
) TripDuration
JOIN safety_labels l ON TripDuration.bookingID = l.bookingID
GROUP BY 
    TripDuration.trip_duration_bucket
ORDER BY 
    Danger_percentage DESC;


-- Query 3
SELECT
    ROUND(AVG(CASE 
            WHEN ISNULL(acceleration_x, 0) = 0 AND ISNULL(acceleration_z, 0) = 0 
            THEN 0 
            ELSE DEGREES(ATN2(ISNULL(acceleration_x, 0), ISNULL(acceleration_z, 1E-6))) 
        END),2) AS 'Average Pitch Degrees',
    ROUND(AVG(CASE 
            WHEN ISNULL(acceleration_y, 0) = 0 AND ISNULL(acceleration_z, 0) = 0 
            THEN 0 
            ELSE DEGREES(ATN2(ISNULL(acceleration_y, 0), ISNULL(acceleration_z, 1E-6))) 
        END),2) AS 'Average Roll Degrees',
    ROUND(AVG(DEGREES(ISNULL(gyro_z, 0))),2) AS 'Average Yaw Degrees',
    ROUND(AVG(ISNULL(s.speed, 0)) / 1000*3600,2) AS 'Average Speed km/h',
    CASE 
        WHEN sl.Label = 0 THEN 'Normal'
        WHEN sl.Label = 1 THEN 'Dangerous'
        ELSE 'Unknown'
    END AS 'Categorised Safety Label'
FROM 
    Sensor s
JOIN 
    Safety_Labels sl ON s.bookingID = sl.bookingID
JOIN 
    Driver d ON d.id = sl.driver_id
GROUP BY 
    sl.Label