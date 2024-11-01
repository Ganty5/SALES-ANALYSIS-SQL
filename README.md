Project: Advanced Sales Data Analysis using SQL

This project focuses on performing advanced data analysis on a comprehensive sales dataset (sales_data_sample). Utilizing SQL, the project demonstrates powerful techniques to derive insights into customer spending patterns, sales trends, and overall performance metrics. The dataset contains over 700 rows of sales information, covering various customer transactions, including order details, sales amounts, and product information.

Objectives Of the Analysis

	1.	Customer Spending Analysis:
	•	Analyzing total spend, number of orders, and average order value per customer.
	•	Sorting and identifying top customers based on total spend.
	2.	City-Based Sales Aggregation:
	•	Grouping total sales by city and filtering to identify high-revenue cities.
	•	Understanding regional sales distribution and focusing on cities with sales above a certain threshold.
	3.	Cumulative Sales Calculation:
	•	Using a running total (cumulative sum) to track each customer’s cumulative sales over time.
	•	This metric provides a view of customer retention and growth in spending across order dates.

SQL Techniques Used

	•	Window Functions: Leveraging SUM(SALES) OVER for calculating cumulative sales per customer.
	•	Grouping and Aggregation: Using GROUP BY along with aggregate functions (SUM, COUNT, AVG) to analyze data by customer, city, and other dimensions.
	•	Conditional Filtering: Using HAVING clauses to filter data based on aggregated metrics, such as showing cities with total sales above a specified value.
	•	Ordering and Sorting: Ordering results by specific columns to prioritize insights, such as sorting customers by highest spend.

Why This Project?

This project is designed to demonstrate advanced SQL skills essential for data analysis, including complex joins, aggregate functions, and window functions. The aim is to build a strong practical, real-world applications of SQL in analyzing and deriving insights from business data.
