USE AdventureWorksLT2022;
GO



-- List all base tables in the database ordered by schema and name
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_SCHEMA, TABLE_NAME;




-- Select top 10 rows from the Customer table
SELECT TOP 10 * FROM SalesLT.Customer;
GO



-- Count total rows in the Customer table
SELECT 
    COUNT(*) AS total_rows
FROM SalesLT.Customer;




-- Count total columns in the Customer table
SELECT COUNT(*) AS total_columns 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Customer' AND TABLE_SCHEMA = 'SalesLT';




-- Show column names, data types, and nullability for Customer table
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Customer' AND TABLE_SCHEMA = 'SalesLT';




-- Check for NULL values in each column of Customer table
SELECT 
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS CustomerID_NULLs,
    SUM(CASE WHEN NameStyle IS NULL THEN 1 ELSE 0 END) AS NameStyle_NULLs,
    SUM(CASE WHEN Title IS NULL THEN 1 ELSE 0 END) AS Title_NULLs,
    SUM(CASE WHEN FirstName IS NULL THEN 1 ELSE 0 END) AS FirstName_NULLs,
    SUM(CASE WHEN MiddleName IS NULL THEN 1 ELSE 0 END) AS MiddleName_NULLs,
    SUM(CASE WHEN LastName IS NULL THEN 1 ELSE 0 END) AS LastName_NULLs,
    SUM(CASE WHEN Suffix IS NULL THEN 1 ELSE 0 END) AS Suffix_NULLs,
    SUM(CASE WHEN CompanyName IS NULL THEN 1 ELSE 0 END) AS CompanyName_NULLs,
    SUM(CASE WHEN SalesPerson IS NULL THEN 1 ELSE 0 END) AS SalesPerson_NULLs,
    SUM(CASE WHEN EmailAddress IS NULL THEN 1 ELSE 0 END) AS EmailAddress_NULLs,
    SUM(CASE WHEN Phone IS NULL THEN 1 ELSE 0 END) AS Phone_NULLs,
    SUM(CASE WHEN PasswordHash IS NULL THEN 1 ELSE 0 END) AS PasswordHash_NULLs,
    SUM(CASE WHEN PasswordSalt IS NULL THEN 1 ELSE 0 END) AS PasswordSalt_NULLs,
    SUM(CASE WHEN rowguid IS NULL THEN 1 ELSE 0 END) AS rowguid_NULLs,
    SUM(CASE WHEN ModifiedDate IS NULL THEN 1 ELSE 0 END) AS ModifiedDate_NULLs
FROM SalesLT.Customer;






-- Create a cleaned version of the Customer table with selected columns
SELECT 
    CustomerID,
    NameStyle,
    Title,
    FirstName,
    LastName,
    CompanyName,
    SalesPerson,
    EmailAddress,
    Phone,
    rowguid,
    ModifiedDate
INTO SalesLT.Customer_Cleaned
FROM SalesLT.Customer;



ALTER TABLE SalesLT.Customer_Cleaned
DROP COLUMN NameStyle;




-- View columns and data types
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'SalesLT' AND TABLE_NAME = 'Customer_Cleaned';




--Display first 20 rows
SELECT TOP 20 * FROM SalesLT.Customer_Cleaned;





--Standardize column data types
ALTER TABLE SalesLT.Customer_Cleaned
ALTER COLUMN CustomerID INT;

ALTER TABLE SalesLT.Customer_Cleaned
ALTER COLUMN Title NVARCHAR(8);

ALTER TABLE SalesLT.Customer_Cleaned
ALTER COLUMN FirstName NVARCHAR(50);

ALTER TABLE SalesLT.Customer_Cleaned
ALTER COLUMN LastName NVARCHAR(50);

ALTER TABLE SalesLT.Customer_Cleaned
ALTER COLUMN CompanyName NVARCHAR(100);

ALTER TABLE SalesLT.Customer_Cleaned
ALTER COLUMN SalesPerson NVARCHAR(100);

ALTER TABLE SalesLT.Customer_Cleaned
ALTER COLUMN EmailAddress NVARCHAR(50);

ALTER TABLE SalesLT.Customer_Cleaned
ALTER COLUMN Phone VARCHAR(20);

ALTER TABLE SalesLT.Customer_Cleaned
ALTER COLUMN rowguid UNIQUEIDENTIFIER;

ALTER TABLE SalesLT.Customer_Cleaned
ALTER COLUMN ModifiedDate DATETIME;





-- Analyze number of customers per title
SELECT 
    Title,
    COUNT(*) AS CountPerTitle
FROM SalesLT.Customer_Cleaned
GROUP BY Title
ORDER BY CountPerTitle DESC;





--Add Gender column based on Title
ALTER TABLE SalesLT.Customer_Cleaned
ADD Gender NVARCHAR(10);
GO

UPDATE SalesLT.Customer_Cleaned
SET Gender = 
    CASE 
        WHEN Title IN ('Mr.', 'Sr.') THEN 'Male'
        WHEN Title IN ('Ms.', 'Sra.') THEN 'Female'
        ELSE 'None'
    END;
GO
-- Show gender distribution by title
SELECT Title, Gender, COUNT(*) AS CountPerGender
FROM SalesLT.Customer_Cleaned
GROUP BY Title, Gender
ORDER BY CountPerGender DESC;





-- Add FullName column
ALTER TABLE SalesLT.Customer_Cleaned
ADD FullName NVARCHAR(150);
GO
UPDATE SalesLT.Customer_Cleaned
SET FullName = CONCAT(FirstName, ' ', LastName);
GO

ALTER TABLE SalesLT.Customer_Cleaned
DROP COLUMN FirstName, LastName;
GO





-- Extract SalesPerson name from domain and clean formatting
ALTER TABLE SalesLT.Customer_Cleaned
ADD SalesPersonName NVARCHAR(100);
GO

UPDATE SalesLT.Customer_Cleaned
SET SalesPersonName = 
    CASE 
        WHEN CHARINDEX('\', SalesPerson) > 0 
            THEN RIGHT(SalesPerson, LEN(SalesPerson) - CHARINDEX('\', SalesPerson))
        ELSE 
            LTRIM(RIGHT(SalesPerson, CHARINDEX(' ', REVERSE(SalesPerson)) - 1))
    END;
GO


IF COL_LENGTH('SalesLT.Customer_Cleaned', 'SalesPersonName') IS NULL
    ALTER TABLE SalesLT.Customer_Cleaned ADD SalesPersonName NVARCHAR(100);
GO

UPDATE SalesLT.Customer_Cleaned
SET SalesPersonName = 
    TRIM(
        REPLACE(
            TRANSLATE(
                SUBSTRING(SalesPerson, CHARINDEX('\', SalesPerson) + 1, LEN(SalesPerson)),
                '0123456789',         
                '          '          
            ),
            ' ', ''                  
        )
    );
GO




ALTER TABLE SalesLT.Customer_Cleaned
DROP COLUMN SalesPerson;
GO






-- Display all cleaned data
SELECT * FROM SalesLT.Customer_Cleaned;

SELECT 
    'CustomerID',
    'FullName',
    'CompanyName',
    'EmailAddress',
    'Phone',
    'Gender',
    'SalesPersonName',
    'rowguid',
    'ModifiedDate'
UNION ALL
SELECT 
    CAST(CustomerID AS NVARCHAR(50)),
    FullName,
    CompanyName,
    EmailAddress,
    Phone,
    Gender,
    SalesPersonName,
    CAST(rowguid AS NVARCHAR(50)),
    CONVERT(NVARCHAR(20), ModifiedDate, 23)  -- YYYY-MM-DD
FROM SalesLT.Customer_Cleaned;

