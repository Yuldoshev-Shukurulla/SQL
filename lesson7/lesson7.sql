--=======================================================
--Task1
--=======================================================
CREATE TABLE Messages (
    ID INT PRIMARY KEY,
    NAME VARCHAR(50) NOT NULL,
    GENDER CHAR(1) NOT NULL
);
GO

INSERT INTO Messages (ID, NAME, GENDER)
VALUES
    (1, 'Neeraj', 'M'),
    (2, 'Mayank', 'M'),
    (3, 'Pawan', 'M'),
    (4, 'Gopal', 'M'),
    (5, 'Sandeep', 'M'),
    (6, 'Isha', 'F'),
    (7, 'Sugandha', 'F'),
    (8, 'kritika', 'F');
GO

SELECT ID, NAME, GENDER 
FROM Messages;

SELECT
    ID, NAME, GENDER
FROM(
    SELECT
        *,
        ROW_NUMBER() OVER(ORDER BY ID) AS RNK
    FROM Messages
    WHERE GENDER = 'M'
    UNION ALL
    SELECT
        *,
        ROW_NUMBER() OVER(ORDER BY ID) AS RNK
    FROM Messages
    WHERE GENDER = 'F') AS T
ORDER BY RNK, GENDER DESC

SELECT *
FROM Messages
ORDER BY ROW_NUMBER() OVER(PARTITION BY GENDER ORDER BY ID), GENDER DESC

--=======================================================
--Task1
--=======================================================
