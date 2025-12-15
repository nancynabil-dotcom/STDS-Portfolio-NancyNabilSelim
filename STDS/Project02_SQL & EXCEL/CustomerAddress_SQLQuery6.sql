USE AdventureWorksLT2022;
GO




-- Select column names, data types, nullability, and character length
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'CustomerAddress'
ORDER BY COLUMN_NAME;
GO




-- Check total row count and number of NULL values in columns
SELECT 
    COUNT(*) AS TotalRows,
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS CustomerID_NULLs,
    SUM(CASE WHEN AddressID IS NULL THEN 1 ELSE 0 END) AS AddressID_NULLs,
    SUM(CASE WHEN rowguid IS NULL THEN 1 ELSE 0 END) AS rowguid_NULLs,
    SUM(CASE WHEN ModifiedDate IS NULL THEN 1 ELSE 0 END) AS ModifiedDate_NULLs
FROM SalesLT.CustomerAddress;
GO





-- Create a cleaned version of CustomerAddress table
SELECT 
    AddressID,
    AddressType,
    CustomerID,
    CONVERT(NVARCHAR(20), ModifiedDate, 23) AS ModifiedDate,  -- YYYY-MM-DD
    CAST(rowguid AS NVARCHAR(50)) AS rowguid
INTO SalesLT.CustomerAddress_Cleaned
FROM SalesLT.CustomerAddress;
GO






SELECT
    'AddressID',
    'AddressType',
    'CustomerID',
    'ModifiedDate',
    'rowguid'
UNION ALL
SELECT
    CAST(AddressID AS NVARCHAR(50)),
    AddressType,
    CAST(CustomerID AS NVARCHAR(50)),
    ModifiedDate,
    rowguid
FROM SalesLT.CustomerAddress_Cleaned;

