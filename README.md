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
## Python-Powered Insights & Business Intelligence

This document presents **14 key business questions** answered using **Python** (pandas, plotly, seaborn, matplotlib) on the `dw_gold.report_customers` view.

All analysis was performed in Jupyter Notebooks under the `python` folder with insights from the analysis noted.

---

### A. Revenue and Profitability Insights

#### Question 1: Which `age_category` generates the highest `total_sales`?
#### Insight 1: The 40-60 age category generates the highest total sales.
This is your primary revenue-driving demographic — prioritize targeted marketing here.

####  Question 2: What is the relationship between spender_category and average_order_value (AOV)?
nsight 2: High Spenders have an AOV of $2,592 — nearly 28 times higher than Low Spenders, despite fewer orders.
High Spenders focus on premium/luxury purchases, while Low Spenders drive volume (nearly 14,000 low-value transactions).

### Question 3: How does `average_monthly_spend` differ across various `age_categories`?
#### Insight 3: The 40-60 age group has the highest average monthly spend at $10.66.
The 20-40 age group follows closely at $8.20 – $9.17. This group should be prioritized for retention and upselling.

#### Question 4: Are customers with a high `total_products` count also those with the highest `total_sales`?
#### Insight 4: Revenue is primarily driven by high-value luxury buyers rather than high-volume bulk buyers.

#### Question 5: Which `spender_category` has the highest `total_quantities` per order?
#### Insight 5: High Spenders have the highest average quantity per order.
They are your power users who move the most inventory.

#### Question 6: What is the average `recency` for each `spender_category`?
#### Insight 6: High Spenders show varying recency levels.
This metric helps identify at-risk VIP customers early for retention campaigns.

#### Question 7: Is there a correlation between `life_span` and `total_sales`?
#### Insight 7: There is a strong positive correlation between customer lifespan and total sales.
Longer loyalty significantly increases customer value.

#### Question 8: Who are the "at-risk" champions (High `total_sales` but `recency` > 160 days)?
#### Insight 8: There are 282 At-Risk Champions (high-value customers inactive for over 160 days) and 4,492 Active High Spenders.
These 282 customers should be targeted with win-back campaigns.

#### Question 9:  Is the "Senior" age_category more likely to be a "Low" or "High" spender?
#### Insight 9: High Spenders are typically 35–45 years old on average.
Senior customers (Above 60) are more likely to be Low Spenders.

#### Question 10: How does `last_order_date` trend over time (Month-over-Month)?
#### Insight 10: The last_order_date remained stagnant below 100 users until a late-2012 breakout, followed by consistent MoM growth to a peak of 2,000+ users in December 2013.
<p align="center">
  <img width="820" height="393" alt="image" src="https://github.com/user-attachments/assets/7404f5cc-4fc5-4c0a-8ccf-a65d54787df8" />
</p>

#### Question 11: Which `spender_category` buys the most diverse range of `total_products`?
#### Insight 11: The 40-60 age category buys the most variety of products.
This indicates strong cross-selling success in this segment.

#### Question 12: Does a high `life_span` result in a higher `average_monthly_spend`?
#### Insight 12: High spending customers show peak activity between 145–165 days of lifespan.
Beyond this period, customers either churn or spend less.

#### Question 13: What percentage of revenue is contributed by the top 10% of customers (by `total_sales`)?
#### Insight 13: The top 10% of customers (4,763 customers) contribute $11,531,461 representing 40.56% of total revenue ($28,429,761).
This indicates high customer concentration risk.

#### Question 14: What is the "Revenue Velocity" (`total_sales` divided by `life_span`)?
#### Insight 14: 
<p align="center">
  <img width="589" height="385" alt="image" src="https://github.com/user-attachments/assets/57d515f2-be75-40c2-b0d5-01b3abe36281" />
</p>
The Average Revenue Velocity chart highlights a tiered spending structure, where high spenders generate a dominant $42.62/day compared to just $0.67/day for low spenders. This revenue disparity has revealed that the business is highly dependent on a top-tier group, making their retention the primary driver for sustainable growth.
  
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

---

## 💡 Strategic Recommendations

- 🎯 **Target High-Value Age Segment (40–60)**  
  Focus marketing efforts on the 40–60 age group through premium offers, personalized experiences, and loyalty programs to maximize lifetime value.

- 🔄 **Reactivation of Inactive High Spenders**  
  Develop targeted re-engagement campaigns for customers with high recency but strong historical spending to recover lost revenue.

- 📈 **Increase Average Order Value (AOV)**  
  Implement upselling and cross-selling strategies to move medium spenders toward higher value segments.

- ⚡ **Adopt Revenue Velocity as a KPI**  
  Utilize **revenue velocity** (`total_sales / life_span`) to identify and prioritize high-performing customers for strategic decision-making.

---

---





