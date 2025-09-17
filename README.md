# SQL Data Warehouse and Analytics Project - Part 2: Data Analytics

## 🌟 About Me

Hey, I'm **JunFai Kan**. I’m a Master of Data Science graduate passionate in pursuing my career in data engineering !

I get excited about opportunities to design scalable data pipelines, build analytical data models, and leverage modern cloud platforms like Azure and Fabric to deliver impactful business insights.

Let's connect on LinkedIn!

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/junfaikan/)

--- 

## 📖 Project Overview

Welcome to Part 2 of my **SQL Data Warehouse and Analytics Project** !

This analytics project builds on the previous [Data Warehouse Project developed in Part 1](https://github.com/faiceps/data-warehouse), 
extending into a business analytics layer to answer real business questions. 

In this project, I used SQL-based analytics to explore data, build metrics, and deliver actionable insights that mirror real-world BI use cases.

This project involves:

**A.  Exploratory Data Analysis (EDA)**
1.  Database and schema exploration.
2.  Dimensions exploration.
3.  Date range exploration.
4.  Key measures exploration.
5.  Magnitude analysis.
6.  Ranking analysis.

**B.  Advanced Analytics**
1.  Change over time analysis.
2.  Cumulative analysis.
3.  Performance analysis.

As this SQL analytics project is a work in progress, more **advanced analytics** will be performed, such as:

-  Customer segmentation.
-  Customer report.
-  Product report.

This project demonstrates my ability to transform warehouse data into decision-ready insights. 

It showcases skills in SQL analytics, time-series analysis, KPI definition, and BI reporting logic, which are crucial for building dashboards in Power BI and Fabric.

---

## A. Exploratory Data Analysis (EDA)

### Script 1.  Database and Schema Exploration

Script: [database-exploration.sql](scripts/database-exploration.sql)

Purpose:

- To explore the structure of the database, including the list of tables and their schemas.
- To inspect the columns and metadata for specific tables.

Table Used:
- INFORMATION_SCHEMA.TABLES
- INFORMATION_SCHEMA.COLUMNS

```sql
-- Retrieve a list of all tables in the database
SELECT 
    TABLE_CATALOG, 
    TABLE_SCHEMA, 
    TABLE_NAME, 
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES;
```
List of all tables in the database:

<img width="538" height="387" alt="image" src="https://github.com/user-attachments/assets/e428dcec-3a77-45a0-9bc9-8bc4666cd468" />

```sql
-- Retrieve all columns for a specific table (dim_customers)
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE, 
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';
```
All columns for a specific table (dim_customers):

<img width="619" height="266" alt="image" src="https://github.com/user-attachments/assets/75d150a1-2148-46b6-87bb-0666dfadeca1" />

---

### Script 2.  Dimensions Exploration

Script: [dimensions-exploration.sql](scripts/dimensions-exploration.sql)

Purpose:

- To explore the structure of dimension tables.
	
SQL Functions Used:

- DISTINCT
- ORDER BY

```sql
-- Retrieve a list of unique countries from which customers originate
SELECT DISTINCT 
    country 
FROM gold.dim_customers
ORDER BY country;
```
List of unique countries from which customers originate:

<img width="161" height="199" alt="image" src="https://github.com/user-attachments/assets/f95f15f7-500c-49a7-847d-cbd7023125b8" />

```sql
-- Retrieve a list of unique categories, subcategories, and products
SELECT DISTINCT 
    category, 
    subcategory, 
    product_name 
FROM gold.dim_products
ORDER BY category, subcategory, product_name;
```
List of unique categories, subcategories, and products - 295 unique rows returned:

<img width="422" height="510" alt="image" src="https://github.com/user-attachments/assets/be7181fc-70a3-447a-9d82-cf326a5b7fb6" />

---

### Script 3.  Date Range Exploration.

Script: [date-range-exploration.sql](scripts/date-range-exploration.sql)

Purpose:

- To determine the temporal boundaries of key data points.
- To understand the range of historical data.

SQL Functions Used:

- MIN(), MAX(), DATEDIFF()

```sql
-- Determine the first and last order date and the total duration in months
SELECT 
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS order_range_months
FROM gold.fact_sales;
```
The first and last order date and the total duration in months:

<img width="413" height="50" alt="image" src="https://github.com/user-attachments/assets/f8149b1d-69db-4dd1-a2c4-a1eb60f9a508" />

```sql
-- Find the youngest and oldest customer based on birthdate
SELECT
    MIN(birthdate) AS oldest_birthdate,
    DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS oldest_age,
    MAX(birthdate) AS youngest_birthdate,
    DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS youngest_age
FROM gold.dim_customers;
```
The youngest and oldest customer based on birthdate:

<img width="486" height="54" alt="image" src="https://github.com/user-attachments/assets/0f88fe62-1ab1-45dc-8ff8-4a84a2884c66" />

---

### Script 4.  Key Measures Exploration (Key Metrics)

Script: [measures-exploration.sql](scripts/measures-exploration.sql)

Purpose:

- To calculate aggregated metrics (e.g., totals, averages) for quick insights.
- To identify overall trends or spot anomalies.

SQL Functions Used:

- COUNT(), SUM(), AVG()

```sql
-- Find the Total Sales
SELECT SUM(sales_amount) AS total_sales FROM gold.fact_sales

-- Find how many items are sold
SELECT SUM(quantity) AS total_quantity FROM gold.fact_sales

-- Find the average selling price
SELECT AVG(price) AS avg_price FROM gold.fact_sales

-- Find the Total number of Orders
SELECT COUNT(order_number) AS total_orders FROM gold.fact_sales
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales

-- Find the total number of products
SELECT COUNT(product_name) AS total_products FROM gold.dim_products

-- Find the total number of customers
SELECT COUNT(customer_key) AS total_customers FROM gold.dim_customers;

-- Find the total number of customers that has placed an order
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM gold.fact_sales;
```

```sql
-- Generate a Report that shows all key metrics of the business
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Products', COUNT(DISTINCT product_name) FROM gold.dim_products
UNION ALL
SELECT 'Total Customers', COUNT(customer_key) FROM gold.dim_customers;
```
Report that shows all key metrics of the business:

<img width="277" height="170" alt="image" src="https://github.com/user-attachments/assets/0688996f-9095-41f1-913d-22938564c9fc" />

---

### Script 5.  Magnitude Analysis.

Script: [magnitude-analysis.sql](scripts/magnitude-analysis.sql)

Purpose:

- To quantify data and group results by specific dimensions.
- For understanding data distribution across categories.

SQL Functions Used:

- Aggregate Functions: SUM(), COUNT(), AVG()
- GROUP BY, ORDER BY


```sql
-- Find total customers by countries
SELECT
    country,
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC;
```
Total customers by countries:

<img width="279" height="191" alt="image" src="https://github.com/user-attachments/assets/6334119f-10df-4c2b-9f20-066986a51302" />

```sql
-- Find total customers by gender
SELECT
    gender,
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC;SS
```
Total customers by gender:

<img width="244" height="104" alt="image" src="https://github.com/user-attachments/assets/a4535797-e2e5-482f-98e6-68634867dffd" />

```sql
-- Find total products by category
SELECT
    category,
    COUNT(product_key) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC;
```
Total products by category:

<img width="249" height="147" alt="image" src="https://github.com/user-attachments/assets/1ebf88b7-d080-4e19-a2a8-f03c441aa350" />

```sql
-- What is the average costs in each category?
SELECT
    category,
    AVG(product_cost) AS avg_cost
FROM gold.dim_products
GROUP BY category
ORDER BY avg_cost DESC;
```
Average costs in each category:

<img width="223" height="147" alt="image" src="https://github.com/user-attachments/assets/2afd3bd8-34d9-47eb-9a1c-a8f7963aa91b" />

```sql
-- What is the total revenue generated for each category?
SELECT
    p.category,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
GROUP BY p.category
ORDER BY total_revenue DESC;
```
Total revenue generated for each category:

<img width="244" height="98" alt="image" src="https://github.com/user-attachments/assets/54ac428e-9e14-45d7-9177-96001079681d" />

```sql
-- What is the total revenue generated by each customer?
SELECT
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_revenue DESC;
```
total revenue generated by each customer - 18484 rows returned:

<img width="420" height="309" alt="image" src="https://github.com/user-attachments/assets/4f2d942e-dad9-490f-a40e-0f266172481e" />

```sql
-- What is the distribution of sold items across countries?
SELECT
    c.country,
    SUM(f.quantity) AS total_sold_items
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY c.country
ORDER BY total_sold_items DESC;
```
The distribution of sold items across countries:

<img width="282" height="196" alt="image" src="https://github.com/user-attachments/assets/453b321f-3884-4d10-9601-b1acd46da933" />

---

### Script 6.  Ranking Analysis.

Script: [ranking-analysis.sql](scripts/ranking-analysis.sql)

Purpose:

- To rank items (e.g., products, customers) based on performance or other metrics.
- To identify top performers or laggards.

SQL Functions Used:

- Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
- Clauses: GROUP BY, ORDER BY

```sql
-- Which 5 products Generating the Highest Revenue?
-- Simple Ranking
SELECT TOP 5
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;
```
Simple Ranking - 5 products Generating the Highest Revenue: 

<img width="315" height="147" alt="image" src="https://github.com/user-attachments/assets/439f74cc-23d4-4c79-83c3-4f79f63754f6" />

```sql
-- Complex but Flexibly Ranking Using Window Functions
SELECT *
FROM (
    SELECT
        p.product_name,
        SUM(f.sales_amount) AS total_revenue,
        RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_products
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.product_name
) AS ranked_products
WHERE rank_products <= 5;
```
Flexibly Ranking Using Window Functions:

<img width="419" height="147" alt="image" src="https://github.com/user-attachments/assets/323c5488-3ffe-47b3-9887-243a90150131" />

```sql
-- What are the 5 worst-performing products in terms of sales?
SELECT TOP 5
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue;
```
5 worst-performing products in terms of sales:

<img width="297" height="155" alt="image" src="https://github.com/user-attachments/assets/398339d7-fb89-49dc-8ebe-21cb8d555329" />

```sql
-- Find the top 10 customers who have generated the highest revenue
SELECT TOP 10
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_revenue DESC;
```
Top 10 customers who have generated the highest revenue:

<img width="419" height="264" alt="image" src="https://github.com/user-attachments/assets/d8461e20-0983-483e-99d7-dd8c901c911a" />

```sql
-- The 3 customers with the fewest orders placed
SELECT TOP 3
    c.customer_key,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_orders ;
```
The 3 customers with the fewest orders placed:

<img width="399" height="100" alt="image" src="https://github.com/user-attachments/assets/5ca7b749-0334-4371-a6b9-d304f19805cb" />

---

## B. Advanced Analytics

### Script 7.  Database and schema exploration.

Script: [database-exploration.sql](scripts/database-exploration.sql)

Purpose:
    - To explore the structure of the database, including the list of tables and their schemas.
    - To inspect the columns and metadata for specific tables.

Table Used:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS

```sql

```    

---

### Script 8.  Database and schema exploration.

Script: [database-exploration.sql](scripts/database-exploration.sql)

Purpose:
    - To explore the structure of the database, including the list of tables and their schemas.
    - To inspect the columns and metadata for specific tables.

Table Used:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS

```sql

```    

---

### Script 9.  Database and schema exploration.

Script: [database-exploration.sql](scripts/database-exploration.sql)

Purpose:
    - To explore the structure of the database, including the list of tables and their schemas.
    - To inspect the columns and metadata for specific tables.

Table Used:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS

```sql

```    

---
