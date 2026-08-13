-- ============================================================================
-- 1. DELETE vs TRUNCATE vs DROP (with IDENTITY example)
-- ============================================================================
--1. DELETE vs TRUNCATE vs DROP (with IDENTITY example)
--Create a table test_identity with an IDENTITY(1,1) column and insert 5 rows.
--Use DELETE, TRUNCATE, and DROP one by one (in different test cases) and observe 
--how they behave.
--Answer the following questions:
--1. What happens to the identity column when you use DELETE? 2. What happens
--to the identity column when you use TRUNCATE? 3. What happens to the table when you use DROP?
CREATE TABLE test_identity
(
	id INT IDENTITY(1, 1) PRIMARY KEY,
	val VARCHAR(50)
);

INSERT INTO test_identity (val)
VALUES ('A'), ('B'), ('C'), ('D'), ('E');
SELECT * FROM test_identity;
DELETE FROM test_identity;
INSERT INTO test_identity (val)
VALUES ('F');
TRUNCATE TABLE test_identity;
DROP TABLE test_identity;

-- ============================================================================
-- 2. Common Data Types
-- ============================================================================

--2. Common Data Types
--Create a table data_types_demo with columns covering at least one example of each data type covered in class.
--Insert values into the table.
--Retrieve and display the values.


 -- Exact Numeric
 -- Decimal/Numeric
 -- Approximate Numeric
 -- Non-Unicode String
 -- Unicode String
 -- Boolean (0 yoki 1)
 -- Date and Time
 -- GUID / UUID

CREATE TABLE data_types_demo
(
	id INT IDENTITY(1, 1) PRIMARY KEY,
	price DECIMAL(10, 2),
	description VARCHAR(50),
	name NVARCHAR(50),
	true_false BIT,
	a_time DATETIME DEFAULT GETDATE(),
	un_id UNIQUEIDENTIFIER DEFAULT NEWID()
);

INSERT INTO data_types_demo (price, description, name, true_false, a_time)
VALUES (10.5, 'asdasd', 'asdasda', 1, '20260218')
SELECT * FROM data_types_demo


-- ============================================================================
-- 3. Inserting and Retrieving an Image (SQL part)
-- ============================================================================
--3. Inserting and Retrieving an Image
--Create a photos table with an id column and a varbinary(max) column.
--Insert an image into the table using OPENROWSET.
--Write a Python script to retrieve the image and save it as a file.

drop table if exists imagea;
CREATE TABLE imagea
(
	id int IDENTITY(1, 1),
	image varbinary(max)
);

INSERT INTO imagea (image)
SELECT BulkColumn FROM OPENROWSET(BULK 'C:\images.jpg', SINGLE_BLOB) AS A;

SELECT id, DATALENGTH(image) AS ImageSizeBytes FROM imagea;

-- ============================================================================
-- 4. Computed Columns
-- ============================================================================
--4. Computed Columns
--Create a student table with a computed column total_tuition as classes * tuition_per_class.
--Insert 3 sample rows.
--Retrieve all data and check if the computed column works correctly.



-- ============================================================================
-- 5. CSV to SQL Server (BULK INSERT)
-- ============================================================================
--5. CSV to SQL Server
--Download or create a CSV file with at least 5 rows of worker data (id, name).
--Use BULK INSERT to import the CSV file into the worker table.
--Verify the imported data.
