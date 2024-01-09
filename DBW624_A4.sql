--DBW624 Assignment 4
--Note: in Assignment 2, sales_fact contains 100 sales records that are all in quarter 4, year 2023.
use dbw624;

--1. Sales Volumes Analysis by fiscal quarter
--a. by store
SELECT
	d.[Year], d.[Quarter], s.[StoreName] as Store, s.[StoreID], COUNT(*) AS SalesVolume
FROM [Sales_fact] sf
JOIN [Date_dimension] d ON sf.[DateID] = d.[DateID]
JOIN [Stores_dimension] s ON sf.[StoreID] = s.[StoreID]
GROUP BY d.[Year], d.[Quarter], s.[StoreName], s.[StoreID]
ORDER BY SalesVolume desc;

--b. by product
SELECT
	d.[Year], d.[Quarter], p.[ProductName], COUNT(*) AS SalesVolume
FROM [Sales_fact] sf
JOIN [Date_dimension] d ON sf.[DateID] = d.[DateID]
JOIN [Products_dimension] p ON sf.[ProductID] = p.[ProductID]
GROUP BY d.[Year], d.[Quarter], p.[ProductName]
ORDER BY SalesVolume desc;

--c. by age group
SELECT
	d.[Year], d.[Quarter], a.[AgeGroupName], COUNT(*) AS SalesVolume
FROM [Sales_fact] sf
JOIN [Date_dimension] d ON sf.[DateID] = d.[DateID]
JOIN [AgeGroup_dimension] a ON sf.[AgeGroupID] = a.[AgeGroupID]
GROUP BY d.[Year], d.[Quarter], a.[AgeGroupName]
ORDER BY SalesVolume desc;

--2. Sales Revenue Analysis by fiscal quarter
--a. by store
SELECT
	d.[Year], d.[Quarter], s.[StoreName], SUM(sf.[Revenue]) AS TotalRevenue
FROM [Sales_fact] sf
JOIN [Date_dimension] d ON sf.[DateID] = d.[DateID]
JOIN [Stores_dimension] s ON sf.[StoreID] = s.[StoreID]
GROUP BY d.[Year], d.[Quarter], s.[StoreName]
ORDER BY TotalRevenue desc;

--b. by product
SELECT
	d.[Year], d.[Quarter], p.[ProductName], SUM(sf.[Revenue]) AS TotalRevenue
FROM [Sales_fact] sf
JOIN [Date_dimension] d ON sf.[DateID] = d.[DateID]
JOIN [Products_dimension] p ON sf.[ProductID] = p.[ProductID]
GROUP BY d.[Year], d.[Quarter], p.[ProductName]
ORDER BY TotalRevenue desc;

--c. by age group
SELECT
	d.[Year], d.[Quarter], a.[AgeGroupName], SUM(sf.[Revenue]) AS TotalRevenue
FROM [Sales_fact] sf
JOIN [Date_dimension] d ON sf.[DateID] = d.[DateID]
JOIN [AgeGroup_dimension] a ON sf.[AgeGroupID] = a.[AgeGroupID]
GROUP BY d.[Year], d.[Quarter], a.[AgeGroupName]
ORDER BY TotalRevenue desc;

--3. Sales Profit Analysis by fiscal quarter
--a. by store
SELECT
	d.[Year], d.[Quarter], s.[StoreName], SUM((sf.[Revenue] - p.[ProductCost])) AS TotalProfit
FROM [Sales_fact] sf
JOIN [Date_dimension] d ON sf.[DateID] = d.[DateID]
JOIN [Stores_dimension] s ON sf.[StoreID] = s.[StoreID]
JOIN [Products_dimension] p ON sf.[ProductID] = p.[ProductID]
GROUP BY d.[Year], d.[Quarter], s.[StoreName]
ORDER BY TotalProfit desc;

--b. by product
SELECT
	d.[Year], d.[Quarter], p.[ProductName], SUM((sf.[Revenue] - p.[ProductCost])) AS TotalProfit
FROM [Sales_fact] sf
JOIN [Date_dimension] d ON sf.[DateID] = d.[DateID]
JOIN [Products_dimension] p ON sf.[ProductID] = p.[ProductID]
GROUP BY d.[Year], d.[Quarter], p.[ProductName]
ORDER BY TotalProfit desc;

--c. by age group
SELECT
	d.[Year], d.[Quarter], a.[AgeGroupName], SUM((sf.[Revenue] - p.[ProductCost])) AS TotalProfit
FROM [Sales_fact] sf
JOIN [Date_dimension] d ON sf.[DateID] = d.[DateID]
JOIN [AgeGroup_dimension] a ON sf.[AgeGroupID] = a.[AgeGroupID]
JOIN [Products_dimension] p ON sf.[ProductID] = p.[ProductID]
GROUP BY d.[Year], d.[Quarter], a.[AgeGroupName]
ORDER BY TotalProfit desc;

--4. Product Line Analysis by fiscal quarter, measured by revenue and profit
--a. Which products have been the most / least successful
SELECT
	d.[Year], d.[Quarter], p.[ProductName], SUM(sf.[Revenue]) AS TotalRevenue, SUM((sf.[Revenue] - p.[ProductCost])) AS TotalProfit
FROM [Sales_fact] sf
JOIN [Date_dimension] d ON sf.[DateID] = d.[DateID]
JOIN [Products_dimension] p ON sf.[ProductID] = p.[ProductID]
GROUP BY d.[Year], d.[Quarter], p.[ProductName]
ORDER BY TotalProfit DESC;

--b. Which product groups have been the most / least successful
SELECT
	d.[Year], d.[Quarter], a.[AgeGroupName], SUM(sf.[Revenue]) AS TotalRevenue, SUM((sf.[Revenue] - p.[ProductCost])) AS TotalProfit
FROM [Sales_fact] sf
JOIN [Date_dimension] d ON sf.[DateID] = d.[DateID]
JOIN [AgeGroup_dimension] a ON sf.[AgeGroupID] = a.[AgeGroupID]
JOIN [Products_dimension] p ON sf.[ProductID] = p.[ProductID]
GROUP BY d.[Year], d.[Quarter], a.[AgeGroupName]
ORDER BY TotalProfit DESC;

--c. What is the product trends (growth or declining)?
SELECT 
    d.[Year], d.[Quarter], p.[ProductName] AS Product, SUM(sf.[Revenue]) AS TotalRevenue, SUM((sf.[Revenue] - p.[ProductCost])) AS TotalProfit
FROM [Sales_fact] sf
JOIN [Date_dimension] d ON sf.[DateID] = d.[DateID]
JOIN [Products_dimension] p ON sf.[ProductID] = p.[ProductID]
WHERE p.[ProductID] = 10001
GROUP BY d.[Year], d.[Quarter], p.[ProductName];
--The sales data from assignment 2 are hypothetically only in October 2023

--5. Store Analysis by fiscal quarter, measured by revenue and profit
--a. Which stores are the most / least successful
SELECT
	d.[Year], d.[Quarter], s.[StoreName], SUM(sf.[Revenue]) AS TotalRevenue, SUM((sf.[Revenue] - p.[ProductCost])) AS TotalProfit
FROM [Sales_fact] sf
JOIN [Date_dimension] d ON sf.[DateID] = d.[DateID]
JOIN [Stores_dimension] s ON sf.[StoreID] = s.[StoreID]
JOIN [Products_dimension] p ON sf.[ProductID] = p.[ProductID]
GROUP BY d.[Year], d.[Quarter], s.[StoreName]
ORDER BY TotalRevenue DESC;
--b. What is the growth trends for each store (growth or declining)?
SELECT
	d.[Year], d.[Quarter], s.[StoreName], SUM(sf.[Revenue]) AS TotalRevenue, SUM((sf.[Revenue] - p.[ProductCost])) AS TotalProfit
FROM [Sales_fact] sf
JOIN [Date_dimension] d ON sf.[DateID] = d.[DateID]
JOIN [Stores_dimension] s ON sf.[StoreID] = s.[StoreID]
JOIN [Products_dimension] p ON sf.[ProductID] = p.[ProductID]
WHERE s.[StoreID] = 81003
GROUP BY d.[Year], d.[Quarter], s.[StoreName];

--6. Additional Analysis
--a. Which names have been most successful by volume
SELECT
	c.[CustFirstName], COUNT(*) AS SalesVolume
FROM [Sales_fact] sf
JOIN [Customers_dimension] c ON sf.[CustomerID] = c.[CustomerID]
GROUP BY c.[CustFirstName]
ORDER BY SalesVolume DESC;

--b. Which gender has been most successful by volume
SELECT c.[Gender], COUNT(*) AS SalesVolume
FROM [Sales_fact] sf
JOIN [Customers_dimension] c ON sf.[CustomerID] = c.[CustomerID]
GROUP BY c.[Gender];

--c. Who was the top sales person for the quarter?
SELECT d.[Year], d.[Quarter], sr.[SalesRepName], SUM(sf.[Revenue]) as SalesRevenue
FROM [Sales_fact] sf
JOIN [Date_dimension] d ON sf.[DateID] = d.[DateID]
JOIN [Salesrep_dimension] sr ON sf.[SalesRepID] = sr.[SalesRepID]
GROUP BY d.[Year], d.[Quarter], sr.[SalesRepName]
ORDER BY SalesRevenue desc;

--d. What percentage of sales are cash versus credit card?
--in assignment 2, all sales records are on debit/credit only, so there is only
--percentage of sales in debit/credit. 0% in cash.
SELECT
    pd.[PaymentType],
    CONCAT(CAST((100.0 * SUM(sf.[Revenue])) / (SELECT SUM([Revenue]) FROM [Sales_fact]) AS DECIMAL(10,2)),'%') AS Percentage
FROM [Sales_fact] sf
JOIN [Payment_dimension] pd ON sf.[PaymentID] = pd.[PaymentID]
GROUP BY pd.[PaymentType];

--e. What percentage of sales were using a marketing campaign?
--in assignment 2, all sales records are in Thanksgiving 2023.
SELECT
    m.[MktName] AS 'Marketing Campaign',
    CONCAT(CAST((100.0 * SUM(sf.[Revenue])) / (SELECT SUM([Revenue]) FROM [Sales_fact]) AS DECIMAL(10,2)),'%') AS Percentage
FROM [Sales_fact] sf
JOIN [Marketing_campaign_dimension] m ON sf.[MktID] = m.[MktID]
GROUP BY m.[MktName];

--7. Analytics Against Reference Tables
--a. Which ten cities should we open stores in, based on population?
--in assignment 2, there are stores in Toronto, Hamilton, Ottawa, Sudbury
--so it is advisable to look for another 10 city regions in Ontario (assignment 3)
SELECT TOP 10 CityRegion, Population
FROM Population
WHERE CityRegion NOT IN ('Toronto', 'Hamilton', 'Greater Sudbury', 'Ottawa')
ORDER BY Population DESC;

--b. Which names should we expect will be the most popular for our personalized products?
WITH RankedBabyNames AS (
    SELECT
        BabyName, Frequency, BabyGender,
        ROW_NUMBER() OVER (PARTITION BY BabyName, BabyGender ORDER BY Frequency DESC) AS NameRank
    FROM Baby_names
	 WHERE LEN(BabyName) >= 2 --some "names" have only 1 letter so I should exclude them for practical purposes.
)
SELECT
    BabyName, Frequency, BabyGender
FROM RankedBabyNames
WHERE NameRank = 1
ORDER BY Frequency DESC