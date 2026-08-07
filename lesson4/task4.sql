-- ============================================================================
-- Task 1: Barcha ustunlari 0 bo'lgan qatorlarni yashirish
-- ============================================================================
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

SELECT A, B, C, D
FROM [dbo].[TestMultipleZero]
WHERE ISNULL(A, 0) <> 0 
   OR ISNULL(B, 0) <> 0 
   OR ISNULL(C, 0) <> 0 
   OR ISNULL(D, 0) <> 0;
GO


-- ============================================================================
-- Task 2: Bir nechta ustunlar orasidan eng katta qiymatni (MAX) topish
-- ============================================================================
CREATE TABLE TestMax
(
    Year1 INT
    ,Max1 INT
    ,Max2 INT
    ,Max3 INT
);
GO
 
INSERT INTO TestMax 
VALUES
    (2001,10,101,87)
    ,(2002,103,19,88)
    ,(2003,21,23,89)
    ,(2004,27,28,91);

SELECT 
    t.Year1,
    (SELECT MAX(v) FROM (VALUES (t.Max1), (t.Max2), (t.Max3)) AS CrossValues(v)) AS MaxValue
FROM TestMax t;
GO


-- ============================================================================
-- Task 3: Tug'ilgan kuni 7-May va 15-May oralig'ida bo'lgan xodimlarni topish
-- ============================================================================
CREATE TABLE EmpBirth
(
    EmpId INT IDENTITY(1,1) 
    ,EmpName VARCHAR(50) 
    ,BirthDate DATETIME 
);

INSERT INTO EmpBirth(EmpName,BirthDate)
SELECT 'Pawan' , '12/04/1983'
UNION ALL
SELECT 'Zuzu' , '11/28/1986'
UNION ALL
SELECT 'Parveen', '05/07/1977'
UNION ALL
SELECT 'Mahesh', '01/13/1983'
UNION ALL
SELECT 'Ramesh', '05/09/1983';

SELECT EmpId, EmpName, BirthDate
FROM EmpBirth
WHERE DATEPART(month, BirthDate) = 5 
  AND DATEPART(day, BirthDate) BETWEEN 7 AND 15;
GO


-- ============================================================================
-- Task 4: Harflarni saralash ('b' harfini birinchi, oxirgi va 3-o'ringa qo'yish)
-- ============================================================================
CREATE TABLE letters
(
    letter CHAR(1)
);

INSERT INTO letters
VALUES ('a'), ('a'), ('a'), 
       ('b'), ('c'), ('d'), ('e'), ('f');

-- 1) 'b' harfi BIRINCHI bo'lsin:
SELECT letter
FROM letters
ORDER BY 
    CASE WHEN letter = 'b' THEN 0 ELSE 1 END,
    letter;

-- 2) 'b' harfi OXIRGI bo'lsin:
SELECT letter
FROM letters
ORDER BY 
    CASE WHEN letter = 'b' THEN 1 ELSE 0 END,
    letter;

-- 3) 'b' harfi 3-O'RINDA bo'lsin:
WITH RankedLetters AS (
    SELECT 
        letter,
        ROW_NUMBER() OVER (ORDER BY letter) AS SortOrder
    FROM letters
    WHERE letter <> 'b'
)
SELECT letter
FROM (
    SELECT 
        letter, 
        CASE WHEN SortOrder >= 3 THEN SortOrder + 1 ELSE SortOrder END AS CustomPos
    FROM RankedLetters
    
    UNION ALL
    
    SELECT 'b' AS letter, 3 AS CustomPos
) AS FinalSort
ORDER BY CustomPos;
GO