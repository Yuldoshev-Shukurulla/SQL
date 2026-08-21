-- Puzzle 1: The Shifting Employees
-- A company has a rotational transfer policy where employees switch departments every 6 months. You have an Employees table:

-- Table: Employees

-- | EmployeeID | Name    | Department | Salary |
-- |------------|---------|------------|--------|
-- | 1          | Alice   | HR         | 5000   |
-- | 2          | Bob     | IT         | 7000   |
-- | 3          | Charlie | Sales      | 6000   |
-- | 4          | David   | HR         | 5500   |
-- | 5          | Emma    | IT         | 7200   |
-- Task:
-- 1. Create a temporary table #EmployeeTransfers with the same structure as Employees. 
-- 2. Swap departments for each employee in a circular manner:
-- HR → IT → Sales → HR
-- Example: Alice (HR) moves to IT, Bob (IT) moves to Sales, Charlie (Sales) moves to HR.
-- 3. Insert the updated records into #EmployeeTransfers. 
-- 4. Retrieve all records from #EmployeeTransfers.

CREATE TABLE Employees
(
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    Department VARCHAR(50),
    Salary INT
);
GO

INSERT INTO Employees
VALUES  (1, 'Alice', 'HR', 5000),
        (2, 'Bob', 'IT', 7000),
        (3, 'Charlie', 'Sales', 6000),
        (4, 'David', 'HR', 5500),
        (5, 'Emma', 'IT', 7200);

DROP TABLE IF EXISTS #EmployeeTransfers;
CREATE TABLE #EmployeeTransfers
(
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    Department VARCHAR(50),
    Salary INT
);

INSERT INTO #EmployeeTransfers (EmployeeID, Name, Department, Salary)
SELECT
    EmployeeID,
    Name,
    CASE Department
        WHEN 'HR' THEN 'IT'
        WHEN 'IT' THEN 'Sales'
        WHEN 'Sales' THEN 'HR'
        ELSE Department 
    END AS Department,
    Salary
FROM Employees;

SELECT * FROM #EmployeeTransfers ORDER BY EmployeeID;

-- ---

-- Puzzle 2: The Missing Orders
-- An e-commerce company tracks orders in two separate systems, but some orders are missing in one of them. 
-- You need to find the missing records.

-- Given Tables:
-- Table 1: Orders_DB1 (Main System)
-- | OrderID | CustomerName | Product | Quantity |
-- |---------|--------------|---------|----------|
-- | 101     | Alice        | Laptop  | 1        |
-- | 102     | Bob          | Phone   | 2        |
-- | 103     | Charlie      | Tablet  | 1        |
-- | 104     | David        | Monitor | 1        |
-- Table 2: Orders_DB2 (Backup System, with some missing records)
-- | OrderID | CustomerName | Product | Quantity |
-- |---------|--------------|---------|----------|
-- | 101     | Alice        | Laptop  | 1        |
-- | 103     | Charlie      | Tablet  | 1        |
-- Task:
-- 1. Declare a table variable @MissingOrders with the same structure as Orders_DB1. 2. Insert all orders that exist in Orders_DB1 
-- but not in Orders_DB2 into @MissingOrders. 3. Retrieve the missing orders.

CREATE TABLE Orders_DB1
(
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Product VARCHAR(50),
    Quantity INT
);

CREATE TABLE Orders_DB2
(
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Product VARCHAR(50),
    Quantity INT
);
INSERT INTO Orders_DB1
VALUES
(101, 'Alice', 'Laptop', 1),
(102, 'Bob', 'Phone', 2),
(103, 'Charlie', 'Tablet', 1),
(104, 'David', 'Monitor', 1);

INSERT INTO Orders_DB2
VALUES
(101, 'Alice', 'Laptop', 1),
(103, 'Charlie', 'Tablet', 1);

DECLARE @MissingOrders TABLE(
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Product VARCHAR(50),
    Quantity INT
);
INSERT INTO @MissingOrders (OrderID, CustomerName, Product, Quantity)
SELECT db1.* FROM Orders_DB1 db1
LEFT JOIN Orders_DB2 db2
ON db1.OrderID=db2.OrderID
WHERE db2.OrderID IS NULL;
SELECT * FROM @MissingOrders

-- ---

-- Puzzle 3: The Unbreakable View
-- You are given a database that tracks employee working hours. The company needs a monthly summary report that calculates:

-- Total hours worked per employee
-- Total hours worked per department
-- Average hours worked per department
-- Given Table: WorkLog
-- | EmployeeID | EmployeeName | Department | WorkDate   | HoursWorked |
-- |------------|--------------|------------|------------|-------------|
-- | 1          | Alice        | HR         | 2024-03-01 | 8           |
-- | 2          | Bob          | IT         | 2024-03-01 | 9           |
-- | 3          | Charlie      | Sales      | 2024-03-02 | 7           |
-- | 1          | Alice        | HR         | 2024-03-03 | 6           |
-- | 2          | Bob          | IT         | 2024-03-03 | 8           |
-- | 3          | Charlie      | Sales      | 2024-03-04 | 9           |
-- Task:
-- 1. Create a view vw_MonthlyWorkSummary that calculates:

-- EmployeeID, EmployeeName, Department, TotalHoursWorked (SUM of hours per employee).
-- Department, TotalHoursDepartment (SUM of all hours per department).
-- Department, AvgHoursDepartment (AVG hours worked per department).
-- 2. Retrieve all records from vw_MonthlyWorkSummary.

CREATE TABLE WorkLog (
    EmployeeID INT,
    EmployeeName VARCHAR(50),
    Department VARCHAR(50),
    WorkDate DATE,
    HoursWorked INT
);

INSERT INTO WorkLog (EmployeeID, EmployeeName, Department, WorkDate, HoursWorked) VALUES
(1, 'Alice',   'HR',    '2024-03-01', 8),
(2, 'Bob',     'IT',    '2024-03-01', 9),
(3, 'Charlie', 'Sales', '2024-03-02', 7),
(1, 'Alice',   'HR',    '2024-03-03', 6),
(2, 'Bob',     'IT',    '2024-03-03', 8),
(3, 'Charlie', 'Sales', '2024-03-04', 9);
GO

SELECT * FROM WorkLog;
GO

CREATE VIEW vw_MonthlyWorkSummary AS
SELECT
    EmployeeID,
    EmployeeName,
    Department,
    TotalHoursWorked,
    SUM(TotalHoursWorked) OVER (PARTITION BY Department) AS TotalHoursDepartment,
    AVG(TotalHoursWorked) OVER (PARTITION BY Department) AS AvgHoursDepartment
FROM (
    SELECT 
        EmployeeID,
        EmployeeName,
        Department,
        SUM(HoursWorked) AS TotalHoursWorked
    FROM WorkLog
    GROUP BY EmployeeID, EmployeeName, Department
) AS T;
GO

SELECT * FROM vw_MonthlyWorkSummary
ORDER BY Department, EmployeeID;