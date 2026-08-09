-- ============================================================================
-- 1. Assign a Unique Rank to Each Employee Based on Salary
-- ============================================================================
SELECT 
    EmployeeID,
    Name,
    Salary,
    ROW_NUMBER() OVER (ORDER BY Salary DESC) AS UniqueRank
FROM Employees;


-- ============================================================================
-- 2. Find Employees Who Have the Same Salary Rank
-- ============================================================================
WITH SalaryRanks AS (
    SELECT 
        EmployeeID,
        Name,
        Salary,
        DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
    FROM Employees
)
SELECT EmployeeID, Name, Salary, SalaryRank
FROM SalaryRanks
WHERE SalaryRank IN (
    SELECT SalaryRank 
    FROM SalaryRanks 
    GROUP BY SalaryRank 
    HAVING COUNT(*) > 1
)
ORDER BY SalaryRank;


-- ============================================================================
-- 3. Identify the Top 2 Highest Salaries in Each Department
-- ============================================================================
WITH DeptSalaries AS (
    SELECT 
        EmployeeID,
        Name,
        Department,
        Salary,
        DENSE_RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS DeptRank
    FROM Employees
)
SELECT EmployeeID, Name, Department, Salary, DeptRank
FROM DeptSalaries
WHERE DeptRank <= 2;


-- ============================================================================
-- 4. Find the Lowest-Paid Employee in Each Department
-- ============================================================================
WITH MinSalaryPerDept AS (
    SELECT 
        EmployeeID,
        Name,
        Department,
        Salary,
        ROW_NUMBER() OVER (PARTITION BY Department ORDER BY Salary ASC) AS RowNum
    FROM Employees
)
SELECT EmployeeID, Name, Department, Salary
FROM MinSalaryPerDept
WHERE RowNum = 1;


-- ============================================================================
-- 5. Calculate the Running Total of Salaries in Each Department
-- ============================================================================
SELECT 
    EmployeeID,
    Name,
    Department,
    Salary,
    HireDate,
    SUM(Salary) OVER (
        PARTITION BY Department 
        ORDER BY HireDate, EmployeeID 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningTotalSalary
FROM Employees;


-- ============================================================================
-- 6. Find the Total Salary of Each Department Without GROUP BY
-- ============================================================================
SELECT 
    EmployeeID,
    Name,
    Department,
    Salary,
    SUM(Salary) OVER (PARTITION BY Department) AS TotalDeptSalary
FROM Employees;


-- ============================================================================
-- 7. Calculate the Average Salary in Each Department Without GROUP BY
-- ============================================================================
SELECT 
    EmployeeID,
    Name,
    Department,
    Salary,
    AVG(Salary) OVER (PARTITION BY Department) AS AvgDeptSalary
FROM Employees;


-- ============================================================================
-- 8. Find the Difference Between an Employee’s Salary and Their Department’s Average
-- ============================================================================
SELECT 
    EmployeeID,
    Name,
    Department,
    Salary,
    Salary - AVG(Salary) OVER (PARTITION BY Department) AS SalaryDifferenceFromAvg
FROM Employees;


-- ============================================================================
-- 9. Calculate the Moving Average Salary Over 3 Employees (Including Current, Previous, and Next)
-- ============================================================================
SELECT 
    EmployeeID,
    Name,
    Salary,
    AVG(Salary) OVER (
        ORDER BY HireDate, EmployeeID 
        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
    ) AS MovingAvgSalary3
FROM Employees;


-- ============================================================================
-- 10. Find the Sum of Salaries for the Last 3 Hired Employees
-- ============================================================================
WITH Last3Hired AS (
    SELECT 
        Salary,
        ROW_NUMBER() OVER (ORDER BY HireDate DESC, EmployeeID DESC) AS RowNum
    FROM Employees
)
SELECT SUM(Salary) AS TotalSalaryLast3Hired
FROM Last3Hired
WHERE RowNum <= 3;


-- ============================================================================
-- 11. Calculate the Running Average of Salaries Over All Previous Employees
-- ============================================================================
SELECT 
    EmployeeID,
    Name,
    Salary,
    HireDate,
    AVG(Salary) OVER (
        ORDER BY HireDate, EmployeeID 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningAvgSalary
FROM Employees;


-- ============================================================================
-- 12. Find the Maximum Salary Over a Sliding Window of 2 Employees Before and After
-- ============================================================================
SELECT 
    EmployeeID,
    Name,
    Salary,
    MAX(Salary) OVER (
        ORDER BY HireDate, EmployeeID 
        ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING
    ) AS MaxSalaryInWindow
FROM Employees;


-- ============================================================================
-- 13. Determine the Percentage Contribution of Each Employee’s Salary to Their Department’s Total Salary
-- ============================================================================
SELECT 
    EmployeeID,
    Name,
    Department,
    Salary,
    CAST((Salary * 100.0 / SUM(Salary) OVER (PARTITION BY Department)) AS DECIMAL(5, 2)) AS SalaryPercentageContribution
FROM Employees;