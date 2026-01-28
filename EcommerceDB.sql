--e-ticarət verilənlər bazasının yaradılması
CREATE DATABASE EcommerceDB;
USE EcommerceDB;
--cədvəllərin yaradılması
CREATE TABLE Saticilar (
    Id INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Email NVARCHAR(150) UNIQUE,
    Phone NVARCHAR(20)
);

CREATE TABLE Kategoriyalar (
    Id INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255)
);

CREATE TABLE Musteriler (
    Id INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Email NVARCHAR(150) UNIQUE,
    Phone NVARCHAR(20)
);

CREATE TABLE Mehsullar (
    Id INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255),
    Price DECIMAL(10,2) CHECK (Price >= 0),
    KategoriyaId INT NOT NULL,
    CONSTRAINT FK_Mehsullar_Kategoriyalar
        FOREIGN KEY (KategoriyaId) REFERENCES Kategoriyalar(Id)
);

CREATE TABLE Sifarishler (
    Id INT IDENTITY PRIMARY KEY,
    OrderDate DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(50),
    MusteriId INT NOT NULL,
    CONSTRAINT FK_Sifarishler_Musteriler
        FOREIGN KEY (MusteriId) REFERENCES Musteriler(Id)
);

CREATE TABLE SifarishDetallari (
    Id INT IDENTITY PRIMARY KEY,
    Quantity INT CHECK (Quantity > 0),
    UnitPrice DECIMAL(10,2) CHECK (UnitPrice >= 0),
    SifarishId INT NOT NULL,
    MehsulId INT NOT NULL,
    CONSTRAINT FK_SifarishDetallari_Sifarishler
        FOREIGN KEY (SifarishId) REFERENCES Sifarishler(Id),
    CONSTRAINT FK_SifarishDetallari_Mehsullar
        FOREIGN KEY (MehsulId) REFERENCES Mehsullar(Id)
);

CREATE TABLE Techizatcilar (
    Id INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    ContactInfo NVARCHAR(255)
);

CREATE TABLE MehsulTechizatcilar (
    MehsulId INT ,
    TechizatciId INT,
    CONSTRAINT PK_MehsulTechizatcilar
        PRIMARY KEY (MehsulId, TechizatciId),
    CONSTRAINT FK_MT_Mehsullar
        FOREIGN KEY (MehsulId) REFERENCES Mehsullar(Id),
    CONSTRAINT FK_MT_Techizatcilar
        FOREIGN KEY (TechizatciId) REFERENCES Techizatcilar(Id)
);
--dataların daxil edilməsi
INSERT INTO Kategoriyalar (Name, Description) VALUES
('Electronics', 'Electronic devices'),
('Home', 'Home and furniture products'),
('Books', 'Printed books');

INSERT INTO Musteriler (Name, Email, Phone) VALUES
('Elmir Mammadov', 'elmir.mammedov@mail.com', '0501111111'),
('Fidan Aliyeva', 'fidanali@mail.com', '0502222222'),
('Kamran Hasanov', 'kamran@mail.com', '0503333333');

INSERT INTO Saticilar (Name, Email, Phone) VALUES
('TechStore', 'tech@store.com', '012111111'),
('HomeShop', 'home@shop.com', '012222222');

INSERT INTO Techizatcilar (Name, ContactInfo) VALUES
('Samsung Supplier', 'samsung@supplier.com'),
('Ikea Supplier', 'ikea@supplier.com'),
('BookWorld Supplier', 'books@supplier.com');

INSERT INTO Mehsullar (Name, Description, Price, KategoriyaId) VALUES
('Laptop', 'Gaming laptop', 2500, 1),
('Smartphone', 'Latest model smartphone', 1800, 1),
('Sofa', 'Comfortable sofa', 1200, 2),
('Table', 'Wooden table', 600, 2),
('PS Book', 'Database fundamentals book', 80, 3);

INSERT INTO MehsulTechizatcilar (MehsulId, TechizatciId)
SELECT m.Id, t.Id
FROM Mehsullar m
JOIN Techizatcilar t ON t.Name = 'Samsung Supplier'
WHERE m.Name IN ('Laptop', 'Smartphone');

INSERT INTO MehsulTechizatcilar (MehsulId, TechizatciId)
SELECT m.Id, t.Id
FROM Mehsullar m
JOIN Techizatcilar t ON t.Name = 'Ikea Supplier'
WHERE m.Name IN ('Sofa', 'Table');

INSERT INTO MehsulTechizatcilar (MehsulId, TechizatciId)
SELECT m.Id, t.Id
FROM Mehsullar m
JOIN Techizatcilar t ON t.Name = 'BookWorld Supplier'
WHERE m.Name = 'SQL Book';

INSERT INTO Sifarishler (Status, MusteriId) VALUES
('Completed', 1),
('Completed', 1),
('Completed', 2),
('Pending', 3);
INSERT INTO SifarishDetallari (Quantity, UnitPrice, SifarishId, MehsulId) VALUES
(1, 2500, 1, 1),
(2, 1800, 1, 2),
(1, 1200, 2, 3),
(1, 600, 2, 4),
(3, 80, 3, 5);

--task 2.1  Hər bir müştərinin ümumi sifariş sayini tapın

SELECT m.Id,
    m.Name AS CustomerName,
    COUNT(s.Id) AS TotalOrders
FROM Musteriler m
LEFT JOIN Sifarishler s ON m.Id = s.MusteriId
GROUP BY m.Id, m.Name;

--task 2.2 Yalnız ümumi sifarisleri 5000-dən çox olan müştəriləri göstər.

SELECT m.Id,
m.Name AS CustomerName,
SUM(sd.Quantity * sd.UnitPrice) AS TotalSpent
FROM Musteriler m
JOIN Sifarishler s ON m.Id = s.MusteriId
JOIN SifarishDetallari sd ON s.Id = sd.SifarishId
GROUP BY m.Id, m.Name
HAVING SUM(sd.Quantity * sd.UnitPrice) > 5000;

--task 2.3 Hər sifariş üçün məhsulların ümumi qiymətini (Quantity × UnitPrice) hesablayın,
-- sifarişin TotalAmount ilə müqayisə edin.
SELECT  s.Id AS OrderId,
    SUM(sd.Quantity * sd.UnitPrice) AS CalculatedTotal
FROM Sifarishler s
JOIN SifarishDetallari sd ON s.Id = sd.SifarishId
GROUP BY s.Id;

--task 2.4 Hər məhsul kateqoriyası üzrə satılan toplam məhsul sayı və toplam satış məbləğini tapın.
SELECT k.Name AS CategoryName,
    SUM(sd.Quantity) AS TotalQuantity,
    SUM(sd.Quantity * sd.UnitPrice) AS TotalSales
FROM Kategoriyalar k
JOIN Mehsullar m ON k.Id = m.KategoriyaId
JOIN SifarishDetallari sd ON m.Id = sd.MehsulId
GROUP BY k.Name;

--task 2.5 Hər bir müştərinin ən çox sifariş verdiyi məhsul kateqoriyasını tapın.

SELECT CustomerName, CategoryName
FROM (
    SELECT 
        mu.Name AS CustomerName,
        k.Name AS CategoryName,
        SUM(sd.Quantity) AS TotalQuantity,
        ROW_NUMBER() OVER (
            PARTITION BY mu.Id
            ORDER BY SUM(sd.Quantity) DESC
        ) AS rn
    FROM Musteriler mu
    JOIN Sifarishler s ON mu.Id = s.MusteriId
    JOIN SifarishDetallari sd ON s.Id = sd.SifarishId
    JOIN Mehsullar m ON sd.MehsulId = m.Id
    JOIN Kategoriyalar k ON m.KategoriyaId = k.Id
    GROUP BY mu.Id, mu.Name, k.Name
) t
WHERE rn = 1;

--task 2.6Bu tapşırıqların nəticələrini istifadə edərək bir VIEW yaradın, 
--CustomerOrderSummary,VIEW aşağıdakı məlumatları saxlamalıdır indi bu tapsirigi yaz:

CREATE VIEW CustomerOrderSummary AS
SELECT m.Id AS CustomerId,
       m.Name AS CustomerName,
       COUNT(DISTINCT s.Id) AS TotalOrders,
       SUM(sd.Quantity * sd.UnitPrice) AS TotalSpent,
       mc.CategoryName AS MostOrderedCategory
FROM Musteriler m
LEFT JOIN Sifarishler s ON m.Id = s.MusteriId
LEFT JOIN SifarishDetallari sd ON s.Id = sd.SifarishId
OUTER APPLY (
    SELECT TOP 1
        k.Name AS CategoryName
    FROM Sifarishler s2
    JOIN SifarishDetallari sd2 ON s2.Id = sd2.SifarishId
    JOIN Mehsullar m2 ON sd2.MehsulId = m2.Id
    JOIN Kategoriyalar k ON m2.KategoriyaId = k.Id
    WHERE s2.MusteriId = m.Id
    GROUP BY k.Name
    ORDER BY SUM(sd2.Quantity) DESC
) mc
GROUP BY m.Id, m.Name, mc.CategoryName;

--end of the code file



