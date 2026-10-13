
SELECT TOP 10 *
FROM SalespersonData;


SELECT COUNT(*) AS Total_Rows
FROM SalespersonData;

SELECT
    order_id,
    COUNT(*) AS Occurrences
FROM SalespersonData
GROUP BY order_id
HAVING COUNT(*) > 1


-- Calculate sales for each salesperson
SELECT salesperson, SUM(total) AS Total_Sales
FROM SalespersonData
GROUP BY salesperson
ORDER BY Total_Sales DESC;



-- Count unique orders for each salesperson
SELECT salesperson, COUNT(DISTINCT order_id) AS Total_Orders
FROM SalespersonData
GROUP BY salesperson
ORDER BY Total_Orders DESC;


-- Calculate total units sold by each salesperson
SELECT salesperson, SUM(quantity) AS Units_Sold
FROM SalespersonData
GROUP BY salesperson
ORDER BY Units_Sold DESC;


-- Calculate average value per order
WITH OrderSales AS (
    SELECT salesperson, order_id, SUM(total) AS Order_Total
    FROM SalespersonData
    GROUP BY salesperson, order_id
)
SELECT
    salesperson,
    SUM(Order_Total) AS Total_Sales,
    COUNT(*) AS Total_Orders,
    AVG(Order_Total) AS Average_Order_Value
FROM OrderSales
GROUP BY salesperson
ORDER BY Average_Order_Value DESC;


-- Rank salespeople by total sales
SELECT
    salesperson,
    SUM(total) AS Total_Sales,
    RANK() OVER (ORDER BY SUM(total) DESC) AS Sales_Rank
FROM SalespersonData
GROUP BY salesperson
ORDER BY Sales_Rank;


-- Summarize overall sales performance
SELECT
    COUNT(DISTINCT salesperson) AS Total_Salespeople,
    COUNT(DISTINCT order_id) AS Total_Orders,
    SUM(quantity) AS Total_Units_Sold,
    SUM(total) AS Total_Sales,
    AVG(total) AS Average_Row_Sale
FROM SalespersonData;


-- Calculate total sales for each month
SELECT
    YEAR([date]) AS Sales_Year,
    MONTH([date]) AS Sales_Month,
    SUM(total) AS Monthly_Sales
FROM SalespersonData
GROUP BY YEAR([date]), MONTH([date])
ORDER BY Sales_Year, Sales_Month;


-- Compare January–March with April–June 2026
WITH SalesPeriods AS (
    SELECT
        salesperson,
        SUM(CASE
            WHEN [date] >= '20260101' AND [date] < '20260401'
            THEN total ELSE 0 END) AS Jan_Mar_Sales,
        SUM(CASE
            WHEN [date] >= '20260401' AND [date] < '20260701'
            THEN total ELSE 0 END) AS Apr_Jun_Sales
    FROM SalespersonData
    GROUP BY salesperson
)
SELECT
    salesperson,
    Jan_Mar_Sales,
    Apr_Jun_Sales,
    Apr_Jun_Sales - Jan_Mar_Sales AS Sales_Change,
    CASE
        WHEN Jan_Mar_Sales = 0 THEN NULL
        ELSE (Apr_Jun_Sales - Jan_Mar_Sales) * 100.0
             / Jan_Mar_Sales
    END AS Sales_Growth_Percentage
FROM SalesPeriods
ORDER BY Sales_Growth_Percentage DESC;


-- Compare sales and order volume across regions
SELECT
    region,
    SUM(total) AS Total_Sales,
    COUNT(DISTINCT order_id) AS Total_Orders,
    SUM(quantity) AS Units_Sold
FROM SalespersonData
GROUP BY region
ORDER BY Total_Sales DESC;


-- Rank salespeople separately within each region
SELECT
    region,
    salesperson,
    SUM(total) AS Total_Sales,
    COUNT(DISTINCT order_id) AS Total_Orders,
    RANK() OVER (
        PARTITION BY region
        ORDER BY SUM(total) DESC
    ) AS Regional_Rank
FROM SalespersonData
GROUP BY region, salesperson
ORDER BY region, Regional_Rank;


-- Calculate each salesperson's share of total sales
SELECT
    salesperson,
    SUM(total) AS Total_Sales,
    SUM(total) * 100.0 /
        NULLIF(SUM(SUM(total)) OVER (), 0)
        AS Sales_Contribution_Percentage
FROM SalespersonData
GROUP BY salesperson
ORDER BY Total_Sales DESC;


-- Find the three highest-selling salespeople
SELECT TOP 3
    salesperson,
    SUM(total) AS Total_Sales
FROM SalespersonData
GROUP BY salesperson
ORDER BY Total_Sales DESC;


-- Find the three lowest-selling salespeople
SELECT TOP 3
    salesperson,
    SUM(total) AS Total_Sales
FROM SalespersonData
GROUP BY salesperson
ORDER BY Total_Sales ASC;
















