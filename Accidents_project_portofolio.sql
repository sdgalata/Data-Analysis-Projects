use [CarAccidents];
select* from [dbo].[accident];
select* from [dbo].[vehicle];

--How many accidents have occurred in urban areas versus rural areas?
SELECT
 [Area],
 COUNT([AccidentIndex]) AS 'Total Accident'
FROM
 [dbo].[accident]
GROUP BY
 [Area]

--Which day of the week has the highest number of accidents?
SELECT 
 [Day],
 COUNT([AccidentIndex]) AS 'Total Accident'
 FROM
  [dbo].[accident]
 GROUP BY
  [Day]
 ORDER BY
  'Total Accident' DESC

--What is the average age of vehicles involved in accidents based on their type?
 SELECT
  [VehicleType],
  COUNT([AccidentIndex]) AS 'Total Accident',
  CEILING(AVG([AgeVehicle])) AS 'Average Year'
 FROM
  [dbo].[vehicle]
WHERE
 [AgeVehicle] IS NOT NULL
GROUP BY
 [VehicleType]
ORDER BY
 'Total Accident' DESC

/*Can we identify any trends in accidents based on the age of vehicles involved? */
SELECT
 AgeGroup,
 COUNT([AccidentIndex]) AS 'Total Accident',
 CEILING(AVG([AgeVehicle])) AS 'Average Year'
FROM (
  SELECT
   [AccidentIndex],
   [AgeVehicle],
   CASE 
     WHEN [AgeVehicle] BETWEEN 0 AND 5 THEN 'New'
     WHEN [AgeVehicle] BETWEEN 6 AND 10 THEN 'Regular'
     ELSE 'Old'
   END AS 'AgeGroup'
  FROM [dbo].[vehicle]
) AS SubQuery
GROUP BY
 AgeGroup

-- Are there any specific weather conditions that contribute to severe accidents?

DECLARE @Severity varchar(100)
SET @Severity = 'Fatal'

SELECT
 [WeatherConditions],
 COUNT([Severity]) AS 'Total Accident'
FROM
 [dbo].[accident]
WHERE 
 [Severity] = @Severity
GROUP BY
 [WeatherConditions]
ORDER BY
 'Total Accident' DESC

--Do accidents often involve impacts on left-hand side of vehicles?
SELECT
 [LeftHand],
 COUNT([AccidentIndex]) AS 'Total Accident'
FROM
 [dbo].[vehicle]
GROUP BY
 [LeftHand]
HAVING 
 [LeftHand] IS NOT NULL

--Are there any relationships between journey purposes and the severity of accidents?
SELECT
 V.[JourneyPurpose],
 COUNT(A.[Severity]) AS 'Total Accident',
 CASE
   WHEN COUNT(A.[Severity]) BETWEEN 0 AND 1000 THEN 'Low'
   WHEN COUNT(A.[Severity]) BETWEEN 1001 AND 3000 THEN 'Moderate'
   ELSE 'High'
 END AS 'Level'
FROM
 [dbo].[accident]AS A
JOIN
 [dbo].[vehicle] AS V ON V.[AccidentIndex] = A.[AccidentIndex]
GROUP BY
 V.[JourneyPurpose]
ORDER BY 
 'Total Accident' DESC

-- Calculate the average age of vehicles involved in accidents concerning Day Light and point of impact.
 
 DECLARE @Impact varchar(100)
 DECLARE @Light varchar(100)
 SET @Impact='Nearside' /*Change based on Impact you would like to examine e.g Front */
 SET @Light= 'Daylight'  /*Change based on Light you would like to examine e.g Front */
 
 SELECT
  A.[LightConditions],
  V.[PointImpact],
  CEILING(AVG(V.AgeVehicle)) AS 'Average Year'
 FROM
  [dbo].[accident]A
JOIN
 [dbo].[vehicle]V ON V.[AccidentIndex] = A.[AccidentIndex]
GROUP BY
 A.LightConditions, V.PointImpact
HAVING 
 V.PointImpact = @Impact AND A.LightConditions= @Light