--Top 20 customers by total Internet sales
SELECT TOP (20)
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    SUM(fis.SalesAmount) AS TotalSales
FROM 
FactInternetSales fis
INNER JOIN DimCustomer c ON fis.CustomerKey = c.CustomerKey
GROUP BY c.FirstName, c.LastName
ORDER BY TotalSales DESC;

SELECT COUNT(DISTINCT CustomerKey) FROM DimCustomer;
SELECT COUNT(DISTINCT CustomerKey) FROM FactInternetSales;


--Total 2014-onward Internet sales for all current products, including those with no sales
SELECT
dp.EnglishProductName AS ProductName,
dp.Color AS ProductColor,
SUM(fs.SalesAmount) AS SalesAmount
FROM
DimProduct AS dp
LEFT JOIN FactInternetSales AS fs ON fs.ProductKey = dp.ProductKey 
AND fs.OrderDate >= '20140101'
WHERE
dp.Status = 'Current'
GROUP BY
dp.EnglishProductName,
dp.Color
ORDER BY
SalesAmount DESC



--Combine products in key range 210-219 with the first 10 black products using UNION ALL
SELECT
ProductKey,
EnglishProductName,
Color,
Status,
ListPrice
FROM DimProduct
WHERE
ProductKey BETWEEN  210 AND 219
UNION ALL
SELECT TOP (10)
ProductKey,
EnglishProductName,
Color,
Status,
ListPrice
FROM DimProduct
WHERE
Color = 'Black'
ORDER BY 
ProductKey;



--Top 5 product subcategories by Internet sales in the United States (US Dollar transactions)
SELECT
TOP (5) dpsc.EnglishProductSubcategoryName AS SubCategory,
SUM(fs.SalesAmount) AS SalesAmount
FROM
FactInternetSales AS fs
JOIN DimProduct AS dp ON fs.ProductKey = dp.ProductKey
JOIN DimProductSubCategory AS dpsc ON dp.ProductSubCategoryKey = dpsc.ProductSubcategoryKey
JOIN DimSalesTerritory AS dst ON fs.SalesTerritoryKey = dst.SalesTerritoryKey
JOIN DimCurrency AS dcy ON fs.CurrencyKey = dcy.CurrencyKey
WHERE
dst.SalesTerritoryCountry = 'United States'
AND dcy.CurrencyName = 'US Dollar'
GROUP BY
dpsc.EnglishProductSubcategoryName
ORDER BY
SalesAmount DESC



-- Combine 2012 Canada sales from web (Internet) and reseller channels into one unified list using UNION
SELECT
--Sales and promo summary from Internet Sales
fs.SalesOrderNumber AS InvoiceNumber,
fs.SalesOrderLineNumber AS InvoiceLineNumber, 
fs.OrderDate AS OrderDate,
fs.SalesAmount AS SalesAmount,
fs.OrderQuantity AS Quantity,
dp.EnglishProductName AS ProductName,
dst.SalesTerritoryCountry AS Country,
dst.SalesTerritoryRegion AS Region,
'Web' AS Source
FROM
FactInternetSales AS fs
INNER JOIN DimProduct AS dp ON fs.ProductKey = dp.ProductKey
INNER JOIN DimSalesTerritory AS dst ON fs.SalesTerritoryKey = dst.SalesTerritoryKey
WHERE
YEAR(fs.OrderDate) = 2012
AND dst.SalesTerritoryCountry= 'Canada'
UNION
SELECT
--Sales and promo summary from Reseller sales
fs.SalesOrderNumber AS InvoiceNumber,
fs.SalesOrderLineNumber AS InvoiceLineNumber, 
fs.OrderDate AS OrderDate,
fs.SalesAmount AS SalesAmount,
fs.OrderQuantity AS Quantity,
dp.EnglishProductName AS ProductName,
dst.SalesTerritoryCountry AS Country,
dst.SalesTerritoryRegion AS Region,
dr.ResellerName AS Source
FROM
FactResellerSales AS fs
INNER JOIN DimProduct AS dp ON fs.ProductKey = dp.ProductKey
INNER JOIN DimSalesTerritory AS dst ON fs.SalesTerritoryKey = dst.SalesTerritoryKey
INNER JOIN DimReseller AS dr ON fs.ResellerKey = dr.ResellerKey
WHERE
YEAR(fs.OrderDate) = 2012
AND dst.SalesTerritoryCountry = 'Canada'
ORDER BY 
OrderDate DESC
