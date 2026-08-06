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
category_id (integer, should be a foreign key referencing category_id  in category table)
First, define the foreign key inside CREATE TABLE.
Then, drop and add the foreign key using ALTER TABLE.*/
CREATE TABLE category
(
	category_id INT PRIMARY KEY,
	category_name varchar(50)
);

CREATE TABLE item
(
	item_id INT PRIMARY KEY,
	item_name varchar(50),
	category_if INT FOREIGN	KEY REFERENCES category(category_id)
);

SELECT 
    CONSTRAINT_NAME 
FROM 
    INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
WHERE 
    TABLE_NAME = 'item' 
    AND CONSTRAINT_TYPE = 'FOREIGN KEY';

ALTER TABLE item
DROP CONSTRAINT FK__item__category_i__04E4BC85;

ALTER TABLE item
add constraint FK_item FOREIGN KEY (category_if) REFERENCES category(category_id)

/*
5. CHECK Constraint
Create a table named account with:
account_id (integer, primary key)
balance (decimal, should always be greater than or equal to 0)
account_type (string, should only accept values 'Saving' or 'Checking')
Use CHECK constraints to enforce these rules.
First, define the constraints inside CREATE TABLE.
Then, drop and re-add the CHECK constraints using ALTER TABLE.*/




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



