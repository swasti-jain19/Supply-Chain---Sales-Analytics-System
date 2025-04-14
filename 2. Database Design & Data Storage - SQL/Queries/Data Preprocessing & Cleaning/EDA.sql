-- Orders with Missing or Incorrect Shipping Dates --

SELECT COUNT(*) AS Missing_Incorrect
FROM(
	SELECT * 
	FROM shipping 
	WHERE shipping_date IS NULL
) AS Miss_Incorr;

-- Products with Missing or Null Category Names --

SELECT COUNT(*) AS Missing_Null_Category_Names
FROM(
	SELECT p.product_id, p.product_name 
	FROM products p
	JOIN categories c ON p.product_category_id = c.product_category_id
	WHERE c.category_name IS NULL
	) AS miss_null

-- Products with Invalid Prices --
	
SELECT COUNT(*) AS Invalid_Price
FROM(
	SELECT * 
	FROM products 
	WHERE product_price <= 0 OR product_price IS NULL
) AS invalid_price

-- Orders Where Shipping Date is Earlier Than Order Date -- 

SELECT COUNT(*) AS Invalid_Orders
FROM(
	SELECT s.*, o.order_date
	FROM shipping s
	JOIN orders o ON s.order_id = o.order_id
	WHERE s.shipping_date < o.order_date
) AS invalid_orders


-- Customers Who Placed Multiple Orders with Same Details --

SELECT COUNT(*) AS Multiple_Orders
FROM(
	SELECT customer_id, COUNT(*)
	FROM orders
	GROUP BY customer_id, order_date, order_status, order_region, order_state, sales
	HAVING COUNT(*) > 1
) AS multiple_orders

-- Product Names With Special Characters --

SELECT * 
FROM products 
WHERE product_name ~ '[^a-zA-Z0-9\s]';