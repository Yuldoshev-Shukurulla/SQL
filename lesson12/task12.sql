-- ============================================================================
-- Task 1:
-- ============================================================================

CREATE TABLE #DatabaseColumns (
    DatabaseName SYSNAME,
    SchemaName   SYSNAME,
    TableName    SYSNAME,
    ColumnName   SYSNAME,
    DataType     VARCHAR(128)
);

EXEC sp_MSforeachdb '
USE [?];
IF DB_ID(''?'') > 4 -- Excludes master (1), tempdb (2), model (3), msdb (4)
BEGIN
    INSERT INTO #DatabaseColumns (DatabaseName, SchemaName, TableName, ColumnName, DataType)
    SELECT 
        DB_NAME() AS DatabaseName,
        s.name AS SchemaName,
        t.name AS TableName,
        c.name AS ColumnName,
        ty.name AS DataType
    FROM sys.tables t
    INNER JOIN sys.schemas s 
        ON t.schema_id = s.schema_id
    INNER JOIN sys.columns c 
        ON t.object_id = c.object_id
    INNER JOIN sys.types ty 
        ON c.user_type_id = ty.user_type_id
    WHERE t.is_ms_shipped = 0; -- Excludes internal SQL Server system tables
END';

SELECT 
    DatabaseName,
    SchemaName,
    TableName,
    ColumnName,
    DataType
FROM #DatabaseColumns
ORDER BY DatabaseName, SchemaName, TableName, ColumnName;

DROP TABLE #DatabaseColumns;
GO
-- ============================================================================
-- Task 2:
-- ============================================================================
CREATE OR ALTER PROCEDURE sp_GetRoutineParameters
    @DatabaseName SYSNAME = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @DatabaseName IS NOT NULL AND DB_ID(@DatabaseName) IS NULL
    BEGIN
        RAISERROR('The specified database "%s" does not exist or is inaccessible.', 16, 1, @DatabaseName);
        RETURN;
    END

    CREATE TABLE #RoutineMetadata (
        DatabaseName   SYSNAME,
        SchemaName     SYSNAME,
        RoutineName    SYSNAME,
        RoutineType    NVARCHAR(20),
        ParameterName  SYSNAME NULL,
        DataType       NVARCHAR(128) NULL,
        MaxLength      SMALLINT NULL
    );

    DECLARE @Query NVARCHAR(MAX) = N'
    USE [?];
    IF DB_ID(''?'') > 4
    BEGIN
        INSERT INTO #RoutineMetadata (DatabaseName, SchemaName, RoutineName, RoutineType, ParameterName, DataType, MaxLength)
        SELECT 
            DB_NAME() AS DatabaseName,
            s.name AS SchemaName,
            o.name AS RoutineName,
            CASE o.type
                WHEN ''P''  THEN ''SQL Stored Procedure''
                WHEN ''FN'' THEN ''SQL Scalar Function''
                WHEN ''IF'' THEN ''SQL Inline Table-Valued Function''
                WHEN ''TF'' THEN ''SQL Table-Valued Function''
            END AS RoutineType,
            p.name AS ParameterName,
            ty.name AS DataType,
            p.max_length AS MaxLength
        FROM sys.objects o
        INNER JOIN sys.schemas s 
            ON o.schema_id = s.schema_id
        LEFT JOIN sys.parameters p 
            ON o.object_id = p.object_id
        LEFT JOIN sys.types ty 
            ON p.user_type_id = ty.user_type_id
        WHERE o.type IN (''P'', ''FN'', ''IF'', ''TF'')
          AND o.is_ms_shipped = 0;
    END';

    IF @DatabaseName IS NOT NULL
    BEGIN
        SET @Query = REPLACE(@Query, '?', @DatabaseName);
        EXEC sp_executesql @Query;
    END
    ELSE
    BEGIN
        EXEC sp_MSforeachdb @Query;
    END

    SELECT 
        DatabaseName,
        SchemaName,
        RoutineName,
        RoutineType,
        ISNULL(ParameterName, '(No Parameters)') AS ParameterName,
        DataType,
        MaxLength
    FROM #RoutineMetadata
    ORDER BY DatabaseName, SchemaName, RoutineName, ParameterName;

    DROP TABLE #RoutineMetadata;
END;
GO

EXEC sp_GetRoutineParameters;

EXEC sp_GetRoutineParameters @DatabaseName = 'YourDatabaseName';