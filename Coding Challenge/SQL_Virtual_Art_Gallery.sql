CREATE DATABASE Virtual_Art_Gallery;
USE Virtual_Art_Gallery;

CREATE TABLE Artists (
 ArtistID INT PRIMARY KEY,
 Name VARCHAR(255) NOT NULL,
 Biography TEXT,
 Nationality VARCHAR(100));

CREATE TABLE Categories (
 CategoryID INT PRIMARY KEY,
 Name VARCHAR(100) NOT NULL);

CREATE TABLE Artworks (
 ArtworkID INT PRIMARY KEY,
 Title VARCHAR(255) NOT NULL,
 ArtistID INT,
 CategoryID INT,
 Year INT,
 Description TEXT,
 ImageURL VARCHAR(255),
 FOREIGN KEY (ArtistID) REFERENCES Artists (ArtistID),
 FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID));

CREATE TABLE Exhibitions (
 ExhibitionID INT PRIMARY KEY,
 Title VARCHAR(255) NOT NULL,
 StartDate DATE,
 EndDate DATE,
 Description TEXT);

CREATE TABLE ExhibitionArtworks (
 ExhibitionID INT,
 ArtworkID INT,
 PRIMARY KEY (ExhibitionID, ArtworkID),
 FOREIGN KEY (ExhibitionID) REFERENCES Exhibitions (ExhibitionID),
 FOREIGN KEY (ArtworkID) REFERENCES Artworks (ArtworkID));

INSERT INTO Artists 
VALUES
 (1, 'Pablo Picasso', 'Renowned Spanish painter and sculptor.', 'Spanish'),
 (2, 'Vincent van Gogh', 'Dutch post-impressionist painter.', 'Dutch'),
 (3, 'Leonardo da Vinci', 'Italian polymath of the Renaissance.', 'Italian');

INSERT INTO Categories 
VALUES
 (1, 'Painting'),
 (2, 'Sculpture'),
 (3, 'Photography');

INSERT INTO Artworks 
VALUES
 (1, 'Starry Night', 2, 1, 1889, 'A famous painting by Vincent van Gogh.', 'starry_night.jpg'),
 (2, 'Mona Lisa', 3, 1, 1503, 'The iconic portrait by Leonardo da Vinci.', 'mona_lisa.jpg'),
 (3, 'Guernica', 1, 1, 1937, 'Pablo Picasso powerful anti-war mural.', 'guernica.jpg');

INSERT INTO Exhibitions 
VALUES
 (1, 'Modern Art Masterpieces', '2023-01-01', '2023-03-01', 'A collection of modern art masterpieces.'),
 (2, 'Renaissance Art', '2023-04-01', '2023-06-01', 'A showcase of Renaissance art treasures.');

INSERT INTO ExhibitionArtworks 
VALUES
 (1, 1),
 (1, 2),
 (1, 3),
 (2, 2);

--Q1
SELECT Artists.Name, COUNT(Artworks.ArtworkID) AS ArtworkCount
FROM Artists
LEFT JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
GROUP BY Artists.Name
ORDER BY ArtworkCount DESC;

--Q2
SELECT Artworks.Title, Artists.Name, Artworks.Year
FROM Artists
JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
WHERE Artists.Nationality IN ('Spanish', 'Dutch')
ORDER BY Artworks.Year ASC;

--Q3
SELECT Artists.Name, COUNT(Artworks.ArtworkID) AS ArtworkCount
FROM Artists
JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
WHERE Artworks.CategoryID = 1  -- Assuming 'Painting' has CategoryID = 1
GROUP BY Artists.Name;

--Q4
SELECT Artworks.Title, Artists.Name, Categories.Name AS Category
FROM Artworks
JOIN ExhibitionArtworks ON Artworks.ArtworkID = ExhibitionArtworks.ArtworkID
JOIN Exhibitions ON ExhibitionArtworks.ExhibitionID = Exhibitions.ExhibitionID
JOIN Artists ON Artworks.ArtistID = Artists.ArtistID
JOIN Categories ON Artworks.CategoryID = Categories.CategoryID
WHERE Exhibitions.Title = 'Modern Art Masterpieces';

--Q5
SELECT Artists.Name, COUNT(Artworks.ArtworkID) AS ArtworkCount
FROM Artists
JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
GROUP BY Artists.Name
HAVING COUNT(Artworks.ArtworkID) > 2;

--Q6
SELECT DISTINCT Artworks.Title
FROM Artworks
JOIN ExhibitionArtworks ea1 ON Artworks.ArtworkID = ea1.ArtworkID
JOIN ExhibitionArtworks ea2 ON Artworks.ArtworkID = ea2.ArtworkID
JOIN Exhibitions e1 ON ea1.ExhibitionID = e1.ExhibitionID
JOIN Exhibitions e2 ON ea2.ExhibitionID = e2.ExhibitionID
WHERE e1.Title = 'Modern Art Masterpieces' AND e2.Title = 'Renaissance Art';

--Q7
SELECT Categories.Name, COUNT(Artworks.ArtworkID) AS ArtworkCount
FROM Categories
LEFT JOIN Artworks ON Categories.CategoryID = Artworks.CategoryID
GROUP BY Categories.Name;

--Q8
SELECT Artists.Name, COUNT(Artworks.ArtworkID) AS ArtworkCount
FROM Artists
JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
GROUP BY Artists.Name
HAVING COUNT(Artworks.ArtworkID) > 3;

--Q9
SELECT Artworks.Title, Artists.Name, Artists.Nationality
FROM Artists
JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
WHERE Artists.Nationality = 'Spanish';

--Q10
SELECT e.Title
FROM Exhibitions e
JOIN ExhibitionArtworks ea1 ON e.ExhibitionID = ea1.ExhibitionID
JOIN ExhibitionArtworks ea2 ON e.ExhibitionID = ea2.ExhibitionID
JOIN Artworks a1 ON ea1.ArtworkID = a1.ArtworkID
JOIN Artworks a2 ON ea2.ArtworkID = a2.ArtworkID
JOIN Artists av ON a1.ArtistID = av.ArtistID
JOIN Artists al ON a2.ArtistID = al.ArtistID
WHERE (av.Name = 'Vincent van Gogh' AND al.Name = 'Leonardo da Vinci')

--Q11
SELECT Artworks.*
FROM Artworks
LEFT JOIN ExhibitionArtworks ON Artworks.ArtworkID = ExhibitionArtworks.ArtworkID
WHERE ExhibitionArtworks.ArtworkID IS NULL;

--Q12
SELECT Artists.ArtistID, Artists.Name
FROM Artists
WHERE NOT EXISTS (
    SELECT CategoryID
    FROM Categories
    EXCEPT
    SELECT DISTINCT CategoryID
    FROM Artworks
    WHERE Artworks.ArtistID = Artists.ArtistID
);

--Q13
SELECT Categories.Name, COUNT(Artworks.ArtworkID) AS ArtworkCount
FROM Categories
LEFT JOIN Artworks ON Categories.CategoryID = Artworks.CategoryID
GROUP BY Categories.Name;

--Q14
SELECT Artists.Name, COUNT(Artworks.ArtworkID) AS ArtworkCount
FROM Artists
JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
GROUP BY Artists.Name
HAVING COUNT(Artworks.ArtworkID) > 2;

--Q15
SELECT Categories.Name, AVG(Artworks.Year) AS AverageYear
FROM Categories
JOIN Artworks ON Categories.CategoryID = Artworks.CategoryID
GROUP BY Categories.Name
HAVING COUNT(Artworks.ArtworkID) > 1;

--Q16
SELECT Artworks.Title, Artworks.ArtistID, Artists.Name
FROM Artworks
JOIN ExhibitionArtworks ON Artworks.ArtworkID = ExhibitionArtworks.ArtworkID
JOIN Exhibitions ON ExhibitionArtworks.ExhibitionID = Exhibitions.ExhibitionID
JOIN Artists ON Artworks.ArtistID = Artists.ArtistID
WHERE Exhibitions.Title = 'Modern Art Masterpieces';

--Q17
SELECT C.CategoryID, C.Name AS CategoryName, AVG(W.Year) AS AverageYearInCategory,
   (SELECT AVG(Year) FROM Artworks) AS AverageYearOverall
    FROM Categories C
    JOIN  Artworks W ON C.CategoryID = W.CategoryID
    GROUP BY C.CategoryID, C.Name
    HAVING AVG(W.Year) > (SELECT AVG(Year) FROM Artworks);

--Q18
SELECT Artworks.*
FROM Artworks
WHERE Artworks.ArtworkID NOT IN (SELECT ArtworkID FROM ExhibitionArtworks);

--Q19
SELECT DISTINCT
    A.ArtistID,
    A.Name AS ArtistName,
    AC.CategoryID,
    AC.CategoryName
FROM Artists A
JOIN Artworks AW ON A.ArtistID = AW.ArtistID
JOIN (SELECT AW.CategoryID,C.Name AS CategoryName FROM Artworks AW
JOIN Categories C ON AW.CategoryID = C.CategoryID
WHERE AW.Title = 'Mona Lisa') 
AC ON AW.CategoryID = AC.CategoryID AND A.ArtistID != (SELECT ArtistID FROM Artworks WHERE Title = 'Mona Lisa');

--Q20
SELECT Artists.Name, COUNT(Artworks.ArtworkID) AS ArtworkCount
FROM Artists
JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
GROUP BY Artists.Name;