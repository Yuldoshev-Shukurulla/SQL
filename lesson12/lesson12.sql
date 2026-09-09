-- Task 1:

-- Write an SQL query to retrieve the database name, schema name, table name, column name, and column data type for all tables across all databases in a SQL Server instance.
-- Ensure that system databases (master, tempdb, model, msdb) are excluded from the results.

-- ---

-- Task 2:

-- Write a stored procedure that retrieves all stored procedure and function names along with their schema names and parameters (if they exist), 
-- including parameter data types and maximum lengths. The procedure should accept a database name as an optional parameter. If a database name is provided, 
-- it should return the information for that specific database; otherwise, it should retrieve the information for all databases in the SQL Server instance.



-- =========================================
CREATE TABLE #temp(
    n INT
);
DECLARE @n INT = 0

WHILE @n<10
BEGIN
    INSERT INTO #temp
    SELECT @n
    SET @n = @n + 1
END;
SELECT * FROM #temp;
GO

ALTER PROC sp_select_all @table_name varchar(255), @top_k INT = NULL
as
begin
declare @sql_cmd varchar(255) = 'SELECT '
    if @top_k IS NULL
    begin
        SET @sql_cmd = CONCAT(@sql_cmd, '* FROM ', @table_name)
    END
    ELSE
    BEGIN
        SET @sql_cmd = CONCAT(@sql_cmd, 'top ', @top_k, '* FROM ', @table_name)
    END
EXEC(@sql_cmd)
END;

exec sp_select_all 'department', 2;



