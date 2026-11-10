# DATA6222 – SQL Server Database Project

A two-part SQL Server 2012 project covering **views, stored procedures, reporting queries, table design, constraints and referential integrity**.

- **Part 1:** Event booking management for conference venues
- **Part 2:** Equipment and warehouse stock management

Completed as part of my Diploma in IT (Software Development) at IIE Rosebank College.

---

## Tech Stack

- Microsoft SQL Server 2012 (T-SQL)
- SQL Server Management Studio (SSMS)

---

## Part 1 – Venue Booking System

**Database:** `StudentNumber_DATA6222_ExamQ1` (built from the provided `DATA6222E1Preload.sql` script)

### Entity Relationship Overview

```
CLIENT (1) ────< BOOKING >──── (1) VENUE
```

| Table   | Key columns |
|---------|-------------|
| CLIENT  | `ClientID` (PK), `ClientFullName`, `ClientContact` |
| VENUE   | `VenueID` (PK), `VenueName`, `VenueAddress` |
| BOOKING | `BookingID` (PK), `ClientID` (FK), `VenueID` (FK), `EventStartDate`, `EventEndDate`, `NumberOfAttendees` |

### Tasks Implemented

| # | Task | Concepts |
|---|------|----------|
| 1.1 | `LargeBOOKINGs` view – 2026 bookings with 100+ attendees | Views, `YEAR()`, filtering |
| 1.2 | `FindBOOKINGs` stored procedure – bookings for a given VenueID | Stored procedures, parameters, `INNER JOIN` |
| 1.3 | Booking status per venue (`Bookings exist` / `No bookings exist`) | `CASE`, `EXISTS` |
| 1.4 | Total attendees per venue, highest first | `LEFT JOIN`, `SUM`, `GROUP BY`, `ORDER BY ... DESC` |
| 1.5 | Venues with no bookings | `LEFT JOIN ... IS NULL` |

### Example

```sql
CREATE PROCEDURE FindBOOKINGs
    @VenueID VARCHAR(5)
AS
BEGIN
    SELECT c.ClientFullName, c.ClientContact,
           b.EventStartDate, b.EventEndDate, b.NumberOfAttendees
    FROM BOOKING b
    INNER JOIN CLIENT c ON b.ClientID = c.ClientID
    INNER JOIN VENUE  v ON b.VenueID  = v.VenueID
    WHERE b.VenueID = @VenueID;
END
GO

EXEC FindBOOKINGs 'V0002';
```

---

## Part 2 – Equipment & Warehouse Management

**Database:** `StudentNumber_DATA6222_ExamQ2` (created entirely by script)

### Tables

| Table        | Description | Keys |
|--------------|-------------|------|
| EQUIPMENT    | Equipment catalogue | PK: `EQUIPMENT_ID` |
| WAREHOUSE    | Warehouse locations | PK: `WAREHOUSE_ID` |
| AVAILABILITY | Stock per equipment per warehouse | Composite PK (`EQUIPMENT_ID`, `WAREHOUSE_ID`), FKs to EQUIPMENT and WAREHOUSE |

### Tasks Implemented

| # | Task | Concepts |
|---|------|----------|
| 2.1 | Create database and tables | `CREATE TABLE`, PK/FK constraints, data types |
| 2.2 | Populate all tables | `INSERT` |
| 2.3 | Add `STOCK_ORDERED` column | `ALTER TABLE` |
| 2.4 | Update stock ordered for E004 at W003 | `UPDATE ... WHERE` |
| 2.5 | Equipment not stocked in any warehouse | `LEFT JOIN ... IS NULL` |
| 2.6 | Total stock per equipment, alphabetical | `SUM`, `GROUP BY`, `ORDER BY` |
| 2.7 | Warehouse holding the most of E002 | `TOP 1`, multi-table `JOIN` |

---

## How to Run

1. Open **SQL Server Management Studio** and connect to your SQL Server instance.
2. **Part 1:** create the database `StudentNumber_DATA6222_ExamQ1`, then run the preload script (`DATA6222E1Preload.sql`) to create and populate the tables.
3. Run `Question1.sql` to create the view and stored procedure and execute the queries.
4. **Part 2:** run `Question2.sql`. It creates the database, tables and data, then runs all queries.

> Replace `StudentNumber` in the database names with your own student number.

---

## Suggested Repository Structure

```
├── README.md
├── Question1.sql
├── Question2.sql
└── screenshots/
    ├── q1_results.png
    └── q2_results.png
```

---

## What I Learned

- Designing views and stored procedures in T-SQL
- Choosing the right join type (`INNER` vs `LEFT`) to handle missing related records
- Using aggregate functions with `GROUP BY` and handling `NULL` results
- Enforcing referential integrity with primary, composite and foreign keys
- Altering and updating existing tables safely

---

## Author

**MJ (Mihle Jantjies)**
Software Development student, IIE Rosebank College
[GitHub](https://github.com/your-username) · [Portfolio](https://your-portfolio-link)
