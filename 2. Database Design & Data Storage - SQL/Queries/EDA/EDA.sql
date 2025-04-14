-- 1. Top 10 Most Frequently Ordered Products --

SELECT p.product_name, COUNT(*) AS total_orders
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_orders DESC
LIMIT 10;

-- 2. Top 5 Most Common Customer Segments --

SELECT customer_segment, COUNT(*) AS total_customers
FROM customers
GROUP BY customer_segment
ORDER BY total_customers DESC
LIMIT 5;

-- 3. Distribution of Order Statuses --

SELECT order_status, COUNT(*) AS count
FROM orders
GROUP BY order_status
ORDER BY count DESC;

-- 4. Average Number of Products per Order --

SELECT ROUND(AVG(product_count),2) AS avg_products_per_order
FROM (
    SELECT order_id, COUNT(*) AS product_count
    FROM order_items
    GROUP BY order_id
) sub;

-- 5. Top 10 Best-Selling Categories Based on Revenue --

SELECT 
	c.category_name, 
	ROUND(SUM(oi.order_item_quantity * oi.order_item_product_price)::NUMERIC, 2) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.product_category_id = c.product_category_id
GROUP BY c.category_name
ORDER BY total_revenue DESC
LIMIT 10;

-- 6. Average and Median Product Price in Each Category --

-- Average
SELECT c.category_name, ROUND(AVG(p.product_price)::NUMERIC,2) AS avg_price
FROM products p
JOIN categories c ON p.product_category_id = c.product_category_id
GROUP BY c.category_name;

-- Median (requires a CTE or window function - for PostgreSQL 11+)
WITH category_prices AS (
  SELECT 
    c.category_name,
    p.product_price
  FROM products p
  JOIN categories c ON p.product_category_id = c.product_category_id
)
SELECT 
  category_name,
  ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY product_price)::NUMERIC,2) AS median_price
FROM category_prices
GROUP BY category_name;

-- 7. Number of Unique Customers Who Placed Orders --

SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM orders;

-- 8. % of Revenue by Top 10% Customers --

WITH customer_revenue AS (
  SELECT o.customer_id, SUM(o.sales) AS total_revenue
  FROM orders o
  GROUP BY o.customer_id
),
ranked_customers AS (
  SELECT *, NTILE(10) OVER (ORDER BY total_revenue DESC) AS decile
  FROM customer_revenue
)
SELECT 
  ROUND(
    (100.0 * SUM(CASE WHEN decile = 1 THEN total_revenue ELSE 0 END) / SUM(total_revenue))::NUMERIC,
    2
  ) AS top_10_percent_contribution
FROM ranked_customers;


-- 9. Top-Selling Products by Revenue --

SELECT p.product_name, ROUND(SUM(oi.order_item_quantity * oi.order_item_product_price)::NUMERIC,2) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 10;

-- 10. Customer Segments with Highest & Lowest Return Rates --

WITH customer_returns AS (
    SELECT o.customer_id, COUNT(DISTINCT r.order_id) AS returns
    FROM returns r
    JOIN orders o ON r.order_id = o.order_id
    GROUP BY o.customer_id
),
customer_orders AS (
    SELECT customer_id, COUNT(*) AS total_orders
    FROM orders
    GROUP BY customer_id
),
return_rates AS (
    SELECT co.customer_id, 
           cu.customer_segment,
           cr.returns,
           co.total_orders,
           ROUND(100.0 * cr.returns / co.total_orders, 2) AS return_rate
    FROM customer_orders co
    JOIN customer_returns cr ON co.customer_id = cr.customer_id
    JOIN customers cu ON co.customer_id = cu.customer_id
)
SELECT customer_segment, 
       ROUND(AVG(return_rate),2) AS avg_return_rate
FROM return_rates
GROUP BY customer_segment
ORDER BY avg_return_rate DESC;