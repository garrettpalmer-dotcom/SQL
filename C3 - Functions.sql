--Convert product data types with CAST and CONVERT (numbers, dates, and string building)
SELECT 
ProductKey,
'Product #' + CAST(ProductKey AS VARCHAR(10)) AS ProductName,
ListPrice,
CAST(ListPrice AS DECIMAL(10,2)) AS ListPrice_d,
Weight,
CAST(Weight AS INT) AS Weight_i,
StartDate,
CONVERT(varchar(10), StartDate, 101) AS StartDate_d
FROM
DimProduct
WHERE
ProductKey BETWEEN 200 AND 299



--Build full and display names with NULL-safe string handling and safe division
SELECT
CustomerKey,
Title,
FirstName,
MiddleName,
LastName,
FirstName + ' ' + ISNULL(MiddleName + ' ', '') + LastName AS FullName,
COALESCE(
    Title + ' ' +LastName,
    FirstName + ' ' + ISNULL(MiddleName + ' ', '') + LastName
) AS DisplayName,
NumberChildrenAtHome AS ChildHome,
TotalChildren AS ChildTotal,
NumberChildrenAtHome / NULLIF(TotalChildren, 0) AS PerChildHome
FROM
DimCustomer
ORDER BY
CustomerKey;



--String function demonstrations on a single product (length, case, replace, substring)
SELECT
ProductKey,
ProductAlternateKey,
EnglishProductName AS ProductName,
CONCAT(ProductAlternateKey, ' - ', EnglishProductName) AS ProductKeyName,
LEN(EnglishProductName) AS NameLength,
UPPER(EnglishProductName) AS UpperName,
LOWER(EnglishProductName) AS LowerName,
REPLACE(EnglishProductName, 'Front', 'Ultra Durable') AS NameReplaced,
LEFT(ProductAlternateKey, 2) AS ProductShort,
RIGHT(ProductAlternateKey, 4) AS ProductEnd
FROM
DimProduct
WHERE
ProductKey = 555



--Invoice-level sales and tax totals with rounding/math functions, filtered to high-value orders
SELECT
SalesOrderNumber AS InvoiceNumber,
OrderDate,
SUM(SalesAmount) AS InvoiceSubTotal,
SUM(TaxAmt) AS TaxAmount,
ROUND(SUM(TaxAmt), 2) AS TaxRounded,
FLOOR(SUM(TaxAmt)) AS TaxFloor,
CEILING(SUM(TaxAmt)) AS TaxCeiling,
SUM(OrderQuantity) AS TotalQuantity,
SUM(SalesAmount) - 1500 AS SubTotalVsTarget,
ABS(SUM(SalesAmount) - 1500) AS MagDifference
FROM 
FactInternetSales
WHERE 
SalesTerritoryKey = 6
GROUP BY
SalesOrderNumber,
OrderDate
HAVING
(SUM(SalesAmount) > 1000)
ORDER BY
SalesOrderNumber DESC



--Date function demonstrations on a single sales order (parts, differences, and offsets)
SELECT DISTINCT
GETDATE() AS DateTimeStamp,
OrderDate,
DueDate,
ShipDate,
DATENAME(weekday, OrderDate) AS InvoiceDayOfWeek,
DATEPART(week, OrderDate) AS InvoiceWeek,
YEAR(OrderDate) AS OrderYear,
MONTH(OrderDate) AS OrderMonth,
DATEDIFF(DAY,ShipDate, DueDate) AS DaysBetween,
DATEADD(DAY, -10, DueDate) AS DueDateMinus10
FROM
FactInternetSales
WHERE
SalesOrderNumber= 'SO74443'
ORDER BY
OrderDate DESC



--Black products with type conversions and NULL/missing-value handling
SELECT
TOP (25) ProductKey,
ProductAlternateKey,
CAST(ListPrice AS decimal(12,2)) AS ListPrice,
CONVERT(date, StartDate) AS StartDate_Date,
CONVERT(date,COALESCE(EndDate, DATEADD(day, 30, StartDate))) AS EndDate_Filled,
CAST(ListPrice AS decimal(12,2)) / NULLIF(Weight, 0) AS PricePerUnitWeight,
ISNULL(NULLIF(Size, ''), '(no size)') AS Size_Filled
FROM
DimProduct
WHERE
ListPrice IS NOT NULL
AND Color = 'Black'
ORDER BY
ProductKey;



--Customer display formatting and date calculations using string and date functions
SELECT
TOP (10) CustomerKey,
CONCAT(UPPER(LastName), ', ', LEFT(FirstName, 1)) AS DisplayName,
REPLACE(EmailAddress, '@', ' [at] ') AS EmailMasked,
ABS(YearlyIncome - 75000) AS AbsDiffFrom75000,
DATENAME(weekday, BirthDate) AS BirthWeekdayName,
DATEPART(week, BirthDate) AS BirthWeekOfYear,
DATEDIFF(week, DateFirstPurchase, GETDATE()) AS WeeksSinceFirstPurchase
FROM
DimCustomer
WHERE
BirthDate IS NOT NULL
ORDER BY 
CommuteDistance DESC;
