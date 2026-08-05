-- ============================================================================
-- 1. DELETE vs TRUNCATE vs DROP (with IDENTITY example)
-- ============================================================================
CREATE TABLE test_identity_delete (
    id INT IDENTITY(1,1) PRIMARY KEY,
    val NVARCHAR(50)
);

INSERT INTO test_identity_delete (val) VALUES ('A'), ('B'), ('C'), ('D'), ('E');

DELETE FROM test_identity_delete; 

INSERT INTO test_identity_delete (val) VALUES ('F');
SELECT 'DELETE Natijasi' AS TestType, * FROM test_identity_delete;


CREATE TABLE test_identity_truncate (
    id INT IDENTITY(1,1) PRIMARY KEY,
    val NVARCHAR(50)
);

INSERT INTO test_identity_truncate (val) VALUES ('A'), ('B'), ('C'), ('D'), ('E');

TRUNCATE TABLE test_identity_truncate; 

INSERT INTO test_identity_truncate (val) VALUES ('F');
SELECT 'TRUNCATE Natijasi' AS TestType, * FROM test_identity_truncate;


CREATE TABLE test_identity_drop (
    id INT IDENTITY(1,1) PRIMARY KEY,
    val NVARCHAR(50)
);

DROP TABLE test_identity_drop; 

=== ANSWERS ===
1. What happens to the identity column when you use DELETE?
   -> DELETE ma'lumotlarni o'chiradi, lekin IDENTITY hisoblagichini RESET qilmaydi. Keyingi INSERT oxirgi qiymatdan davom etadi.

2. What happens to the identity column when you use TRUNCATE?
   -> TRUNCATE ma'lumotlarni o'chirib, IDENTITY hisoblagichini boshlang'ich qiymatga (masalan: 1) RESET qiladi.

3. What happens to the table when you use DROP?
   -> DROP jadvalning o'zini, uning strukturasi, ustunlari va constraint'lari bilan birga bazadan butunlay o'chirib tashlaydi.
*/
GO


-- ============================================================================
-- 2. Common Data Types
-- ============================================================================

CREATE TABLE data_types_demo (
    id INT IDENTITY(1,1) PRIMARY KEY,        -- Exact Numeric
    price DECIMAL(10, 2),                   -- Decimal/Numeric
    rating FLOAT,                            -- Approximate Numeric
    product_code VARCHAR(20),                -- Non-Unicode String
    description NVARCHAR(200),               -- Unicode String
    is_active BIT,                           -- Boolean (0 yoki 1)
    created_at DATETIME2 DEFAULT GETDATE(),  -- Date and Time
    item_guid UNIQUEIDENTIFIER DEFAULT NEWID() -- GUID / UUID
);

INSERT INTO data_types_demo (price, rating, product_code, description, is_active)
VALUES (99.99, 4.8, 'PRD-001', N'Noutbuk Dell XPS', 1);

SELECT * FROM data_types_demo;
GO


-- ============================================================================
-- 3. Inserting and Retrieving an Image (SQL part)
-- ============================================================================

CREATE TABLE photos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    image_data VARBINARY(MAX)
);

INSERT INTO photos (image_data)
SELECT * FROM OPENROWSET(BULK 'C:\Images\sample.jpg', SINGLE_BLOB) AS ImageFile;

SELECT id, DATALENGTH(image_data) AS ImageSizeBytes FROM photos;
GO


-- ============================================================================
-- 4. Computed Columns
-- ============================================================================

CREATE TABLE student (
    student_id INT IDENTITY(1,1) PRIMARY KEY,
    student_name NVARCHAR(100),
    classes INT,
    tuition_per_class DECIMAL(10, 2),
    total_tuition AS (classes * tuition_per_class) -- Computed column
);

INSERT INTO student (student_name, classes, tuition_per_class) VALUES 
(N'Ali Valiyev', 4, 150.00),
(N'Sardor Azimov', 5, 200.00),
(N'Madina Umarova', 3, 180.00);

SELECT * FROM student;
GO


-- ============================================================================
-- 5. CSV to SQL Server (BULK INSERT)
-- ============================================================================

CREATE TABLE worker (
    id INT,
    name NVARCHAR(100)
);

BULK INSERT worker
FROM 'C:\data\workers.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 1
);

SELECT * FROM worker;
GO