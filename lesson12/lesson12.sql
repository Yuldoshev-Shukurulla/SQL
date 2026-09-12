-- Task 1:

-- Write an SQL query to retrieve the database name, schema name, table name, column name, and column data type for all tables across all databases in a SQL Server instance.
-- Ensure that system databases (master, tempdb, model, msdb) are excluded from the results.


select 
	TABLE_CATALOG as DatabaseName,
	TABLE_SCHEMA as SchemaName,
	TABLE_NAME as TableName,
	COLUMN_NAME as ColumnName,
	concat(
		DATA_TYPE,'('+ 
			case when cast(CHARACTER_MAXIMUM_LENGTH as varchar) = '-1'
			then 'max'
			else cast(CHARACTER_MAXIMUM_LENGTH as varchar) end
		+')'
	) as DataType
from class11.INFORMATION_SCHEMA.COLUMNS;


declare @name varchar(255);
declare @i int = 1;
declare @count int;
select @count = count(1)
from sys.databases where name not in ('master', 'tempdb', 'model', 'msdb')
-- CREATE TABLE #temp (
--     DatabaseName VARCHAR(255),
--     SchemaName VARCHAR(255),
--     TableName VARCHAR(255),
--     ColumnName VARCHAR(255),
--     DataType VARCHAR(255)
-- );


while @i < @count
begin
	with cte as (
		select name, ROW_NUMBER() OVER(order BY name) as rn
		from sys.databases where name not in ('master', 'tempdb', 'model', 'msdb')
	)
	select @name=name from cte
	where rn = @i;
    DECLARE @sql_cmd varchar(MAX) = N'
	select 
		TABLE_CATALOG as DatabaseName,
		TABLE_SCHEMA as SchemaName,
		TABLE_NAME as TableName,
		COLUMN_NAME as ColumnName,
		concat(
			DATA_TYPE,''(''+ 
				case when cast(CHARACTER_MAXIMUM_LENGTH as varchar) = ''-1''
				then ''max''
				else cast(CHARACTER_MAXIMUM_LENGTH as varchar) end
			+'')''
		) as DataType
	from ';
    SET @sql_cmd = CONCAT(@sql_cmd, @name, '.INFORMATION_SCHEMA.COLUMNS;');

    INSERT INTO #temp
    EXEC(@sql_cmd);
	set @i = @i + 1;

end
SELECT * FROM #temp;





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

