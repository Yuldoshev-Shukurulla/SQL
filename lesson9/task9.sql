-- ============================================================================
-- Task 1: Level of depth each employee from the President.
-- ============================================================================
WITH EmployeeHierarchy AS (
    SELECT 
        EmployeeID,
        ManagerID,
        JobTitle,
        0 AS Depth
    FROM Employees
    WHERE ManagerID IS NULL

    UNION ALL

    SELECT 
        e.EmployeeID,
        e.ManagerID,
        e.JobTitle,
        h.Depth + 1 AS Depth
    FROM Employees e
    INNER JOIN EmployeeHierarchy h 
        ON e.ManagerID = h.EmployeeID
)
SELECT 
    EmployeeID,
    ManagerID,
    JobTitle,
    Depth
FROM EmployeeHierarchy
ORDER BY EmployeeID;

-- ============================================================================
-- Task 2: Factorials up to N.
-- ============================================================================
DECLARE @N INT = 10;

WITH FactorialCTE AS (
    SELECT 
        1 AS Num, 
        CAST(1 AS BIGINT) AS Factorial

    UNION ALL

    SELECT 
        Num + 1, 
        Factorial * (Num + 1)
    FROM FactorialCTE
    WHERE Num < @N
)
SELECT 
    Num, 
    Factorial
FROM FactorialCTE;

-- ============================================================================
-- Task 3: Fibonacci Sequence Up to N.
-- ============================================================================
DECLARE @N INT = 10;

WITH FibonacciCTE AS (
    SELECT 
        1 AS n, 
        CAST(1 AS BIGINT) AS Fibonacci_Number,
        CAST(0 AS BIGINT) AS Prev_Number

    UNION ALL

    SELECT 
        n + 1, 
        Fibonacci_Number + Prev_Number,
        Fibonacci_Number
    FROM FibonacciCTE
    WHERE n < @N
)
SELECT 
    n, 
    Fibonacci_Number
FROM FibonacciCTE;
