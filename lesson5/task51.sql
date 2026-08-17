--Assignment

--Table Structure
--Employees:
--    - EmployeeID    INT
--    - Name          VARCHAR(50)
--    - Department    VARCHAR(50)
--    - Salary        DECIMAL(10,2)
--    - HireDate      DATE
-----
DROP TABLE IF EXISTS Employees;
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Department VARCHAR(50) NOT NULL,
    Salary DECIMAL(10, 2) NOT NULL,
    HireDate DATE NOT NULL
);
GO

INSERT INTO Employees (EmployeeID, Name, Department, Salary, HireDate)
VALUES
    (1, 'Alice Smith', 'IT', 95000.00, '2020-01-15'),
    (2, 'Bob Jones', 'IT', 80000.00, '2020-06-01'),
    (3, 'Charlie Brown', 'IT', 80000.00, '2021-03-10'),
    (4, 'Diana Prince', 'IT', 60000.00, '2022-01-05'),
    (5, 'Evan Wright', 'HR', 75000.00, '2019-11-20'),
    (6, 'Fiona Gallagher', 'HR', 75000.00, '2021-08-14'),
    (7, 'George Clark', 'HR', 50000.00, '2022-05-30'),
    (8, 'Hannah Abbott', 'Sales', 90000.00, '2018-04-12'),
    (9, 'Ian Malcolm', 'Sales', 85000.00, '2020-09-18'),
    (10, 'Julia Roberts', 'Sales', 65000.00, '2021-11-01'),
    (11, 'Kevin Bacon', 'Sales', 65000.00, '2023-02-15');
GO

SELECT * FROM Employees;


--Tasks
--Ranking Functions
--1. Assign a Unique Rank to Each Employee Based on Salary
SELECT 
    *,
    ROW_NUMBER() OVER(ORDER BY Salary) AS Rank
FROM Employees;
--2. Find Employees Who Have the Same Salary Rank
SELECT 
    EmployeeID,
    Name,
    Department,
    Salary,
    HireDate,
    SalaryRank     
FROM (
    SELECT 
        *,
        DENSE_RANK() OVER(ORDER BY Salary) AS SalaryRank,
        LAG(Salary) OVER(ORDER BY Salary) AS Previous, 
        LEAD(Salary) OVER(ORDER BY Salary) AS Nextone 
    FROM Employees) AS d
WHERE Salary = Previous OR Salary = Nextone;

--3. Identify the Top 2 Highest Salaries in Each Department
SELECT 
    EmployeeID,
    Name,
    Department,
    Salary,
    HireDate,
    SalaryRank     
FROM (
    SELECT 
        *,
        DENSE_RANK() OVER(PARTITION BY Department ORDER BY Salary) AS SalaryRank
    FROM Employees) AS d
WHERE SalaryRank <= 2;

--4. Find the Lowest-Paid Employee in Each Department
SELECT 
    EmployeeID,
    Name,
    Department,
    Salary,
    HireDate
FROM (
    SELECT 
        *,
        DENSE_RANK() OVER(PARTITION BY Department ORDER BY Salary ASC) AS SalaryRank
    FROM Employees) AS d
WHERE SalaryRank = 1;

--5. Calculate the Running Total of Salaries in Each Department
SELECT
    *,
    SUM(Salary) OVER(PARTITION BY Department ORDER BY Salary) AS Total
FROM Employees;

--6. Find the Total Salary of Each Department Without GROUP BY
SELECT
    DISTINCT Department,
    SUM(Salary) OVER(PARTITION BY Department) AS Total
FROM Employees;

--7. Calculate the Average Salary in Each Department Without GROUP BY
SELECT
    DISTINCT Department,
    AVG(Salary) OVER(PARTITION BY Department) AS Total
FROM Employees;

--8. Find the Difference Between an Employee’s Salary and Their Department’s Average
SELECT
    *,
    Salary - AVG(Salary) OVER(PARTITION BY Department) AS Diff
FROM Employees;

--9. Calculate the Moving Average Salary Over 3 Employees (Including Current, Previous, and Next)
SELECT 
    *,
    AVG(Salary) OVER(ORDER BY EmployeeID ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS MovingAVG
FROM Employees
--10. Find the Sum of Salaries for the Last 3 Hired Employees
SELECT
    SUM(Salary)
FROM (SELECT TOP (3) 
        * 
    FROM Employees
    ORDER BY HireDate) AS T;
--11. Calculate the Running Average of Salaries Over All Previous Employees
SELECT
    *,
    AVG(Salary) OVER(ORDER BY EmployeeID) AS RunningAvgSalary
FROM Employees;

--12. Find the Maximum Salary Over a Sliding Window of 2 Employees Before and After
SELECT
    *,
    MAX(Salary) OVER(ORDER BY HireDate ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING) AS Maxover
FROM Employees
ORDER BY HireDate;

--13. Determine the Percentage Contribution of Each Employee’s Salary to Their Department’s Total Salary
SELECT
    *,
    CAST(Salary * 100.0 / SUM(Salary) OVER(PARTITION BY Department) AS DECIMAL(10,2)) AS SalaryPercent
FROM Employees