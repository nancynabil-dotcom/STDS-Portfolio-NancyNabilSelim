


--View column information for ProductCategory table
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ProductCategory';
GO



--Create a cleaned version of ProductCategory table
SELECT *
INTO SalesLT.ProductCategory_Cleaned
FROM SalesLT.ProductCategory;
GO





--Check for NULL values in columns
SELECT 
    COUNT(*) AS TotalRows,
    SUM(CASE WHEN ProductCategoryID IS NULL THEN 1 ELSE 0 END) AS ProductCategoryID_NULLs,
    SUM(CASE WHEN ParentProductCategoryID IS NULL THEN 1 ELSE 0 END) AS ParentProductCategoryID_NULLs,
    SUM(CASE WHEN Name IS NULL THEN 1 ELSE 0 END) AS Name_NULLs,
    SUM(CASE WHEN rowguid IS NULL THEN 1 ELSE 0 END) AS rowguid_NULLs,
    SUM(CASE WHEN ModifiedDate IS NULL THEN 1 ELSE 0 END) AS ModifiedDate_NULLs
FROM SalesLT.ProductCategory_Cleaned;
GO





--Replace 'No Parent' text with 0 
UPDATE SalesLT.ProductCategory_Cleaned
SET ParentProductCategoryID = 0
WHERE LTRIM(RTRIM(ParentProductCategoryID)) = 'No Parent';
GO

ALTER TABLE SalesLT.ProductCategory_Cleaned
ALTER COLUMN ParentProductCategoryID INT;
GO





SELECT
    'ProductCategoryID',
    'ParentProductCategoryID',
    'Name',
    'rowguid',
    'ModifiedDate'
UNION ALL
SELECT
    CAST(ProductCategoryID AS NVARCHAR(50)),
    CAST(ParentProductCategoryID AS NVARCHAR(50)),
    Name,
    CAST(rowguid AS NVARCHAR(50)),
    CONVERT(NVARCHAR(20), ModifiedDate, 23) -- YYYY-MM-DD
FROM SalesLT.ProductCategory_Cleaned;
GO
