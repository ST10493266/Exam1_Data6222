CREATE DATABASE ST10493266_DATA6222_ExamQ1;

-- 1. Create the CLIENT table
CREATE TABLE CLIENT (
    ClientID VARCHAR(5) NOT NULL PRIMARY KEY,
    ClientFullName VARCHAR(50) NOT NULL,
    ClientContact VARCHAR(20) NOT NULL
);

-- 2. Create the VENUE table
CREATE TABLE VENUE (
    VenueID VARCHAR(5) NOT NULL PRIMARY KEY,
    VenueName VARCHAR(50) NOT NULL,
    VenueAddress VARCHAR(100) NOT NULL
);

-- 3. Create the BOOKING table (with Foreign Key constraints referencing CLIENT and VENUE)
CREATE TABLE Booking (
    BookingID VARCHAR(5) NOT NULL PRIMARY KEY,
    ClientID VARCHAR(5) NOT NULL,
    VenueID VARCHAR(5) NOT NULL,
    EventStartDate DATE NOT NULL,
    EventEndDate DATE NOT NULL,
    NumberOfAttendees INT NOT NULL,
    CONSTRAINT FK_Booking_Client FOREIGN KEY (ClientID) REFERENCES CLIENT(ClientID),
    CONSTRAINT FK_Booking_Venue FOREIGN KEY (VenueID) REFERENCES VENUE(VenueID)
);

--Q.1.1 VIEW
CREATE VIEW LargeBOOKINGs AS
SELECT 
    VenueID,
    ClientID,
    EventStartDate,
    EventEndDate,
    NumberOfAttendees
FROM 
    Booking
WHERE 
    YEAR(EventStartDate) = 2026
    AND NumberOfAttendees >= 100;
GO

-- Verification Query
SELECT * FROM LargeBOOKINGs;

--Q.12 STORED PROCEDURE FindBookings
CREATE PROCEDURE FindBOOKINGs
    @VenueID VARCHAR(5)
AS
BEGIN
    SELECT 
        c.ClientFullName,
        c.ClientContact,
        b.EventStartDate,
        b.EventEndDate,
        b.NumberOfAttendees
    FROM 
        Booking b
    INNER JOIN 
        Client c ON b.ClientID = c.ClientID
    INNER JOIN 
        Venue v ON b.VenueID = v.VenueID
    WHERE 
        b.VenueID = @VenueID;
END;
GO

-- Execution Requirement
EXEC FindBOOKINGs @VenueID = 'V0002';


--Q.1.3 VENUE BOOKING STATUS CLASSIFICATION
SELECT 
    v.VenueID,
    v.VenueName,
    v.VenueAddress,
    CASE 
        WHEN COUNT(b.BookingID) > 0 THEN 'Bookings exist'
        ELSE 'No bookings exist'
    END AS [BOOKING STATUS]
FROM 
    Venue v
LEFT JOIN 
    Booking b ON v.VenueID = b.VenueID
GROUP BY 
    v.VenueID,
    v.VenueName,
    v.VenueAddress;

    --Q.1.4 ATTENDEES SUMMARY REPORT
    SELECT 
    v.VenueName,
    SUM(b.NumberOfAttendees) AS [TOTAL ATTENDEES]
FROM 
    Venue v
LEFT JOIN 
    Booking b ON v.VenueID = b.VenueID
GROUP BY 
    v.VenueName
ORDER BY 
    [TOTAL ATTENDEES] DESC;

    --Q.1.5 UNBOOKED VENUES LIST 
    SELECT 
    v.VenueName
FROM 
    Venue v
LEFT JOIN 
    Booking b ON v.VenueID = b.VenueID
WHERE 
    b.BookingID IS NULL;

    --QUESTION 2
    --2.1 CREATE TABLE EQUIPMENT

CREATE TABLE EQUIPMENT (
    EQUIPMENT_ID VARCHAR(5) NOT NULL PRIMARY KEY,
    EQUIPMENT_NAME VARCHAR(40) NOT NULL
);

CREATE TABLE WAREHOUSE (
    WAREHOUSE_ID VARCHAR(5) NOT NULL PRIMARY KEY,
    WAREHOUSE_NAME VARCHAR(20) NOT NULL,
    ADDRESS VARCHAR(40) NOT NULL
);

CREATE TABLE AVAILABILITY (
    EQUIPMENT_ID VARCHAR(5) NOT NULL,
    WAREHOUSE_ID VARCHAR(5) NOT NULL,
    QUANTITY SMALLINT NOT NULL,
    CONSTRAINT PK_AVAILABILITY PRIMARY KEY (EQUIPMENT_ID, WAREHOUSE_ID),
    CONSTRAINT FK_AVAILABILITY_EQUIPMENT FOREIGN KEY (EQUIPMENT_ID) REFERENCES EQUIPMENT(EQUIPMENT_ID),
    CONSTRAINT FK_AVAILABILITY_WAREHOUSE FOREIGN KEY (WAREHOUSE_ID) REFERENCES WAREHOUSE(WAREHOUSE_ID)
);

--Q.2.2 POPULATE DATA
-- Populate EQUIPMENT
INSERT INTO EQUIPMENT (EQUIPMENT_ID, EQUIPMENT_NAME) VALUES
('E001', 'Football Nets'),
('E002', 'Training Cones'),
('E003', 'Cricket Bats'),
('E004', 'Tennis Rackets'),
('E005', 'Gym Mats');

-- Populate WAREHOUSE
INSERT INTO WAREHOUSE (WAREHOUSE_ID, WAREHOUSE_NAME, ADDRESS) VALUES
('W001', 'Central Sports Depot', '15 Loop Street, Cape Town'),
('W002', 'Northern Supplies', '88 Church Street, Polokwane'),
('W003', 'Coastal Storage', '44 Marine Road, Durban'),
('W004', 'Inland Hub', '9 Park Avenue, Bloemfontein'),
('W005', 'Eastern Depot', '61 Oxford Street, East London');

-- Populate AVAILABILITY
INSERT INTO AVAILABILITY (EQUIPMENT_ID, WAREHOUSE_ID, QUANTITY) VALUES
('E002', 'W001', 20),
('E002', 'W004', 12),
('E003', 'W005', 7),
('E004', 'W003', 9),
('E004', 'W001', 14);

--Q.2.3 ALTER TABLE
ALTER TABLE AVAILABILITY
ADD STOCK_ORDERED SMALLINT NULL;

--Q.2.4 UPDATE COLUMN
UPDATE AVAILABILITY
SET STOCK_ORDERED = 3
WHERE EQUIPMENT_ID = 'E004' AND WAREHOUSE_ID = 'W003';

--Q.2.5 UNSTOKED EQUIPMENT REPORT
SELECT 
    e.EQUIPMENT_NAME
FROM 
    EQUIPMENT e
LEFT JOIN 
    AVAILABILITY a ON e.EQUIPMENT_ID = a.EQUIPMENT_ID
WHERE 
    a.EQUIPMENT_ID IS NULL;

 --Q.2.6 TOTAL AVAILABLE STOCK REPORT
    SELECT 
    e.EQUIPMENT_NAME,
    SUM(a.QUANTITY) AS TOTAL_AVAILABLE
FROM 
    EQUIPMENT e
LEFT JOIN 
    AVAILABILITY a ON e.EQUIPMENT_ID = a.EQUIPMENT_ID
GROUP BY 
    e.EQUIPMENT_NAME
ORDER BY 
    e.EQUIPMENT_NAME ASC;


    --Q.2.7 WAREHOUSE STOCK LOOKUP FOR 'E002'
    SELECT TOP 1
    w.WAREHOUSE_NAME,
    w.ADDRESS,
    e.EQUIPMENT_NAME,
    a.QUANTITY
FROM 
    AVAILABILITY a
INNER JOIN 
    WAREHOUSE w ON a.WAREHOUSE_ID = w.WAREHOUSE_ID
INNER JOIN 
    EQUIPMENT e ON a.EQUIPMENT_ID = e.EQUIPMENT_ID
WHERE 
    a.EQUIPMENT_ID = 'E002'
ORDER BY 
    a.QUANTITY DESC;
