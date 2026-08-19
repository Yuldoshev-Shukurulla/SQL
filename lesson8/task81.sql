-- 1. Write an SQL statement that counts the consecutive values in the Status field.

-- Input table (Groupings):
-- 1. Create Table
CREATE TABLE TestSteps (
    StepNumber INT PRIMARY KEY,
    Status VARCHAR(10) NOT NULL
);
GO

-- 2. Insert Data
INSERT INTO TestSteps (StepNumber, Status)
VALUES
    (1, 'Passed'),
    (2, 'Passed'),
    (3, 'Passed'),
    (4, 'Passed'),
    (5, 'Failed'),
    (6, 'Failed'),
    (7, 'Failed'),
    (8, 'Failed'),
    (9, 'Failed'),
    (10, 'Passed'),
    (11, 'Passed'),
    (12, 'Passed');
GO
-- | Step Number | Status |
-- |-------------|--------|
-- | 1           | Passed |
-- | 2           | Passed |
-- | 3           | Passed |
-- | 4           | Passed |
-- | 5           | Failed |
-- | 6           | Failed |
-- | 7           | Failed |
-- | 8           | Failed |
-- | 9           | Failed |
-- | 10          | Passed |
-- | 11          | Passed |
-- | 12          | Passed |
-- Expected Output:
WITH Temp AS (
    SELECT
        StepNumber,
        Status,
        StepNumber - ROW_NUMBER() OVER(PARTITION BY Status ORDER BY StepNumber) AS GroupKey
    FROM TestSteps
)
SELECT
    MIN(StepNumber) AS MinStepNumber,
    MAX(StepNumber) AS MaxStepNumber,
    Status,
    COUNT(*)
FROM Temp
GROUP BY Status, GroupKey
ORDER BY MinStepNumber
-- | Min Step Number | Max Step Number | Status | Consecutive Count |
-- |-----------------|-----------------|--------|-------------------|
-- | 1               | 4               | Passed | 4                 |
-- | 5               | 9               | Failed | 5                 |
-- | 10              | 12              | Passed | 3                 |
-- ---


-- 2. Find all the year-based intervals from 1975 up to current when the company did not hire employees.

CREATE TABLE [dbo].[EMPLOYEES_N]
(
    [EMPLOYEE_ID] [int] NOT NULL,
    [FIRST_NAME] [varchar](20) NULL,
    [HIRE_DATE] [date] NOT NULL
);
-- Expected Output:

-- | Years       |
-- |-------------|
-- | 1978 - 1978 |
-- | 1981 - 1981 |
-- | 1986 - 1989 |
-- | 1991 - 1996 |
-- | 1998 - 2025 |
-- 1. Insert Sample Data
INSERT INTO [dbo].[EMPLOYEES_N] ([EMPLOYEE_ID], [FIRST_NAME], [HIRE_DATE])
VALUES
    (101, 'Alice',   '1975-03-15'),  -- Hired in 1975
    (102, 'Bob',     '1976-06-20'),  -- Hired in 1976
    (103, 'Charlie', '1979-11-01'),  -- Hired in 1979 (Gap: 1977-1978)
    (104, 'Diana',   '1980-01-10'),  -- Hired in 1980
    (105, 'Evan',    '1985-05-12'),  -- Hired in 1985 (Gap: 1981-1984)
    (106, 'Fiona',   '1987-09-25'),  -- Hired in 1987 (Gap: 1986)
    (107, 'George',  '2020-04-18'),  -- Hired in 2020 (Gap: 1988-2019)
    (108, 'Hannah',  '2021-08-30');  -- Hired in 2021 (Gap: 2022-2026)
GO

SELECT * FROM EMPLOYEES_N
WITH TT AS (
    SELECT 
        value, 
        IIF(year IS NULL, 0, 1) AS Ronn,
        RNK - ROW_NUMBER() OVER(PARTITION BY IIF(year IS NULL, 0, 1) ORDER BY value) AS RNK1
     FROM (
        SELECT *,
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS RNK
        FROM generate_series(1975, YEAR(CURRENT_DATE), 1) Y
        LEFT JOIN (SELECT YEAR(HIRE_DATE) AS year FROM EMPLOYEES_N) T
        ON T.year=Y.[value]
) AS Temp)
SELECt CONCAT(MIN(value), '-', MAX(value)) AS year
FROM TT
WHERE Ronn=0
GROUP BY RNK1;
