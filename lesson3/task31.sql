CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2),
    HireDate DATE
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    Status VARCHAR(20) CHECK (Status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled'))
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Stock INT
);

INSERT INTO Employees (EmployeeID, FirstName, LastName, Department, Salary, HireDate) 
VALUES
(1, 'Anvar', 'Karimov', 'IT', 12000000.00, '2021-03-15'),
(2, 'Dilnoza', 'Alimova', 'HR', 8500000.00, '2020-06-01'),
(3, 'Sardor', 'Rahimov', 'Sales', 9500000.00, '2022-01-10'),
(4, 'Malika', 'Umarova', 'Marketing', 9000000.00, '2019-11-20'),
(5, 'Jasur', 'Toshpulatov', 'IT', 15000000.00, '2018-05-12'),
(6, 'Nigora', 'Ismoilova', 'Finance', 11000000.00, '2021-09-01'),
(7, 'Otabek', 'Yusupov', 'Sales', 7800000.00, '2023-02-15'),
(8, 'Zuhra', 'Xasanova', 'HR', 8000000.00, '2022-08-19'),
(9, 'Bekzod', 'Azimov', 'IT', 13500000.00, '2020-04-10'),
(10, 'Shahnoza', 'Qosimova', 'Finance', 10500000.00, '2023-01-05');

INSERT INTO Orders (OrderID, CustomerName, OrderDate, TotalAmount, Status) 
VALUES
(101, 'Alisher Navoiy Club', '2026-08-01', 150.50, 'Delivered'),
(102, 'Toshkent Trade LLC', '2026-08-02', 320.00, 'Shipped'),
(103, 'Samarqand Logistics', '2026-08-03', 75.25, 'Pending'),
(104, 'Buxoro Express', '2026-08-04', 500.00, 'Delivered'),
(105, 'Vodiy Market', '2026-08-05', 45.00, 'Cancelled'),
(106, 'Oasis Retail', '2026-08-06', 1250.80, 'Shipped'),
(107, 'Global Tech', '2026-08-07', 890.00, 'Delivered'),
(108, 'Mega Auto', '2026-08-08', 210.10, 'Pending'),
(109, 'Uzbekistan Airways Store', '2026-08-09', 1500.00, 'Delivered'),
(110, 'Orient Group', '2026-08-10', 95.99, 'Cancelled');

INSERT INTO Products (ProductID, ProductName, Category, Price, Stock) 
VALUES
(1, 'Laptop Lenovo ThinkPad', 'Electronics', 1200.00, 15),
(2, 'Wireless Mouse', 'Electronics', 25.50, 100),
(3, 'Office Chair Ergonomic', 'Furniture', 180.00, 30),
(4, 'Wooden Desk', 'Furniture', 250.00, 12),
(5, 'Notebook A5', 'Stationery', 3.50, 500),
(6, 'Ballpoint Pen Blue', 'Stationery', 0.80, 1000),
(7, '27-inch Monitor', 'Electronics', 300.00, 25),
(8, 'Mechanical Keyboard', 'Electronics', 85.00, 45),
(9, 'File Folder', 'Stationery', 1.20, 300),
(10, 'Bookshelf 5-Tier', 'Furniture', 120.00, 8);

-- ============================================================================
-- Task 1: Employee Salary Report
-- ============================================================================
--Task 1: Employee Salary Report
--Write an SQL query that:
--Selects the top 10% highest-paid employees.
--Groups them by department and calculates the average salary per department.
--Displays a new column SalaryCategory:
--'High' if Salary > 80,000
--'Medium' if Salary is between 50,000 and 80,000
--'Low' otherwise.
--Orders the result by AverageSalary descending.
--Skips the first 2 records and fetches the next 5.



-- ============================================================================
-- Task 2: Customer Order Insights
-- ============================================================================
--Task 2: Customer Order Insights
--Write an SQL query that:
--Selects customers who placed orders between '2023-01-01' and '2023-12-31'.
--Includes a new column OrderStatus that returns:
--'Completed' for Shipped or Delivered orders.
--'Pending' for Pending orders.
--'Cancelled' for Cancelled orders.
--Groups by OrderStatus and finds the total number of orders and total revenue.
--Filters only statuses where revenue is greater than 5000.
--Orders by TotalRevenue descending.



-- ============================================================================
-- Task 3: Product Inventory Check
-- ============================================================================
--Task 3: Product Inventory Check
--Write an SQL query that:
--Selects distinct product categories.
--Finds the most expensive product in each category.
--Assigns an inventory status using IIF:
--'Out of Stock' if Stock = 0.
--'Low Stock' if Stock is between 1 and 10.
--'In Stock' otherwise.
--Orders the result by Price descending and skips the first 5 rows.