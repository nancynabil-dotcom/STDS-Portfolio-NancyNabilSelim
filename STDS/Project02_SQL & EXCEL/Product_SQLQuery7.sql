USE AdventureWorksLT2022;
GO


-- Select column names, data types, nullability, and maximum length
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Product'
ORDER BY COLUMN_NAME;
GO




-- Check total number of rows and count NULL values for all columns
SELECT 
    COUNT(*) AS TotalRows,
    SUM(CASE WHEN Color IS NULL THEN 1 ELSE 0 END) AS Color_NULLs,
    SUM(CASE WHEN DiscontinuedDate IS NULL THEN 1 ELSE 0 END) AS DiscontinuedDate_NULLs,
    SUM(CASE WHEN ListPrice IS NULL THEN 1 ELSE 0 END) AS ListPrice_NULLs,
    SUM(CASE WHEN ModifiedDate IS NULL THEN 1 ELSE 0 END) AS ModifiedDate_NULLs,
    SUM(CASE WHEN Name IS NULL THEN 1 ELSE 0 END) AS Name_NULLs,
    SUM(CASE WHEN ProductCategoryID IS NULL THEN 1 ELSE 0 END) AS ProductCategoryID_NULLs,
    SUM(CASE WHEN ProductID IS NULL THEN 1 ELSE 0 END) AS ProductID_NULLs,
    SUM(CASE WHEN ProductModelID IS NULL THEN 1 ELSE 0 END) AS ProductModelID_NULLs,
    SUM(CASE WHEN ProductNumber IS NULL THEN 1 ELSE 0 END) AS ProductNumber_NULLs,
    SUM(CASE WHEN rowguid IS NULL THEN 1 ELSE 0 END) AS rowguid_NULLs,
    SUM(CASE WHEN SellEndDate IS NULL THEN 1 ELSE 0 END) AS SellEndDate_NULLs,
    SUM(CASE WHEN SellStartDate IS NULL THEN 1 ELSE 0 END) AS SellStartDate_NULLs,
    SUM(CASE WHEN Size IS NULL THEN 1 ELSE 0 END) AS Size_NULLs,
    SUM(CASE WHEN StandardCost IS NULL THEN 1 ELSE 0 END) AS StandardCost_NULLs,
    SUM(CASE WHEN ListPrice IS NULL THEN 1 ELSE 0 END) AS ListPrice_NULLs,
    SUM(CASE WHEN Weight IS NULL THEN 1 ELSE 0 END) AS Weight_NULLs,
    SUM(CASE WHEN ThumbnailPhotoFileName IS NULL THEN 1 ELSE 0 END) AS ThumbnailPhotoFileName_NULLs
FROM SalesLT.Product;
GO





-- Create a cleaned version of the Product table
SELECT
    ProductID,
    Name,
    ProductNumber,
    CAST(ProductModelID AS NVARCHAR(50)) AS ProductModelID,
    CAST(ProductCategoryID AS NVARCHAR(50)) AS ProductCategoryID,
    Color,
    CAST(StandardCost AS NVARCHAR(50)) AS StandardCost,
    CAST(ListPrice AS NVARCHAR(50)) AS ListPrice,
    Size,
    CAST(Weight AS NVARCHAR(50)) AS Weight,
    CONVERT(NVARCHAR(20), SellStartDate, 23) AS SellStartDate,
    CONVERT(NVARCHAR(20), DiscontinuedDate, 23) AS DiscontinuedDate,
    CAST(rowguid AS NVARCHAR(50)) AS rowguid,
    CONVERT(NVARCHAR(20), ModifiedDate, 23) AS ModifiedDate,
    ThumbnailPhotoFileName
INTO SalesLT.Product_Cleaned
FROM SalesLT.Product;
GO



-- Replace NULL values in Color, Size, and Weight columns
UPDATE SalesLT.Product_Cleaned
SET 
    Color = ISNULL(Color, 'Not Specified'),
    Size  = ISNULL(Size, 'Not Specified'),
    Weight = ISNULL(Weight, 'Not Specified');
GO




ALTER TABLE SalesLT.Product_Cleaned
DROP COLUMN DiscontinuedDate;
GO




-- Normalize the Size column by categorizing numeric values
UPDATE SalesLT.Product_Cleaned
SET Size = CASE 
    WHEN TRY_CAST(Size AS INT) BETWEEN 0 AND 48 THEN 'S'
    WHEN TRY_CAST(Size AS INT) BETWEEN 49 AND 56 THEN 'M'
    WHEN TRY_CAST(Size AS INT) BETWEEN 57 AND 62 THEN 'L'
    WHEN TRY_CAST(Size AS INT) >= 63 THEN 'XL'
    WHEN Size IN ('S','M','L','XL') THEN Size
    ELSE 'M'
END;
GO









SELECT
    'ProductID',
    'Name',
    'ProductNumber',
    'ProductModelID',
    'ProductCategoryID',
    'Color',
    'StandardCost',
    'ListPrice',
    'Size',
    'Weight',
    'SellStartDate',
    'rowguid',
    'ModifiedDate',
    'ThumbnailPhotoFileName'
UNION ALL
SELECT
    CAST(ProductID AS NVARCHAR(50)),
    Name,
    ProductNumber,
    ProductModelID,
    ProductCategoryID,
    Color,
    StandardCost,
    ListPrice,
    Size,
    Weight,
    SellStartDate,
    rowguid,
    ModifiedDate,
    ThumbnailPhotoFileName
FROM SalesLT.Product_Cleaned;
GO





