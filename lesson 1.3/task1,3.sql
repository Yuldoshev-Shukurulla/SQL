/* 1. NOT NULL Constraint
Create a table named student with columns:
id (integer, should not allow NULL values)
name (string, can allow NULL values)
age (integer, can allow NULL values)
First, create the table without the NOT NULL constraint.
Then, use ALTER TABLE to apply the NOT NULL constraint to the id column.*/

CREATE TABLE student (
	id int,
	name varchar,
	age int);

ALTER TABLE student
ALTER COLUMN id int NOT NULL;

/* 2. UNIQUE Constraint
Create a table named product with the following columns:
product_id (integer, should be unique)
product_name (string, no constraint)
price (decimal, no constraint)
First, define product_id as UNIQUE inside the CREATE TABLE statement.
Then, drop the unique constraint and add it again using ALTER TABLE.
Extend the constraint so that the combination of product_id and product_name must be unique.*/

CREATE TABLE product (
	product_id int CONSTRAINT UQ_product_id UNIQUE,
	product_name varchar(100),
	price decimal(10, 2));

ALTER TABLE product
DROP CONSTRAINT UQ_product_id;

ALTER TABLE product
ADD CONSTRAINT UQ_product_id_name UNIQUE (product_id, product_name);

/* . PRIMARY KEY Constraint
Create a table named orders with:
order_id (integer, should be the primary key)
customer_name (string, no constraint)
order_date (date, no constraint)
First, define the primary key inside the CREATE TABLE statement.
Then, drop the primary key and add it again using ALTER TABLE.*/

CREATE TABLE orders (
	order_id int CONSTRAINT PK_order_id PRIMARY KEY,
	customer_name varchar(100),
	order_date date);

ALTER TABLE orders
DROP CONSTRAINT PK_order_id;

ALTER TABLE orders
ADD CONSTRAINT PK_order_id PRIMARY KEY (order_id);

/*4. FOREIGN KEY Constraint
Create two tables:
category:
category_id (integer, primary key)
category_name (string)
item:
item_id (integer, primary key)
item_name (string)
category_id (integer, should be a foreign key referencing category_id in category table)
First, define the foreign key inside CREATE TABLE.
Then, drop and add the foreign key using ALTER TABLE.*/
CREATE TABLE category (
    category_id INT CONSTRAINT PK_category PRIMARY KEY,
    category_name NVARCHAR(100)
);

CREATE TABLE item (
    item_id INT CONSTRAINT PK_item PRIMARY KEY,
    item_name NVARCHAR(100),
    category_id INT CONSTRAINT FK_item_category FOREIGN KEY REFERENCES category(category_id)
);

ALTER TABLE item
DROP CONSTRAINT FK_item_category;

ALTER TABLE item
ADD CONSTRAINT FK_item_category FOREIGN KEY (category_id) REFERENCES category(category_id);
GO


/*5. CHECK Constraint
Create a table named account with:
account_id (integer, primary key)
balance (decimal, should always be greater than or equal to 0)
account_type (string, should only accept values 'Saving' or 'Checking')
Use CHECK constraints to enforce these rules.
First, define the constraints inside CREATE TABLE.
Then, drop and re-add the CHECK constraints using ALTER TABLE.*/
CREATE TABLE account (
    account_id INT CONSTRAINT PK_account PRIMARY KEY,
    balance DECIMAL(18, 2) CONSTRAINT CHK_account_balance CHECK (balance >= 0),
    account_type NVARCHAR(20) CONSTRAINT CHK_account_type CHECK (account_type IN ('Saving', 'Checking'))
);
ALTER TABLE account DROP CONSTRAINT CHK_account_balance;
ALTER TABLE account DROP CONSTRAINT CHK_account_type;

ALTER TABLE account ADD CONSTRAINT CHK_account_balance CHECK (balance >= 0);
ALTER TABLE account ADD CONSTRAINT CHK_account_type CHECK (account_type IN ('Saving', 'Checking'));


/*6. DEFAULT Constraint
Create a table named customer with:
customer_id (integer, primary key)
name (string, no constraint)
city (string, should have a default value of 'Unknown')
First, define the default value inside CREATE TABLE.
Then, drop and re-add the default constraint using ALTER TABLE.*/
CREATE TABLE customer (
    customer_id INT CONSTRAINT PK_customer PRIMARY KEY,
    name NVARCHAR(100),
    city NVARCHAR(100) CONSTRAINT DF_customer_city DEFAULT 'Unknown'
);
ALTER TABLE customer DROP CONSTRAINT DF_customer_city;

ALTER TABLE customer ADD CONSTRAINT DF_customer_city DEFAULT 'Unknown' FOR city;
GO
/*7. IDENTITY Column
Create a table named invoice with:
invoice_id (integer, should auto-increment starting from 1)
amount (decimal, no constraint)
Insert 5 rows into the table without specifying invoice_id.
Enable and disable IDENTITY_INSERT, then manually insert a row with invoice_id = 100.*/
 
 CREATE TABLE invoice (
    invoice_id INT IDENTITY(1,1) CONSTRAINT PK_invoice PRIMARY KEY,
    amount DECIMAL(10, 2)
);

INSERT INTO invoice (amount) VALUES (100.50), (250.00), (75.25), (430.00), (120.00);
SET IDENTITY_INSERT invoice ON;

INSERT INTO invoice (invoice_id, amount) VALUES (100, 999.99);

SET IDENTITY_INSERT invoice OFF;
GO
 /*8. All at once
Create a books table with:
book_id (integer, primary key, auto-increment)
title (string, must not be empty)
price (decimal, must be greater than 0)
genre (string, default should be 'Unknown')
Insert data and test if all constraints work as expected.*/
CREATE TABLE books (
    book_id INT IDENTITY(1,1) CONSTRAINT PK_books PRIMARY KEY,
    title NVARCHAR(200) NOT NULL CONSTRAINT CHK_books_title CHECK (title <> ''),
    price DECIMAL(10, 2) CONSTRAINT CHK_books_price CHECK (price > 0),
    genre NVARCHAR(50) CONSTRAINT DF_books_genre DEFAULT 'Unknown'
);
INSERT INTO books (title, price, genre) VALUES (N'Otkan kunlar', 45000, N'Romantika');
/*9. Scenario: Library Management System
You need to design a simple database for a library where books are borrowed by members.

Tables and Columns:
1. Book (Stores information about books)

book_id (Primary Key)
title (Text)
author (Text)
published_year (Integer)
2. Member (Stores information about library members)

member_id (Primary Key)
name (Text)
email (Text)
phone_number (Text)
3. Loan (Tracks which members borrow which books)

loan_id (Primary Key)
book_id (Foreign Key → References book.book_id)
member_id (Foreign Key → References member.member_id)
loan_date (Date)
return_date (Date, can be NULL if not returned yet)
Tasks:
1. Understand Relationships

A member can borrow multiple books.
A book can be borrowed by different members at different times.
The Loan table connects Book and Member (Many-to-Many).
2. Write SQL Statements

Create the tables with proper constraints (Primary Key, Foreign Key).
Insert at least 2-3 sample records into each table.*/


CREATE TABLE Loan (
    loan_id INT IDENTITY(1,1) CONSTRAINT PK_Loan PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    loan_date DATE NOT NULL,
    return_date DATE NULL,
    CONSTRAINT FK_Loan_Book FOREIGN KEY (book_id) REFERENCES Book(book_id),
    CONSTRAINT FK_Loan_Member FOREIGN KEY (member_id) REFERENCES Member(member_id)
);



INSERT INTO Book (title, author, published_year) VALUES 
(N'Usta va Margarita', N'Mixail Bulgakov', 1967),
(N'Sariq devni minib', N'Xudoyberdi Toxtaboyev', 1968),
(N'Shum bola', N'Gafur Gulom', 1936);

INSERT INTO Member (name, email, phone_number) VALUES 
(N'Ali Valiyev', 'ali@gmail.com', '+998901234567'),
(N'Sardor Azimov', 'sardor@gmail.com', '+998919876543');

INSERT INTO Loan (book_id, member_id, loan_date, return_date) VALUES 
(1, 1, '2026-07-01', '2026-07-15'), -- Qaytarilgan
(2, 1, '2026-08-01', NULL),          -- Hali qaytarilmagan
(3, 2, '2026-08-03', NULL);          -- Hali qaytarilmagan

