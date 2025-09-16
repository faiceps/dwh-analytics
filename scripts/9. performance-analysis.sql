--=====================================
-- PERFORMANCE ANALYSIS
--=====================================

----------------------------------------------------------
-- VISUAL: Year-over-Year Analysis
-- Sales(Current period/year - previous period/year)
--
-- Analyze yearly performance of products by comparing
-- each product's sales, 
-- to both its average sales performance
-- and the previous year's sales.
----------------------------------------------------------

-- Join sales table with product table:
SELECT 
	YEAR(f.order_date)			AS order_year,
	p.product_name,
	SUM(f.sales_amount)			AS current_sales
FROM		  gold.fact_sales	AS f
LEFT JOIN	  gold.dim_products	AS p
ON f.product_key = p.product_key
WHERE f.order_date IS NOT NULL
GROUP BY YEAR(f.order_date), p.product_name
;

----------------------------------------------------------
-- Use CTE to arrange current sales 
-- by products according to each year:
----------------------------------------------------------
WITH yearly_product_sales	AS (
	SELECT 
		YEAR(f.order_date)			AS order_year,
		p.product_name,
		SUM(f.sales_amount)			AS current_sales
	FROM		  gold.fact_sales	AS f
	LEFT JOIN	  gold.dim_products	AS p
	ON f.product_key = p.product_key
	WHERE f.order_date IS NOT NULL
	GROUP BY YEAR(f.order_date), p.product_name
)

SELECT 
	order_year,
	product_name,
	current_sales,
	AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales
FROM yearly_product_sales
ORDER BY product_name, order_year
;
-- Current Sales and Avg Sales formed.

----------------------------------------------------------
-- Difference in AVG = Current Sales - AVG Sales 
----------------------------------------------------------
WITH yearly_product_sales	AS (
	SELECT 
		YEAR(f.order_date)			AS order_year,
		p.product_name,
		SUM(f.sales_amount)			AS current_sales
	FROM		  gold.fact_sales	AS f
	LEFT JOIN	  gold.dim_products	AS p
	ON f.product_key = p.product_key
	WHERE f.order_date IS NOT NULL
	GROUP BY YEAR(f.order_date), p.product_name
)

SELECT 
	order_year,
	product_name,
	current_sales,
	AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
	current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg
FROM yearly_product_sales
ORDER BY product_name, order_year
;

---------------------------------------------------------------
-- Use CASE WHEN to label rows and indicate above or below AVG:
---------------------------------------------------------------
WITH yearly_product_sales	AS (
	SELECT 
		YEAR(f.order_date)			AS order_year,
		p.product_name,
		SUM(f.sales_amount)			AS current_sales
	FROM		  gold.fact_sales	AS f
	LEFT JOIN	  gold.dim_products	AS p
	ON f.product_key = p.product_key
	WHERE f.order_date IS NOT NULL
	GROUP BY YEAR(f.order_date), p.product_name
)

SELECT 
	order_year,
	product_name,
	current_sales,
	AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
	current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg,
	CASE WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
		 WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
		 ELSE 'Avg'
	END AS avg_change
FROM yearly_product_sales
ORDER BY product_name, order_year
;

---------------------------------------------------------------
-- Compare current year sales with previous year sales:
---------------------------------------------------------------
WITH yearly_product_sales	AS (
	SELECT 
		YEAR(f.order_date)			AS order_year,
		p.product_name,
		SUM(f.sales_amount)			AS current_sales
	FROM		  gold.fact_sales	AS f
	LEFT JOIN	  gold.dim_products	AS p
	ON f.product_key = p.product_key
	WHERE f.order_date IS NOT NULL
	GROUP BY YEAR(f.order_date), p.product_name
)

SELECT 
	order_year,
	product_name,
	current_sales,
	AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
	current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg,
	CASE WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
		 WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
		 ELSE 'Avg'
	END AS avg_change,
	LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS prev_year_sales		-- Access previous value of sales.
FROM yearly_product_sales
ORDER BY product_name, order_year
;
-- prev_year_sales value tabulated and ready for YoY calculation.

---------------------------------------------------------------
-- Year-over-Year Analysis = Current Sales - Previous Year Sales 
---------------------------------------------------------------
WITH yearly_product_sales	AS (
	SELECT 
		YEAR(f.order_date)			AS order_year,
		p.product_name,
		SUM(f.sales_amount)			AS current_sales
	FROM		  gold.fact_sales	AS f
	LEFT JOIN	  gold.dim_products	AS p
	ON f.product_key = p.product_key
	WHERE f.order_date IS NOT NULL
	GROUP BY YEAR(f.order_date), p.product_name
)

SELECT 
	order_year,
	product_name,
	current_sales,
	AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
	current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg,
	CASE WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
		 WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
		 ELSE 'Avg'
	END AS avg_change,
	LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS prev_year_sales,		
	current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS diff_prev_year,
	CASE WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
		 WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
		 ELSE 'No Change'
	END AS prev_year_change
FROM yearly_product_sales
ORDER BY product_name, order_year
;
-- Year-over-Year Analysis calculated.