-- 1. Month-over-month sales growth rate --

WITH monthly_sales AS (
    SELECT 
        DATE_TRUNC('month', order_date) AS month,
        SUM(sales) AS total_sales
    FROM orders
    GROUP BY month
),
growth_rate AS (
    SELECT 
        month,
        total_sales,
        LAG(total_sales) OVER (ORDER BY month) AS prev_month_sales
    FROM monthly_sales
)
SELECT 
    TO_CHAR(month, 'Month YYYY') AS month_year,
    total_sales,
    ROUND(
        (100.0 * (total_sales - prev_month_sales) / NULLIF(prev_month_sales, 0))::numeric, 
        2
    ) AS growth_rate_percentage
FROM growth_rate
ORDER BY month;

-- 2. Which quarter had the highest revenue --

SELECT 
    CONCAT('Q', EXTRACT(QUARTER FROM order_date), '-', EXTRACT(YEAR FROM order_date)) AS quarter,
    SUM(sales) AS total_revenue
FROM orders
GROUP BY quarter
ORDER BY total_revenue DESC
LIMIT 1;


-- 3. Which day of the week has the highest sales volume --

SELECT 
    TO_CHAR(order_date, 'Day') AS day_of_week,
    COUNT(order_id) AS total_orders,
    SUM(sales) AS total_sales
FROM orders
GROUP BY day_of_week
ORDER BY total_sales DESC
LIMIT 1;

-- 4. Best-performing hour for online orders --

SELECT 
    EXTRACT(HOUR FROM order_date::timestamp) AS order_hour,
    COUNT(order_id) AS order_count,
    SUM(sales) AS total_sales
FROM orders
GROUP BY order_hour
ORDER BY total_sales DESC
LIMIT 1;

-- 5. Compare revenue generated in Q1, Q2, Q3, Q4 --

SELECT 
    EXTRACT(YEAR FROM order_date) AS year,
    EXTRACT(QUARTER FROM order_date) AS quarter,
    SUM(sales) AS total_revenue
FROM orders
GROUP BY year, quarter
ORDER BY year, quarter;

-- 6. Which products sell best during specific seasons --

WITH seasonal_data AS (
    SELECT 
        p.product_name,
        CASE 
            WHEN EXTRACT(MONTH FROM o.order_date) IN (12, 1, 2) THEN 'Winter'
            WHEN EXTRACT(MONTH FROM o.order_date) IN (3, 4, 5) THEN 'Spring'
            WHEN EXTRACT(MONTH FROM o.order_date) IN (6, 7, 8) THEN 'Summer'
            ELSE 'Fall'
        END AS season,
        SUM(oi.order_item_quantity) AS total_sold
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY p.product_name, season
)
SELECT *
FROM seasonal_data
ORDER BY season, total_sold DESC;

-- 7. Percentage increase in orders during holiday seasons --

WITH monthly_orders AS (
    SELECT 
        DATE_TRUNC('month', order_date) AS month,
        COUNT(order_id) AS orders_count
    FROM orders
    GROUP BY month
),
holiday_orders AS (
    SELECT 
        SUM(orders_count) AS holiday_total
    FROM monthly_orders
    WHERE EXTRACT(MONTH FROM month) IN (11, 12)
),
non_holiday_orders AS (
    SELECT 
        SUM(orders_count) AS non_holiday_total
    FROM monthly_orders
    WHERE EXTRACT(MONTH FROM month) NOT IN (11, 12)
)
SELECT 
    ROUND(
        100.0 * (h.holiday_total - n.non_holiday_total) / NULLIF(n.non_holiday_total, 0), 
        2
    ) AS percentage_increase
FROM holiday_orders h, non_holiday_orders n;


-- 8. Average revenue per day in the last 12 months --

SELECT 
    ROUND(SUM(sales)::NUMERIC / COUNT(DISTINCT order_date), 2) AS avg_revenue_per_day
FROM orders
WHERE order_date >= DATE '2017-02-01' AND order_date < DATE '2018-02-01';


-- 9. Weekend vs Weekday revenue comparison --

SELECT 
    CASE 
        WHEN EXTRACT(DOW FROM order_date) IN (0, 6) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    ROUND(SUM(sales)::NUMERIC,2) AS total_revenue
FROM orders
GROUP BY day_type
ORDER BY total_revenue DESC;


-- 10. Peak sales periods for the past 3 years --

SELECT 
    TO_CHAR(DATE_TRUNC('month', order_date), 'Month YYYY') AS month,
    ROUND(SUM(sales)::NUMERIC,2) AS total_sales
FROM orders
WHERE order_date >= DATE '2015-01-01' AND order_date < DATE '2018-02-01'
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY total_sales DESC
LIMIT 5;