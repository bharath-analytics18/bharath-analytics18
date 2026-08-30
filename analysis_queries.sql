create database shopping_analysis;

use shopping_analysis;


SELECT COUNT(*) FROM customers;
SELECT SUM(purchase_amount_usd) FROM customers;

USE shopping_analysis;

-- 1. Total Revenue
SELECT SUM(purchase_amount_usd) AS total_revenue
FROM customers;

-- 2. Average Purchase Amount
SELECT ROUND(AVG(purchase_amount_usd), 2) AS avg_purchase_amount
FROM customers;

-- 3. Category-wise Revenue
SELECT
    category,
    COUNT(*) AS num_orders,
    SUM(purchase_amount_usd) AS total_revenue,
    ROUND(AVG(purchase_amount_usd), 2) AS avg_order_value
FROM customers
GROUP BY category
ORDER BY total_revenue DESC;

-- 4. Seasonal Performance
SELECT
    season,
    COUNT(*) AS num_orders,
    SUM(purchase_amount_usd) AS total_revenue,
    ROUND(AVG(purchase_amount_usd), 2) AS avg_order_value
FROM customers
GROUP BY season
ORDER BY total_revenue DESC;

-- 5. Top Purchased Products (by order count)
SELECT
    item_purchased,
    COUNT(*) AS times_purchased,
    SUM(purchase_amount_usd) AS total_revenue
FROM customers
GROUP BY item_purchased
ORDER BY times_purchased DESC
LIMIT 10;

-- 6. Payment Method Usage
SELECT
    payment_method,
    COUNT(*) AS num_transactions,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customers), 2) AS pct_of_total
FROM customers
GROUP BY payment_method
ORDER BY num_transactions DESC;

-- 7. Age Group Spending
SELECT
    CASE
        WHEN age < 25 THEN '18-24'
        WHEN age BETWEEN 25 AND 35 THEN '25-35'
        WHEN age BETWEEN 36 AND 50 THEN '36-50'
        ELSE '50+'
    END AS age_group,
    COUNT(*) AS num_customers,
    SUM(purchase_amount_usd) AS total_revenue,
    ROUND(AVG(purchase_amount_usd), 2) AS avg_spend
FROM customers
GROUP BY age_group
ORDER BY total_revenue DESC;


SELECT gender, COUNT(*) AS num_customers, SUM(purchase_amount_usd) AS total_revenue,
       ROUND(AVG(purchase_amount_usd),2) AS avg_spend
FROM customers GROUP BY gender ORDER BY total_revenue DESC;



SELECT discount_applied, COUNT(*) AS num_orders, ROUND(AVG(purchase_amount_usd),2) AS avg_spend
FROM customers GROUP BY discount_applied;



SELECT location, COUNT(*) AS num_orders, SUM(purchase_amount_usd) AS total_revenue
FROM customers GROUP BY location ORDER BY total_revenue DESC LIMIT 10;








