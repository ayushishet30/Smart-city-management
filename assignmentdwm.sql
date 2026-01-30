CREATE DATABASE SmartCityWaste;

USE SmartCityWaste;

-- Task 1.2 

-- City
CREATE TABLE City (
    CityID INT AUTO_INCREMENT PRIMARY KEY,
    CityName VARCHAR(100) NOT NULL UNIQUE
);
SELECT * FROM City;

-- Zone
CREATE TABLE Zone (
    ZoneID INT AUTO_INCREMENT PRIMARY KEY,
    CityID INT NOT NULL,
    ZoneName VARCHAR(100) NOT NULL,
    ZoneType ENUM('Residential','Commercial','Industrial','Mixed') DEFAULT 'Residential',
    UNIQUE (CityID, ZoneName),
    FOREIGN KEY (CityID) REFERENCES City(CityID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

SELECT * FROM Zone;

-- WasteBin
CREATE TABLE WasteBin (
    BinID INT AUTO_INCREMENT PRIMARY KEY,
    ZoneID INT NOT NULL,
    CapacityKg INT NOT NULL CHECK (CapacityKg > 0),
    BinType ENUM('Organic','Plastic','Metal','Paper','Mixed') DEFAULT 'Mixed',
    LocationDescription VARCHAR(255),
    FOREIGN KEY (ZoneID) REFERENCES Zone(ZoneID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
SELECT * FROM WasteBin;

-- Vehicle
CREATE TABLE Vehicle (
    VehicleID INT AUTO_INCREMENT PRIMARY KEY,
    VehicleNumber VARCHAR(50) NOT NULL UNIQUE,
    CapacityKg INT NOT NULL CHECK (CapacityKg > 0),
    VehicleType ENUM('Truck','Van','Tricycle') DEFAULT 'Truck'
);

SELECT * FROM Vehicle;

-- WasteCollection
CREATE TABLE WasteCollection (
    CollectionID INT AUTO_INCREMENT PRIMARY KEY,
    BinID INT NOT NULL,
    VehicleID INT NOT NULL,
    CollectionDate DATE NOT NULL DEFAULT '2025-01-01', 
    WasteWeightKg DECIMAL(10,2) NOT NULL,             
    FOREIGN KEY (BinID) REFERENCES WasteBin(BinID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (VehicleID) REFERENCES Vehicle(VehicleID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

SELECT * FROM WasteCollection;

-- RecyclingPlant
CREATE TABLE RecyclingPlant (
    PlantID INT AUTO_INCREMENT PRIMARY KEY,
    PlantName VARCHAR(100) NOT NULL UNIQUE,
    Location VARCHAR(255)
);

SELECT * FROM RecyclingPlant;

-- Employee
CREATE TABLE Employee (
    EmployeeID INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeName VARCHAR(100) NOT NULL,
    Role ENUM('Collector','Supervisor','Manager') DEFAULT 'Collector'
);

SELECT * FROM Employee;

-- Resident
CREATE TABLE Resident (
    ResidentID INT AUTO_INCREMENT PRIMARY KEY,
    ResidentName VARCHAR(100) NOT NULL,
    ZoneID INT NOT NULL,
    FOREIGN KEY (ZoneID) REFERENCES Zone(ZoneID) ON DELETE CASCADE
);

SELECT * FROM Resident;

-- WasteType
CREATE TABLE WasteType (
    WasteTypeID INT AUTO_INCREMENT PRIMARY KEY,
    TypeName VARCHAR(50) NOT NULL UNIQUE
);

SELECT * FROM WasteType;

-- Vendor
CREATE TABLE Vendor (
    VendorID INT AUTO_INCREMENT PRIMARY KEY,
    VendorName VARCHAR(100) NOT NULL UNIQUE,
    ContactInfo VARCHAR(255)
);

SELECT * FROM Vendor;

-- Junction Tables for Many-to-Many Relationships

CREATE TABLE Collection_Recycling (
    CollectionID INT NOT NULL,
    PlantID INT NOT NULL,
    ProcessedKg DECIMAL(10,2) NOT NULL CHECK (ProcessedKg >= 0),
    PRIMARY KEY (CollectionID, PlantID),
    FOREIGN KEY (CollectionID) REFERENCES WasteCollection(CollectionID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (PlantID) REFERENCES RecyclingPlant(PlantID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);



-- Employee ↔ Vehicle
CREATE TABLE Employee_Vehicle (
    EmployeeID INT NOT NULL,
    VehicleID INT NOT NULL,
    PRIMARY KEY (EmployeeID, VehicleID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID) ON DELETE CASCADE,
    FOREIGN KEY (VehicleID) REFERENCES Vehicle(VehicleID) ON DELETE CASCADE
);

-- Resident ↔ WasteBin
CREATE TABLE Resident_Bin (
    ResidentID INT NOT NULL,
    BinID INT NOT NULL,
    PRIMARY KEY (ResidentID, BinID),
    FOREIGN KEY (ResidentID) REFERENCES Resident(ResidentID) ON DELETE CASCADE,
    FOREIGN KEY (BinID) REFERENCES WasteBin(BinID) ON DELETE CASCADE
);

-- Vendor ↔ WasteType
CREATE TABLE Vendor_WasteType (
    VendorID INT NOT NULL,
    WasteTypeID INT NOT NULL,
    PRIMARY KEY (VendorID, WasteTypeID),
    FOREIGN KEY (VendorID) REFERENCES Vendor(VendorID) ON DELETE CASCADE,
    FOREIGN KEY (WasteTypeID) REFERENCES WasteType(WasteTypeID) ON DELETE CASCADE
);


-- ===============================
-- INSERT SAMPLE DATA (10+ ROWS EACH)
-- ===============================

-- 1. Cities
INSERT INTO City (CityName) VALUES 
('Berlin'), ('Munich'), ('Hamburg'), ('Frankfurt'), ('Cologne'),
('Stuttgart'), ('Dresden'), ('Leipzig'), ('Nuremberg'), ('Bremen');

-- 2. Zones
INSERT INTO Zone (CityID, ZoneName, ZoneType) VALUES
(1, 'Mitte', 'Commercial'),
(1, 'Kreuzberg', 'Residential'),
(2, 'Altstadt', 'Residential'),
(2, 'Schwabing', 'Mixed'),
(3, 'HafenCity', 'Industrial'),
(4, 'Innenstadt', 'Commercial'),
(5, 'Deutz', 'Mixed'),
(6, 'Stuttgart-Mitte', 'Commercial'),
(7, 'Neustadt', 'Residential'),
(8, 'Plagwitz', 'Industrial'),
(9, 'Gostenhof', 'Mixed'),
(10, 'Östliche Vorstadt', 'Residential');

-- 3. WasteBins
INSERT INTO WasteBin (ZoneID, CapacityKg, BinType, LocationDescription) VALUES
(1, 100, 'Plastic', 'Near central park'),
(1, 150, 'Organic', 'Street corner A'),
(2, 200, 'Mixed', 'Residential block 12'),
(3, 120, 'Metal', 'City market area'),
(4, 180, 'Paper', 'Near university'),
(5, 250, 'Mixed', 'Industrial zone main'),
(6, 130, 'Organic', 'Downtown plaza'),
(7, 140, 'Plastic', 'Shopping area'),
(8, 160, 'Metal', 'Factory entrance'),
(9, 170, 'Paper', 'Community center'),
(10, 190, 'Mixed', 'Bus station');

-- 4. Vehicles
INSERT INTO Vehicle (VehicleNumber, CapacityKg, VehicleType) VALUES
('TRK101', 1000, 'Truck'),
('VAN102', 500, 'Van'),
('TRI103', 200, 'Tricycle'),
('TRK104', 1200, 'Truck'),
('VAN105', 600, 'Van'),
('TRI106', 250, 'Tricycle'),
('TRK107', 1100, 'Truck'),
('VAN108', 550, 'Van'),
('TRI109', 300, 'Tricycle'),
('TRK110', 1500, 'Truck');

-- 5. Employees
INSERT INTO Employee (EmployeeName, Role) VALUES
('John Doe', 'Collector'),
('Maria Smith', 'Collector'),
('Liam Johnson', 'Supervisor'),
('Emma Brown', 'Manager'),
('Oliver Schmidt', 'Collector'),
('Sophie Weber', 'Collector'),
('Lucas Meyer', 'Supervisor'),
('Hannah Fischer', 'Manager'),
('Felix Neumann', 'Collector'),
('Laura Keller', 'Collector');

-- 6. Residents
INSERT INTO Resident (ResidentName, ZoneID) VALUES
('Alice Fischer', 2),
('Bob Meyer', 1),
('Clara Schulz', 4),
('David Klein', 3),
('Eva Bauer', 5),
('Finn Wolf', 6),
('Greta Vogel', 7),
('Hugo Roth', 8),
('Isabel Lorenz', 9),
('Jan Richter', 10);

-- 7. WasteTypes
INSERT INTO WasteType (TypeName) VALUES
('Organic'), ('Plastic'), ('Metal'), ('Paper'), ('Mixed'),
('Glass'), ('Electronics'), ('Textiles'), ('Hazardous'), ('Food Waste');

-- 8. Vendors
INSERT INTO Vendor (VendorName, ContactInfo) VALUES
('EcoSupply', 'eco@example.com'),
('RecycleCorp', 'contact@recyclecorp.com'),
('GreenBins', 'info@greenbins.de'),
('WasteSolutions', 'waste@solutions.de'),
('CleanCity', 'clean@city.de'),
('SmartRecycle', 'smart@recycle.com'),
('BinMasters', 'bin@masters.de'),
('EcoTech', 'info@ecotech.com'),
('UrbanWaste', 'urban@waste.com'),
('RecyclePro', 'pro@recycle.de');

-- 9. WasteCollection
INSERT INTO WasteCollection (BinID, VehicleID, CollectionDate, WasteWeightKg) VALUES
(1, 1, '2025-12-20', 90),
(2, 1, '2025-12-21', 140),
(3, 2, '2025-12-22', 180),
(4, 2, '2025-12-23', 110),
(5, 3, '2025-12-24', 170),
(6, 4, '2025-12-25', 130),
(7, 5, '2025-12-26', 150),
(8, 5, '2025-12-27', 160),
(9, 6, '2025-12-28', 120),
(10, 7, '2025-12-29', 140);

-- 10. RecyclingPlants
INSERT INTO RecyclingPlant (PlantName, Location) VALUES
('Berlin Recycling', 'Berlin'),
('Munich Plant', 'Munich'),
('Hamburg Eco', 'Hamburg'),
('Frankfurt Recycle', 'Frankfurt'),
('Cologne Waste', 'Cologne'),
('Stuttgart Green', 'Stuttgart'),
('Dresden Plant', 'Dresden'),
('Leipzig Eco', 'Leipzig'),
('Nuremberg Recycle', 'Nuremberg'),
('Bremen Waste', 'Bremen');

-- ===============================
-- JUNCTION TABLES (M:N relationships)
-- ===============================

-- Collection_Recycling
INSERT INTO Collection_Recycling (CollectionID, PlantID, ProcessedKg) VALUES
(1, 1, 90),(2, 1, 140),(3, 2, 180),(4, 2, 110),(5, 3, 170),
(6, 4, 130),(7, 5, 150),(8, 5, 160),(9, 6, 120),(10, 7, 140);

-- Employee_Vehicle
INSERT INTO Employee_Vehicle (EmployeeID, VehicleID) VALUES
(1, 1),(2, 2),(3, 3),(4, 4),(5, 5),(6, 6),(7, 7),(8, 8),(9, 9),(10, 10);

-- Resident_Bin
INSERT INTO Resident_Bin (ResidentID, BinID) VALUES
(1, 3),(2, 1),(2, 2),(3, 5),(4, 4),
(5, 6),(6, 7),(7, 8),(	8, 9),(9, 10),(10, 5);

-- Vendor_WasteType
INSERT INTO Vendor_WasteType (VendorID, WasteTypeID) VALUES
(1, 1),(1, 2),(2, 3),(2, 4),(3, 5),
(4, 6),(5, 7),(6, 8),(7, 9),(8, 10),(9, 1),(10, 2);

-- View 1: Total waste collected per vehicle
CREATE VIEW Vehicle_Waste_Summary AS
SELECT v.VehicleNumber, SUM(wc.WasteWeightKg) AS TotalWasteCollected
FROM WasteCollection wc
JOIN Vehicle v ON wc.VehicleID = v.VehicleID
GROUP BY v.VehicleNumber;

-- View 2: Waste processed per recycling plant
CREATE VIEW Plant_Processed_Waste AS
SELECT rp.PlantName, SUM(cr.ProcessedKg) AS TotalProcessed
FROM Collection_Recycling cr
JOIN RecyclingPlant rp ON cr.PlantID = rp.PlantID
GROUP BY rp.PlantName;

-- TASK 3: Advanced SQL Queries for Analytics 
SELECT 
    v.VehicleNumber,
    SUM(wc.WasteWeightKg) AS TotalWaste,
    RANK() OVER (ORDER BY SUM(wc.WasteWeightKg) DESC) AS VehicleRank,
    CASE 
        WHEN SUM(wc.WasteWeightKg) > 500 THEN 'High Performer'
        ELSE 'Normal'
    END AS PerformanceStatus
FROM WasteCollection wc
JOIN Vehicle v ON wc.VehicleID = v.VehicleID
GROUP BY v.VehicleNumber
HAVING TotalWaste > 100;


-- Query 2: Total Waste Collected Per Zone by Type
SELECT 
    z.ZoneName,
    wb.BinType,
    SUM(wc.WasteWeightKg) AS TotalWaste,
    CASE 
        WHEN SUM(wc.WasteWeightKg) > 200 THEN 'High Waste Zone'
        ELSE 'Normal'
    END AS WasteLevel
FROM WasteCollection wc
JOIN WasteBin wb ON wc.BinID = wb.BinID
JOIN Zone z ON wb.ZoneID = z.ZoneID
GROUP BY z.ZoneName, wb.BinType
ORDER BY TotalWaste DESC;



-- Query 3: Recycling Plant Efficiency
 SELECT 
    rp.PlantName,
    SUM(cr.ProcessedKg) AS ProcessedWaste,
    (SELECT SUM(wc.WasteWeightKg)
     FROM WasteCollection wc
     JOIN Collection_Recycling cr2 ON wc.CollectionID = cr2.CollectionID
     WHERE cr2.PlantID = rp.PlantID) AS TotalCollected,
    CASE
        WHEN SUM(cr.ProcessedKg) < 
             (SELECT SUM(wc.WasteWeightKg)
              FROM WasteCollection wc
              JOIN Collection_Recycling cr2 ON wc.CollectionID = cr2.CollectionID
              WHERE cr2.PlantID = rp.PlantID)
        THEN 'Below Target'
        ELSE 'On Target'
    END AS Status
FROM Collection_Recycling cr
JOIN RecyclingPlant rp ON cr.PlantID = rp.PlantID
GROUP BY rp.PlantName;


-- Query 4: Resident Waste Contribution Trend
SELECT 
    ResidentName,
    CollectionMonth,
    WastePerMonth,
    ROW_NUMBER() OVER (PARTITION BY ResidentID ORDER BY CollectionMonth) AS RowNum
FROM (
    SELECT 
        r.ResidentID,
        r.ResidentName,
        MONTH(wc.CollectionDate) AS CollectionMonth,
        SUM(wc.WasteWeightKg) AS WastePerMonth
    FROM Resident r
    JOIN Resident_Bin rb ON r.ResidentID = rb.ResidentID
    JOIN WasteCollection wc ON rb.BinID = wc.BinID
    GROUP BY r.ResidentID, r.ResidentName, MONTH(wc.CollectionDate)
) AS sub
ORDER BY ResidentName, CollectionMonth;

-- Query 5: Employee Productivity – Waste Collection per Employee

SELECT 
    e.EmployeeName,
    COUNT(wc.CollectionID) AS TotalCollections,
    SUM(wc.WasteWeightKg) AS TotalWeightCollected,
    AVG(wc.WasteWeightKg) AS AvgWeightPerCollection,
    CASE 
        WHEN SUM(wc.WasteWeightKg) > 400 THEN 'High Performer'
        ELSE 'Normal'
    END AS PerformanceStatus
FROM Employee e
JOIN Employee_Vehicle ev ON e.EmployeeID = ev.EmployeeID
JOIN WasteCollection wc ON ev.VehicleID = wc.VehicleID
GROUP BY e.EmployeeName
HAVING TotalCollections >= 2
ORDER BY TotalWeightCollected DESC;


CALL GetVehicleWaste(1);

CALL GetZoneWaste(2);

-- Task 5

SELECT 
    rp.PlantName,
    SUM(cr.ProcessedKg) AS ProcessedWaste,
    (SELECT SUM(wc.WasteWeightKg)
     FROM WasteCollection wc
     JOIN Collection_Recycling cr2 
       ON wc.CollectionID = cr2.CollectionID
     WHERE cr2.PlantID = rp.PlantID) AS TotalCollected,
    CASE
        WHEN SUM(cr.ProcessedKg) < 
             (SELECT SUM(wc.WasteWeightKg)
              FROM WasteCollection wc
              JOIN Collection_Recycling cr2 
                ON wc.CollectionID = cr2.CollectionID
              WHERE cr2.PlantID = rp.PlantID)
        THEN 'Below Target'
        ELSE 'On Target'
    END AS Status
FROM Collection_Recycling cr
JOIN RecyclingPlant rp ON cr.PlantID = rp.PlantID
GROUP BY rp.PlantName;
 
 SELECT 
    rp.PlantName,
    SUM(cr.ProcessedKg) AS ProcessedWaste,
    SUM(wc.WasteWeightKg) AS TotalCollected,
    CASE
        WHEN SUM(cr.ProcessedKg) < SUM(wc.WasteWeightKg)
        THEN 'Below Target'
        ELSE 'On Target'
    END AS Status
FROM RecyclingPlant rp
JOIN Collection_Recycling cr 
    ON rp.PlantID = cr.PlantID
JOIN WasteCollection wc 
    ON cr.CollectionID = wc.CollectionID
GROUP BY rp.PlantName;


CREATE INDEX idx_wc_collectionid ON WasteCollection(CollectionID);
CREATE INDEX idx_cr_plantid ON Collection_Recycling(PlantID);
CREATE INDEX idx_cr_collectionid ON Collection_Recycling(CollectionID);

UPDATE Employee SET EmployeeName = 'Aarav Schneider' WHERE EmployeeID = 1;
UPDATE Employee SET EmployeeName = 'Zoya Hoffmann' WHERE EmployeeID = 2;
UPDATE Employee SET EmployeeName = 'Rohan Müller' WHERE EmployeeID = 3;
UPDATE Employee SET EmployeeName = 'Ananya Krüger' WHERE EmployeeID = 4;
UPDATE Employee SET EmployeeName = 'Kunal Weber' WHERE EmployeeID = 5;
UPDATE Employee SET EmployeeName = 'Meera Fischer' WHERE EmployeeID = 6;
UPDATE Employee SET EmployeeName = 'Siddharth Neumann' WHERE EmployeeID = 7;
UPDATE Employee SET EmployeeName = 'Pooja Lehmann' WHERE EmployeeID = 8;
UPDATE Employee SET EmployeeName = 'Aditya Braun' WHERE EmployeeID = 9;
UPDATE Employee SET EmployeeName = 'Nisha Keller' WHERE EmployeeID = 10;

UPDATE Resident SET ResidentName = 'Ishaan Vogel' WHERE ResidentID = 1;
UPDATE Resident SET ResidentName = 'Aaliya Becker' WHERE ResidentID = 2;
UPDATE Resident SET ResidentName = 'Varun Schäfer' WHERE ResidentID = 3;
UPDATE Resident SET ResidentName = 'Sneha Roth' WHERE ResidentID = 4;
UPDATE Resident SET ResidentName = 'Arjun Baumann' WHERE ResidentID = 5;
UPDATE Resident SET ResidentName = 'Kavya Brandt' WHERE ResidentID = 6;
UPDATE Resident SET ResidentName = 'Nikhil Sauer' WHERE ResidentID = 7;
UPDATE Resident SET ResidentName = 'Aishwarya Lindner' WHERE ResidentID = 8;
UPDATE Resident SET ResidentName = 'Rahul König' WHERE ResidentID = 9;
UPDATE Resident SET ResidentName = 'Tanvi Albrecht' WHERE ResidentID = 10;
