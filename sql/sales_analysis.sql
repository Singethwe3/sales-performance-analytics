USE [sales_performance_db];
GO

-- 01. PREVIEW DATA
SELECT TOP (20) *
FROM dbo.sales_orders
ORDER BY [Row ID];
GO

-- 02. CHECK RECORD COUNTS AND UNIQUENESS
SELECT
    COUNT(*) AS TotalRows,
    COUNT(DISTINCT [Row ID]) AS UniqueRowIDs,
    COUNT(DISTINCT [Order ID]) AS UniqueOrders,
    COUNT(DISTINCT [Customer ID]) AS UniqueCustomers
FROM dbo.sales_orders;
GO

-- 03. CHECK MISSING VALUES IN IMPORTANT FIELDS
SELECT
    SUM(CASE WHEN [Row ID] IS NULL THEN 1 ELSE 0 END) AS MissingRowIDs,
    SUM(CASE WHEN [Order ID] IS NULL OR LTRIM(RTRIM([Order ID])) = '' THEN 1 ELSE 0 END) AS MissingOrderIDs,
    SUM(CASE WHEN [Order Date] IS NULL THEN 1 ELSE 0 END) AS MissingOrderDates,
    SUM(CASE WHEN [Category] IS NULL OR LTRIM(RTRIM([Category])) = '' THEN 1 ELSE 0 END) AS MissingCategories,
    SUM(CASE WHEN [Region] IS NULL OR LTRIM(RTRIM([Region])) = '' THEN 1 ELSE 0 END) AS MissingRegions,
    SUM(CASE WHEN [Sales] IS NULL THEN 1 ELSE 0 END) AS MissingSales,
    SUM(CASE WHEN [Profit] IS NULL THEN 1 ELSE 0 END) AS MissingProfit
FROM dbo.sales_orders;
GO

-- 04. FIND DUPLICATE ROW IDS (SHOULD RETURN ZERO ROWS)
SELECT [Row ID], COUNT(*) AS Occurrences
FROM dbo.sales_orders
GROUP BY [Row ID]
HAVING COUNT(*) > 1;
GO

-- 05. OVERALL BUSINESS KPIs
SELECT
    CAST(SUM([Sales]) AS DECIMAL(18,2)) AS TotalRevenue,
    CAST(SUM([Profit]) AS DECIMAL(18,2)) AS TotalProfit,
    CAST(100.0 * SUM([Profit]) / NULLIF(SUM([Sales]), 0) AS DECIMAL(10,2)) AS ProfitMarginPercent,
    COUNT(DISTINCT [Order ID]) AS TotalOrders,
    COUNT(DISTINCT [Customer ID]) AS TotalCustomers,
    SUM([Quantity]) AS UnitsSold,
    CAST(SUM([Sales]) / NULLIF(COUNT(DISTINCT [Order ID]), 0) AS DECIMAL(18,2)) AS AverageOrderValue
FROM dbo.sales_orders;
GO

-- 06. SALES AND PROFIT BY CATEGORY
SELECT
    [Category],
    CAST(SUM([Sales]) AS DECIMAL(18,2)) AS Revenue,
    CAST(SUM([Profit]) AS DECIMAL(18,2)) AS Profit,
    CAST(100.0 * SUM([Profit]) / NULLIF(SUM([Sales]), 0) AS DECIMAL(10,2)) AS ProfitMarginPercent,
    SUM([Quantity]) AS UnitsSold,
    COUNT(DISTINCT [Order ID]) AS Orders
FROM dbo.sales_orders
GROUP BY [Category]
ORDER BY Revenue DESC;
GO

-- 07. SALES AND PROFIT BY SUB-CATEGORY
SELECT
    [Category],
    [Sub-Category],
    CAST(SUM([Sales]) AS DECIMAL(18,2)) AS Revenue,
    CAST(SUM([Profit]) AS DECIMAL(18,2)) AS Profit,
    CAST(100.0 * SUM([Profit]) / NULLIF(SUM([Sales]), 0) AS DECIMAL(10,2)) AS ProfitMarginPercent,
    SUM([Quantity]) AS UnitsSold