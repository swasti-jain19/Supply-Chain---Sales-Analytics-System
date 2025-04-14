-- 1. What percentage of customers purchase more than once? --

SELECT 
    ROUND(100.0 * COUNT(DISTINCT customer_id) FILTER (WHERE order_count > 1) / COUNT(DISTINCT customer_id), 2) AS repeat_customer_percentage
FROM (
    SELECT customer_id, COUNT(order_id) AS order_count
    FROM orders
    GROUP BY customer_id
) AS customer_orders;

-- 2. Which customer demographic spends the most on orders? --

SELECT 
    c.customer_segment,
    ROUND(SUM(o.sales)::NUMERIC, 2) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_segment
ORDER BY total_spent DESC
LIMIT 1;

-- 3. What is the average time between a customer's first and second purchase? --

WITH customer_order_times AS (
    SELECT 
        customer_id,
        order_date,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS order_rank
    FROM orders
),
first_two_orders AS (
    SELECT * 
    FROM customer_order_times 
    WHERE order_rank <= 2
),
diffs AS (
    SELECT customer_id,
           MAX(order_date) - MIN(order_date) AS days_between
    FROM first_two_orders
    GROUP BY customer_id
    HAVING COUNT(*) = 2
)
SELECT ROUND(AVG(days_between), 2) AS avg_days_between_first_second
FROM diffs;


-- 4. Which customer segment has the highest lifetime value? --
-- (Lifetime Value = Total sales per customer segment) --

SELECT 
    c.customer_segment,
    ROUND(SUM(o.sales)::NUMERIC, 2) AS lifetime_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_segment
ORDER BY lifetime_value DESC
LIMIT 1;

-- 5. What is the churn rate of customers over time? --
--(Assuming churn = no orders for 6+ months after first order) --

WITH customer_activity AS (
    SELECT 
        customer_id,
        MIN(order_date) AS first_order,
        MAX(order_date) AS last_order
    FROM orders
    GROUP BY customer_id
),
churned_customers AS (
    SELECT 
        customer_id,
        CASE 
            WHEN last_order <= first_order + INTERVAL '6 months' THEN 1 
            ELSE 0 
        END AS churned
    FROM customer_activity
)
SELECT 
    ROUND(100.0 * SUM(churned)::NUMERIC / COUNT(*), 2) AS churn_rate_percentage
FROM churned_customers;

-- 6. How does customer spending behavior vary by region? --

SELECT 
    o.order_region,
    ROUND(AVG(o.sales)::NUMERIC, 2) AS avg_order_value,
    ROUND(SUM(o.sales)::NUMERIC, 2) AS total_spent
FROM orders o
GROUP BY o.order_region
ORDER BY total_spent DESC;

-- 7. Which product categories are most popular among high-spending customers? --

WITH customer_spending AS (
    SELECT 
        customer_id,
        SUM(sales) AS total_spent
    FROM orders
    GROUP BY customer_id
),
high_spenders AS (
    SELECT customer_id 
    FROM customer_spending 
    WHERE total_spent > (
        SELECT PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY total_spent) FROM customer_spending
    )
)
SELECT 
    cat.category_name,
    COUNT(*) AS total_orders
FROM high_spenders hs
JOIN orders o ON hs.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
JOIN categories cat ON p.product_category_id = cat.product_category_id
GROUP BY cat.category_name
ORDER BY total_orders DESC;


-- 8. What is the frequency of purchases per customer segment? --

SELECT 
    c.customer_segment,
    ROUND(AVG(order_count), 2) AS avg_orders
FROM (
    SELECT customer_id, COUNT(order_id) AS order_count
    FROM orders
    GROUP BY customer_id
) o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_segment;


-- 9. What is the average order value (AOV) trend per month, and how does it differ between customer segments?
-- This query gives insight into monthly customer behavior and highlights how different customer segments behave in terms of spending over time — super useful for marketing and forecasting. --

SELECT 
    DATE_TRUNC('month', o.order_date) AS month,
    c.customer_segment,
    ROUND(SUM(o.sales)::NUMERIC / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY month, c.customer_segment
ORDER BY month, c.customer_segment;


-- 10. What percentage of customers make a second purchase within 6 months? --

WITH ranked_orders AS (
    SELECT 
        customer_id,
        order_date,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS order_rank
    FROM orders
),
first_second AS (
    SELECT * FROM ranked_orders WHERE order_rank <= 2
),
date_diff AS (
    SELECT customer_id, 
           MAX(order_date) - MIN(order_date) AS days_between
    FROM first_second
    GROUP BY customer_id
    HAVING COUNT(*) = 2
)
SELECT 
    ROUND(100.0 * COUNT(*) FILTER (WHERE days_between <= 180) / COUNT(*), 2) AS percent_second_within_6_months
FROM date_diff;

-- 11. Revenue Contribution by Repeat vs One-Time Buyers --

WITH customer_order_count AS (
    SELECT 
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders
    FROM orders
    GROUP BY customer_id
),
orders_with_class AS (
    SELECT 
        o.order_id,
        o.customer_id,
        CASE 
            WHEN coc.total_orders = 1 THEN 'One-Time Buyer'
            ELSE 'Repeat Buyer'
        END AS buyer_type,
        o.sales
    FROM orders o
    JOIN customer_order_count coc ON o.customer_id = coc.customer_id
)
SELECT 
    buyer_type,
    COUNT(DISTINCT customer_id) AS num_customers,
    ROUND(SUM(sales)::NUMERIC, 2) AS total_sales,
    ROUND(SUM(sales)::NUMERIC * 100.0 / SUM(SUM(sales)) OVER ()::NUMERIC, 2) AS percentage_contribution
FROM orders_with_class
GROUP BY buyer_type;
