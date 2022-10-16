Create DATABASE Transactions_betsson
GO
USE Transactions_betsson;
GO
EXEC sp_configure 'Show Advanced Options', 1
RECONFIGURE
GO

EXEC sp_configure 'Ad Hoc Distributed Queries', 1
RECONFIGURE
GO

EXEC sp_MSSet_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1
GO

EXEC sp_MSSet_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParameters', 1
GO


SELECT * into DepositTransactions
FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
                'Excel 12.0;Database=C:\Users\Evolligence\Desktop\Material\Question1-Material.xlsx',
                'SELECT * FROM [DBtest.dbo.DepositTransactions$]')

SELECT * into GamePlayTransactions
FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
                'Excel 12.0;Database=C:\Users\Evolligence\Desktop\Material\Question1-Material.xlsx',
                'SELECT * FROM [DBtest.dbo.GamePlayTransactions$]')