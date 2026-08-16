---=======================================================================
--- Task1
---=======================================================================
DROP TABLE IF EXISTS sales;
CREATE TABLE sales
(
    sales_id INT PRIMARY KEY IDENTITY(1, 1),
    product_name VARCHAR(50),
    date_sold DATE
);

INSERT INTO sales (product_name, date_sold)
VALUES 
    ('apple', '2020-10-05'),
    ('banana', '2020-10-05'),
    ('banana', '2021-01-01'),
    ('cherry', '2020-05-01');

SELECT * FROM sales

SELECT 
    product_name
FROM sales
GROUP BY product_name
HAVING SUM(CASE 
    WHEN YEAR(date_sold) <> 2020 THEN 1  
    ELSE 0 END)=0;

---=======================================================================
--- Task2
---=======================================================================
CREATE TABLE TestTable (
    ID INT PRIMARY KEY,
    Typ VARCHAR(5) NULL,
    Value1 VARCHAR(5) NULL,
    Value2 VARCHAR(5) NULL,
    Value3 VARCHAR(5) NULL
);
GO

INSERT INTO TestTable (ID, Typ, Value1, Value2, Value3) 
VALUES 
(1, 'I', 'a', 'b', NULL)
(2, 'O', 'a', 'd', 'f'),
(3, 'I', 'd', 'b', NULL),
(4, 'O', 'g', 'l', NULL),
(5, 'I', 'z', 'g', 'a'),
(6, 'I', 'z', 'g', 'a'),
(7, 'O', 'a', 'b', 'a'),
(8, 'I', 'a', 'a', 'a');
SELECT * FROM TestTable;
SELECT Typ,
    SUM(CASE 
        WHEN Value1 = 'a' AND Value2 = 'a' AND Value3 = 'a' THEN 3
        WHEN (Value1 = 'a' AND (Value2 = 'a' OR Value3 = 'a')) OR ((Value1 = 'a' OR Value2 = 'a') AND Value3 = 'a') THEN 2
        WHEN Value1 = 'a' OR Value2 = 'a' OR Value3 = 'a' THEN 1
        ELSE 0 END) AS CNT 
FROM TestTable
GROUP BY Typ;

---=======================================================================
--- Task3
---=======================================================================

-- 1. Create Table
CREATE TABLE NullTestTable (
    id INT NULL,
    name VARCHAR(5) NULL,
    typed VARCHAR(5) NULL
);
GO

-- 2. Insert Data
INSERT INTO NullTestTable (id, name, typed)
VALUES 
(1, 'P', NULL),
(1, NULL, 'Q'),
(2, 'A', NULL),
(2, NULL, 'B');
GO

-- 3. Verify inserted data
SELECT * FROM NullTestTable;

SELECT
    id,
    MAX(name) AS name,
    MAX(typed) AS typed
FROM NullTestTable
GROUP BY id;

---=======================================================================
--- Task4
---=======================================================================

SELECT  ROW_NUMBER() over(ORDER BY value) as c FROM string_split(REPLICATE('1,', 99), ',')

---=======================================================================
--- Task5
---=======================================================================