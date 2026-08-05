-- ============================================================================
-- Task 1: Employee Salary Report
-- ============================================================================


WITH HighestPaidEmployees AS (
    SELECT TOP (10) PERCENT 
        EmployeeID,
        FirstName,
        LastName,
        Department,
        Salary,
        CASE 
            WHEN Salary > 80000 THEN 'High'
            WHEN Salary BETWEEN 50000 AND 80000 THEN 'Medium'
            ELSE 'Low'
        END AS SalaryCategory
    FROM Employees
    ORDER BY Salary DESC
)
SELECT 
    Department,
    SalaryCategory,
    AVG(Salary) AS AverageSalary
FROM HighestPaidEmployees
GROUP BY Department, SalaryCategory
ORDER BY AverageSalary DESC
OFFSET 2 ROWS 
FETCH NEXT 5 ROWS ONLY;
GO


-- ============================================================================
-- Task 2: Customer Order Insights
-- ============================================================================


SELECT 
    CASE 
        WHEN Status IN ('Shipped', 'Delivered') THEN 'Completed'
        WHEN Status = 'Pending' THEN 'Pending'
        WHEN Status = 'Cancelled' THEN 'Cancelled'
    END AS OrderStatus,
    COUNT(OrderID) AS TotalOrders,
    SUM(TotalAmount) AS TotalRevenue
FROM Orders
WHERE OrderDate BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY 
    CASE 
        WHEN Status IN ('Shipped', 'Delivered') THEN 'Completed'
        WHEN Status = 'Pending' THEN 'Pending'
        WHEN Status = 'Cancelled' THEN 'Cancelled'
    END
HAVING SUM(TotalAmount) > 5000
ORDER BY TotalRevenue DESC;
GO


-- ============================================================================
-- Task 3: Product Inventory Check
-- ============================================================================


WITH CategorizedProducts AS (
    SELECT 
        Category,
        ProductName,
        Price,
        Stock,
        IIF(Stock = 0, 'Out of Stock', 
            IIF(Stock BETWEEN 1 AND 10, 'Low Stock', 'In Stock')) AS InventoryStatus,
        ROW_NUMBER() OVER(PARTITION BY Category ORDER BY Price DESC) AS RowNum
    FROM Products
)
SELECT 
    Category,
    ProductName,
    Price,
    InventoryStatus
FROM CategorizedProducts
WHERE RowNum = 1
ORDER BY Price DESC
OFFSET 5 ROWS;
GO