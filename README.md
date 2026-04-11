# End-to-End-Customer-Analytics-Pipeline-with-SQL-and-Python
This project utilizes SQL for structured data exploration and Python for advanced data analysis and visualization, enabling comprehensive insights and data-driven decision-making.

---

## 📊 Project Overview

This project analyzes the **`dw_gold.report_customers`** view — an aggregated customer analytics dataset derived from a star schema data warehouse.

The analysis focuses on:
- Demographic segmentation (age groups)
- Spending behavior classification
- Customer lifetime metrics (recency, lifespan, velocity)
- Revenue insights and strategic recommendations

The goal is to derive actionable business insights through descriptive, diagnostic, and predictive-style analyses to support decision-making in sales, marketing, and product strategy.

## Objectives

- Explore and understand the raw data structure across all database layers
- Perform comprehensive exploratory data analysis (EDA)
- Conduct magnitude, ranking, trend, cumulative, performance, and proportional analysis
- Build customer segmentation and KPI reporting
- Generate key business metrics and visualizations-ready insights
- Provide strategic recommendations based on findings

---
## 🛠️ Tools and Technologies

- **Database**: MySQL / MariaDB (v8.0) – Data storage, exploration, and querying  
- **Data Architecture**: Bronze → Silver → Gold layered Data Warehouse  
- **Language**: SQL – Data extraction, transformation, and analysis  
- **ETL Process**: Custom SQL-based transformations for data cleaning and modeling  

### 🐍 Python Ecosystem
- **Python (v3.12)** – Data analysis and automation  
- **Pandas** – Data manipulation and preprocessing  
- **Matplotlib** – Data visualization  
- **Seaborn** – Statistical data visualization  
- **Jupyter Notebook** – Interactive development and analysis environment  

---

## Data Modelling

- **Fact Table**: `dw_gold.facts_sales` (sales_amount, quantity, price, order details)
- **Dimension Tables**:
  - `dw_gold.dim_customers`
  - `dw_gold.dim_products`
- **Source Tables**:
  - `dw_bronze.crm_sales_details`
  - `dw_silver.crm_sales_details`

**Star Schema** implemented for optimal analytical querying.
<p align="center">
  <img src="https://github.com/user-attachments/assets/5737ccd2-509a-4838-b160-979e52a499d9" width="500"/>
</p>


## Exploratory Analysis (SQL)

### Database Exploration
- Explore all objects in the database
- Check every column in each table
- Dimension Exploration (distinct & unique values)

### Key Dimension Insights
- Identify all countries customers come from
- Identify all product categories

### Date Exploration
- First and last order date
- Youngest and oldest customer

### Measures Exploration (Key Metrics)

```sql
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM dw_gold.facts_sales
UNION
SELECT 'Total Quantity', SUM(quantity) FROM dw_gold.facts_sales
UNION
SELECT 'Average Selling Price', AVG(price) FROM dw_gold.facts_sales
UNION
SELECT 'Total Numbers of Orders', COUNT(DISTINCT order_number) FROM dw_gold.facts_sales
UNION
SELECT 'Total Numbers of Products', COUNT(DISTINCT product_key) FROM dw_gold.dim_products
UNION
SELECT 'Total Numbers of Customers', COUNT(DISTINCT customer_key) FROM dw_gold.dim_customers;
The visualization are done with Python while asking some crucial questions
```

## Intermediate Analysis (SQL)
### Magnitude Analysis

- Total customers by country
- Total customers by gender
- Total products by category
- Average revenue per category
- Total revenue by category
- Distribution of sold items across regions/countries

### Ranking Analysis

- Top 5 highest revenue generating products
- Bottom 5 worst performing products by sales

## Advanced Analysis (SQL)
### Trend Analysis (Change Over Time)

- Total sales by year
- Total sales by year and month
- Average cost by month

### Cumulative Analysis
- Running total sales by year
- Moving averages by month
- Moving Average of Price

### Performance Analysis

- Yearly product performance vs average and previous year
- Proportional Analysis
- Product category contribution to total sales
- Customer segmentation by spending behavior
---
## 📑 Customer Analytics Reporting View (SQL)

This view creates a **comprehensive customer analytics layer** by integrating sales and customer dimension data into a single reporting structure.

```sql
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
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        c.gender,
        c.maritial_status,
        TIMESTAMPDIFF(YEAR, birth_date, CURRENT_DATE) AS age,
        c.country
    FROM dw_gold.facts_sales s
    LEFT JOIN dw_gold.dim_customers c 
        ON s.customer_key = c.customer_key
    WHERE order_date IS NOT NULL
),

customer_aggregation AS (
    SELECT
        customer_key,
        customer_number,
        customer_name,
        age,
        COUNT(DISTINCT order_number) AS total_orders,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantities,
        COUNT(DISTINCT product_key) AS total_products,
        MAX(order_date) AS last_order_date,
        TIMESTAMPDIFF(MONTH, MAX(order_date), CURRENT_DATE) AS life_span
    FROM base_query
    WHERE customer_key IS NOT NULL
    GROUP BY customer_key, customer_number, customer_name, age
)

SELECT
    customer_key,
    customer_number,
    customer_name,
    age,

    CASE
        WHEN age < 20 THEN 'Below 20'
        WHEN age BETWEEN 20 AND 40 THEN '20-40'
        WHEN age BETWEEN 40 AND 60 THEN '40-60'
        ELSE 'Above 60'
    END AS age_category,

    total_orders,
    total_sales,

    CASE
        WHEN total_sales < 1000 THEN 'Low Spender'
        WHEN total_sales BETWEEN 1000 AND 5000 THEN 'Medium Spender'
        ELSE 'High Spender'
    END AS spender_category,

    last_order_date,
    TIMESTAMPDIFF(MONTH, last_order_date, CURRENT_DATE) AS recency,
    total_quantities,
    total_products,
    life_span,

    total_sales / total_orders AS average_order_value,
    total_sales / life_span AS average_monthly_spend

FROM customer_aggregation
);
```
---

## ✨ Key Insights

### 1. Revenue Drivers
- **High Spenders** generate significantly higher daily revenue velocity compared to Medium and Low spenders.
- Most customers fall into the **40-60 age group**, making it the core demographic.

### 2. Customer Segments
| Spender Category | Avg Daily Revenue | Characteristics |
|------------------|-------------------|-----------------|
| High Spender     | Highest           | High AOV, loyal |
| Medium Spender   | Medium            | Majority of base |
| Low Spender      | Lowest            | Needs nurturing |

### 3. Strategic Recommendations
- **Target 40-60 age group** with premium offers and loyalty programs.
- Develop **reactivation campaigns** for high-recency (inactive) high-spenders.
- Focus on increasing **average order value** for medium spenders.
- Use **revenue velocity** (`total_sales / life_span`) as a key KPI for customer prioritization.

---

## 🛠 Tech Stack




