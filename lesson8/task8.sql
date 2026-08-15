-- ============================================================================
-- Task 1: Count Consecutive Values in Status Field
-- ============================================================================

WITH GroupedData AS (
    SELECT 
        [Step Number],
        [Status],
        [Step Number] - ROW_NUMBER() OVER (PARTITION BY [Status] ORDER BY [Step Number]) AS GroupKey
    FROM Groupings
)
SELECT 
    MIN([Step Number]) AS [Min Step Number],
    MAX([Step Number]) AS [Max Step Number],
    [Status],
    COUNT(*) AS [Consecutive Count]
FROM GroupedData
GROUP BY [Status], GroupKey
ORDER BY [Min Step Number];

-- ============================================================================
-- Task 2: Find Year-Based Intervals Without Hires
-- ============================================================================

WITH RECURSIVE_YEARS AS (
    -- 1. Generate all years from 1975 to Current Year
    SELECT 1975 AS [Year]
    UNION ALL
    SELECT [Year] + 1
    FROM RECURSIVE_YEARS
    WHERE [Year] < YEAR(GETDATE())
),
HIRE_YEARS AS (
    -- 2. Extract distinct years in which hires occurred
    SELECT DISTINCT YEAR([HIRE_DATE]) AS [HireYear]
    FROM [dbo].[EMPLOYEES_N]
),
UNHIRED_YEARS AS (
    -- 3. Filter out years where hires happened and calculate group identifier for consecutive missing years
    SELECT 
        y.[Year],
        y.[Year] - ROW_NUMBER() OVER (ORDER BY y.[Year]) AS IslandGroup
    FROM RECURSIVE_YEARS y
    LEFT JOIN HIRE_YEARS h ON y.[Year] = h.[HireYear]
    WHERE h.[HireYear] IS NULL
)
-- 4. Aggregate consecutive missing year islands into formatted range strings
SELECT 
    CASE 
        WHEN MIN([Year]) = MAX([Year]) THEN CAST(MIN([Year]) AS VARCHAR(4)) + ' - ' + CAST(MAX([Year]) AS VARCHAR(4))
        ELSE CAST(MIN([Year]) AS VARCHAR(4)) + ' - ' + CAST(MAX([Year]) AS VARCHAR(4))
    END AS [Years]
FROM UNHIRED_YEARS
GROUP BY IslandGroup
ORDER BY MIN([Year])
OPTION (MAXRECURSION 1000);

