-- 1. Which products are increasing in sales over time? --

WITH monthly_sales AS (
    SELECT 
        oi.product_id,
        DATE_TRUNC('month', o.order_date) AS sales_month,
        SUM(oi.order_item_quantity * oi.order_item_product_price) AS total_sales
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    GROUP BY oi.product_id, sales_month
),
sales_growth AS (
    SELECT 
        product_id,
        sales_month,
        total_sales,
        LAG(total_sales) OVER (PARTITION BY product_id ORDER BY sales_month) AS previous_sales
    FROM monthly_sales
)
SELECT 
    p.product_name,
    sg.product_id,
    COUNT(*) AS months_with_growth
FROM sales_growth sg
JOIN products p ON p.product_id = sg.product_id
WHERE sg.previous_sales IS NOT NULL AND sg.total_sales > sg.previous_sales
GROUP BY sg.product_id, p.product_name
ORDER BY months_with_growth DESC
LIMIT 10;


--  2. Which categories are experiencing a decline in sales? --

WITH category_monthly_sales AS (
    SELECT 
        c.category_name,
        DATE_TRUNC('month', o.order_date) AS sales_month,
        SUM(oi.order_item_quantity * oi.order_item_product_price) AS total_sales
    FROM order_items oi
    JOIN products p ON p.product_id = oi.product_id
    JOIN categories c ON c.product_category_id = p.product_category_id
    JOIN orders o ON o.order_id = oi.order_id
    GROUP BY c.category_name, sales_month
),
decline AS (
    SELECT 
        category_name,
        sales_month,
        total_sales,
        LAG(total_sales) OVER (PARTITION BY category_name ORDER BY sales_month) AS previous_sales
    FROM category_monthly_sales
)
SELECT 
    category_name,
    COUNT(*) AS months_with_decline
FROM decline
WHERE previous_sales IS NOT NULL AND total_sales < previous_sales
GROUP BY category_name
ORDER BY months_with_decline DESC;


--  3. What is the correlation between discount percentage and total sales? --

SELECT 
    (CORR(d.discount_percentage, oi.order_item_quantity * oi.order_item_product_price)) AS discount_sales_correlation
FROM discounts d
JOIN order_items oi ON d.order_id = oi.order_id AND d.product_id = oi.product_id;


-- 4. Which regions are showing rapid revenue growth? --

WITH region_monthly_sales AS (
    SELECT 
        o.order_region,
        DATE_TRUNC('month', o.order_date) AS month,
        SUM(o.sales) AS monthly_sales
    FROM orders o
    GROUP BY o.order_region, month
),
region_growth AS (
    SELECT 
        order_region,
        month,
        monthly_sales,
        LAG(monthly_sales) OVER (PARTITION BY order_region ORDER BY month) AS prev_month_sales
    FROM region_monthly_sales
)
SELECT 
    order_region,
    ROUND(AVG(((monthly_sales - prev_month_sales) * 100.0 / NULLIF(prev_month_sales, 0)))::numeric, 2) AS avg_growth_percentage
FROM region_growth
WHERE prev_month_sales IS NOT NULL
GROUP BY order_region
ORDER BY avg_growth_percentage DESC;


-- 5. Which time of day has the highest order volume? --

SELECT 
    TO_CHAR(order_date, 'HH12:MI AM') AS hour_of_day,
    COUNT(*) AS order_count
FROM orders
GROUP BY hour_of_day
ORDER BY order_count DESC
LIMIT 1;

-- 6.Average Number of Items per Order Over Time --

WITH month_summary AS (
    SELECT 
        TO_CHAR(o.order_date, 'Mon YYYY') AS month_label,
        EXTRACT(MONTH FROM o.order_date) AS month_number,
        EXTRACT(YEAR FROM o.order_date) AS year_number,
        ROUND(AVG(oi.order_item_quantity), 2) AS avg_items_per_order
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY month_label, month_number, year_number
)
SELECT 
    month_label,
    avg_items_per_order
FROM month_summary
ORDER BY year_number, month_number;

-- 7. Delay Rate by Shipping Mode -- 

SELECT 
    shipping_mode,
    COUNT(*) AS total_orders,
    COUNT(*) FILTER (WHERE late_delivery_risk) AS late_deliveries,
    ROUND(100.0 * COUNT(*) FILTER (WHERE late_delivery_risk) / COUNT(*), 2) AS late_delivery_rate
FROM shipping
GROUP BY shipping_mode
ORDER BY late_delivery_rate DESC;


-- 8. High-Profit Low-Volume Products

SELECT 
    p.product_id,
    p.product_name,
    SUM(oi.order_item_quantity) AS total_quantity,
    ROUND(SUM(oi.order_item_profit_ratio * oi.order_item_quantity)::NUMERIC, 2) AS total_profit,
    ROUND(
        (SUM(oi.order_item_profit_ratio * oi.order_item_quantity) / NULLIF(SUM(oi.order_item_quantity), 0))::NUMERIC,
        2
    ) AS avg_profit_per_unit
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(oi.order_item_quantity) < 50
ORDER BY avg_profit_per_unit DESC
LIMIT 10;

-- 9. Category-wise Discount Utilization --

SELECT 
    c.category_name,
    COUNT(d.discount_id) AS discount_usage_count,
    ROUND(AVG(d.discount_percentage)::NUMERIC, 2) AS avg_discount_percent
FROM discounts d
JOIN products p ON d.product_id = p.product_id
JOIN categories c ON p.product_category_id = c.product_category_id
GROUP BY c.category_name
ORDER BY discount_usage_count DESC;


-- 10. Which product categories are frequently bought together? --

WITH product_category_per_order AS (
    SELECT 
        o.order_id,
        c.category_name
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    JOIN categories c ON p.product_category_id = c.product_category_id
    JOIN orders o ON oi.order_id = o.order_id
),
category_pairs AS (
    SELECT 
        a.order_id,
        LEAST(a.category_name, b.category_name) AS category_1,
        GREATEST(a.category_name, b.category_name) AS category_2
    FROM product_category_per_order a
    JOIN product_category_per_order b 
        ON a.order_id = b.order_id AND a.category_name <> b.category_name
),
frequent_pairs AS (
    SELECT 
        category_1,
        category_2,
        COUNT(*) AS pair_count
    FROM category_pairs
    GROUP BY category_1, category_2
)
SELECT 
    category_1,
    category_2,
    pair_count
FROM frequent_pairs
ORDER BY pair_count DESC
LIMIT 10;