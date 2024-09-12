-- create schema retail_shop;
use retail_shop;
select * from online_retail;
select CustomerID, SUM(Quantity * UnitPrice) as TotalOrderValue 
from online_retail
group by customerID
order by TotalOrderValue DESC;

-- ow many unique products has each customer purchased?
SELECT CustomerID, COUNT(DISTINCT StockCode) AS UniqueProductsPurchased
FROM online_retail
GROUP BY CustomerID
ORDER BY UniqueProductsPurchased DESC;



--  Which customers have only made a single purchase from the company?
SELECT CustomerID
FROM online_retail
GROUP BY CustomerID
HAVING COUNT(InvoiceNo) = 1;



--  Which products are most commonly purchased together by customers in the dataset?
SELECT A.StockCode AS ProductA, B.StockCode AS ProductB, COUNT(*) AS Frequency
FROM online_retail A
JOIN online_retail B ON A.InvoiceNo = B.InvoiceNo AND A.StockCode < B.StockCode
GROUP BY ProductA, ProductB
ORDER BY Frequency DESC
LIMIT 10;

-- Customer Segmentation by Purchase Frequency
SELECT CustomerID,
       COUNT(InvoiceNo) AS PurchaseCount,
       CASE
           WHEN COUNT(InvoiceNo) >= 20 THEN 'High Frequency'
           WHEN COUNT(InvoiceNo) BETWEEN 10 AND 19 THEN 'Medium Frequency'
           ELSE 'Low Frequency'
       END AS PurchaseFrequency
FROM online_retail
GROUP BY CustomerID
ORDER BY PurchaseCount DESC;



-- Average Order Value by Country

SELECT Country,
       AVG(Quantity * UnitPrice) AS AverageOrderValue
FROM online_retail
GROUP BY Country
ORDER BY AverageOrderValue DESC;


-- Customer Churn Analysis
SELECT CustomerID
FROM online_retail
GROUP BY CustomerID
HAVING MAX(InvoiceDate) < (CURRENT_DATE - INTERVAL 6 MONTH);

-- Product Affinity Analysis
WITH ProductPairs AS (
    SELECT 
        t1.StockCode AS Product1,
        t2.StockCode AS Product2,
        COUNT(*) AS CoOccurrenceCount
    FROM online_retail t1
    JOIN
       online_retail  t2
    ON t1.InvoiceNo = t2.InvoiceNo
        AND t1.StockCode < t2.StockCode
    GROUP BY 
        t1.StockCode, t2.StockCode
)
SELECT 
    Product1, 
    Product2, 
    CoOccurrenceCount
FROM ProductPairs
ORDER BY CoOccurrenceCount DESC;

--  Time-based Analysis
SELECT
    CONCAT(YEAR(InvoiceDate), ' Q', QUARTER(InvoiceDate)) AS Quarter,  
    SUM(Quantity * UnitPrice) AS TotalSales                           
FROM
    online_retail                               
GROUP BY
    YEAR(InvoiceDate), QUARTER(InvoiceDate)                           
ORDER BY
    YEAR(InvoiceDate), QUARTER(InvoiceDate);            

SELECT
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS Month,  
    SUM(Quantity * UnitPrice) AS TotalSales      
FROM
    online_retail                      
GROUP BY
    DATE_FORMAT(InvoiceDate, '%Y-%m')            
ORDER BY
    Month;