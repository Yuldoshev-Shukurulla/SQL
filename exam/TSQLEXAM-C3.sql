
------------------------1------------------------
/*
Scenario: HR wants attendance streaks.
Each row is one day an employee showed up. Find, per employee,
the length of their LONGEST run of CONSECUTIVE days present.
(Classic gaps-and-islands.)
*/
DROP TABLE IF EXISTS Attendance;
GO
CREATE TABLE Attendance
(
    EmpID    INT NOT NULL,
    WorkDate DATE NOT NULL
);
GO
INSERT INTO Attendance (EmpID, WorkDate) VALUES
(1,'2024-03-01'),(1,'2024-03-02'),(1,'2024-03-03'),
(1,'2024-03-06'),(1,'2024-03-07'),
(2,'2024-03-01'),(2,'2024-03-02');
GO
WITH Sequenced AS(
    SELECT
        EmpID,
        WorkDate,
        DATEADD(day, - ROW_NUMBER() OVER(PARTITION BY EmpID ORDER BY WorkDate), WorkDate) AS sgroup
    FROM Attendance),
Grouped AS(
    SELECT 
        EmpID,
        COUNT(sgroup) AS StrLength
    FROM Sequenced
    GROUP BY EmpID, sgroup)
SELECT
    EmpID,
    MAX(StrLength) AS LongestStreakDays
FROM Grouped
GROUP BY EmpID
ORDER BY EmpID;

/*
Expected Output:
-----------------------------
| EmpID | LongestStreakDays |
-----------------------------
|   1   |         3         |
|   2   |         2         |
-----------------------------
*/


------------------------2------------------------
/*
Scenario: a simple bank ledger.
For every transaction, show the ACCOUNT BALANCE after that
transaction (a running total per account, ordered by TxnID).
*/

DROP TABLE IF EXISTS Txns;
GO
CREATE TABLE Txns
(
    TxnID   INT PRIMARY KEY,
    Account VARCHAR(10) NOT NULL,
    Amount  INT NOT NULL          -- deposits +, withdrawals -
);
GO
INSERT INTO Txns (TxnID, Account, Amount) VALUES
(1,'A',100),(2,'A',-30),(3,'A',50),
(4,'B',200),(5,'B',-250);
GO
SELECT  
    TxnID,
    Account,
    Amount,
    SUM(Amount) OVER(PARTITION BY Account ORDER BY TxnID) AS RunningBalance
FROM Txns;
/*
Expected Output:
--------------------------------------------
| TxnID | Account | Amount | RunningBalance |
--------------------------------------------
|   1   |    A    |   100  |       100      |
|   2   |    A    |   -30  |        70      |
|   3   |    A    |    50  |       120      |
|   4   |    B    |   200  |       200      |
|   5   |    B    |  -250  |       -50      |
--------------------------------------------
*/

------------------------3------------------------
/*
Scenario: overdraft detection (uses the SAME Txns table as puzzle 2).
Return the ACCOUNTS whose running balance ever dropped below zero
at any point in their transaction history.
*/
WITH temp AS(
    SELECT  
        TxnID,
        Account,
        Amount,
        SUM(Amount) OVER(PARTITION BY Account ORDER BY TxnID) AS RunningBalance
    FROM Txns
)
SELECT DISTINCT
    Account
FROM temp
WHERE RunningBalance < 0
ORDER BY Account;
/*
Expected Output:
-----------
| Account |
-----------
|    B    |
-----------
*/

------------------------4------------------------
/*
Scenario: product catalogue.
For each category, return the employee/product on the SECOND-HIGHEST
DISTINCT price. If several products tie on that price, return them all.
*/

DROP TABLE IF EXISTS Products;
GO
CREATE TABLE Products
(
    Category VARCHAR(50) NOT NULL,
    Name     VARCHAR(50) NOT NULL,
    Price    INT NOT NULL
);
GO
INSERT INTO Products (Category, Name, Price) VALUES
('Phone','Galaxy',900),('Phone','Pixel',800),('Phone','Nord',800),
('Laptop','ProBook',1500),('Laptop','IdeaPad',1200);
GO

WITH CTE AS(
    SELECT 
        Category,
        Name,
        Price,
        DENSE_RANK() OVER(PARTITION BY Category ORDER BY Price DESC) DNSRNK
    FROM Products)
SELECT
    Category,
    Name,
    Price
FROM CTE
WHERE DNSRNK = 2
ORDER BY Category;

/*
Expected Output:
-----------------------------------
| Category |  Name   | Price |
-----------------------------------
| Laptop   | IdeaPad | 1200  |
| Phone    | Pixel   |  800  |
| Phone    | Nord    |  800  |
-----------------------------------
*/


------------------------5------------------------
/*
Scenario: monthly revenue per product.
For each product and month, show the amount, the month-over-month
CHANGE, and the % change vs the previous month (1 decimal, NULL for
the first month).
*/

DROP TABLE IF EXISTS MonthlySales;
GO
CREATE TABLE MonthlySales
(
    Product   VARCHAR(20) NOT NULL,
    MonthNo   INT NOT NULL,
    Revenue   INT NOT NULL
);
GO
INSERT INTO MonthlySales (Product, MonthNo, Revenue) VALUES
('A',1,100),('A',2,150),('A',3,120),
('B',1,200),('B',2,260);
GO
WITH CTE AS(
    SELECT 
        Product,
        MonthNo,
        Revenue,
        Revenue - LAG(Revenue) OVER(PARTITION BY Product ORDER BY MonthNo) AS MoM,
        LAG(Revenue) OVER(PARTITION BY Product ORDER BY MonthNo) AS PrevMRevenue
    FROM MonthlySales)
SELECT
    Product,
    MonthNo,
    Revenue,
    MoM,
    ROUND((MoM * 100) / PrevMRevenue, 2) AS PctChange
FROM CTE
ORDER BY Product, MonthNo;
/*
Expected Output:
------------------------------------------------
| Product | MonthNo | Revenue | MoM  | PctChange|
------------------------------------------------
|    A    |    1    |   100   | NULL |   NULL   |
|    A    |    2    |   150   |  50  |   50.0   |
|    A    |    3    |   120   | -30  |  -20.0   |
|    B    |    1    |   200   | NULL |   NULL   |
|    B    |    2    |   260   |  60  |   30.0   |
------------------------------------------------
*/


------------------------6------------------------
/*
Scenario: "power buyers".
Return the customers who have bought EVERY product in the catalogue
(relational division). Do not hard-code the number of products.
*/

DROP TABLE IF EXISTS Catalogue;
DROP TABLE IF EXISTS Purchases;
GO
CREATE TABLE Catalogue (ProductID INT PRIMARY KEY);
GO
INSERT INTO Catalogue VALUES (1),(2),(3);
GO
CREATE TABLE Purchases (Customer VARCHAR(10), ProductID INT);
GO
INSERT INTO Purchases VALUES
('X',1),('X',2),('X',3),
('Y',1),('Y',2),
('Z',1),('Z',2),('Z',3);
GO


SELECT
    Customer
FROM Purchases
GROUP BY Customer
HAVING COUNT(DISTINCT ProductID) = (SELECT COUNT(ProductID) FROM Catalogue)
ORDER BY Customer;

/*
Expected Output:
------------
| Customer |
------------
|    X     |
|    Z     |
------------
*/


------------------------7------------------------
/*
Scenario: server health alarms.
A monitor logs a status every minute. Raise an alarm for each run of
3 OR MORE consecutive 'FAIL' rows. Return where each such run starts
and how long it is.
*/

DROP TABLE IF EXISTS HealthLog;
GO
CREATE TABLE HealthLog
(
    LogID  INT PRIMARY KEY,
    Status VARCHAR(10) NOT NULL
);
GO
INSERT INTO HealthLog (LogID, Status) VALUES
(1,'OK'),(2,'FAIL'),(3,'FAIL'),(4,'FAIL'),
(5,'OK'),(6,'FAIL'),(7,'FAIL');
GO

WITH Sequences AS (
    SELECT
        LogID,
        Status,
        LogID - ROW_NUMBER() OVER(PARTITION BY Status ORDER BY LogID) AS GroupID
    FROM HealthLog
),
Fails AS(
    SELECT
        MIN(LogID) AS StartLogID,
        COUNT(*) ConsecutiveFails
    FROM Sequences
    WHERE Status = 'Fail'
    GROUP BY GroupID
)
SELECT
    StartLogID,
    ConsecutiveFails
FROM Fails
WHERE ConsecutiveFails >= 3
ORDER BY StartLogID;

/*
Expected Output:
--------------------------------
| StartLogID | ConsecutiveFails |
--------------------------------
|     2      |        3         |
--------------------------------
(The run 6-7 is only 2 long, so it is NOT alarmed.)
*/


------------------------8------------------------
/*
Scenario: top earners.
Return the TOP 2 highest-paid employees in EACH department,
ordered by department, then salary descending.
*/

DROP TABLE IF EXISTS Employees;
GO
CREATE TABLE Employees
(
    Dept   VARCHAR(20) NOT NULL,
    Name   VARCHAR(20) NOT NULL,
    Salary INT NOT NULL
);
GO
INSERT INTO Employees (Dept, Name, Salary) VALUES
('IT','Ann',90),('IT','Ben',80),('IT','Cara',60),
('HR','Dan',70),('HR','Eve',50);
GO

WITH CTE AS(
    SELECT
        Dept,
        Name,
        Salary,
        ROW_NUMBER() OVER(PARTITION BY Dept ORDER BY Salary DESC) AS rnk
    FROM Employees
)
SELECT
    Dept,
    Name,
    Salary
FROM CTE
WHERE rnk <= 2
ORDER BY Dept, Salary DESC;


/*
Expected Output:
----------------------------
| Dept | Name | Salary |
----------------------------
| HR   | Dan  |   70   |
| HR   | Eve  |   50   |
| IT   | Ann  |   90   |
| IT   | Ben  |   80   |
----------------------------
*/


------------------------9------------------------
/*
Scenario: order status report, pivoted.
Produce ONE row per month with a column per status holding the
count of orders. Use conditional aggregation (SUM + CASE).
*/

DROP TABLE IF EXISTS Orders;
GO
CREATE TABLE Orders
(
    OrderID INT PRIMARY KEY,
    MonthNm VARCHAR(3) NOT NULL,
    Status  VARCHAR(10) NOT NULL
);
GO
INSERT INTO Orders (OrderID, MonthNm, Status) VALUES
(1,'Jan','Done'),(2,'Jan','Pending'),
(3,'Feb','Done'),(4,'Feb','Done'),(5,'Jan','Done');
GO
SELECT 
    MonthNm,
    SUM(CASE WHEN Status = 'Done' THEN 1 ELSE 0 END) AS Done,
    SUM(CASE WHEN Status = 'Pending' THEN 1 ELSE 0 END) AS Pending
FROM Orders
GROUP BY  MonthNm;


/*
Expected Output:
--------------------------
| MonthNm | Done | Pending |
--------------------------
|  Feb    |  2   |    0    |
|  Jan    |  2   |    1    |
--------------------------
*/


------------------------10------------------------
/*
Scenario: pay-equity check.
Return the MEDIAN salary per department. (Even count -> average of
the two middle values.)
*/

DROP TABLE IF EXISTS DeptPay;
GO
CREATE TABLE DeptPay
(
    Dept   VARCHAR(20) NOT NULL,
    Salary INT NOT NULL
);
GO
INSERT INTO DeptPay (Dept, Salary) VALUES
('IT',50),('IT',60),('IT',70),('IT',80),
('HR',30),('HR',90);
GO

SELECT DISTINCT
    Dept,
    CAST(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Salary) OVER(PARTITION BY Dept) AS DECIMAL(10, 1)) AS MedianSalary
FROM DeptPay
GROUP BY Dept
ORDER BY Dept;
/*
Expected Output:
-------------------------
| Dept | MedianSalary |
-------------------------
| HR   |     60.0     |
| IT   |     65.0     |
-------------------------
*/


------------------------11------------------------
/*
Scenario: de-duplication before a merge.
Email must be unique, but bad imports created duplicates. Return the
IDs that should be DELETED so that only the row with the LOWEST ID
survives for each email.
*/

DROP TABLE IF EXISTS Customers;
GO
CREATE TABLE Customers
(
    ID    INT PRIMARY KEY,
    Email VARCHAR(50) NOT NULL
);
GO
INSERT INTO Customers (ID, Email) VALUES
(1,'a@x.com'),(2,'b@x.com'),(3,'a@x.com'),
(4,'c@x.com'),(5,'b@x.com');
GO

/*
Expected Output:
-----------------
| IDToDelete |
-----------------
|     3      |
|     5      |
-----------------
*/


------------------------12------------------------
/*
Scenario: web-session landing & exit pages.
For each user, return their FIRST page (landing) and LAST page (exit),
ordered by the event timestamp.
*/

DROP TABLE IF EXISTS Events;
GO
CREATE TABLE Events
(
    UserID VARCHAR(10) NOT NULL,
    Ts     INT NOT NULL,
    Page   VARCHAR(20) NOT NULL
);
GO
INSERT INTO Events (UserID, Ts, Page) VALUES
('U',1,'home'),('U',2,'cart'),('U',3,'buy'),
('V',5,'home'),('V',6,'exit');
GO

/*
Expected Output:
---------------------------------
| UserID | Landing | ExitPage |
---------------------------------
|   U    |  home   |   buy    |
|   V    |  home   |   exit   |
---------------------------------
*/


------------------------13------------------------
/*
Scenario: org chart.
Print every employee with their LEVEL (CEO = 1) and their full
reporting PATH from the top, using a recursive CTE.
*/

DROP TABLE IF EXISTS Org;
GO
CREATE TABLE Org
(
    EmpID   INT PRIMARY KEY,
    MgrID   INT NULL,
    Name    VARCHAR(20) NOT NULL
);
GO
INSERT INTO Org (EmpID, MgrID, Name) VALUES
(1,NULL,'CEO'),(2,1,'CTO'),(3,2,'Dev'),(4,1,'CFO');
GO

/*
Expected Output:
-------------------------------------------
| Name |  Lvl | Path                 |
-------------------------------------------
| CEO  |  1   | CEO                  |
| CFO  |  2   | CEO > CFO            |
| CTO  |  2   | CEO > CTO            |
| Dev  |  3   | CEO > CTO > Dev      |
-------------------------------------------
*/


------------------------14------------------------
/*
Scenario: double-booked meeting rooms.
Two bookings clash if they are in the same room and their time
intervals OVERLAP. Return each clashing PAIR once.
(Intervals are [Start, End); touching ends do NOT overlap.)
*/

DROP TABLE IF EXISTS Bookings;
GO
CREATE TABLE Bookings
(
    BookingID INT PRIMARY KEY,
    Room      VARCHAR(10) NOT NULL,
    StartH    INT NOT NULL,
    EndH      INT NOT NULL
);
GO
INSERT INTO Bookings (BookingID, Room, StartH, EndH) VALUES
(1,'R1',10,12),(2,'R1',11,13),(3,'R1',14,15),(4,'R2',9,10);
GO

/*
Expected Output:
--------------------------------------
| Room | Booking_A | Booking_B |
--------------------------------------
| R1   |     1     |     2     |
--------------------------------------
*/


------------------------15------------------------
/*
Scenario: customer acquisition (cohorts).
A customer is "new" in the first month they ever ordered. Count how
many NEW customers were acquired in each month.
*/

DROP TABLE IF EXISTS CustomerOrders;
GO
CREATE TABLE CustomerOrders
(
    Customer VARCHAR(10) NOT NULL,
    MonthNo  INT NOT NULL
);
GO
INSERT INTO CustomerOrders (Customer, MonthNo) VALUES
('A',1),('B',1),('A',2),('C',2),('A',3),('C',3);
GO

/*
Expected Output:
------------------------
| MonthNo | NewCustomers |
------------------------
|    1    |      2       |
|    2    |      1       |
------------------------
(Month 3 acquired no first-time customers.)
*/


------------------------ END ------------------------
