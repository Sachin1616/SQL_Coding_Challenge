CREATE DATABASE Crime_Management;
USE Crime_Management;

CREATE TABLE Crime (
 CrimeID INT PRIMARY KEY,
 IncidentType VARCHAR(255),
 IncidentDate DATE,
 Location VARCHAR(255),
 Description TEXT,
 Status VARCHAR(20)
);

CREATE TABLE Victim (
 VictimID INT PRIMARY KEY,
 CrimeID INT,
 Name VARCHAR(255),
 ContactInfo VARCHAR(255),
 Injuries VARCHAR(255),
 FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID)
);

CREATE TABLE Suspect (
SuspectID INT PRIMARY KEY,
 CrimeID INT,
 Name VARCHAR(255),
 Description TEXT,
 CriminalHistory TEXT,
 FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID)
);

INSERT INTO Crime 
VALUES
 (1, 'Robbery', '2023-09-15', '123 Main St, Cityville', 'Armed robbery at a convenience store', 'Open'),
 (2, 'Homicide', '2023-09-20', '456 Elm St, Townsville', 'Investigation into a murder case', 'Under Investigation'),
 (3, 'Theft', '2023-09-10', '789 Oak St, Villagetown', 'Shoplifting incident at a mall', 'Closed');

INSERT INTO Victim 
VALUES
 (1, 1, 'John Doe', 'johndoe@example.com', 'Minor injuries'),
 (2, 2, 'Jane Smith', 'janesmith@example.com', 'Deceased'),
 (3, 3, 'Alice Johnson', 'alicejohnson@example.com', 'None');

INSERT INTO Suspect 
VALUES
 (1, 1, 'Robber 1', 'Armed and masked robber', 'Previous robbery convictions'),
 (2, 2, 'Unknown', 'Investigation ongoing', NULL),
 (3, 3, 'Suspect 1', 'Shoplifting suspect', 'Prior shoplifting arrests');

--Q1
SELECT *
FROM Crime
WHERE Status = 'Open';

--Q2
SELECT COUNT(*) AS TotalIncidents
FROM Crime;

--Q3
SELECT DISTINCT IncidentType
FROM Crime;

--Q4
SELECT *
FROM Crime
WHERE IncidentDate BETWEEN '2023-09-01' AND '2023-09-10';

--Q7
SELECT IncidentType, COUNT(*) AS IncidentCount
FROM Crime
WHERE Status = 'Open'
GROUP BY IncidentType;

--Q8
SELECT name
FROM Victim
WHERE Name LIKE '%Doe%'
UNION
SELECT name
FROM Suspect
WHERE Name LIKE '%Doe%';

--Q9
SELECT Name, Status
FROM (
      SELECT Name, 'Open' AS Status FROM Victim
      UNION
      SELECT Name, 'Open' AS Status FROM Suspect
      UNION
      SELECT Name, 'Closed' AS Status FROM Victim
      UNION
      SELECT Name, 'Closed' AS Status FROM Suspect
     ) AS CombinedNames;


-- Q11
SELECT Name
FROM Victim
WHERE CrimeID = (SELECT CrimeID FROM Crime WHERE IncidentType = 'Robbery')
UNION
SELECT Name
FROM Suspect
WHERE CrimeID = (SELECT CrimeID FROM Crime WHERE IncidentType = 'Robbery');

--Q12
SELECT IncidentType, COUNT(*) AS OpenCaseCount
FROM Crime
WHERE Status = 'Open'
GROUP BY IncidentType
HAVING COUNT(*) > 1;

--Q13
SELECT *
FROM Crime
JOIN Suspect ON Crime.CrimeID = Suspect.CrimeID
WHERE Suspect.Name IN (SELECT Name FROM Victim WHERE CrimeID = Crime.CrimeID);

--Q14
SELECT c.*, v.Name AS VictimName, s.Name AS SuspectName
FROM Crime c
LEFT JOIN Victim v ON c.CrimeID = v.CrimeID
LEFT JOIN Suspect s ON c.CrimeID = s.CrimeID;


--Q16
SELECT SuspectID, Name, COUNT(CrimeID) AS IncidentCount
FROM Suspect
GROUP BY SuspectID, Name
HAVING COUNT(CrimeID) > 1;

--Q17
SELECT *
FROM Crime
WHERE CrimeID NOT IN (SELECT CrimeID FROM Suspect);

--Q18
SELECT *
FROM Crime
WHERE IncidentType = 'Homicide' OR (IncidentType = 'Robbery' AND CrimeID NOT IN (SELECT CrimeID FROM Crime WHERE IncidentType <> 'Robbery'));

--Q19
SELECT c.*, 
       ISNULL(s.Name, 'No Suspect') AS SuspectName
FROM Crime c
LEFT JOIN Suspect s ON c.CrimeID = s.CrimeID;

--Q20
SELECT s.*
FROM Suspect s
JOIN Crime c ON s.CrimeID = c.CrimeID
WHERE c.IncidentType IN ('Robbery', 'Assault');