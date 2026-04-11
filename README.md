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

The analysis in the SQL are divided into
1. Exploratory analysis
  Under the exploratory analysis
we have
-- Database Exploration
-- 
3. Intermediate analysis
4. Advanced analysis
---

The visualization are done with Python while asking some crucial questions
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

-**MySQL** 8.0 - Data Exploration
- **Python** 3.12 - Analysis and Visualiztion
- **Pandas** — Data manipulation
- **Matplotlib + Seaborn** — Visualization
- **Jupyter Notebook**



