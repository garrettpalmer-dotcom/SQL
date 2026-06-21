--Paginated invoice totals (rows 101-120) for territories 6-8 with mid-range tax amounts
SELECT
SalesOrderNumber AS InvoiceNumber,
OrderDate,
SUM(SalesAmount) AS TotalAmount,
SUM(TaxAmt) AS TaxAmount,
SUM(OrderQuantity) AS TotalQuantity
FROM FactInternetSales
WHERE 
SalesTerritoryKey IN (6,7,8) 
AND TaxAmt BETWEEN 150 AND 200
GROUP BY 
SalesOrderNumber, 
OrderDate
HAVING SUM(SalesAmount) > 200
ORDER BY OrderDate DESC, TotalAmount DESC
OFFSET 100 ROWS FETCH NEXT 20 ROWS ONLY;



--Compare total line rows to distinct invoices for territory 6 (reveals multi-line orders)
SELECT
COUNT(*) AS TableRowCount,
COUNT(DISTINCT SalesOrderNumber) AS DistinctInvoices
FROM
FactInternetSales
WHERE
SalesTerritoryKey=6 



--Invoice totals for territory 6, filtered to 7-character SO4-prefixed order numbers
SELECT
SalesOrderNumber AS InvoiceNumber,
OrderDate,
SUM(SalesAmount) AS InvoiceSubTotal,
SUM(TaxAmt) AS TaxAmount,
SUM(OrderQuantity) AS TotalQuantity
FROM FactInternetSales
WHERE SalesTerritoryKey = 6
AND SalesOrderNumber LIKE 'SO4____'
GROUP BY 
SalesOrderNumber,
OrderDate
HAVING 
SUM(SalesAmount) > 200
ORDER BY 
OrderDate DESC, InvoiceSubTotal DESC



--Classify invoices by size and item count using CASE and IIF, with per-invoice totals
SELECT
SalesOrderNumber AS InvoiceNumber,
OrderDate,
CASE 
WHEN SUM(SalesAmount) >= 2000 THEN 'Large'  
WHEN SUM(SalesAmount) >= 1000 THEN 'Medium' 
ELSE 'Small'
END AS InvoiceSize,
IIF(SUM(OrderQuantity) >= 3, 'Multi-Item', '1-2 Items') AS QuantityType,
SUM(SalesAmount) AS InvoiceSubTotal,
SUM(TaxAmt) AS TaxAmount,
SUM(OrderQuantity) AS TotalQuantity
FROM 
FactInternetSales
WHERE 
SalesTerritoryKey = 6
GROUP BY 
SalesOrderNumber,
OrderDate
HAVING 
SUM(SalesAmount) > 200
ORDER BY 
OrderDate DESC, InvoiceSubTotal DESC



--Rank products by revenue with conditional tier labels using CASE and IIF
SELECT TOP (25)
ProductKey,
COUNT(DISTINCT SalesOrderNumber) AS DistinctInvoices,
AVG(SalesAmount) AS AvgLineRevenue,
CASE
	WHEN SUM(SalesAmount) >= 50000 THEN 'Platinum'
	WHEN SUM(SalesAmount) >= 20000 THEN 'Gold'
	ELSE 'Silver'
END AS RevenueTier,
IIF(COUNT(*) >= 20, 'High', 'Normal') AS HighVolumeFlag
FROM
FactInternetSales
WHERE CurrencyKey IN (19,100)
AND PromotionKey <> 1
GROUP BY
ProductKey
HAVING
SUM(SalesAmount) >= 10000
ORDER BY
AvgLineRevenue DESC;



--Count customers by title for titles starting with M (or missing), with distinct last-name counts
SELECT
Title,
COUNT(*) AS NumCustomers,
COUNT(DISTINCT LastName) AS LastNames
FROM
DimCustomer
WHERE
Title LIKE 'M%'
OR Title IS NULL
GROUP BY
Title
ORDER BY
NumCustomers;
