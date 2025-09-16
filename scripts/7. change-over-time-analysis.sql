--=====================================
-- CHANGES OVER TIME ANALYSIS
--=====================================
SELECT * FROM gold.fact_sales;

SELECT 
	order_date,
	sales_amount
FROM gold.fact_sales
ORDER BY order_date
;

-- filter out NULLs in data
SELECT 
	order_date,
	SUM(sales_amount) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY order_date
ORDER BY order_date
;

----------------------------------------------------------
-- VISUAL: Order Sales by each year
-- Display total_customers and total_quantity
----------------------------------------------------------
SELECT 
	YEAR(order_date)				AS order_year,
	SUM(sales_amount)				AS total_sales,
	COUNT(DISTINCT customer_key)	AS total_customers,
	SUM(quantity)					AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date)
;
-- BEST YEAR by sales performance: year 2013
-- WORST YEAR by sales performance: year 2010
-- 2013 showed greatest increase in total_customers, 
-- indicating growth in new customers.

----------------------------------------------------------
-- VISUAL: Display by MONTH
----------------------------------------------------------
SELECT 
	MONTH(order_date)				AS order_month,
	SUM(sales_amount)				AS total_sales,
	COUNT(DISTINCT customer_key)	AS total_customers,
	SUM(quantity)					AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY MONTH(order_date)
ORDER BY MONTH(order_date)
;
-- SEASONALITY:
-- December showed highest total sales,
-- whereas February showed lowest total_sales.


----------------------------------------------------------
-- VISUAL: Show total sales, customers, quantity
-- by each year and each month:
----------------------------------------------------------
SELECT 
	YEAR(order_date)				AS order_year,
	MONTH(order_date)				AS order_month,
	SUM(sales_amount)				AS total_sales,
	COUNT(DISTINCT customer_key)	AS total_customers,
	SUM(quantity)					AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date)
;

-- Use DATETRUNC() to format YEAR and MONTH
-- into a single column
SELECT 
	DATETRUNC(month, order_date)	AS order_date,
	SUM(sales_amount)				AS total_sales,
	COUNT(DISTINCT customer_key)	AS total_customers,
	SUM(quantity)					AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date)
;
