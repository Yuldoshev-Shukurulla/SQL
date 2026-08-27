DECLARE @HTML NVARCHAR(MAX);

SET @HTML =
N'<html>
<head>
    <style>
        body {
            font-family: Arial, sans-serif;
            font-size: 14px;
        }

        table {
            border-collapse: collapse;
            width: 100%;
        }

        th {
            background-color: #2F75B5;
            color: white;
            padding: 8px;
            border: 1px solid #ddd;
            text-align: left;
        }

        td {
            padding: 8px;
            border: 1px solid #ddd;
        }

        tr:nth-child(even) {
            background-color: #F2F2F2;
        }
    </style>
</head>
<body>

<h2>Index Metadata</h2>

<table>
    <tr>
        <th>Table Name</th>
        <th>Index Name</th>
        <th>Index Type</th>
        <th>Column Type</th>
    </tr>';

-- Add index metadata
SELECT @HTML = @HTML +
(
    SELECT
        N'<tr>' +
        N'<td>' + ISNULL(QUOTENAME(s.name) + N'.' + QUOTENAME(t.name), N'') + N'</td>' +
        N'<td>' + ISNULL(i.name, N'') + N'</td>' +
        N'<td>' + ISNULL(i.type_desc, N'') + N'</td>' +
        N'<td>' + ISNULL(
            STUFF(
                (
                    SELECT N', ' + 
                           c2.name + N' (' + ty2.name + N')'
                    FROM sys.index_columns ic2
                    INNER JOIN sys.columns c2
                        ON ic2.object_id = c2.object_id
                       AND ic2.column_id = c2.column_id
                    INNER JOIN sys.types ty2
                        ON c2.user_type_id = ty2.user_type_id
                    WHERE ic2.object_id = i.object_id
                      AND ic2.index_id = i.index_id
                    ORDER BY ic2.key_ordinal, ic2.index_column_id
                    FOR XML PATH(''), TYPE
                ).value('.', 'NVARCHAR(MAX)'),
                1, 2, N''
            ),
            N''
        ) + N'</td>' +
        N'</tr>'
    FROM sys.indexes i
    INNER JOIN sys.tables t
        ON i.object_id = t.object_id
    INNER JOIN sys.schemas s
        ON t.schema_id = s.schema_id
    WHERE i.index_id > 0
      AND i.name IS NOT NULL
    ORDER BY s.name, t.name, i.name
    FOR XML PATH(''), TYPE
).value('.', 'NVARCHAR(MAX)');

SET @HTML = @HTML +
N'</table>
</body>
</html>';

EXEC msdb.dbo.sp_send_dbmail
    @profile_name = 'YourDatabaseMailProfile',
    @recipients = 'recipient@example.com',
    @subject = 'SQL Server Index Metadata',
    @body = @HTML,
    @body_format = 'HTML';