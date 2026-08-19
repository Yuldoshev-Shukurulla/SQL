--/*
--Guidelines:
--There are 5 puzzles in the practical part of the exam.
--Provide your solution for each puzzle in the 
--solution sections.

--Before the start don't forget to create 
--the "finalexam" database using the 
--query below:
--*/

create database finalexam;
go
use finalexam

-------------------------------------------------------------------------------------------------------------------------

----PUZZLE 1(Max score: 20):
--/*	
--Find athletes who competed for different countries across multiple Olympic games. 
--An athlete is considered to have multiple teams if they appear in the dataset representing
--different countries in different Olympic competitions.
--Return all competition records for athletes who represented more than one country. 
--Output the athlete name, country, games, sport, and medal for each of their competitions.
--*/
CREATE TABLE olympic_games_athletes (
    id BIGINT,
    name VARCHAR(255),
    sex VARCHAR(10),
    age BIGINT,
    height BIGINT,
    weight BIGINT,
    team VARCHAR(255),
    city VARCHAR(100),
    sport VARCHAR(100),
    event VARCHAR(255),
    medal VARCHAR(50),
    season VARCHAR(50),
    games VARCHAR(50),
    year BIGINT
);

INSERT INTO olympic_games_athletes
(id, name, sex, age, height, weight, team, city, sport, event, medal, season, games, year)
VALUES
(1, 'Alex Johnson', 'M', 24, 180, 75, 'USA', 'London', 'Athletics', '100m Sprint', 'Gold', 'Summer', '2012 Summer', 2012),
(2, 'Alex Johnson', 'M', 28, 180, 76, 'Canada', 'Rio de Janeiro', 'Athletics', '100m Sprint', 'Silver', 'Summer', '2016 Summer', 2016),
(3, 'Maria Petrova', 'F', 22, 170, 60, 'Russia', 'Beijing', 'Gymnastics', 'Floor Exercise', 'Bronze', 'Summer', '2008 Summer', 2008),
(4, 'Maria Petrova', 'F', 26, 171, 61, 'Ukraine', 'London', 'Gymnastics', 'Floor Exercise', NULL, 'Summer', '2012 Summer', 2012),
(5, 'Maria Petrova', 'F', 30, 172, 62, 'Germany', 'Rio de Janeiro', 'Gymnastics', 'Floor Exercise', 'Silver', 'Summer', '2016 Summer', 2016),
(6, 'John Smith', 'M', 27, 185, 82, 'UK', 'Tokyo', 'Swimming', '200m Freestyle', 'Gold', 'Summer', '2020 Summer', 2020),
(7, 'Li Wei', 'M', 23, 178, 70, 'China', 'London', 'Table Tennis', 'Singles', 'Gold', 'Summer', '2012 Summer', 2012),
(8, 'Li Wei', 'M', 27, 179, 71, 'China', 'Rio de Janeiro', 'Table Tennis', 'Singles', 'Gold', 'Summer', '2016 Summer', 2016);

---- SOLUTION
SELECT 
    Name,
    team AS country,
    games,
    sport,
    medal
FROM olympic_games_athletes
WHERE name IN(
    SELECT name
    FROM olympic_games_athletes
    GROUP BY name
    HAVING COUNT(DISTINCT team)>1)
ORDER BY name, year

    
---- EXPECTED OUTPUT
--/*
--name			country		games			sport		medal
--Alex Johnson	  USA	  2012 Summer     Athletics	    Gold
--Alex Johnson	 Canada	  2016 Summer	  Athletics	   Silver
--Maria Petrova	 Russia	  2008 Summer	  Gymnastics	Bronze
--Maria Petrova	 Ukraine  2012 Summer	  Gymnastics	NULL
--Maria Petrova	 Germany  2016 Summer	  Gymnastics	Silver
--*/

-------------------------------------------------------------------------------------------------------------------------------
----PUZZLE 2(Max Score: 15):
--/*
--Count the number of unique users per day who logged in from either a mobile device or web. 
--Output the date and the corresponding number of users.
--*/

CREATE TABLE mobile_logs (
    log_date DATE,
    user_id VARCHAR(100)
);

CREATE TABLE web_logs (
    log_date DATE,
    user_id VARCHAR(100)
);

INSERT INTO mobile_logs (log_date, user_id) VALUES
('2024-01-01', 'U1'),
('2024-01-01', 'U2'),
('2024-01-01', 'U3'),
('2024-01-02', 'U1'),
('2024-01-02', 'U4'),
('2024-01-03', 'U2'),
('2024-01-03', 'U5');

INSERT INTO web_logs (log_date, user_id) VALUES
('2024-01-01', 'U2'),
('2024-01-01', 'U3'),
('2024-01-01', 'U6'),
('2024-01-02', 'U1'),
('2024-01-02', 'U3'),
('2024-01-03', 'U5'),
('2024-01-03', 'U7');

----SOLUTION

SELECT
    log_date,
    COUNT(DISTINCT user_id) AS unique_users
FROM(
    SELECT 
        log_date,
        user_id
    FROM mobile_logs
    UNION
    SELECT 
        log_date, 
        user_id
    FROM web_logs) as T
GROUP BY log_date
ORDER BY log_date;



---- EXPECTED OUTPUT:
--/*
--log_date	  unique_users
--2024-01-01	      4
--2024-01-02	      3
--2024-01-03	      3
--*/

---------------------------------------------------------------------------------------------------------------------------------

----PUZZLE 3(Max Score: 15):
--/*
--Write a query that identifies cities with higher than average home prices when compared to 
--the national average. 
--Output the city names.
--*/

CREATE TABLE zillow_transactions (
    id BIGINT,
    street_address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(50),
    mkt_price BIGINT
);

INSERT INTO zillow_transactions (id, street_address, city, state, mkt_price) VALUES
(1, '123 Main St', 'New York', 'NY', 1200000),
(2, '456 Park Ave', 'New York', 'NY', 1350000),
(3, '789 Market St', 'San Francisco', 'CA', 1500000),
(4, '101 Castro St', 'San Francisco', 'CA', 1600000),
(5, '202 Lake Shore Dr', 'Chicago', 'IL', 600000),
(6, '303 Michigan Ave', 'Chicago', 'IL', 650000),
(7, '404 Elm St', 'Dallas', 'TX', 400000),
(8, '505 Pine St', 'Dallas', 'TX', 420000),
(9, '606 Peach St', 'Atlanta', 'GA', 350000),
(10, '707 Oak St', 'Atlanta', 'GA', 370000);

----SOLUTION
SELECT
    city
FROM zillow_transactions
GROUP BY city
HAVING AVG(mkt_price) > (SELECT AVG(mkt_price) FROM zillow_transactions)
ORDER BY city

----EXPECTED OUTPUT
--/*
--city
--New York
--San Francisco
--*/
---------------------------------------------------------------------------------------------------------------------------------

----PUZZLE 4(Max Score: 25):
--/*
--Find the genre of the person with the most number of oscar winnings.
--If there are more than one person with the same number of oscar wins, 
--return the first one in alphabetic order based on their name. Use the names as keys 
--when joining the tables.
--*/

DROP TABLE IF EXISTS oscar_nominees;
DROP TABLE IF EXISTS nominee_information;

CREATE TABLE oscar_nominees (
    id BIGINT,
    category VARCHAR(100),
    movie VARCHAR(200),
    nominee VARCHAR(100),
    winner BIT,
    year BIGINT
);

CREATE TABLE nominee_information (
    id BIGINT,
    amg_person_id VARCHAR(50),
    name VARCHAR(100),
    birthday DATE,
    top_genre VARCHAR(50)
);

INSERT INTO nominee_information (id, amg_person_id, name, birthday, top_genre) VALUES
(1, 'P001', 'Alice Johnson', '1980-05-10', 'Drama'),
(2, 'P002', 'Bob Smith', '1975-03-22', 'Action'),
(3, 'P003', 'Charlie Brown', '1982-11-01', 'Comedy');

INSERT INTO oscar_nominees (id, category, movie, nominee, winner, year) VALUES
(1, 'Best Actress', 'Movie A', 'Alice Johnson', 1, 2018),
(2, 'Best Actress', 'Movie B', 'Alice Johnson', 1, 2019),
(3, 'Best Actor', 'Movie C', 'Bob Smith', 1, 2017),
(4, 'Best Actor', 'Movie D', 'Bob Smith', 1, 2018),
(5, 'Best Actor', 'Movie E', 'Charlie Brown', 1, 2020);


----SOLUTION 
SELECT top 1
    n.top_genre
FROM oscar_nominees AS o
JOIN nominee_information AS n
ON o.nominee = n.name
GROUP BY n.name, n.top_genre
ORDER BY COUNT(*) DESC, n.name ASC

----EXPECTED OUTPUT
--/*
--	top_genre
--	 Drama
--*/


---------------------------------------------------------------------------------------------------------------------------------
-- --PUZZLE 5(Max Score:10):
-- /*
-- Find the total cost of each customer's orders. 
-- Output customer's id, first name, and the total order cost. Order records by customer's first name alphabetically.
-- */

 CREATE TABLE customers (
    id BIGINT,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    phone_number VARCHAR(50),
    address VARCHAR(255),
    city VARCHAR(100)
);

CREATE TABLE orders (
    id BIGINT,
    cust_id BIGINT,
    order_date DATE,
    order_details VARCHAR(255),
    total_order_cost BIGINT
);

INSERT INTO customers (id, first_name, last_name, phone_number, address, city) VALUES
(1, 'Alice', 'Brown', '111-111', '10 Main St', 'New York'),
(2, 'Bob', 'Smith', '222-222', '20 Oak St', 'Chicago'),
(3, 'Charlie', 'Davis', '333-333', '30 Pine St', 'Dallas');

INSERT INTO orders (id, cust_id, order_date, order_details, total_order_cost) VALUES
(101, 1, '2024-01-01', 'Electronics', 500),
(102, 1, '2024-01-05', 'Accessories', 300),
(103, 2, '2024-01-02', 'Furniture', 800),
(104, 2, '2024-01-06', 'Office Supplies', 200),
(105, 3, '2024-01-03', 'Groceries', 150);
----SOLUTION 
SELECT
    o.cust_id,
    c.first_name,
    SUM(o.total_order_cost) AS total_order_cost
FROM orders AS o
JOIN customers AS c
ON o.cust_id=c.id
GROUP BY o.cust_id, c.first_name

--/*
--customer_id		first_name	 total_order_cost
--1				  Alice			800
--2				   Bob		    1000
--3				 Charlie	    150
--*/
