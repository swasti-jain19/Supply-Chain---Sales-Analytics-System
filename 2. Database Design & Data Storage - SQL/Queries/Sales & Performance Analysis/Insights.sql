-- 1. Total revenue generated in the past year --

SELECT 
	ROUND(SUM(order_item_total)::NUMERIC,2) AS total_revenue
FROM orders
WHERE order_date >= '2017-01-01' AND order_date <= '2017-12-31';

-- 2. Product category contributing most to total sales --

SELECT c.category_name, 
       ROUND(SUM(oi.order_item_quantity * oi.order_item_product_price)::NUMERIC,2) AS total_sales
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.product_category_id = c.product_category_id
GROUP BY c.category_name
ORDER BY total_sales DESC
LIMIT 1;

-- 2.a Product category contributing most to total sales --

SELECT c.category_name, 
       ROUND(SUM(oi.order_item_quantity * oi.order_item_product_price)::NUMERIC,2) AS total_sales
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.product_category_id = c.product_category_id
GROUP BY c.category_name
ORDER BY total_sales DESC


-- 3. Top 10 customers who spent the most --

SELECT 
    c.customer_id, 
    CONCAT(c.customer_fname, ' ', c.customer_lname) AS customer_name, 
    ROUND(SUM(o.order_item_total)::NUMERIC,2) AS total_spent
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, customer_name
ORDER BY total_spent DESC
LIMIT 10;

-- 4. Total number of orders placed each month --

SELECT TO_CHAR(order_date, 'YYYY-MM') AS month, COUNT(*) AS order_count
FROM orders
GROUP BY month
ORDER BY month;

-- 5. Percentage of returning vs. new customers --

-- Returning customers have placed more than one order
WITH customer_order_counts AS (
  SELECT customer_id, COUNT(*) AS orders_count
  FROM orders
  GROUP BY customer_id
)
SELECT
  ROUND(SUM(CASE WHEN orders_count = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS new_customers_percentage,
  ROUND(SUM(CASE WHEN orders_count > 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS returning_customers_percentage
FROM customer_order_counts;


-- 6. City or region generating highest revenue --

SELECT 
    c.order_city, 
    ROUND(SUM(o.sales)::numeric, 2) AS total_revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.order_city
ORDER BY total_revenue DESC
LIMIT 1;

-- 7. How average order value changes over time --

SELECT 
    TO_CHAR(order_date, 'YYYY-MM') AS month,
    ROUND(AVG(sales)::numeric, 2) AS avg_order_value
FROM orders
GROUP BY month
ORDER BY month;


-- 8. Products with the highest profit margins --

SELECT 
    product_id, 
    product_name, 
    ROUND(product_price::NUMERIC,2)
FROM products
ORDER BY product_price DESC
LIMIT 10;

-- 9. Overall return rate of products --

SELECT 
  (SELECT COUNT(*) FROM returns) * 100.0 / COUNT(*) AS return_rate_percentage
FROM order_items;

-- Assumes a returns table exists containing returned order items. --

-- 10. Impact of discount percentage on total sales --

SELECT 
    d.discount_percentage, 
    SUM(oi.order_item_quantity * oi.order_item_product_price) AS total_sales
FROM order_items oi
JOIN discounts d ON oi.order_id = d.order_id AND oi.product_id = d.product_id
GROUP BY d.discount_percentage
ORDER BY d.discount_percentage;