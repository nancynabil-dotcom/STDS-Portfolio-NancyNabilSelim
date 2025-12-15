

--View column structure and metadata
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'SalesLT'
  AND TABLE_NAME = 'SalesOrderDetail';
GO


--Preview the first 100 rows from table
SELECT TOP 100 *
FROM SalesLT.SalesOrderDetail;
GO


--Select and format  ModifiedDate column
SELECT 
    SalesOrderID,
    SalesOrderDetailID,
    OrderQty,
    ProductID,
    UnitPrice,
    UnitPriceDiscount,
    LineTotal,
    rowguid,
    CONVERT(NVARCHAR(10), ModifiedDate, 23) AS ModifiedDate
FROM SalesLT.SalesOrderDetail;
GO



SELECT
    'SalesOrderID',
    'SalesOrderDetailID',
    'OrderQty',
    'ProductID',
    'UnitPrice',
    'UnitPriceDiscount',
    'LineTotal',
    'rowguid',
    'ModifiedDate'
UNION ALL
SELECT
    CAST(SalesOrderID AS NVARCHAR(50)),
    CAST(SalesOrderDetailID AS NVARCHAR(50)),
    CAST(OrderQty AS NVARCHAR(50)),
    CAST(ProductID AS NVARCHAR(50)),
    CAST(UnitPrice AS NVARCHAR(50)),
    CAST(UnitPriceDiscount AS NVARCHAR(50)),
    CAST(LineTotal AS NVARCHAR(50)),
    CAST(rowguid AS NVARCHAR(50)),
    CONVERT(NVARCHAR(20), ModifiedDate, 23) -- yyyy-MM-dd
FROM SalesLT.SalesOrderDetail;
GO
