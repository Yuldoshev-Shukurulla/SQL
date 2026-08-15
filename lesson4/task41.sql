-- ============================================================================
-- Task 1: Barcha ustunlari 0 bo'lgan qatorlarni yashirish
-- ============================================================================
--Task 1:
--If all the columns having zero value then don't show that row.

CREATE TABLE [dbo].[TestMultipleZero]
(
    [A] [int] NULL,
    [B] [int] NULL,
    [C] [int] NULL,
    [D] [int] NULL
);
GO

INSERT INTO [dbo].[TestMultipleZero](A,B,C,D)
VALUES 
    (0,0,0,1),
    (0,0,1,0),
    (0,1,0,0),
    (1,0,0,0),
    (0,0,0,0),
    (1,1,1,0);

SELECT * FROM TestMultipleZero
WHERE A+B+C+D>0;



-- ============================================================================
-- Task 2: Bir nechta ustunlar orasidan eng katta qiymatni (MAX) topish
-- ============================================================================
--Task 2
--Write a query which will find maximum value from multiple columns of the table.

CREATE TABLE TestMax
(
    Year1 INT,
    Max1 INT,
    Max2 INT,
    Max3 INT
);
GO
 
INSERT INTO TestMax 
VALUES
    (2001,10,101,87),
    (2002,103,19,88),
    (2003,21,23,89),
    (2004,27,28,91);

SELECT 
    Year1,
    GREATEST(Max1, Max2, Max3) AS HighestValue
    FROM TestMax

-- ============================================================================
-- Task 3: Tug'ilgan kuni 7-May va 15-May oralig'ida bo'lgan xodimlarni topish
-- ============================================================================
--Task 3
--Write a query which will find the Date of Birth of employees whose birthdays lies between May 7 and May 15.

CREATE TABLE EmpBirth
(
    EmpId INT  IDENTITY(1,1), 
    EmpName VARCHAR(50), 
    BirthDate DATETIME 
);
GO
 
INSERT INTO EmpBirth(EmpName,BirthDate)
SELECT 'Pawan' , '12/04/1983'
UNION ALL
SELECT 'Zuzu' , '11/28/1986'
UNION ALL
SELECT 'Parveen', '05/07/1977'
UNION ALL
SELECT 'Mahesh', '01/13/1983'
UNION ALL
SELECT'Ramesh', '05/09/1983';

SELECT * FROM EmpBirth
WHERE MONTH(BirthDate) = 5 AND DAY(BirthDate) BETWEEN 7 AND 15


-- ============================================================================
-- Task 4: Harflarni saralash ('b' harfini birinchi, oxirgi va 3-o'ringa qo'yish)
-- ============================================================================
--Task 4
--Order letters but 'b' must be first/last
--Order letters but 'b' must be 3rd (Optional)

create table letters
(letter char(1));
GO
insert into letters
values ('a'), ('a'), ('a'), 
  ('b'), ('c'), ('d'), ('e'), ('f');

SELECT * FROM letters
ORDER BY CASE WHEN letter = 'b' THEN 1 ELSE 0 END, letter;


