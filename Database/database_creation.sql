/* Create the database if not exist*/
IF NOT EXISTS (
    SELECT name 
    FROM master.dbo.sysdatabases 
    WHERE ('[' + name + ']' = 'Practical_AI' OR name = 'Practical_AI')
)
CREATE DATABASE [Practical_AI];
use Practical_AI;

/* Dropping the table if exist to prevent overlapping */
DROP TABLE IF EXISTS Staging

DROP TABLE IF EXISTS Sensor

DROP TABLE IF EXISTS Safety_Labels

DROP TABLE IF EXISTS Driver

DROP TABLE IF EXISTS BOOKING

/* Create the staging table to have a surrogate key */
CREATE TABLE Staging (
    ID INT,
    bookingID BIGINT,
    accuracy float,
    bearing float,
    acceleration_x float,
    acceleration_y float,
    acceleration_z float,
    gyro_x float,
    gyro_y float,
    gyro_z float,
    second float,
    speed float
    PRIMARY KEY (ID)
);

/* Create the driver table */
CREATE TABLE Driver (
	id INT,
	name VARCHAR(255),
	date_of_birth DATETIME,
    no_of_years_driving_exp INTEGER,
    gender VARCHAR(50),
    car_make VARCHAR(255),
    car_model_year INTEGER,
    rating NUMERIC
    PRIMARY KEY (id)
)

/* Create the safety labels table*/
CREATE TABLE Safety_Labels (
    bookingID BIGINT,
    driver_id INT,
    label INT
    PRIMARY KEY (bookingID),
    FOREIGN KEY (driver_id) REFERENCES Driver(id)
);

/* Create the sensor table*/
CREATE TABLE Sensor (
    ID BIGINT IDENTITY(1,1),
    bookingID BIGINT,
    accuracy float,
    bearing float,
    acceleration_x float,
    acceleration_y float,
    acceleration_z float,
    gyro_x float,
    gyro_y float,
    gyro_z float,
    second float,
    speed float
    PRIMARY KEY (ID),
    FOREIGN KEY (bookingID) REFERENCES Safety_Labels(bookingID)
);


