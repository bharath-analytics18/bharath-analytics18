# Customer Shopping Behavior Analysis (v2 — MySQL Edition)

An analysis of 3,900 customer shopping transactions to uncover purchasing
patterns across category, season, demographics, and payment behavior — built
using **MySQL**, **SQL (window functions & CTEs)**, and an interactive
**Power BI dashboard**.

This is an upgraded version of my original Customer Shopping Behavior
Analysis project — rebuilt on MySQL (instead of SQLite) with more advanced
SQL techniques and a fully interactive dashboard.

---

## Tools Used
- **MySQL** — database, data storage, and SQL analysis
- **SQL** — GROUP BY aggregations, window functions (`RANK() OVER`), CTEs (`WITH ... AS`)
- **Power BI** — interactive dashboard connected live to MySQL

---

## Project Workflow
1. **Data Cleaning** — loaded the raw CSV, standardized column names, verified zero nulls/duplicates
2. **Database Setup** — created a MySQL database and `customers` table
3. **Data Loading** — imported all 3,900 cleaned records into MySQL
4. **SQL Analysis** — ran aggregation queries, a window function, and CTEs to answer key business questions
5. **Dashboard** — built a 5-KPI, 6-chart interactive Power BI dashboard connected directly to the MySQL database

---

## Key Findings

**Overview**
- Total Revenue: **$233,081**
- Average Order Value: **$59.76**
- Total Customers: **3,900**

**Category Performance**
- **Clothing** is the top category — $104,264 in revenue (~45% of total)
- Followed by Accessories (~$74,200), Footwear (~$36,000), and Outerwear (~$18,500)

**Seasonal Performance**
- **Fall** leads slightly ($60,018), but all four seasons are close — Spring and Winter both around $58,600, Summer lowest at $55,777
- Takeaway: no single season dominates; seasonal marketing should stay fairly balanced

**Customer Demographics**
- **68% male, 32% female** customer base
- Revenue is fairly evenly spread across age groups, with the 50+ segment (both genders) contributing the most in total

**Payment Behavior**
- No dominant payment method — PayPal, Credit Card, Cash, Debit Card, Venmo, and Bank Transfer are all within 15–18% of transaction share

**Discount Impact**
- Customers **without** a discount spent slightly *more* on average ($60.13) than those who used one ($59.28)
- Takeaway: discounts in this dataset don't appear to drive larger basket sizes — worth testing further before assuming discounts boost revenue

**Top Purchased Items**
- Shirt, Sweater, and Sunglasses are the most frequently purchased items, all in a fairly tight 150–170 range — no single item dominates

---

## Advanced SQL Highlights

**Window Function** — ranks each customer's spend within their own category:
```sql
SELECT
    category, customer_id, purchase_amount_usd,
    RANK() OVER (PARTITION BY category ORDER BY purchase_amount_usd DESC) AS rank_in_category
FROM customers;
```

**CTE** — calculates each category's share of total revenue:
```sql
WITH category_revenue AS (
    SELECT category, SUM(purchase_amount_usd) AS total_revenue
    FROM customers GROUP BY category
)
SELECT category, total_revenue,
       ROUND(total_revenue * 100.0 / (SELECT SUM(total_revenue) FROM category_revenue), 2) AS pct_of_total
FROM category_revenue
ORDER BY total_revenue DESC;
```

Full query set available in [`analysis_queries.sql`](./analysis_queries.sql).

---

## Dashboard

The Power BI dashboard includes:
- **5 KPI cards**: Total Customers, Total Revenue, Average Order Value, Avg Previous Purchases, Subscribed Customers %
- **6 visuals**: Revenue by Category, Customers by Gender, Payment Methods, Top Purchased Items, Revenue by Season, Discount Impact
- **4 slicers**: Season, Category, Gender, Subscription Status — fully interactive filtering across all visuals

File: [`customer_shopping_behavior_dashboard.pbix`](./customer_shopping_behavior_dashboard.pbix)

---

## Files in This Repo

| File | Description |
|---|---|
| `shopping_trends_updated.csv` | Original raw dataset (source: [Kaggle](https://www.kaggle.com/datasets/iamsouravbanerjee/customer-shopping-trends-dataset)) |
| `shopping_trends_cleaned.csv` | Cleaned dataset with standardized column names |
| `analysis_queries.sql` | Full SQL analysis — aggregations, window function, CTEs |
| `customer_shopping_behavior_dashboard.pbix` | Interactive Power BI dashboard |
| `README.md` | This file |

---

## How to Reproduce This Project
1. Download the dataset from [Kaggle](https://www.kaggle.com/datasets/iamsouravbanerjee/customer-shopping-trends-dataset)
2. Set up a MySQL database and import the cleaned CSV (via Workbench's Table Data Import Wizard, or `LOAD DATA INFILE`)
3. Run `analysis_queries.sql` against the table
4. Open `customer_shopping_behavior_dashboard.pbix` in Power BI Desktop, and point the MySQL connection to your own local database (Server: `localhost:3306`, Database name as configured)

---

## What's New in v2
- Migrated from SQLite → **MySQL**
- Added a **window function** and **two CTEs** to the SQL analysis
- Rebuilt the Power BI dashboard **connected live to MySQL** instead of a static CSV
- Added new business questions: subscription status vs. spend, discount impact on average order value
