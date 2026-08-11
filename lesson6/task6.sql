-- ============================================================================
-- JADVALLARNI YARATISH VA NA'MUNA MA'LUMOTLARNI KIRITISH
-- ============================================================================

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    DepartmentID INT FOREIGN KEY REFERENCES Departments(DepartmentID),
    Salary DECIMAL(10,2)
);

CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(50),
    EmployeeID INT FOREIGN KEY REFERENCES Employees(EmployeeID)
);
GO

-- Ma'lumotlarni joylash
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
    (101, 'IT'),
    (102, 'HR'),
    (103, 'Finance'),
    (104, 'Marketing');

INSERT INTO Employees (EmployeeID, Name, DepartmentID, Salary) VALUES
    (1, 'Alice', 101, 60000),
    (2, 'Bob', 102, 70000),
    (3, 'Charlie', 101, 65000),
    (4, 'David', 103, 72000),
    (5, 'Eva', NULL, 68000);

INSERT INTO Projects (ProjectID, ProjectName, EmployeeID) VALUES
    (1, 'Alpha', 1),
    (2, 'Beta', 2),
    (3, 'Gamma', 1),
    (4, 'Delta', 4),
    (5, 'Omega', NULL);
GO


-- ============================================================================
-- 1. INNER JOIN: Bo'limi bor xodimlarni va ularning bo'lim nomlarini olish
-- ============================================================================
SELECT 
    e.EmployeeID, 
    e.Name AS EmployeeName, 
    d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;
GO


-- ============================================================================
-- 2. LEFT JOIN: Barcha xodimlarni chiqarish (bo'limi yo'q xodimlarni ham)
-- ============================================================================
SELECT 
    e.EmployeeID, 
    e.Name AS EmployeeName, 
    d.DepartmentName
FROM Employees e
LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID;
GO


-- ============================================================================
-- 3. RIGHT JOIN: Barcha bo'limlarni chiqarish (xodimi yo'q bo'limlarni ham)
-- ============================================================================
SELECT 
    e.EmployeeID, 
    e.Name AS EmployeeName, 
    d.DepartmentID, 
    d.DepartmentName
FROM Employees e
RIGHT JOIN Departments d ON e.DepartmentID = d.DepartmentID;
GO


-- ============================================================================
-- 4. FULL OUTER JOIN: Barcha xodimlar va barcha bo'limlarni to'liq chiqarish
-- ============================================================================
SELECT 
    e.EmployeeID, 
    e.Name AS EmployeeName, 
    d.DepartmentID, 
    d.DepartmentName
FROM Employees e
FULL OUTER JOIN Departments d ON e.DepartmentID = d.DepartmentID;
GO


-- ============================================================================
-- 5. JOIN with Aggregation: Har bir bo'limning umumiy maosh xarajatini topish
-- ============================================================================
SELECT 
    d.DepartmentID, 
    d.DepartmentName, 
    ISNULL(SUM(e.Salary), 0) AS TotalSalaryExpense
FROM Departments d
LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentID, d.DepartmentName;
GO


-- ============================================================================
-- 6. CROSS JOIN: Bo'lim va loyihalarning barcha kombinatsiyalarini hosil qilish
-- ============================================================================
SELECT 
    d.DepartmentName, 
    p.ProjectName
FROM Departments d
CROSS JOIN Projects p;
GO


-- ============================================================================
-- 7. MULTIPLE JOINS: Xodimlarni ularning bo'limi va loyihalari bilan chiqarish
-- ============================================================================
SELECT 
    e.EmployeeID, 
    e.Name AS EmployeeName, 
    d.DepartmentName, 
    p.ProjectName
FROM Employees e
LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID
LEFT JOIN Projects p ON e.EmployeeID = p.EmployeeID;
GO