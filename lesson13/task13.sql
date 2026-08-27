DECLARE @TargetDate DATE = '2026-08-01';

WITH DatesSequence AS (
    SELECT DATEFROMPARTS(YEAR(@TargetDate), MONTH(@TargetDate), 1) AS CalendarDate
    UNION ALL
    SELECT DATEADD(DAY, 1, CalendarDate)
    FROM DatesSequence
    WHERE CalendarDate < EOMONTH(@TargetDate)
),
CalendarDetails AS (
    SELECT 
        DAY(CalendarDate) AS DayOfMonth,
        DATENAME(WEEKDAY, CalendarDate) AS DayName,
        DENSE_RANK() OVER (
            ORDER BY DATEPART(WEEK, CalendarDate) + 
                     CASE WHEN DATEPART(WEEKDAY, CalendarDate) = 1 THEN 0 ELSE 0 END
        ) AS WeekOfMonth
    FROM DatesSequence
)
SELECT 
    Sunday, 
    Monday, 
    Tuesday, 
    Wednesday, 
    Thursday, 
    Friday, 
    Saturday
FROM (
    SELECT WeekOfMonth, DayName, DayOfMonth 
    FROM CalendarDetails
) AS SourceTable
PIVOT (
    MAX(DayOfMonth)
    FOR DayName IN (
        [Sunday], [Monday], [Tuesday], [Wednesday], [Thursday], [Friday], [Saturday]
    )
) AS PivotTable
ORDER BY WeekOfMonth;
OPTION (MAXRECURSION 31);