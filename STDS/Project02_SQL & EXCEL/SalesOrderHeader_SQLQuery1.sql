

USE AdventureWorksLT2022;
GO





SELECT *
INTO SalesLT.SalesOrderHeader_Cleaned
FROM SalesLT.SalesOrderHeader;
GO




SELECT
    SUM(CASE WHEN ShipDate IS NULL THEN 1 ELSE 0 END) AS ShipDate_Nulls,
    SUM(CASE WHEN PurchaseOrderNumber IS NULL THEN 1 ELSE 0 END) AS PurchaseOrderNumber_Nulls,
    SUM(CASE WHEN AccountNumber IS NULL THEN 1 ELSE 0 END) AS AccountNumber_Nulls,
    SUM(CASE WHEN ShipToAddressID IS NULL THEN 1 ELSE 0 END) AS ShipToAddressID_Nulls,
    SUM(CASE WHEN BillToAddressID IS NULL THEN 1 ELSE 0 END) AS BillToAddressID_Nulls,
    SUM(CASE WHEN CreditCardApprovalCode IS NULL THEN 1 ELSE 0 END) AS CreditCardApprovalCode_Nulls,
    SUM(CASE WHEN Comment IS NULL THEN 1 ELSE 0 END) AS Comment_Nulls
FROM SalesLT.SalesOrderHeader_Cleaned;
GO




SELECT *
FROM SalesLT.SalesOrderHeader_Cleaned;
GO



ALTER TABLE SalesLT.SalesOrderHeader_Cleaned
DROP COLUMN CreditCardApprovalCode, Comment;
GO




UPDATE SalesLT.SalesOrderHeader_Cleaned
SET ModifiedDate = CONVERT(NVARCHAR(20), ModifiedDate, 23);  -- 23 = yyyy-MM-dd
GO




SELECT
    'SalesOrderID',
    'RevisionNumber',
    'OrderDate',
    'DueDate',
    'ShipDate',
    'Status',
    'OnlineOrderFlag',
    'SalesOrderNumber',
    'PurchaseOrderNumber',
    'AccountNumber',
    'CustomerID',
    'ShipToAddressID',
    'BillToAddressID',
    'ShipMethod',
    'SubTotal',
    'TaxAmt',
    'Freight',
    'TotalDue',
    'rowguid',
    'ModifiedDate'
UNION ALL
SELECT
    CAST(SalesOrderID AS NVARCHAR(50)),
    CAST(RevisionNumber AS NVARCHAR(50)),
    ISNULL(CONVERT(NVARCHAR(10), OrderDate, 23),'N/A'),
    ISNULL(CONVERT(NVARCHAR(10), DueDate, 23),'N/A'),
    ISNULL(CONVERT(NVARCHAR(10), ShipDate, 23),'N/A'),
    CAST(Status AS NVARCHAR(50)),
    CAST(OnlineOrderFlag AS NVARCHAR(10)),
    ISNULL(SalesOrderNumber,'N/A'),
    ISNULL(PurchaseOrderNumber,'N/A'),
    ISNULL(AccountNumber,'N/A'),
    CAST(CustomerID AS NVARCHAR(50)),
    ISNULL(CAST(ShipToAddressID AS NVARCHAR(50)),'N/A'),
    ISNULL(CAST(BillToAddressID AS NVARCHAR(50)),'N/A'),
    ISNULL(ShipMethod,'N/A'),
    CAST(SubTotal AS NVARCHAR(50)),
    CAST(TaxAmt AS NVARCHAR(50)),
    CAST(Freight AS NVARCHAR(50)),
    CAST(TotalDue AS NVARCHAR(50)),
    CAST(rowguid AS NVARCHAR(50)),
    ISNULL(CONVERT(NVARCHAR(10), ModifiedDate, 23),'N/A')
FROM SalesLT.SalesOrderHeader_Cleaned;
GO

