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



