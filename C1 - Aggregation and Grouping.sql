--Per-invoice sales, tax, and quantity totals for territory 6 (orders over $200)
SELECT 
SalesOrderNumber AS InvoiceNumber,
OrderDate,
SUM(SalesAmount) AS TotalAmount,
SUM(TaxAmt) AS TaxAmount,
SUM(OrderQuantity) AS TotalQuantity
FROM FactInternetSales
WHERE SalesTerritoryKey = 6
GROUP BY 
SalesOrderNumber, 
OrderDate
HAVING SUM(SalesAmount) > 200
ORDER BY OrderDate DESC, TotalAmount DESC



--Total product cost per customer, limited to customers under $2,000 lifetime
SELECT
CustomerKey AS Customer,
SUM(TotalProductCost) AS TotalProductCost
FROM
FactInternetSales
GROUP BY
CustomerKey
HAVING
SUM(TotalProductCost) < 2000
ORDER BY
TotalProductCost DESC



--Average sale amount and invoice count per line-number position, for one currency
SELECT
SalesOrderLineNumber AS InvoiceLineNumber,
COUNT(SalesOrderNumber) AS NumInvoices,
AVG(SalesAmount) AS AvgAmount
FROM
FactInternetSales
WHERE
CurrencyKey = 100
GROUP BY
SalesOrderLineNumber
ORDER BY
SalesOrderLineNumber
