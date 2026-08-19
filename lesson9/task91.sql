-- Task 1
-- Given this Employee table below, find the level of depth each employee from the President.
CREATE TABLE Employees
(
    EmployeeID  INTEGER PRIMARY KEY,
    ManagerID   INTEGER NULL,
    JobTitle    VARCHAR(100) NOT NULL
);
INSERT INTO Employees (EmployeeID, ManagerID, JobTitle) 
VALUES
    (1001, NULL, 'President'),
    (2002, 1001, 'Director'),
    (3003, 1001, 'Office Manager'),
    (4004, 2002, 'Engineer'),
    (5005, 2002, 'Engineer'),
    (6006, 2002, 'Engineer');
-- Expected Output:
-- | EmployeeID | ManagerID | JobTitle       | Depth |
-- |------------|-----------|----------------|-------|
-- | 1001       | NULL      | President      | 0     |
-- | 2002       | 1001      | Director       | 1     |
-- | 3003       | 1001      | Office Manager | 1     |
-- | 4004       | 2002      | Engineer       | 2     |
-- | 5005       | 2002      | Engineer       | 2     |
-- | 6006       | 2002      | Engineer       | 2     |
-- ---
WITH CTE AS (
    SELECT *, 0 as depth FROM Employees Where ManagerID is null
    UNION ALL
    select emp.*, depth + 1 FROM Employees emp JOIN CTE ON emp.ManagerID=CTE.EmployeeID 
)
SELECT * FROM CTE;


-- Task 2
-- Find Factorials up to N.
-- Expected output for N = 10:
-- | Num | Factorial |
-- |-----|-----------|
-- | 1   | 1         |
-- | 2   | 2         |
-- | 3   | 6         |
-- | 4   | 24        |
-- | 5   | 120       |
-- | 6   | 720       |
-- | 7   | 5040      |
-- | 8   | 40320     |
-- | 9   | 362880    |
-- | 10  | 3628800   |
declare @N int = 10;
WITH CTE AS(
    SELECT 1 as Num, 1 as Factorial
    UNION ALL
    SELECT Num + 1, Factorial*(Num+1)
    FROM CTE
    WHERE NUM < @N
)
SELECT * FROM CTE;
-- ---
-- Task 3
-- Find Fibonacci numbers up to N.
-- Expected output for N = 10:
-- | n  | Fibonacci_Number |
-- |----|------------------|
-- | 1  | 1                |
-- | 2  | 1                |
-- | 3  | 2                |
-- | 4  | 3                |
-- | 5  | 5                |
-- | 6  | 8                |
-- | 7  | 13               |
-- | 8  | 21               |
-- | 9  | 34               |
-- | 10 | 55               |

declare @N int = 10;
WITH CTE AS(
    SELECT 1 as n, 1 as Fibonacci_Number, 0 as Previous
    UNION ALL
    SELECT n + 1, Fibonacci_Number + Previous, Fibonacci_Number
    FROM CTE
    WHERE n < @N
)
SELECT n, Fibonacci_Number FROM CTE;