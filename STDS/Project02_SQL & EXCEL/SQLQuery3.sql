USE master;
GO

ALTER DATABASE AdventureWorksLT2022 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

RESTORE DATABASE AdventureWorksLT2022
FROM DISK = 'C:\AdventureWorksLT2022.bak'
WITH MOVE 'AdventureWorksLT2022_Data' TO 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\AdventureWorksLT2022_Data.mdf',
     MOVE 'AdventureWorksLT2022_Log' TO 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\AdventureWorksLT2022_Log.ldf',
     REPLACE;
GO

ALTER DATABASE AdventureWorksLT2022 SET MULTI_USER;
GO
