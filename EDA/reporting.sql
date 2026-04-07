-- REPORTING
-- Purpose : This report consolidates key customer metrics and behaviours
-- Highlights
/*
1. Gather essential fields like names, ages, transaction details
2. Segment the Customers based on spending.
3. Aggregate customer-level metrics:
- total orders
- total sales
- total quantity covered
- total products
- lifespan (in months)
4. Calculates valuable KPIs
- recency (months since the last order)
- average order value
- average monthly spend
*/

/*
1. Base query
2. Advanced query -- aggregate
*/
/* Base query
 Extract core information */
 CREATE OR REPLACE VIEW dw_gold.report_customers AS (
WITH base_query AS (
SELECT 
	s.order_number,
    s.customer_key,
    s.product_key,
    s.order_date,
    s.sales_amount,
    s.quantity,
    c.customer_number,
    concat(c.first_name, ' ', c.last_name) AS 'customer_name',
    c.gender,
    c.maritial_status,
    TIMESTAMPDIFF(YEAR, birth_date, CURRENT_DATE) AS age,
    c.country
    
FROM dw_gold.facts_sales s
LEFT JOIN dw_gold.dim_customers c
ON s.customer_key = c.customer_key
WHERE order_date IS NOT NULL
), 
/* Summarize customer metrics at the aggregation level */
customer_aggregation AS 
(SELECT 
	customer_key,
    customer_number,
    customer_name,
    age,
    count(distinct order_number) AS total_orders,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantities,
    COUNT(distinct product_key) AS total_products,
    MAX(order_date) AS last_order_date,
    Timestampdiff(MONTH, MAX(order_date), CURRENT_DATE) AS life_span
FROM base_query
WHERE customer_key IS NOT NULL
GROUP BY customer_key,
    customer_number,
    customer_name,
    age)
-- reporting level
SELECT 
	customer_key,
    customer_number,
    customer_name,
    age,
    CASE 
		WHEN age < 20 THEN "Below 20"
        WHEN age BETWEEN 20 AND 40 THEN "20-40"
        WHEN age BETWEEN 40 AND 60 THEN "40-60"
        WHEN Age > 60  THEN "Above 60"
	END AS age_category,
    total_orders,
    total_sales,
     CASE 
		WHEN total_sales < 1000 THEN "low spender"
        WHEN total_sales BETWEEN 1000 AND 5000 THEN "medium spender"
        WHEN total_sales > 5000 THEN "high spender"
	END AS spender_category,
    last_order_date,
    timestampdiff(month, last_order_date, current_date) AS recency,
    total_quantities,
    total_products,
    life_span,
    -- Compute average order values
    total_sales/ total_orders AS average_order_value,
    -- calculate the average monthly spend
    total_sales / life_span AS average_monthly_spend
    
FROM customer_aggregation )

SELECT *
FROM dw_gold.report_customers;
