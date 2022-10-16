/****** Script for SelectTopNRows command from SSMS  ******/
 
 /*
Which are the 10 largest completed deposit transactions? Extract the amount, customer
email, customer brand name and calendar date.
*/
select * from (
SELECT [CalendarDate]
      ,C.[CustomerEmail]
      ,B.[CustomerBrand]
      ,[amount_eur]
	  ,ROW_NUMBER() over (order by [amount_eur] desc) Rnum
  FROM [Transactions_betsson].[dbo].[DepositTransactionsTBL] T
  inner join CustomerTBL C on T.CustomerID = C.ID
  inner join BrandTBL B on C.BrandID = B.ID
  inner join PaymentTBL P on T.PaymentID = P.ID
  inner join PaymentStatusTBL PS on P.PaymentStatusID = PS.ID
  where PS.PaymentStatusName = 'Completed') A
  where Rnum <=10

  /*
What is the total number and amount of failed deposit transactions per brand? Extract
total number, amount, customer brand name, paymentstatus.
  */

    SELECT Count(1) [Total Number]
      ,B.CustomerBrand [CustomerBrandName]
      ,PS.[PaymentStatusName]
      ,sum([amount_eur]) [Amount]
  FROM [Transactions_betsson].[dbo].[DepositTransactionsTBL] D
  inner join CustomerTBL C on D.CustomerID = C.ID
  inner join BrandTBL B on C.BrandID = B.ID
  inner join PaymentTBL P on D.PaymentID = P.ID
  inner join PaymentStatusTBL PS on P.PaymentStatusID = PS.ID
  where PS.[PaymentStatusName] ='Failed'
  group by B.CustomerBrand ,PS.[PaymentStatusName]

  /*
  How much daily turnover and accounting revenue did each brand generate per product
in the first 6 days of the year? Extract turnover, accountingrevenue, brand. 
  */

   SELECT   B.[CustomerBrand]
      ,sum([turnover_EUR]) [daily turnover]
      ,sum([totalAccountingRevenue_EUR]) [accounting revenue]
  FROM [Transactions_betsson].[dbo].[GamePlayTransactionsTBL] A
  inner join CustomerTBL C on A.CustomerID = C.ID
  inner join BrandTBL B on C.BrandID = B.ID
  inner join ProvideTBL P on A.ProviderID = P.ID
  where MONTH(cast(convert( nvarchar , [CalendarDate] ) as date)) = 1 and day(cast(convert( nvarchar , [CalendarDate] ) as date)) < 7
  group by B.[CustomerBrand],P.[ProviderProductName]
  order by 1


  /*
  What is the average gamewin per product? Extract the average gamewin and product.
  */

  SELECT [ProviderProductName] [product]
      ,avg([gameWin_EUR]) [average gamewin]
  FROM [Transactions_betsson].[dbo].[GamePlayTransactionsTBL] A
  inner join ProvideTBL P on A.ProviderID = P.ID
  group by [ProviderProductName]


  /*
  Which customers had a lifetime total turnover of 500 EUR or more and what was this
total turnover amount? Extract turnover, customeremail, customer
  */

  select * from (
SELECT SUBSTRING([CustomerEmail], 1, charindex('@', [CustomerEmail] )-1)  customer
       ,[CustomerEmail]
      ,Sum([turnover_EUR]) [total turnover]
  FROM [Transactions_betsson].[dbo].[GamePlayTransactionsTBL] A
  inner join CustomerTBL C on A.CustomerID = C.ID
  group by [CustomerEmail]) AA
  where [total turnover] >= 500