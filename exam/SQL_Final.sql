-- ------------------------1------------------------

-- Write an SQL Statement to de-group the following data.

-- ---------------------
-- |Product	|Quantity|
-- ---------------------
-- |Pencil		|	3	|
-- |Eraser		|	4	|
-- |Notebook	|	2	|
-- ---------------------



-- Expected Output:

-- ---------------------
-- |Product	|Quantity|
-- ---------------------
-- |Pencil		|	1	|
-- |Pencil		|	1	|
-- |Pencil		|	1	|
-- |Eraser		|	1	|
-- |Eraser		|	1	|
-- |Eraser		|	1	|
-- |Eraser		|	1	|
-- |Notebook	|	1	|
-- |Notebook	|	1	|
-- ---------------------

-- DROP TABLE IF EXISTS Grouped;
-- GO

-- CREATE TABLE Grouped
-- (
-- Product  VARCHAR(100) PRIMARY KEY,
-- Quantity            INTEGER NOT NULL
-- );
-- GO

-- INSERT INTO Grouped (Product, Quantity) VALUES
-- ('Pencil',3),('Eraser',4),('Notebook',2);
-- GO

-- ------------------------2------------------------

-- From following set of integers, write an SQL statement to determine the expected outputs


CREATE TABLE Seats 
( 
SeatNumber INTEGER 
); 
GO 
INSERT INTO Seats VALUES 
(7),(13),(14),(15),(27),(28),(29),(30), 
(31),(32),(33),(34),(35),(52),(53),(54); 
GO

WITH Temp AS (
    select 
        g.value, 
        IIF(s.SeatNumber IS NULL, 0, SeatNumber) AS Seat,
        g.value-row_number() over(Partition BY IIF(s.SeatNumber IS NULL, 0, 1) ORDER BY g.value) RNK
    from generate_series(1, 54, 1) g
    LEFT join (select * from seats) s
    ON s.SeatNumber = g.value
    WHERE s.SeatNumber IS NULL)
Select 
    MIN(value) AS Gap_Start,
    MAX(value) AS Gap_End
from Temp
GROUP BY RNK;
select COUNT(g.value) AS TotalMissingNumbers from generate_series(1, 54, 1) g
LEFT join (select * from seats) s
ON s.SeatNumber = g.value
WHere s.SeatNumber IS NULL;
SELECT Type, Count(*) AS Count
from(select CASE
        WHEN g.value%2=0 THEN 'EvenNumber' 
        ELSE 'OddNumber' END AS Type
    from generate_series(1, 54, 1) g
    LEFT join (select * from seats) s
    ON s.SeatNumber = g.value
    Where s.SeatNumber IS NOT NULL) AS Tt
GROUP BY Type

-- Output 1:
-- ---------------------
-- |Gap Start	|Gap End|
-- ---------------------
-- |     1     |	4	|
-- |     8     |	12	|
-- |     16    |	26	|
-- |     36    |	51	|
-- ---------------------


-- Output 2:
-- -----------------------
-- |Total Missing Numbers|
-- -----------------------
-- |		  38		  |
-- -----------------------


-- Output 3:
-- ---------------------
-- |Type		 |Count	|
-- ---------------------
-- |Odd Numbers |	8	|
-- |Even Numbers|	9	|
-- ---------------------



-- ------------------------3------------------------

-- You work for a gaming company and need to rank players by their score into two categories. 
-- Players that rank in the top half must be given a value of 1, and the remaining players must be given a 
-- value of 2. 
-- Write an SQL statement that meets these requirements. 

CREATE TABLE PlayerScores 
( 
PlayerID VARCHAR(MAX), 
Score    
INTEGER 
); 
GO 
INSERT INTO PlayerScores VALUES 
(1001,2343),(2002,9432), 
(3003,6548),(4004,1054), 
(5005,6832); 
GO 

select 
    *,
    CASE
        WHEN Score > (SELECT AVG(Score) FROM PlayerScores) THEN 1
    ELSE 0 END AS RNK
from PlayerScores


-- ------------------------4------------------------

-- Write an SQL statement that returns the vendor from which each customer has placed the most orders

-- -----------------------------------------------------------------
-- |Order ID	|	Customer ID	|	 Order Count	|	Vendor		|
-- -----------------------------------------------------------------
-- |Ord195342	|	   1001		|		  12		|	Direct Parts|
-- |Ord245532	|	   1001		|		  54		|	Direct Parts|
-- |Ord344394	|	   1001		|		  32		|	   ACME		|
-- |Ord442423	|	   2002		|		  7			|	   ACME		|
-- |Ord524232	|	   2002		|		  16		|	   ACME		|
-- |Ord645363	|	   2002		|		  5			|	Direct Parts|
-- -----------------------------------------------------------------


-- Here is the expected output

-- ------------------------------
-- |Customer ID	|Vendor		 |
-- ------------------------------
-- |     1001      |Direct Parts|
-- |     2002      |	 ACME	 |
-- ------------------------------

DROP TABLE IF EXISTS Orders;
GO

CREATE TABLE Orders
(
OrderID     INTEGER PRIMARY KEY,
CustomerID  INTEGER NOT NULL,
[Count]     MONEY NOT NULL,
Vendor      VARCHAR(100) NOT NULL
);
GO

INSERT INTO Orders (OrderID, CustomerID, [Count], Vendor) VALUES
(1,1001,12,'Direct Parts'),
(2,1001,54,'Direct Parts'),
(3,1001,32,'ACME'),
(4,2002,7,'ACME'),
(5,2002,16,'ACME'),
(6,2002,5,'Direct Parts');
GO
SELECT CustomerID, Vendor
FROM (
    SELECT CustomerID, Vendor, SUM([Count]) AS TotalOrderCount,
        DENSE_RANK() OVER (PARTITION BY CustomerID ORDER BY SUM([Count]) DESC) AS VendorRank
    FROM Orders
    GROUP BY CustomerID, Vendor
) AS T
WHERE VendorRank = 1

-- ------------------------5------------------------

-- Write an SQL statement that deletes the duplicate data.

CREATE TABLE SampleData 
( 
IntegerValue INTEGER 
); 
GO 
INSERT INTO SampleData VALUES 
(1),(1),(2),(3),(3),(4); 
GO 

WITH CTE AS(select 
    IntegerValue,
    ROW_NUMBER() OVER(PARTITION BY IntegerValue ORDER BY IntegerValue) AS RNK
from SampleData)
DELETE FROM CTE
WHERE RNK > 1

-- ------------------------6------------------------

-- Write an SQL statement to fill in the missing gaps.
-- -----------------------------------------
-- |Row Number	|	Workflow	|	Status	|
-- -----------------------------------------
-- |	  1		|	  Alpha		|	 Pass	|
-- |	  2		|				|	 Fail	|
-- |	  3		|				|	 Fail	|
-- |	  4		|				|	 Fail	|
-- |	  5		|	  Bravo		|	 Pass	|
-- |	  6		|				|	 Fail	|
-- |	  7		|				|	 Fail	|
-- |	  8		|				|	 Pass	|
-- |	  9		|				|	 Pass	|
-- |	  10	|	 Charlie	|	 Fail	|
-- |	  11	|				|	 Fail	|
-- |	  12	|				|	 Fail	|
-- -----------------------------------------


-- Here is the expected output.
-- -----------------------------------------
-- |Row Number	|	Workflow	|	Status	|
-- -----------------------------------------
-- |	  1		|	  Alpha		|	 Pass	|
-- |	  2		|	  Alpha		|	 Fail	|
-- |	  3		|	  Alpha		|	 Fail	|
-- |	  4		|	  Alpha		|	 Fail	|
-- |	  5		|	  Bravo		|	 Pass	|
-- |	  6		|	  Bravo		|	 Fail	|
-- |	  7		|	  Bravo		|	 Fail	|
-- |	  8		|	  Bravo		|	 Pass	|
-- |	  9		|	  Bravo		|	 Pass	|
-- |	  10	|	 Charlie	|	 Fail	|
-- |	  11	|	 Charlie	|	 Fail	|
-- |	  12	|	 Charlie	|	 Fail	|
-- -----------------------------------------

DROP TABLE IF EXISTS Gaps;
GO

CREATE TABLE Gaps
(
RowNumber   INTEGER PRIMARY KEY,
TestCase    VARCHAR(100) NULL
);
GO

INSERT INTO Gaps (RowNumber, TestCase) VALUES
(1,'Alpha'),(2,NULL),(3,NULL),(4,NULL),
(5,'Bravo'),(6,NULL),(7,'Charlie'),(8,NULL),(9,NULL);
GO

WITH GroupedWorkflows AS (
    SELECT 
        RowNumber,
        TestCase,
        COUNT(TestCase) OVER(ORDER BY RowNumber) AS GroupID
    FROM Gaps
)
SELECT 
    RowNumber,
    MAX(TestCase) OVER (PARTITION BY GroupID) AS Workflow
FROM GroupedWorkflows
ORDER BY RowNumber;
-- ------------------------7------------------------

-- You must provide a report of all distributors and their sales by region.  If a distributor did not have any 
-- sales for a region, provide a zero-dollar value for that day.  Assume there is at least one sale for each 
-- region

DROP TABLE IF EXISTS #RegionSales;
GO

CREATE TABLE #RegionSales
(
Region       VARCHAR(100),
Distributor  VARCHAR(100),
Sales        INTEGER NOT NULL,
PRIMARY KEY (Region, Distributor)
);
GO

INSERT INTO #RegionSales (Region, Distributor, Sales) VALUES
('North','ACE',10),
('South','ACE',67),
('East','ACE',54),
('North','ACME',65),
('South','ACME',9),
('East','ACME',1),
('West','ACME',7),
('North','Direct Parts',8),
('South','Direct Parts',7),
('West','Direct Parts',12);
GO

select * from #RegionSales

-- ---------------------------------------
-- |Region       |Distributor    | Sales |
-- ---------------------------------------
-- |North        |ACE            |   10  |
-- |South        |ACE            |   67  |
-- |East         |ACE            |   54  |
-- |North        |Direct Parts   |   8	  |
-- |South        |Direct Parts   |   7	  |
-- |West         |Direct Parts   |   12  |
-- |North        |ACME           |   65  |
-- |South        |ACME           |   9	  |
-- |East         |ACME           |   1	  |
-- |West         |ACME           |   7	  |
-- ----------------------------------------



-- Here is the Expected output.
-- ---------------------------------------
-- |Region       |Distributor    | Sales |
-- ---------------------------------------
-- |North        |ACE            |   10  |
-- |South        |ACE            |   67  |
-- |East         |ACE            |   54  |
-- |West		 |ACE			  |   0   |
-- |North        |Direct Parts   |   8	  |
-- |South        |Direct Parts   |   7	  |
-- |East		 |Direct Parts   |   0   |
-- |West         |Direct Parts   |   12  |
-- |North        |ACME           |   65  |
-- |South        |ACME           |   9	  |
-- |East         |ACME           |   1	  |
-- |West         |ACME           |   7	  |
-- ----------------------------------------

WITH Regions AS
(
    SELECT DISTINCT Region FROM #RegionSales
),
Distributors AS
(
    SELECT DISTINCT Distributor FROM #RegionSales
),
Crossed AS
(
    SELECT
        r.Region,
        d.Distributor
    FROM Regions AS r
    CROSS JOIN Distributors AS d
)
SELECT 
    c.Region,
    c.Distributor,
    ISNULL(t.Sales, 0) AS Sales
FROM Crossed AS c
LEFT JOIN #RegionSales AS t
ON c.Region = t.Region 
AND c.Distributor = t.Distributor

-- ------------------------8------------------------

-- Write an SQL statement to determine which of the below numbers are prime numbers.(output should have 2 columns, 
-- Number and IsPrime column that indicated if the number is prime or not)


-- CREATE TABLE Primes 
-- ( 
-- IntegerValue INTEGER 
-- ); 
-- GO 
-- INSERT INTO Primes VALUES 
-- (1),(2),(3),(4),(5),(6),(7),(8),
--  (9),(10); 
-- GO;



-- ------------------------9------------------------

-- Given a table of employee shifts, and another table of their activities, write an SQL script that produces 
-- the desired output


-- Schedule
-- ------------------------------------------------------
-- |Schedule ID  |		Start TIme    |		End Time	 |
-- ------------------------------------------------------
-- |	   A	  |	10/1/2021 10:00	  |	 10/1/2021 15:00 |
-- |	   B	  | 10/1/2021 10:15   |  10/1/2021 12:15 |
-- ------------------------------------------------------


-- Activity 
-- ------------------------------------------------------------------
-- |Schedule ID  |	 Activity	|	Start TIme    |		End Time	 |
-- ------------------------------------------------------------------
-- |	   A	  |   Meeting	| 10/1/2021 10:00 |	 10/1/2021 10:30 |
-- |	   A	  |	   Break	| 10/1/2021 12:00 |  10/1/2021 12:30 |
-- |	   A	  |	  Meeting	| 10/1/2021 13:00 |  10/1/2021 13:30 |
-- |	   B	  |	   Break	| 10/1/2021 11:00 |  10/1/2021 11:15 |
-- ------------------------------------------------------------------



-- Here is the Expected Output.
-- ------------------------------------------------------------------
-- |Schedule ID  |	 Activity	|	Start TIme    |		End Time	 |
-- ------------------------------------------------------------------
-- |	   A	  |   Meeting	| 10/1/2021 10:00 |	 10/1/2021 10:30 |
-- |	   A	  |	   Work		| 10/1/2021 10:30 |  10/1/2021 12:00 |
-- |	   A	  |	   Break	| 10/1/2021 12:00 |  10/1/2021 12:30 |
-- |	   A	  |	   Work		| 10/1/2021 12:30 |  10/1/2021 13:00 |
-- |	   A	  |	  Meeting	| 10/1/2021 13:00 |  10/1/2021 13:30 |
-- |	   A	  |	   Work		| 10/1/2021 13:30 |  10/1/2021 15:00 |
-- |	   B	  |	   Work		| 10/1/2021 10:15 |  10/1/2021 11:00 |
-- |	   B	  |	   Break	| 10/1/2021 11:00 |  10/1/2021 11:15 |
-- |	   B	  |	   Break	| 10/1/2021 11:15 |  10/1/2021 12:15 |
-- ------------------------------------------------------------------


-- DROP TABLE IF EXISTS #Schedule;
-- DROP TABLE IF EXISTS #Activity;
-- GO

-- CREATE TABLE #Schedule
-- (
-- ScheduleID  CHAR(1) PRIMARY KEY,
-- StartTime   DATETIME NOT NULL,
-- EndTime     DATETIME NOT NULL
-- );
-- GO

-- CREATE TABLE #Activity
-- (
-- ScheduleID    CHAR(1) REFERENCES #Schedule (ScheduleID),
-- ActivityName  VARCHAR(100),
-- StartTime     DATETIME,
-- EndTime       DATETIME,
-- PRIMARY KEY (ScheduleID, ActivityName, StartTime, EndTime)
-- );
-- GO

-- INSERT INTO #Schedule (ScheduleID, StartTime, EndTime) VALUES
-- ('A',CAST('2021-10-01 10:00:00' AS DATETIME),CAST('2021-10-01 15:00:00' AS DATETIME)),
-- ('B',CAST('2021-10-01 10:15:00' AS DATETIME),CAST('2021-10-01 12:15:00' AS DATETIME));
-- GO

-- INSERT INTO #Activity (ScheduleID, ActivityName, StartTime, EndTime) VALUES
-- ('A','Meeting',CAST('2021-10-01 10:00:00' AS DATETIME),CAST('2021-10-01 10:30:00' AS DATETIME)),
-- ('A','Break',CAST('2021-10-01 12:00:00' AS DATETIME),CAST('2021-10-01 12:30:00' AS DATETIME)),
-- ('A','Meeting',CAST('2021-10-01 13:00:00' AS DATETIME),CAST('2021-10-01 13:30:00' AS DATETIME)),
-- ('B','Break',CAST('2021-10-01 11:00:00'AS DATETIME),CAST('2021-10-01 11:15:00' AS DATETIME));
-- GO


-- ------------------------10------------------------

-- You are part of an office lottery pool where you keep a table of the winning lottery numbers along with 
-- a table of each ticket�s chosen numbers.  If a ticket has some but not all the winning numbers, you win 
-- $10.  If a ticket has all the winning numbers, you win $100.    Calculate the total winnings for today�s 
-- drawing.



-- Winning Numbers 
-- ---------
-- |Number |
-- ---------
-- |	25	|
-- |	45	|
-- |	78	|
-- ---------


-- Tickets
-- ---------------------
-- |Ticket ID	|Number |
-- ---------------------
-- |A23423		|	25	|
-- |A23423		|	45	|
-- |A23423  	|	78	|
-- |B35643		|	25	|
-- |B35643		|	45	|
-- |B35643 	|	98	|
-- |C98787		|	67	|
-- |C98787 	|	86	|
-- |C98787		|	91	|
-- ---------------------



-- The expected output would be $110, as you have one winning ticket, and one ticket that has some but 
-- not all the winning numbers. 


-- ------------------------11------------------------
-- From the following table of transactions between two users, write a query to return the change in net worth for each user, ordered by decreasing net change.

-- Transactions
-- -------------------------------------------------
-- | Sender | Receiver | Amount | Transaction Date |  
-- |--------|----------|--------|------------------|  
-- |   5    |    2     |  10    |     2-12-20      |  
-- |   1    |    3     |  15    |     2-13-20      |  
-- |   2    |    1     |  20    |     2-13-20      |  
-- |   2    |    3     |  25    |     2-14-20      |  
-- |   3    |    1     |  20    |     2-15-20      |  
-- |   3    |    2     |  15    |     2-15-20      |  
-- |   1    |    4     |  5     |     2-16-20      |
-- -------------------------------------------------

-- Expected Output
-- ---------------------
-- | User | Net Change |  
-- |------|------------|  
-- |  1   |     20     |  
-- |  3   |      5     |  
-- |  4   |      5     |  
-- |  5   |    -10     |  
-- |  2   |    -20     |
-- ---------------------

-- DROP TABLE IF EXISTS transactions

-- CREATE TABLE transactions (  
--     sender INT,  
--     receiver INT,  
--     amount INT,  
--     transaction_date DATE  
-- );

-- INSERT INTO transactions (sender, receiver, amount, transaction_date)   
-- VALUES   
-- (5, 2, 10, CAST('2020-02-12' AS DATE)),  
-- (1, 3, 15, CAST('2020-02-13' AS DATE)),   
-- (2, 1, 20, CAST('2020-02-13' AS DATE)),   
-- (2, 3, 25, CAST('2020-02-14' AS DATE)),   
-- (3, 1, 20, CAST('2020-02-15' AS DATE)),   
-- (3, 2, 15, CAST('2020-02-15' AS DATE)),   
-- (1, 4, 5, CAST('2020-02-16' AS DATE));

-- ------------------------12------------------------
-- From the following table containing a list of dates and items ordered, write a query to return the most frequent item ordered on each date. Return multiple items in the case of a tie.


-- Items
-- -----------------------
-- |   date   |   item   |  
-- |----------|----------|  
-- | 1-1-20   | apple    |  
-- | 1-1-20   | apple    |  
-- | 1-1-20   | pear     |  
-- | 1-1-20   | pear     |  
-- | 1-2-20   | pear     |  
-- | 1-2-20   | pear     |  
-- | 1-2-20   | pear     |  
-- | 1-2-20   | orange   |
-- -----------------------


-- Expected Output
-- -----------------------
-- |   date   |   item   |  
-- |----------|----------|  
-- | 1-1-20   | apple    |  
-- | 1-1-20   | pear     |  
-- | 1-2-20   | pear     |
-- -----------------------

-- CREATE TABLE Fruits (  
--     date DATE,  
--     item VARCHAR(50)  
-- );


-- INSERT INTO Fruits (date, item) VALUES  
-- ('2020-01-01', 'apple'),  
-- ('2020-01-01', 'apple'),  
-- ('2020-01-01', 'pear'),  
-- ('2020-01-01', 'pear'),  
-- ('2020-02-01', 'pear'),  
-- ('2020-02-01', 'pear'),  
-- ('2020-02-01', 'pear'),  
-- ('2020-02-01', 'orange');


-- ------------------------13------------------------

-- From the following table of user actions, write a query to return for each user the time elapsed between the last action and the second-to-last action, in ascending order by user ID.

-- Users_actions
-- -----------------------------------
-- | user_id | action  | action_date |  
-- |---------|---------|-------------|  
-- |   1     | Start   |  2-12-20    |  
-- |   1     | Cancel  |  2-13-20    |  
-- |   2     | Start   |  2-11-20    |  
-- |   2     | Publish |  2-14-20    |  
-- |   3     | Start   |  2-15-20    |  
-- |   3     | Cancel  |  2-15-20    |  
-- |   4     | Start   |  2-18-20    |  
-- |   1     | Publish |  2-19-20    |
-- -----------------------------------



-- Expected Output
-- --------------------------
-- | user_id | days_elapsed |  
-- |---------|--------------|  
-- |   1     |      6       |  
-- |   2     |      3       |  
-- |   3     |      0       |  
-- |   4     |     NULL     |
-- --------------------------

-- CREATE TABLE users_actions (  
--     user_id INT,  
--     action VARCHAR(10),  
--     action_date DATE  
-- );

-- INSERT INTO users_actions (user_id, action, action_date) VALUES  
-- (1, 'Start', '2020-02-12'),  
-- (1, 'Cancel', '2020-02-13'),  
-- (2, 'Start', '2020-02-11'),  
-- (2, 'Publish', '2020-02-14'),  
-- (3, 'Start', '2020-02-15'),  
-- (3, 'Cancel', '2020-02-15'),  
-- (4, 'Start', '2020-02-18'),  
-- (1, 'Publish', '2020-02-19');



-- ------------------------14------------------------
-- A company defines its super users as those who have made at least two transactions. From the following table, write a query to return, for each user, the date when they become a super user, ordered by oldest super users first. Users who are not super users should also be present in the table.


-- Users
-- -------------------------------------------
-- | user_id | product_id | transaction_date |  
-- |---------|------------|------------------|  
-- |    1    |     101    |      2-12-20     |  
-- |    2    |     105    |      2-13-20     |  
-- |    1    |     111    |      2-14-20     |  
-- |    3    |     121    |      2-15-20     |  
-- |    1    |     101    |      2-16-20     |  
-- |    2    |     105    |      2-17-20     |  
-- |    4    |     101    |      2-16-20     |  
-- |    3    |     105    |      2-15-20     |
-- -------------------------------------------


-- Expected Output
-- ----------------------------
-- | user_id | superuser_date |  
-- |---------|----------------|  
-- |    1    |      2-14-20   |  
-- |    3    |      2-15-20   |  
-- |    2    |      2-17-20   |  
-- |    4    |       NULL     |
-- ----------------------------

-- CREATE TABLE users (  
--     user_id INT,  
--     product_id INT,  
--     transaction_date DATE  
-- );

-- INSERT INTO users (user_id, product_id, transaction_date) VALUES  
-- (1, 101, '2020-02-12'),  
-- (2, 105, '2020-02-13'),  
-- (1, 111, '2020-02-14'),  
-- (3, 121, '2020-02-15'),  
-- (1, 101, '2020-02-16'),  
-- (2, 105, '2020-02-17'),  
-- (4, 101, '2020-02-16'),  
-- (3, 105, '2020-02-15');

-- ------------------------15------------------------

-- Using the following two tables, write a query to return page recommendations to a social media user based on the pages that their friends have liked, but that they have not yet marked as liked. Order the result by ascending user ID.

-- Friends
-- --------------------
-- | user_id | friend |  
-- |---------|--------|  
-- |    1    |    2   |  
-- |    1    |    3   |  
-- |    1    |    4   |  
-- |    2    |    1   |  
-- |    3    |    1   |  
-- |    3    |    4   |  
-- |    4    |    1   |  
-- |    4    |    3   |
-- --------------------


-- Likes
-- ------------------------
-- | user_id | page_likes |  
-- |---------|------------|  
-- |    1    |     A      |  
-- |    1    |     B      |  
-- |    1    |     C      |  
-- |    2    |     A      |  
-- |    3    |     B      |  
-- |    3    |     C      |  
-- |    4    |     B      |
-- ------------------------



-- Expected Output
-- ------------------------------
-- | user_id | recommended_page |  
-- |---------|------------------|  
-- |    2    |        B         |  
-- |    2    |        C         |  
-- |    3    |        A         |  
-- |    4    |        A         |  
-- |    4    |        C         |
-- ------------------------------


-- CREATE TABLE friends (  
--     user_id INT,  
--     friend INT,  
--     PRIMARY KEY (user_id, friend)  
-- );  

-- CREATE TABLE likes (  
--     user_id INT,  
--     page_likes VARCHAR(255),  
--     PRIMARY KEY (user_id, page_likes)  
-- );



-- -- Inserting data into the friends table  
-- INSERT INTO friends (user_id, friend) VALUES  
-- (1, 2),  
-- (1, 3),  
-- (1, 4),  
-- (2, 1),  
-- (3, 1),  
-- (3, 4),  
-- (4, 1),  
-- (4, 3);  

-- -- Inserting data into the likes table  
-- INSERT INTO likes (user_id, page_likes) VALUES  
-- (1, 'A'),  
-- (1, 'B'),  
-- (1, 'C'),  
-- (2, 'A'),  
-- (3, 'B'),  
-- (3, 'C'),  
-- (4, 'B');


-- ------------------------16------------------------

-- Given the following table, return a list of users and their corresponding friend count. Order the result by descending friend count, and in the case of a tie, by ascending user ID. Assume that only unique friendships are displayed.


-- Friends
-- -----------------
-- | user1 | user2 |  
-- |---------------|  
-- | 1    |   2    |  
-- | 1    |   3    |  
-- | 1    |   4    |  
-- | 2    |   3    |
-- -----------------


-- Expected Output
-- ------------------
-- |user_id | count |
-- |--------|-------|
-- | 1      | 3     |
-- | 2      | 2     |
-- | 3      | 2     |
-- | 4      | 1     |
-- ------------------





-- ------------------------17------------------------

-- Given the following two tables, write a query to return the fraction of students, rounded to two decimal places, who attended school
-- (attendance = 1) on their birthday.


-- Attendance
-- -----------------------------------------
-- | student_id | school_date | attendance |  
-- |------------|-------------|------------|  
-- | 1          | 2020-04-03  | 0          |  
-- | 2          | 2020-04-03  | 1          |  
-- | 3          | 2020-04-03  | 1          |  
-- | 1          | 2020-04-04  | 1          |  
-- | 2          | 2020-04-04  | 1          |  
-- | 3          | 2020-04-04  | 1          |  
-- | 1          | 2020-04-05  | 0          |  
-- | 2          | 2020-04-05  | 1          |  
-- | 3          | 2020-04-05  | 1          |  
-- | 4          | 2020-04-05  | 1          |
-- -----------------------------------------

-- Students
-- --------------------------------------------------------
-- | student_id | school_id | grade_level | date_of_birth |
-- |------------|-----------|-------------|---------------|
-- | 1          | 2         | 5           | 2012-04-03    |
-- | 2          | 1         | 4           | 2013-04-04    |
-- | 3          | 1         | 3           | 2014-04-05    |
-- | 4          | 2         | 4           | 2013-04-03    |
-- --------------------------------------------------------

-- Expected Output
-- ---------------------
-- | birthday_attendace|
-- |-------------------|
-- |		0.67		|
-- ---------------------


-- CREATE TABLE Attendance (  
--     student_id INT,  
--     school_date DATE,  
--     attendance INT,  
--     PRIMARY KEY (student_id, school_date)  
-- );  


-- CREATE TABLE Students (  
--     student_id INT PRIMARY KEY,  
--     school_id INT,  
--     grade_level INT,  
--     date_of_birth DATE  
-- );

-- INSERT INTO Attendance (student_id, school_date, attendance) VALUES  
-- (1, '2020-04-03', 0),  
-- (2, '2020-04-03', 1),  
-- (3, '2020-04-03', 1),  
-- (1, '2020-04-04', 1),  
-- (2, '2020-04-04', 1),  
-- (3, '2020-04-04', 1),  
-- (1, '2020-04-05', 0),  
-- (2, '2020-04-05', 1),  
-- (3, '2020-04-05', 1),  
-- (4, '2020-04-05', 1);


-- INSERT INTO Students (student_id, school_id, grade_level, date_of_birth) VALUES  
-- (1, 2, 5, '2012-04-03'),  
-- (2, 1, 4, '2013-04-04'),  
-- (3, 1, 3, '2014-04-05'),  
-- (4, 2, 4, '2013-04-03');



-- ------------------------18------------------------

-- Given the following two tables, write a query to return the hacker ID, name, and total score (the sum of maximum scores for each challenge completed) ordered by descending score, and by ascending hacker ID in the case of score tie. Do not display entries for hackers with a score of zero.

-- Hackers
-- ---------------------
-- | hacker_id | name  |  
-- |-----------|-------|  
-- | 1         | John  |  
-- | 2         | Jane  |  
-- | 3         | Joe   |  
-- | 4         | Jim   |
-- ---------------------


-- Submissions
-- ----------------------------------------------------
-- | submission_id | hacker_id | challenge_id | score |
-- |---------------|-----------|--------------|-------|
-- | 101           | 1         | 1            | 10    |
-- | 102           | 1         | 1            | 12    |
-- | 103           | 2         | 1            | 11    |
-- | 104           | 2         | 1            | 9     |
-- | 105           | 2         | 2            | 13    |
-- | 106           | 3         | 1            | 9     |
-- | 107           | 3         | 2            | 12    |
-- | 108           | 3         | 2            | 15    |
-- | 109           | 4         | 1            | 0     |
-- ----------------------------------------------------

-- Expected output
-- ---------------------------------
-- | hacker_id | name  |Total_Score|
-- |-----------|-------|-----------|
-- | 2         | Jane  |	  24	|
-- | 3         | Joe   |	  24	|
-- | 1         | John  |	  12	|
-- ---------------------------------


-- CREATE TABLE Hackers (  
--     hacker_id INT PRIMARY KEY,  
--     name NVARCHAR(100)  
-- );  

-- CREATE TABLE Submissions (  
--     submission_id INT PRIMARY KEY,  
--     hacker_id INT,  
--     challenge_id INT,  
--     score INT,  
--     FOREIGN KEY (hacker_id) REFERENCES Hackers(hacker_id)  
-- );


-- INSERT INTO Hackers (hacker_id, name) VALUES  
--     (1, 'John'),  
--     (2, 'Jane'),  
--     (3, 'Joe'),  
--     (4, 'Jim');  

-- INSERT INTO Submissions (submission_id, hacker_id, challenge_id, score) VALUES  
--     (101, 1, 1, 10),  
--     (102, 1, 1, 12),  
--     (103, 2, 1, 11),  
--     (104, 2, 1, 9),  
--     (105, 2, 2, 13),  
--     (106, 3, 1, 9),  
--     (107, 3, 2, 12),  
--     (108, 3, 2, 15),  
--     (109, 4, 1, 0);
-- ------------------------19------------------------

-- Write a query to rank scores in the following table without using a window function. If there is a tie between two scores, both should have the same rank. After a tie, the following rank should be the next consecutive integer value.


-- Scores
-- ---------------
-- | id  | score | 
-- |---- | ------|  
-- |  1  | 3.50  |
-- |  2  | 3.65  |
-- |  3  | 4.00  |
-- |  4  | 3.85  |
-- |  5  | 4.00  |
-- |  6  | 3.65  |
-- ---------------


-- Expected Output.
-- -----------------------
-- | score  | score_rank | 
-- |------- | -----------|  
-- |  4.00  |     1  	  |
-- |  4.00  |     1  	  |
-- |  3.85  |     2  	  |
-- |  3.65  |     3  	  |
-- |  3.65  |     3  	  |
-- |  3.50  |     4	  |
-- -----------------------
-- DROP TABLE IF EXISTS ScoreS

-- CREATE TABLE Scores(ID INT, Score FLOAT)

-- INSERT INTO  scores (id, score) VALUES
-- (1, 3.50),
-- (2, 3.65),
-- (3, 4.00),
-- (4, 3.85),
-- (5, 4.00),
-- (6, 3.65)



-- ------------------------20------------------------

-- Write a query to return the scores of each team in the teams table after all matches displayed in the matches table. Points are awarded as follows: zero points for a loss, one point for a tie, and three points for a win. The result should include team name and points, and be ordered by decreasing points. In case of a tie, order by alphabetized team name.


-- Teams
-- ---------------------------
-- | team_id | team_name     |  
-- |---------|---------------|  
-- | 1       | New York      |  
-- | 2       | Atlanta       |  
-- | 3       | Chicago       |  
-- | 4       | Toronto       |  
-- | 5       | Los Angeles   |  
-- | 6       | Seattle       |
-- ---------------------------

-- Matches
-- ------------------------------------------------------------------
-- | match_id | host_team | guest_team | host_goals  | guest_goals  |
-- |----------|-----------|------------|-------------|--------------|
-- | 1        | 1         | 2          | 3           | 0            |
-- | 2        | 2         | 3          | 2           | 4            |
-- | 3        | 3         | 4          | 4           | 3            |
-- | 4        | 4         | 5          | 1           | 1            |
-- | 5        | 5         | 6          | 2           | 1            |
-- | 6        | 6         | 1          | 1           | 2            |
-- ------------------------------------------------------------------

-- Expected Output
-- -------------------------------
-- | team_name    | total_points |  
-- |--------------|--------------|  
-- | Chicago      | 6            |  
-- | New York     | 6            |  
-- | Los Angeles  | 4            |  
-- | Toronto      | 1            |  
-- | Atlanta      | 0            |  
-- | Seattle      | 0            |
-- -------------------------------



-- CREATE TABLE teams (  
--     team_id INT PRIMARY KEY,  
--     team_name VARCHAR(50) NOT NULL  
-- );  

-- INSERT INTO teams (team_id, team_name) VALUES  
-- (1, 'New York'),  
-- (2, 'Atlanta'),  
-- (3, 'Chicago'),  
-- (4, 'Toronto'),  
-- (5, 'Los Angeles'),  
-- (6, 'Seattle');  

-- CREATE TABLE matches (  
--     match_id INT PRIMARY KEY,  
--     host_team INT,  
--     guest_team INT,  
--     host_goals INT,  
--     guest_goals INT, 
-- );  

-- INSERT INTO matches (match_id, host_team, guest_team, host_goals, guest_goals) VALUES  
-- (1, 1, 2, 3, 0),  
-- (2, 2, 3, 2, 4),  
-- (3, 3, 4, 4, 3),  
-- (4, 4, 5, 1, 1),  
-- (5, 5, 6, 2, 1),  
-- (6, 6, 1, 1, 2);


-- ------------------------21------------------------

-- The attendance table logs the number of people counted in a crowd each day an event is held. Write a query to return a table showing the date and visitor count of high-attendance periods, defined as three consecutive entries (not necessarily consecutive dates) with more than 100 visitors.


-- Attendance  
-- |--------------|----------|  
-- | event_date   | visitors |  
-- |--------------|----------|  
-- | 01-01-20     | 10       |  
-- | 01-04-20     | 109      |  
-- | 01-05-20     | 150      |  
-- | 01-06-20     | 99       |  
-- | 01-07-20     | 145      |  
-- | 01-08-20     | 1455     |  
-- | 01-11-20     | 199      |  
-- | 01-12-20     | 188      |  


-- Expected Output 
-- |--------------|----------|  
-- | event_date   | visitors |  
-- |--------------|----------|  
-- | 01-07-20     | 145      |  
-- | 01-08-20     | 1455     |  
-- | 01-11-20     | 199      |  
-- | 01-12-20     | 188      |
-- ---------------------------


-- CREATE TABLE Attendance (  
--     event_date DATE,  
--     visitors INT  
-- );  


-- INSERT INTO Attendance (event_date, visitors) VALUES  
-- ('2020-01-01', 10),  
-- ('2020-01-04', 109),  
-- ('2020-01-05', 150),  
-- ('2020-01-06', 99),  
-- ('2020-01-07', 145),  
-- ('2020-01-08', 1455),  
-- ('2020-01-11', 199),  
-- ('2020-01-12', 188);



-- ------------------------22------------------------

-- Given below table Emp as Input which has two columns 'Groups' and 'Sequence'. Write a SQL query to find the maximum and minimum values of continuos 'Sequence' in each 'Group'.

-- Emp
-- --------------------
-- |Group    |Sequence|
-- |-------  |--------|
-- |A        |1       |
-- |A        |2       |
-- |A        |3       |
-- |A        |5       |
-- |A        |6       |
-- |A        |8       |
-- |A        |9       |
-- |B        |11      |
-- |C        |1       |
-- |C        |2       |
-- |C        |3       |
-- --------------------


-- Expected Output
-- -----------------------------
-- | Group | Min_Seq | Max_Seq |  
-- |-------|---------|---------|  
-- | A     | 1       | 3       |  
-- | A     | 5       | 6       |  
-- | A     | 8       | 9       |  
-- | B     | 11      | 11      |  
-- | C     | 1       | 3       |
-- -----------------------------


-- CREATE TABLE Emp(
-- [Group]  varchar(20),
-- [Sequence]  int )

-- INSERT INTO Emp VALUES('A',1)
-- INSERT INTO Emp VALUES('A',2)
-- INSERT INTO Emp VALUES('A',3)
-- INSERT INTO Emp VALUES('A',5)
-- INSERT INTO Emp VALUES('A',6)
-- INSERT INTO Emp VALUES('A',8)
-- INSERT INTO Emp VALUES('A',9)
-- INSERT INTO Emp VALUES('B',11)
-- INSERT INTO Emp VALUES('C',1)
-- INSERT INTO Emp VALUES('C',2)
-- INSERT INTO Emp VALUES('C',3)



-- --------------------------23------------------------

-- Write a SQL  to find all Employees who earn more than the average salary in their corresponding department.
-- Return EmpID, EmpName,Salary in your output

-- CREATE Table Employee
-- (
-- EmpID INT,
-- EmpName Varchar(30),
-- Salary Float,
-- DeptID INT
-- )

-- INSERT INTO Employee VALUES(1001,'Mark',60000,2)
-- INSERT INTO Employee VALUES(1002,'Antony',40000,2)
-- INSERT INTO Employee VALUES(1003,'Andrew',15000,1)
-- INSERT INTO Employee VALUES(1004,'Peter',35000,1)
-- INSERT INTO Employee VALUES(1005,'John',55000,1)
-- INSERT INTO Employee VALUES(1006,'Albert',25000,3)
-- INSERT INTO Employee VALUES(1007,'Donald',35000,3)


-- --------------------------24------------------------

-- Write a SQL which will fetch total schedule of matches between each Team vs opposite team

-- CREATE TABLE NTeams (ID INT, TeamName VARCHAR(30))

-- INSERT INTO NTeams VALUES
-- (1,'India'),
-- (2,'Australia'),
-- (3,'England'),
-- (4,'NewZealand')

-- Expected Output
-- -----------------------------
-- |Matches					|
-- |---------------------------|  
-- | India Vs Australia        |  
-- | India Vs England          |  
-- | India Vs NewZealand       |  
-- | Australia Vs England      |  
-- | Australia Vs NewZealand   |  
-- | England Vs NewZealand     |
-- -----------------------------


-- --------------------------25------------------------

-- Write SQL to display total number of matches played, matches won, matches tied and matches lost for each team

-- Match_Result
-- -------------------------------------------------------
-- |Team_1              |Team_2              |Result     |
-- |--------------------|--------------------|-----------|
-- |India               |Australia           |India      |
-- |India               |England             |England    |
-- |SouthAfrica         |India               |India      |
-- |Australia           |England             |NULL       |
-- |England             |SouthAfrica         |SouthAfrica|
-- |Australia           |India               |Australia  |
-- -------------------------------------------------------


-- Expected Output
-- --------------------------------------------------------------------
-- | Team         | Match_Played | Match_Won | Match_Tie | Match_Lost |  
-- |--------------|--------------|-----------|-----------|------------|  
-- | Australia    | 3            | 1         | 1         | 1          |  
-- | England      | 3            | 1         | 1         | 1          |  
-- | India        | 4            | 2         | 0         | 2          |  
-- | South Africa | 2            | 1         | 0         | 1          |
-- --------------------------------------------------------------------

-- Create Table Match_Result (
-- Team_1 Varchar(20),
-- Team_2 Varchar(20),
-- Result Varchar(20)
-- )

-- Insert into Match_Result Values('India', 'Australia','India');
-- Insert into Match_Result Values('India', 'England','England');
-- Insert into Match_Result Values('SouthAfrica', 'India','India');
-- Insert into Match_Result Values('Australia', 'England',NULL);
-- Insert into Match_Result Values('England', 'SouthAfrica','SouthAfrica');
-- Insert into Match_Result Values('Australia', 'India','Australia');



-- --------------------------26------------------------

-- Write SQL query to print all the letters of English Alphabets(Capital)

-- Expected Output
-- -------------
-- |	letter	|
-- |-----------|
-- |     A     |                        
-- |     B     |                        
-- |     C     |                        
-- |     D     |                        
-- |     E     |                        
-- |     F     |                        
-- |     G     |                        
-- |     H     |                        
-- |     I     |                        
-- |     J     |                        
-- |     K     |                        
-- |     L     |                        
-- |     M     |                        
-- |     N     |                        
-- |     O     |                        
-- |     P     |                        
-- |     Q     |                        
-- |     R     |                        
-- |     S     |                        
-- |     T     |                        
-- |     U     |                        
-- |     V     |                        
-- |     W     |                        
-- |     X     |                        
-- |     Y     |                        
-- |     Z     |
-- -------------
-- --------------------------27------------------------

-- Write SQL query to derive the Net_Balance columns based on Credit/Debit of the Amount

-- Use the provided create/insert query to see the input table.

-- ----------------------------------------------------------------------
-- | TranDate                | TranID | TranType | Amount | Net_Balance |
-- |-------------------------|--------|----------|--------|-------------|
-- | 2020-05-12 05:29:44.120 | A1001  | Credit   | 50000  | 50000       |
-- | 2020-05-13 10:30:20.100 | B1001  | Debit    | 10000  | 40000       |
-- | 2020-05-13 11:27:50.130 | B1002  | Credit   | 20000  | 60000       |
-- | 2020-05-14 08:35:30.123 | C1001  | Debit    | 5000   | 55000       |
-- | 2020-05-14 09:43:51.100 | C1002  | Debit    | 5000   | 50000       |
-- | 2020-05-15 05:51:11.117 | D1001  | Credit   | 30000  | 80000       |
-- ----------------------------------------------------------------------


-- Create Table Account_Table(
-- TranDate DateTime,
-- TranID Varchar(20),
-- TranType Varchar(10),
-- Amount Float)


-- INSERT [dbo].[Account_Table] ([TranDate], [TranID], [TranType], [Amount]) VALUES ('2020-05-12T05:29:44.120', 'A10001','Credit', 50000)
-- INSERT [dbo].[Account_Table] ([TranDate], [TranID], [TranType], [Amount]) VALUES ('2020-05-13T10:30:20.100', 'B10001','Debit', 10000)
-- INSERT [dbo].[Account_Table] ([TranDate], [TranID], [TranType], [Amount]) VALUES ('2020-05-13T11:27:50.130', 'B10002','Credit', 20000)
-- INSERT [dbo].[Account_Table] ([TranDate], [TranID], [TranType], [Amount]) VALUES ('2020-05-14T08:35:30.123', 'C10001','Debit', 5000)
-- INSERT [dbo].[Account_Table] ([TranDate], [TranID], [TranType], [Amount]) VALUES ('2020-05-14T09:43:51.100', 'C10002','Debit', 5000)
-- INSERT [dbo].[Account_Table] ([TranDate], [TranID], [TranType], [Amount]) VALUES ('2020-05-15T05:51:11.117', 'D10001','Credit', 30000)
-- --------------------------28------------------------

-- Write SQL to derive Start_Date and End_Date column when there is continuous amount in Balance column as shown below

-- Expected Output
-- -------------------------------------
-- | Balance | Start_Date | End_Date   |  
-- |---------|------------|------------|  
-- | 26000   | 2020-01-01 | 2020-01-03 |  
-- | 30000   | 2020-01-04 | 2020-01-05 |  
-- | 26000   | 2020-01-06 | 2020-01-07 |  
-- | 32000   | 2020-01-08 | 2020-01-08 |  
-- | 31000   | 2020-01-09 | 2020-01-09 |
-- -------------------------------------

-- Use the provided create/insert query to see the input table.


-- Create Table BalanceTbl(
-- Balance int,
-- Dates Date
-- )

-- Insert into BalanceTbl Values(26000,'2020-01-01')
-- Insert into BalanceTbl Values(26000,'2020-01-02')
-- Insert into BalanceTbl Values(26000,'2020-01-03')
-- Insert into BalanceTbl Values(30000,'2020-01-04')
-- Insert into BalanceTbl Values(30000,'2020-01-05')
-- Insert into BalanceTbl Values(26000,'2020-01-06')
-- Insert into BalanceTbl Values(26000,'2020-01-07')
-- Insert into BalanceTbl Values(32000,'2020-01-08')
-- Insert into BalanceTbl Values(31000,'2020-01-09')

-- --------------------------29------------------------

-- There are two table. First table name is Sales_Table. Second Table name is ExchangeRate_Table. As and when exchange rate changes, a new row is inserted in the ExchangeRate table with a new effective start date.
-- Use query below to get the input table
-- Write SQL to get Total  sales amount in USD for each sales date as shown below

-- Expected Output
-- --------------------------------------------
-- | Sales_Date  | Total Sales Amount in USD  |  
-- |-------------|----------------------------|  
-- | 2020-01-01  | 137                        |  
-- | 2020-01-02  | 665                        |  
-- | 2020-01-03  | 7.5                        |  
-- | 2020-01-17  | 270                        |
-- --------------------------------------------

-- Create Table Sales_Table(
-- Sales_Date Date,
-- Sales_Amount Bigint,
-- Currency Varchar(10)
-- )

-- INSERT INTO Sales_Table Values ('2020-01-01',500,'INR');
-- INSERT INTO Sales_Table Values ('2020-01-01',100,'GBP');
-- INSERT INTO Sales_Table Values ('2020-01-02',1000,'INR');
-- INSERT INTO Sales_Table Values ('2020-01-02',500,'GBP');
-- INSERT INTO Sales_Table Values ('2020-01-03',500,'INR');
-- INSERT INTO Sales_Table Values ('2020-01-17',200,'GBP');

-- CREATE TABLE [dbo].[ExchangeRate_Table](
--  [Source_Currency] [varchar](10) ,
--  [Target_Currency] [varchar](10),
--  [Exchange_Rate] [float] ,
--  [Effective_Start_Date] [date] 
-- ) 

-- INSERT [dbo].[ExchangeRate_Table] VALUES ('INR','USD', 0.014,'2019-12-31')
-- INSERT [dbo].[ExchangeRate_Table] VALUES ('INR','USD', 0.015,'2020-01-02')
-- INSERT [dbo].[ExchangeRate_Table] VALUES ('GBP','USD', 1.32, '2019-12-20')
-- INSERT [dbo].[ExchangeRate_Table] VALUES ('GBP','USD', 1.3,  '2020-01-01')
-- INSERT [dbo].[ExchangeRate_Table] VALUES ('GBP','USD', 1.35, '2020-01-16')

-- --------------------------30------------------------

-- Write a SQL to display the Source_Phone_Nbr and a flag where the flag needs to be set to �Y� if first called number and last called number are the same and �N� if first called number and last called number are different

-- See the input table provided below(create and insert query).

-- Expected Output
-- -------------------------------
-- | Source_Phone_Nbr | Is_Match |  
-- |------------------|----------|  
-- | 2345             | Y        |  
-- | 3311             | N        |
-- -------------------------------

-- Create Table Phone_Log(
-- Source_Phone_Nbr Bigint,
-- Destination_Phone_Nbr Bigint,
-- Call_Start_DateTime Datetime) ;

-- Insert into Phone_Log Values (2345,6789,'2012-07-01 10:00')
-- Insert into Phone_Log Values (2345,1234,'2012-07-01 11:00')
-- Insert into Phone_Log Values (2345,4567,'2012-07-01 12:00')
-- Insert into Phone_Log Values (2345,4567,'2012-07-01 13:00')
-- Insert into Phone_Log Values (2345,6789,'2012-07-01 15:00')
-- Insert into Phone_Log Values (3311,7890,'2012-07-01 10:00')
-- Insert into Phone_Log Values (3311,6543,'2012-07-01 12:00')
-- Insert into Phone_Log Values (3311,1234,'2012-07-01 13:00')


-- --------------------------31------------------------

-- Write a SQL query to print the Sequence Number from the given range of number.


-- See the input table provided below(create and insert query).

-- Expected Output
-- ------
-- | id |  
-- |----|  
-- |  1 |  
-- |  2 |  
-- |  3 |  
-- |  4 |  
-- |  6 |  
-- |  8 |  
-- |  9 |  
-- | 11 |  
-- | 12 |  
-- | 13 |  
-- | 15 |
-- ------


-- Create Table SampleTable
-- (
-- Start_Range Bigint,
-- End_Range Bigint
-- );
-- Insert into SampleTable Values (1,4)
-- Insert into SampleTable Values (6,6)
-- Insert into SampleTable Values (8,9)
-- Insert into SampleTable Values (11,13)
-- Insert into SampleTable Values (15,15)




-- --------------------------32------------------------

-- Write a SQL Query to get the output as shown in the output table using the string 'INTERVIEW'
-- You have just the string, it is not in a table. You do not have a input table for this puzzle
-- Expected Output
-- -------------
-- | String    |  
-- |-----------|  
-- | INTERVIEW |  
-- | INTERVIE  |  
-- | INTERVI   |  
-- | INTERV    |  
-- | INTER     |  
-- | INTE      |  
-- | INT       |  
-- | IN        |  
-- | I         |
-- -------------


-- --------------------------33------------------------

-- 1.As a convention the values in first_name and last_name should always be in uppercase. But due to data entry issues some records may not adhere to this convention. Write a query to find all such records where first_name is not in upper case.

-- 2.For some records the first_name column has full name and last_name is blank.  Write a SQL query to update it correctly,


-- Create Table Employees
-- (
-- Employee_no BigInt,
-- Birth_date Date,
-- First_name Varchar(50),
-- Last_name Varchar(50),
-- Joining_date Date
-- )

-- INSERT INTO Employees Values(1001,CAST('1988-08-15' AS Date),'ADAM','WAUGH', CAST('2013-04-12' AS Date))
-- INSERT INTO Employees Values(1002,CAST('1990-05-10' AS Date),'Mark','Jennifer', CAST('2010-06-25' AS Date))
-- INSERT INTO Employees Values(1003,CAST('1992-02-07' AS Date),'JOHN','Waugh', CAST('2016-02-07' AS Date))
-- INSERT INTO Employees Values(1004,CAST('1985-06-12' AS Date),'SOPHIA TRUMP','', CAST('2016-02-15' AS Date))
-- INSERT INTO Employees Values(1005,CAST('1995-03-25' AS Date),'Maria','Gracia', CAST('2011-04-09' AS Date))
-- INSERT INTO Employees Values(1006,CAST('1994-06-23' AS Date),'ROBERT','PATRICA', CAST('2015-06-23' AS Date))
-- INSERT INTO Employees Values(1007,CAST('1993-04-05' AS Date),'MIKE JOHNSON','', CAST('2014-03-09' AS Date))
-- INSERT INTO Employees Values(1008,CAST('1989-04-05' AS Date),'JAMES','OLIVER', CAST('2017-01-15' AS Date))






-- --------------------------33------------------------

-- SalesInfo Table has three columns namely Continents, Country and Sales. 
-- Write a SQL query to get the total of sales countrywise and display only those which did most sales in each continents as shown in the output table.


-- Create Table SalesInfo(
-- Continents varchar(30),
-- Country varchar(30),
-- Sales Bigint
-- )

-- Insert into SalesInfo Values('Asia','India',50000)
-- Insert into SalesInfo Values('Asia','India',70000)
-- Insert into SalesInfo Values('Asia','India',60000)
-- Insert into SalesInfo Values('Asia','Japan',10000)
-- Insert into SalesInfo Values('Asia','Japan',20000)
-- Insert into SalesInfo Values('Asia','Japan',40000)
-- Insert into SalesInfo Values('Asia','Thailand',20000)
-- Insert into SalesInfo Values('Asia','Thailand',30000)
-- Insert into SalesInfo Values('Asia','Thailand',40000)
-- Insert into SalesInfo Values('Europe','Denmark',40000)
-- Insert into SalesInfo Values('Europe','Denmark',60000)
-- Insert into SalesInfo Values('Europe','Denmark',10000)
-- Insert into SalesInfo Values('Europe','France',60000)
-- Insert into SalesInfo Values('Europe','France',30000)
-- Insert into SalesInfo Values('Europe','France',40000)


-- Expected Output
-- ------------------------------------------
-- | No | Continents | Country | TotalSales |  
-- |----|------------|---------|------------|  
-- | 1  | Asia       | India   | 180000     |  
-- | 2  | Europe     | France  | 130000     |
-- ------------------------------------------


-- --------------------------34------------------------

-- Write a SQL query to print movie theater like seating numbers as shown in the output table.
-- You cannot create a table(input table), do this without using a phsical table.


-- Expected Output
-- ---------------------------------------------
-- | Row | Seat_Arrangement                    |
-- |-----|-------------------------------------|
-- | A   | A1,A2,A3,A4,A5,A6,A7,A8,A9,A10      |
-- | B   | B1,B2,B3,B4,B5,B6,B7,B8,B9,B10      |
-- | C   | C1,C2,C3,C4,C5,C6,C7,C8,C9,C10      |
-- | D   | D1,D2,D3,D4,D5,D6,D7,D8,D9,D10      |
-- | E   | E1,E2,E3,E4,E5,E6,E7,E8,E9,E10      |
-- | F   | F1,F2,F3,F4,F5,F6,F7,F8,F9,F10      |
-- | G   | G1,G2,G3,G4,G5,G6,G7,G8,G9,G10      |
-- | H   | H1,H2,H3,H4,H5,H6,H7,H8,H9,H10      |
-- | I   | I1,I2,I3,I4,I5,I6,I7,I8,I9,I10      |
-- | J   | J1,J2,J3,J4,J5,J6,J7,J8,J9,J10      |
-- | K   | K1,K2,K3,K4,K5,K6,K7,K8,K9,K10      |
-- ---------------------------------------------


-- --------------------------35------------------------
-- Write a SQL query to find the  total points scored by each club as shown in the desired output.

-- --MM � 0.5, CI � 0.5, CO- 0.5, CD � 1, CL-1, CM � 1

-- Create Table Club (
-- Club_Id int,
-- Member_Id int,
-- EDU varchar(30))

-- Insert into Club Values (1001,210,Null)
-- Insert into Club Values (1001,211,'MM:CI')
-- Insert into Club Values (1002,215,'CD:CI:CM')
-- Insert into Club Values (1002,216,'CL:CM')
-- Insert into Club Values (1002,217,'MM:CM')
-- Insert into Club Values (1003,255,Null)
-- Insert into Club Values (1001,216,'CO:CD:CL:MM')
-- Insert into Club Values (1002,210,Null)


-- Expected Output
-- -------------------------------
-- | No | Club_Id | Total_Points |  
-- |----|---------|--------------|  
-- | 1  | 1001    | 4.0          |  
-- | 2  | 1002    | 6.0          |  
-- | 3  | 1003    | 0.0          |
-- -------------------------------



-- --------------------------36------------------------

-- The Spending table keeps the logs of the spendings history of users that make purchases from an online shopping website which has a desktop and a mobile devices.
-- Write an SQL query to find the total number of users and the total amount spent using mobile only, desktop only and both mobile and desktop together for each date.




-- Expected Output
-- ------------------------------------------------------------
-- | Row | Spend_date | Platform | Total_Amount | Total_users |  
-- |-----|------------|----------|--------------|-------------|  
-- | 1   | 2019-07-01 | Mobile   | 100          | 1           |  
-- | 2   | 2019-07-01 | Desktop  | 100          | 1           |  
-- | 3   | 2019-07-01 | Both     | 200          | 1           |  
-- | 4   | 2019-07-02 | Mobile   | 100          | 1           |  
-- | 5   | 2019-07-02 | Desktop  | 100          | 1           |  
-- | 6   | 2019-07-02 | Both     | 0            | 0           |
-- ------------------------------------------------------------




-- create table Spending 
-- (
-- User_id int,
-- Spend_date date,
-- Platform varchar(10),
-- Amount int
-- );

-- Insert into spending values(1,'2019-07-01','Mobile',100);
-- Insert into spending values(1,'2019-07-01','Desktop',100);
-- Insert into spending values(2,'2019-07-01','Mobile',100);
-- Insert into spending values(2,'2019-07-02','Mobile',100);
-- Insert into spending values(3,'2019-07-01','Desktop',100);
-- Insert into spending values(3,'2019-07-02','Desktop',100);


-- --------------------------37------------------------

-- Write a SQL query to output the names of those students whose best friends got higher salary than Student.



-- Expected Output
-- -----------
-- | Student |  
-- |---------|  
-- | David   |  
-- | John    |  
-- | Albert  |
-- -----------


-- Create Table Students_Tbl
-- (
-- Id int,
-- Student_Name Varchar(30)
-- )

-- Insert into Students_Tbl values(1,'Mark');
-- Insert into Students_Tbl values(2,'David');
-- Insert into Students_Tbl values(3,'John');
-- Insert into Students_Tbl values(4,'Albert');

-- Create Table Friends_Tbl(
-- Id int,
-- Friend_Id int
-- )

-- Insert into Friends_Tbl values(1,2);
-- Insert into Friends_Tbl values(2,3);
-- Insert into Friends_Tbl values(3,4);
-- Insert into Friends_Tbl values(4,1);

-- Create Table Salary_Tbl
-- (StudentId int,
-- Salary Bigint )

-- Insert into Salary_Tbl values(1,18);
-- Insert into Salary_Tbl values(2,12);
-- Insert into Salary_Tbl values(3,13);
-- Insert into Salary_Tbl values(4,15);




-- --------------------------38------------------------

-- Write an SQL query to return the number of locations,in which location most signals sent, and total number of signal for each device from the given table.



-- Expected Output
-- --------------------------------------------------------------------
-- | Device_id | no_of_location | max_signal_location | no_of_signals  |  
-- |-----------|----------------|---------------------|----------------|  
-- | 12        | 2              | Bangalore           | 6              |  
-- | 13        | 2              | Secunderabad        | 5              |
-- ---------------------------------------------------------------------

-- Create Table Device(
-- Device_id int,
-- Locations Varchar(25)
-- )

-- Insert into Device (Device_id,Locations) values
-- (12,' ),
-- (13,'Hyderabad'), 
-- (13,'Hyderabad'), 
-- (13, 'Secunderabad'), 
-- (13, 'Secunderabad'),
-- (13, 'Secunderabad')








