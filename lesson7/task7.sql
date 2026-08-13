-- ============================================================================
-- SQL ASSIGNMENT SOLUTIONS (COMPREHENSIVE WORKPLACE SCRIPT)
-- ============================================================================
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10,2)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50)
);
-- ----------------------------------------------------------------------------
-- 1️. Retrieve All Customers With Their Orders (Include Customers Without Orders)
-- ----------------------------------------------------------------------------
SELECT 
    c.CustomerID,
    c.CustomerName,
    o.OrderID,
    o.OrderDate
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID;
GO


-- ----------------------------------------------------------------------------
-- 2️. Find Customers Who Have Never Placed an Order
-- ----------------------------------------------------------------------------
SELECT 
    c.CustomerID,
    c.CustomerName
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;
GO


-- ----------------------------------------------------------------------------
-- 3️. List All Orders With Their Products
-- ----------------------------------------------------------------------------
SELECT 
    o.OrderID,
    p.ProductName,
    od.Quantity
FROM Orders o
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID;
GO


-- ----------------------------------------------------------------------------
-- 4️. Find Customers With More Than One Order
-- ----------------------------------------------------------------------------
SELECT 
    c.CustomerID,
    c.CustomerName,
    COUNT(o.OrderID) AS TotalOrders
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING COUNT(o.OrderID) > 1;
GO


-- ----------------------------------------------------------------------------
-- 5️. Find the Most Expensive Product in Each Order
-- ----------------------------------------------------------------------------
WITH RankedProducts AS (
    SELECT 
        od.OrderID,
        p.ProductName,
        od.Price,
        ROW_NUMBER() OVER (PARTITION BY od.OrderID ORDER BY od.Price DESC) AS rn
    FROM OrderDetails od
    INNER JOIN Products p ON od.ProductID = p.ProductID
)
SELECT 
    OrderID,
    ProductName,
    Price AS MaxPrice
FROM RankedProducts
WHERE rn = 1;
GO


-- ----------------------------------------------------------------------------
-- 6️. Find the Latest Order for Each Customer
-- ----------------------------------------------------------------------------
WITH RankedOrders AS (
    SELECT 
        o.CustomerID,
        o.OrderID,
        o.OrderDate,
        ROW_NUMBER() OVER (PARTITION BY o.CustomerID ORDER BY o.OrderDate DESC, o.OrderID DESC) AS rn
    FROM Orders o
)
SELECT 
    r.CustomerID,
    c.CustomerName,
    r.OrderID,
    r.OrderDate
FROM RankedOrders r
INNER JOIN Customers c ON r.CustomerID = c.CustomerID
WHERE r.rn = 1;
GO


-- ----------------------------------------------------------------------------
-- 7️. Find Customers Who Ordered ONLY 'Electronics' Products
-- ----------------------------------------------------------------------------
SELECT 
    c.CustomerID,
    c.CustomerName
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CustomerName
HAVING COUNT(DISTINCT p.Category) = 1 
   AND MAX(p.Category) = 'Electronics';
GO


-- ----------------------------------------------------------------------------
-- 8️. Find Customers Who Ordered at Least One 'Stationery' Product
-- ----------------------------------------------------------------------------
SELECT DISTINCT 
    c.CustomerID,
    c.CustomerName
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
WHERE p.Category = 'Stationery';
GO


-- ----------------------------------------------------------------------------
-- 9️. Find Total Amount Spent by Each Customer
-- ----------------------------------------------------------------------------
SELECT 
    c.CustomerID,
    c.CustomerName,
    ISNULL(SUM(od.Quantity * od.Price), 0) AS TotalSpent
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.CustomerName;
GO