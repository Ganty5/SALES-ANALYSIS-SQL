-- understanding an overview of my dataset first
SELECT *
FROM sales_data_sample

--Simplifying the view and focus on the relevant data, selecting columns related to Order details
SELECT ORDERNUMBER, CUSTOMERNAME,ORDERDATE,SALES,STATUS
FROM sales_data_sample
ORDER BY ORDERDATE

-- checking for missing values and displaying the total missing values 
SELECT 
    SUM(CASE WHEN ORDERNUMBER IS NULL THEN 1 ELSE 0 END) AS Missing_ORDERNUMBER,
    SUM(CASE WHEN QUANTITYORDERED IS NULL THEN 1 ELSE 0 END) AS Missing_QUANTITYORDERED,
    SUM(CASE WHEN PRICEEACH IS NULL THEN 1 ELSE 0 END) AS Missing_PRICEEACH,
    SUM(CASE WHEN ORDERLINENUMBER IS NULL THEN 1 ELSE 0 END) AS Missing_ORDERLINENUMBER,
    SUM(CASE WHEN SALES IS NULL THEN 1 ELSE 0 END) AS Missing_SALES,
    SUM(CASE WHEN ORDERDATE IS NULL THEN 1 ELSE 0 END) AS Missing_ORDERDATE,
    SUM(CASE WHEN STATUS IS NULL THEN 1 ELSE 0 END) AS Missing_STATUS,
    SUM(CASE WHEN QTR_ID IS NULL THEN 1 ELSE 0 END) AS Missing_QTR_ID,
    SUM(CASE WHEN MONTH_ID IS NULL THEN 1 ELSE 0 END) AS Missing_MONTH_ID,
    SUM(CASE WHEN YEAR_ID IS NULL THEN 1 ELSE 0 END) AS Missing_YEAR_ID,
    SUM(CASE WHEN PRODUCTLINE IS NULL THEN 1 ELSE 0 END) AS Missing_PRODUCTLINE,
    SUM(CASE WHEN MSRP IS NULL THEN 1 ELSE 0 END) AS Missing_MSRP,
    SUM(CASE WHEN PRODUCTCODE IS NULL THEN 1 ELSE 0 END) AS Missing_PRODUCTCODE,
    SUM(CASE WHEN CUSTOMERNAME IS NULL THEN 1 ELSE 0 END) AS Missing_CUSTOMERNAME,
    SUM(CASE WHEN PHONE IS NULL THEN 1 ELSE 0 END) AS Missing_PHONE,
    SUM(CASE WHEN ADDRESSLINE1 IS NULL THEN 1 ELSE 0 END) AS Missing_ADDRESSLINE1,
    SUM(CASE WHEN ADDRESSLINE2 IS NULL THEN 1 ELSE 0 END) AS Missing_ADDRESSLINE2,
    SUM(CASE WHEN CITY IS NULL THEN 1 ELSE 0 END) AS Missing_CITY,
    SUM(CASE WHEN STATE IS NULL THEN 1 ELSE 0 END) AS Missing_STATE,
    SUM(CASE WHEN POSTALCODE IS NULL THEN 1 ELSE 0 END) AS Missing_POSTALCODE,
    SUM(CASE WHEN COUNTRY IS NULL THEN 1 ELSE 0 END) AS Missing_COUNTRY,
    SUM(CASE WHEN TERRITORY IS NULL THEN 1 ELSE 0 END) AS Missing_TERRITORY,
    SUM(CASE WHEN CONTACTLASTNAME IS NULL THEN 1 ELSE 0 END) AS Missing_CONTACTLASTNAME,
    SUM(CASE WHEN CONTACTFIRSTNAME IS NULL THEN 1 ELSE 0 END) AS Missing_CONTACTFIRSTNAME,
    SUM(CASE WHEN DEALSIZE IS NULL THEN 1 ELSE 0 END) AS Missing_DEALSIZE
FROM sales_data_sample


--Getting the overall sales summary with purpose of calculating total sales, total profit and average order across the data
-- Calculating for total sales, total profit and average sales for the orders

SELECT 
    SUM(SALES) AS Total_Sales,
    SUM(SALES - (PRICEEACH * QUANTITYORDERED)) AS Total_Profit,
    AVG(SALES) AS Average_Order_Value
FROM sales_data_sample

-- Generating a SALES PERFORMANCE ANALYSIS to understand the sales trend over time, identifying seasonality in order of monthly, quarterly and top-performing periods

-- Aggregating sales by month (Monthly Sales Trend)
SELECT 
    MONTH(ORDERDATE) AS Month, 
    YEAR(ORDERDATE) AS Year, 
    SUM(SALES) AS Monthly_Sales
FROM sales_data_sample
GROUP BY YEAR(ORDERDATE), MONTH(ORDERDATE)
ORDER BY Year, Month


--Quartely Sales Trend to identify quartely performance
SELECT 
    QTR_ID AS Quarter,
    YEAR_ID AS Year, 
    SUM(SALES) AS Quarterly_Sales
FROM sales_data_sample
GROUP BY YEAR_ID, QTR_ID
ORDER BY Year, Quarter

--Annual Sales Trend to identify yearly growth
SELECT 
    YEAR_ID AS Year, 
    SUM(SALES) AS Annual_Sales
FROM sales_data_sample
GROUP BY YEAR_ID
ORDER BY Year


-- PRODUCT PERFORMANCE ANALYSIS

-- identifying top-performing product lines and products with the highest sales or order volume
-- Sales by Product Line to show total sales and the average sales per order for each product line.
SELECT 
    PRODUCTLINE, 
    SUM(SALES) AS Total_Sales, 
    AVG(SALES) AS Avg_Sales_Per_Order
FROM sales_data_sample
GROUP BY PRODUCTLINE
ORDER BY Total_Sales DESC

-- Identifying top selling products
SELECT 
    PRODUCTCODE, 
	PRODUCTLINE,
    SUM(SALES) AS Total_Sales, 
    COUNT(ORDERNUMBER) AS Number_Of_Orders
FROM sales_data_sample
GROUP BY PRODUCTCODE, PRODUCTLINE
ORDER BY Total_Sales DESC


--CUSTOMER SEGMENTATION ANALYSIS
--Segmenting customers based on their purchase behavior to identify high-value customers and trends in customer loyalty.

-- Customer Spend analysis by total spend, number of their orders and average order value
SELECT 
    CUSTOMERNAME, 
    COUNT(ORDERNUMBER) AS Total_Orders,
    SUM(SALES) AS Total_Sales, 
    AVG(SALES) AS Avg_Order_Value
FROM sales_data_sample
GROUP BY CUSTOMERNAME
ORDER BY Total_Sales DESC



--Calculating total sales by city and filtering to see only those cities where total sales exceed a certain amount
SELECT CITY, SUM(SALES) AS Total_Sales
FROM sales_data_sample
GROUP BY CITY
HAVING SUM(Sales) > 100000


--Categorizing customers based on their order quantity

SELECT CUSTOMERNAME, QUANTITYORDERED,
    CASE 
        WHEN QUANTITYORDERED >= 50 THEN 'High'
        WHEN QUANTITYORDERED BETWEEN 20 AND 30 THEN 'Medium'
        ELSE 'Low'
    END AS Order_Category
FROM sales_data_sample

-- calculating cumulative sales for each customer across their orders.
SELECT CUSTOMERNAME, ORDERDATE, SALES,
    SUM(SALES) OVER (PARTITION BY CUSTOMERNAME ORDER BY ORDERDATE) AS Cumulative_Sales
FROM sales_data_sample
ORDER BY CUSTOMERNAME, ORDERDATE


--Ranking Customers based on sales
SELECT CUSTOMERNAME, COUNTRY, SUM(SALES) AS Total_Sales,
    RANK() OVER (PARTITION BY COUNTRY ORDER BY SUM(SALES) DESC) AS Sales_Rank
FROM sales_data_sample
GROUP BY CUSTOMERNAME, COUNTRY
ORDER BY COUNTRY, Sales_Rank

--Self-Join to Find Orders Placed by the Same Customer in Different Months
SELECT a.CUSTOMERNAME, a.ORDERDATE AS Order_Date_1, b.ORDERDATE AS Order_Date_2,
       a.SALES AS Sales_1, b.SALES AS Sales_2
FROM sales_data_sample a
JOIN sales_data_sample b ON a.CUSTOMERNAME = b.CUSTOMERNAME
WHERE MONTH(a.ORDERDATE) <> MONTH(b.ORDERDATE)
ORDER BY a.CUSTOMERNAME, a.ORDERDATE


-- counting high, medium, and low sales orders per city.
SELECT CITY,
    SUM(CASE WHEN SALES > 500 THEN 1 ELSE 0 END) AS High_Sales_Orders,
    SUM(CASE WHEN SALES BETWEEN 100 AND 500 THEN 1 ELSE 0 END) AS Medium_Sales_Orders,
    SUM(CASE WHEN SALES < 100 THEN 1 ELSE 0 END) AS Low_Sales_Orders
FROM sales_data_sample
GROUP BY CITY


--checking if a customer placed more than one order in different quarters.

SELECT CUSTOMERNAME, COUNT(DISTINCT QTR_ID) AS Quarters_Ordered
FROM sales_data_sample
GROUP BY CUSTOMERNAME
HAVING COUNT(DISTINCT QTR_ID) > 1










