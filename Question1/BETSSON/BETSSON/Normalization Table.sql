
----------------CustomerCountry
select ROW_NUMBER() over (order by [CustomerCountry]) ID,  V.* into CountryTBL  from (
SELECT distinct 
      [CustomerCountry]
  FROM [Transactions_betsson].[dbo].[GamePlayTransactions]
  union
  SELECT distinct 
      [CustomerCountry]
  FROM [Transactions_betsson].[dbo].[DepositTransactions])V
GO

ALTER TABLE CountryTBL
ALTER COLUMN ID int NOT NULL;
GO

ALTER TABLE CountryTBL
ADD CONSTRAINT PK_Country PRIMARY KEY (ID);

----------------CustomerStatus
select ROW_NUMBER() over (order by [CustomerStatus]) ID,  V.* into StatusTBL  from (
SELECT distinct 
      [CustomerStatus]
  FROM [Transactions_betsson].[dbo].[GamePlayTransactions]
  union
  SELECT distinct 
      [CustomerAccountStatus]
  FROM [Transactions_betsson].[dbo].[DepositTransactions])V
GO

ALTER TABLE StatusTBL
ALTER COLUMN ID int NOT NULL;
GO

ALTER TABLE StatusTBL
ADD CONSTRAINT PK_Status PRIMARY KEY (ID);

----------------CustomerBrand
select ROW_NUMBER() over (order by [CustomerBrand]) ID,  V.* into BrandTBL  from (
SELECT distinct 
      [CustomerBrand]
  FROM [Transactions_betsson].[dbo].[GamePlayTransactions]
  union
  SELECT distinct 
      [CustomerBrandName]
  FROM [Transactions_betsson].[dbo].[DepositTransactions])V
GO

ALTER TABLE BrandTBL
ALTER COLUMN ID int NOT NULL;
GO

ALTER TABLE BrandTBL
ADD CONSTRAINT PK_Brand PRIMARY KEY (ID);


----------------CustomerTable
select ROW_NUMBER() over (order by [CustomerEmail]) ID,  A.[CustomerEmail]
      --,A.[CustomerBrand]
	  ,B.ID [BrandID]
     -- ,A.[CustomerCountry]
	  ,C.ID [CountryID]
      --,A.[CustomerStatus]
	  ,S.ID [StatusID] into CustomerTBL from (
  SELECT distinct [CustomerEmail]
      ,[CustomerBrand]
      ,[CustomerCountry]
      ,[CustomerStatus]
  FROM [Transactions_betsson].[dbo].[GamePlayTransactions]
  union
    SELECT distinct [CustomerEmail]
      ,[CustomerBrandName]
      ,[CustomerCountry]
      ,[CustomerAccountStatus]
  FROM [Transactions_betsson].[dbo].[DepositTransactions])A
  inner join BrandTBL B on A.[CustomerBrand] = B.CustomerBrand
  inner join CountryTBL C on A.CustomerCountry = C.CustomerCountry
  inner join StatusTBL S on A.CustomerStatus = S.CustomerStatus
GO
ALTER TABLE CustomerTBL
ALTER COLUMN ID int NOT NULL;
GO

ALTER TABLE CustomerTBL
ADD CONSTRAINT PK_Customer PRIMARY KEY (ID);

----------------ProvideTable
select ROW_NUMBER() over (order by [ProviderName],[ProviderProductName]) ID ,A.* into ProvideTBL from(
SELECT distinct 
[ProviderName]
      ,isnull([ProviderProductName],-1) [ProviderProductName]
  FROM [Transactions_betsson].[dbo].[GamePlayTransactions] )A
  GO
ALTER TABLE ProvideTBL
ALTER COLUMN ID int NOT NULL;
GO
ALTER TABLE ProvideTBL
ADD CONSTRAINT PK_Provide PRIMARY KEY (ID);

----------------DeviceTable
select ROW_NUMBER() over (order by DeviceName) ID ,A.* into DeviceTBL from(
  SELECT distinct DeviceName
  FROM [Transactions_betsson].[dbo].[GamePlayTransactions] ) A

    GO
ALTER TABLE DeviceTBL
ALTER COLUMN ID int NOT NULL;
GO
ALTER TABLE DeviceTBL
ADD CONSTRAINT PK_Device PRIMARY KEY (ID);

----------------roundTable
select ROW_NUMBER() over (order by rounds) ID ,A.* into roundTBL from(
  SELECT distinct rounds
  FROM [Transactions_betsson].[dbo].[GamePlayTransactions] ) A

    GO
ALTER TABLE roundTBL
ALTER COLUMN ID int NOT NULL;
GO
ALTER TABLE roundTBL
ADD CONSTRAINT PK_round PRIMARY KEY (ID);

----------------GamePlayTransactionsTable
SELECT  ROW_NUMBER() over (order by [CalendarDate],[turnover_EUR]
      ,[gameWin_EUR]
      ,[bonus cost]
      ,[totalAccountingRevenue_EUR] ) ID 
      ,[CalendarDate]
      ,B.ID [CustomerID]
      ,C.ID [ProviderID]
      ,D.ID [DeviceID]
      ,R.ID [roundID]
      ,[turnover_EUR]
      ,[gameWin_EUR]
      ,[bonus cost]
      ,[totalAccountingRevenue_EUR] into GamePlayTransactionsTable
  FROM [Transactions_betsson].[dbo].[GamePlayTransactions] A
  inner join CustomerTBL B on A.CustomerEmail = B.CustomerEmail
  inner join ProvideTBL C on isnull(A.ProviderProductName,-1) = C.ProviderProductName and A.ProviderName = C.ProviderName
  inner join DeviceTBL D on A.DeviceName = D.DeviceName
  inner join roundTBL R on A.rounds = R.rounds
 GO
ALTER TABLE GamePlayTransactionsTable
ALTER COLUMN ID int NOT NULL;
GO
ALTER TABLE GamePlayTransactionsTable
ADD CONSTRAINT PK_GamePlayTransactions PRIMARY KEY (ID);


----------------PaymentStatusTable
select ROW_NUMBER() over (order by [PaymentStatusName]) ID ,A.* into PaymentStatusTBL from(
     SELECT distinct [PaymentStatusName]
      ,[PaymentStatusDescription]
  FROM [Transactions_betsson].[dbo].[DepositTransactions]) A

    GO
ALTER TABLE PaymentStatusTBL
ALTER COLUMN ID int NOT NULL;
GO
ALTER TABLE PaymentStatusTBL
ADD CONSTRAINT PK_PaymentStatus PRIMARY KEY (ID);

----------------PaymentMethodTable
select ROW_NUMBER() over (order by [PaymentMethodName],[PaymentMethodType]) ID ,A.* into PaymentMethodTBL from(
SELECT distinct [PaymentMethodName]
      ,[PaymentMethodType]
  FROM [Transactions_betsson].[dbo].[DepositTransactions] )A

      GO
ALTER TABLE PaymentMethodTBL
ALTER COLUMN ID int NOT NULL;
GO
ALTER TABLE PaymentMethodTBL
ADD CONSTRAINT PK_PaymentMethod PRIMARY KEY (ID);

----------------PaymentTable
select ROW_NUMBER() over (order by [PaymentMethodID],[PaymentStatusID]) ID ,AA.*  into PaymentTBL from(
  SELECT distinct PM.ID [PaymentMethodID]
      ,PS.ID [PaymentStatusID]
  FROM [Transactions_betsson].[dbo].[DepositTransactions] P
  inner join PaymentStatusTBL PS on P.PaymentStatusName = PS.PaymentStatusName
  inner join PaymentMethodTBL PM ON P.PaymentMethodType = PM.PaymentMethodType and P.PaymentMethodName = PM.PaymentMethodName )AA
GO
ALTER TABLE PaymentTBL
ALTER COLUMN ID int NOT NULL;
GO
ALTER TABLE PaymentTBL
ADD CONSTRAINT PK_Payment PRIMARY KEY (ID);

----------------DepositTransactionsTable
select ROW_NUMBER() over (order by [CalendarDate],[amount_eur]) ID
      ,[CalendarDate]
      ,[CustomerID] 
	  ,P.ID [PaymentID]
	  ,[amount_eur] into DepositTransactionsTBL from (
SELECT  [CalendarDate]
      ,B.ID [CustomerID]
      ,PM.ID [PaymentMethodID]
      ,PS.ID [PaymentStatusID]
      ,[amount_eur] 
  FROM [Transactions_betsson].[dbo].[DepositTransactions] A
  inner join CustomerTBL B on A.CustomerEmail = B.CustomerEmail
  inner join PaymentMethodTBL PM ON A.PaymentMethodType = PM.PaymentMethodType and A.PaymentMethodName = PM.PaymentMethodName
  inner join PaymentStatusTBL PS on A.PaymentStatusName = PS.PaymentStatusName) Z
  inner join PaymentTBL P on Z.PaymentMethodID = P.PaymentMethodID and Z.PaymentStatusID = P.PaymentStatusID
  GO
ALTER TABLE DepositTransactionsTBL
ALTER COLUMN ID int NOT NULL;
GO
ALTER TABLE DepositTransactionsTBL
ADD CONSTRAINT PK_DepositTransactions PRIMARY KEY (ID);