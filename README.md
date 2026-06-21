# SQL Query Portfolio — AdventureWorks Data Warehouse

A collection of T-SQL queries written against the **AdventureWorksDW** sample data
warehouse using Microsoft SQL Server (queried through Azure SQL / VS Code). The
queries were built while working through the SQL modules of the **CFI Business
Intelligence & Data Analyst (BIDA)** program and demonstrate core querying,
data-cleaning, and analysis techniques on a star-schema sales dataset.

The work is organized by topic, with each query commented to describe what it
does and why.

## Dataset

AdventureWorksDW — a dimensional model of a fictional bicycle-and-accessories
company. Queries draw on:

- **Fact tables:** `FactInternetSales`, `FactResellerSales`
- **Dimensions:** `DimProduct`, `DimProductSubcategory`, `DimCustomer`,
  `DimSalesTerritory`, `DimReseller`, `DimCurrency`, `DimDate`

## Skills demonstrated

**Single-table querying & filtering**
- `SELECT`, `WHERE`, `ORDER BY`, `TOP`
- Range and list filters: `BETWEEN`, `IN`
- Pattern matching with `LIKE`, including the `%` (any length) and `_`
  (single character) wildcards
- Explicit NULL handling in filters (`IS NULL` / `IS NOT NULL`)

**Data types & conversion**
- `CAST` and `CONVERT`, including date style codes (e.g. `101` for mm/dd/yyyy)
- Building text labels by converting numeric keys for concatenation

**String functions**
- `CONCAT`, `UPPER`, `LOWER`, `LEN`, `REPLACE`, `LEFT`, `RIGHT`

**Date functions**
- `GETDATE`, `YEAR`, `MONTH`, `DATENAME`, `DATEPART`, `DATEDIFF`, `DATEADD`

**NULL & missing-value handling**
- `ISNULL`, `COALESCE`, `NULLIF`
- Guarding against divide-by-zero with `NULLIF(x, 0)`
- Preventing NULL "poisoning" when concatenating optional fields

**Math & rounding**
- `ROUND`, `FLOOR`, `CEILING`, `ABS`

**Aggregation & grouping**
- `SUM`, `AVG`, `COUNT`, `COUNT(DISTINCT …)`
- `GROUP BY` with `HAVING`, and correct separation of row-level filters
  (`WHERE`) from group-level filters (`HAVING`)
- Using `COUNT(*)` vs `COUNT(column)` to measure NULLs and data grain

**Conditional logic**
- Multi-branch `CASE` expressions for tiering
- `IIF` for two-way flags

**Set operations**
- `UNION` and `UNION ALL` to combine result sets from multiple sources

**Multi-table joins**
- `INNER JOIN` and `LEFT JOIN` across fact and dimension tables
- Placing filter conditions in the `ON` clause vs the `WHERE` clause to
  preserve outer-join behavior

**Result paging**
- `OFFSET … FETCH NEXT … ROWS ONLY` for pagination

## Repository structure

```
/
├── C1 - Aggregation and Grouping.sql
├── C2 - Filtering, Conditional Logic and Pagination.sql
├── C3 - Functions.sql
├── C4 - Combining Tables.sql
└── README.md
```

Each file groups several related queries from that chapter, with a `--` comment
above each query describing what it does.

## How to read it

Each `.sql` file contains several related queries, each preceded by a `--`
comment describing the task it solves. The queries are written for Microsoft
SQL Server (T-SQL) and were run interactively in Visual Studio Code against an
AdventureWorksDW database.

## Note on scope

These queries were developed as structured practice while completing the CFI
BIDA SQL coursework. They are intended to demonstrate working proficiency with
T-SQL querying and data-preparation techniques on a realistic dimensional model.

---

*Author: Garrett Palmer*
