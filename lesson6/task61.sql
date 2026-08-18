-- Given Tables:
-- 1. Employees

-- | EmployeeID | Name    | DepartmentID | Salary |
-- |------------|---------|--------------|--------|
-- | 1          | Alice   | 101          | 60000  |
-- | 2          | Bob     | 102          | 70000  |
-- | 3          | Charlie | 101          | 65000  |
-- | 4          | David   | 103          | 72000  |
-- | 5          | Eva     | NULL         | 68000  |
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    DepartmentID INT,
    Salary DECIMAL(10, 2)
);
GO
INSERT INTO Employees (EmployeeID, Name, DepartmentID, Salary) VALUES
(1, 'Alice', 101, 60000),
(2, 'Bob', 102, 70000),
(3, 'Charlie', 101, 65000),
(4, 'David', 103, 72000),
(5, 'Eva', NULL, 68000);
-- 2. Departments

-- | DepartmentID | DepartmentName |
-- |--------------|----------------|
-- | 101          | IT             |
-- | 102          | HR             |
-- | 103          | Finance        |
-- | 104          | Marketing      |
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);
GO
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(101, 'IT'),
(102, 'HR'),
(103, 'Finance'),
(104, 'Marketing');
-- 3. Projects

-- | ProjectID | ProjectName | EmployeeID |
-- |-----------|-------------|------------|
-- | 1         | Alpha       | 1          |
-- | 2         | Beta        | 2          |
-- | 3         | Gamma       | 1          |
-- | 4         | Delta       | 4          |
-- | 5         | Omega       | NULL       |
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(50),
    EmployeeID INT
);
GO
INSERT INTO Projects (ProjectID, ProjectName, EmployeeID) VALUES
(1, 'Alpha', 1),
(2, 'Beta', 2),
(3, 'Gamma', 1),
(4, 'Delta', 4),
(5, 'Omega', NULL);

-- Questions:
-- 1. INNER JOIN
-- Write a query to get a list of employees along with their department names.
SELECT E.*, D.DepartmentName
FROM Employees E
INNER JOIN Departments D ON E.DepartmentID = D.DepartmentID;
-- 2. LEFT JOIN
-- Write a query to list all employees, including those who are not assigned to any department.
SELECT 
    E.*,
    D.DepartmentName
FROM Employees AS E
LEFT JOIN Departments AS D
ON E.DepartmentID=D.DepartmentID;

-- 3. RIGHT JOIN
-- Write a query to list all departments, including those without employees.
SELECT 
    E.*,
    D.DepartmentName
FROM Employees AS E
RIGHT JOIN Departments AS D
ON E.DepartmentID=D.DepartmentID;

-- 4. FULL OUTER JOIN
-- Write a query to retrieve all employees and all departments, even if there’s no match between them.
SELECT 
    E.*,
    D.DepartmentName
FROM Employees AS E
FULL JOIN Departments AS D
ON E.DepartmentID=D.DepartmentID;

-- 5. JOIN with Aggregation
-- Write a query to find the total salary expense for each department.
SELECT
    D.DepartmentName,
    SUM(E.Salary)
FROM Departments AS D
LEFT JOIN Employees AS E
ON E.DepartmentID = D.DepartmentID
GROUP BY D.DepartmentName;

-- 6. CROSS JOIN
-- Write a query to generate all possible combinations of departments and projects.
SELECT
    D.DepartmentName,
    P.ProjectName
FROM  Departments AS D
CROSS JOIN Projects AS P;

-- 7. MULTIPLE JOINS
-- Write a query to get a list of employees with their department names and assigned project names. 
-- Include employees even if they don’t have a project.
SELECT
    e.EmployeeID,
    d.DepartmentName,
    p.ProjectName
FROM Employees AS e
LEFT JOIN Departments AS d
    ON e.DepartmentID = d.DepartmentID
LEFT JOIN Projects AS p
    ON e.EmployeeID = p.EmployeeID;
