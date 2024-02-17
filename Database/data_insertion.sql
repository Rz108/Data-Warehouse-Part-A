use Practical_AI;

-- import the drivers file
BULK
INSERT
        dbo.Driver
FROM
        'C:/dataset/drivers_dataset.csv' WITH (
                FIELDTERMINATOR = ',',
                ROWTERMINATOR = '0x0a',
                firstrow = 2
        )
GO
;

BULK
INSERT
        dbo.Safety_Labels
FROM
        'C:/dataset/safety_status_dataset.csv' WITH (
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                ROWTERMINATOR = '0x0a'
        )
GO
;

-- import first file
BULK
INSERT
        dbo.Staging
FROM
        'C:/dataset/0_Sensor_DataSet_features_part.csv' WITH (
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                ROWTERMINATOR = '\n',
                CODEPAGE = 'UTF-8'
        )
GO
;

INSERT INTO dbo.Sensor
SELECT [bookingID]
      ,[accuracy]
      ,[bearing]
      ,[acceleration_x]
      ,[acceleration_y]
      ,[acceleration_z]
      ,[gyro_x]
      ,[gyro_y]
      ,[gyro_z]
      ,[second]
      ,[speed] FROM dbo.Staging


TRUNCATE TABLE dbo.Staging

-- Import second sensor file

BULK
INSERT
        dbo.Staging
FROM
        'C:/dataset/1-Sensor_DataSet_features_part.csv' WITH (
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                ROWTERMINATOR = '\n',
                CODEPAGE = 'UTF-8'
        )
GO
;

INSERT INTO dbo.Sensor
SELECT bookingID
      ,accuracy
      ,bearing
      ,acceleration_x
      ,acceleration_y
      ,acceleration_z
      ,gyro_x
      ,gyro_y
      ,gyro_z
      ,second
      ,speed FROM dbo.Staging

TRUNCATE TABLE dbo.Staging

-- Import the third file

BULK
INSERT
        dbo.Staging
FROM
        'C:/dataset/2-Sensor_DataSet_features_part.csv' WITH (
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                ROWTERMINATOR = '\n',
                CODEPAGE = 'UTF-8'
        )
GO
;

INSERT INTO dbo.Sensor
SELECT bookingID
      ,accuracy
      ,bearing
      ,acceleration_x
      ,acceleration_y
      ,acceleration_z
      ,gyro_x
      ,gyro_y
      ,gyro_z
      ,second
      ,speed FROM dbo.Staging

TRUNCATE TABLE dbo.Staging

-- Import fourth file

BULK
INSERT
        dbo.Staging
FROM
        'C:/dataset/3_Sensor_DataSet_features_part.csv' WITH (
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                ROWTERMINATOR = '\n',
                CODEPAGE = 'UTF-8'
        )
GO
;

INSERT INTO dbo.Sensor
SELECT bookingID
      ,accuracy
      ,bearing
      ,acceleration_x
      ,acceleration_y
      ,acceleration_z
      ,gyro_x
      ,gyro_y
      ,gyro_z
      ,second
      ,speed FROM dbo.Staging

TRUNCATE TABLE dbo.Staging


-- Import fifth sensor file

BULK
INSERT
        dbo.Staging
FROM
        'C:/dataset/4_Sensor_DataSet_features_part.csv' WITH (
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                ROWTERMINATOR = '\n',
                CODEPAGE = 'UTF-8'
        )
GO
;

INSERT INTO dbo.Sensor
SELECT bookingID
      ,accuracy
      ,bearing
      ,acceleration_x
      ,acceleration_y
      ,acceleration_z
      ,gyro_x
      ,gyro_y
      ,gyro_z
      ,second
      ,speed FROM dbo.Staging
      
DROP TABLE  IF EXISTS  dbo.Staging;

