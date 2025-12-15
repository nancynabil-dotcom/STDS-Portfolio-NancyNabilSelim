
--View column information
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE, 
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'SalesLT'
  AND TABLE_NAME = 'ProductModel';
GO



--Create a cleaned version
SELECT *
INTO SalesLT.ProductModel_Cleaned
FROM SalesLT.ProductModel;
GO





--Check for NULL values in columns 
SELECT
    SUM(CASE WHEN ProductModelID IS NULL THEN 1 ELSE 0 END) AS ProductModelID_Nulls,
    SUM(CASE WHEN Name IS NULL THEN 1 ELSE 0 END) AS Name_Nulls,
    SUM(CASE WHEN CatalogDescription IS NULL THEN 1 ELSE 0 END) AS CatalogDescription_Nulls,
    SUM(CASE WHEN rowguid IS NULL THEN 1 ELSE 0 END) AS rowguid_Nulls,
    SUM(CASE WHEN ModifiedDate IS NULL THEN 1 ELSE 0 END) AS ModifiedDate_Nulls
FROM SalesLT.ProductModel_Cleaned;
GO



--Drop unnecessary column
ALTER TABLE SalesLT.ProductModel_Cleaned
DROP COLUMN CatalogDescription;
GO




SELECT
    'ProductModelID',
    'Name',
    'rowguid',
    'ModifiedDate'
UNION ALL
SELECT
    CAST(ProductModelID AS NVARCHAR(50)),
    Name,
    CAST(rowguid AS NVARCHAR(50)),
    CONVERT(NVARCHAR(20), ModifiedDate, 23) -- yyyy-MM-dd
FROM SalesLT.ProductModel_Cleaned;
GO
