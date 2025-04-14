--  Duplicate Records in All Tables --

-- departments --

SELECT COUNT(*) AS duplicate_departments
FROM (
    SELECT department_id
    FROM departments
    GROUP BY department_id
    HAVING COUNT(*) > 1
) AS dup;

-- categories --

SELECT COUNT(*) AS duplicate_categories
FROM (
    SELECT product_category_id
    FROM categories
    GROUP BY product_category_id
    HAVING COUNT(*) > 1
) AS dup;

-- customers --

SELECT COUNT(*) AS duplicate_customers
FROM (
    SELECT customer_id
    FROM customers
    GROUP BY customer_id
    HAVING COUNT(*) > 1
) AS dup;

-- products --

SELECT COUNT(*) AS duplicate_products
FROM (
    SELECT product_id
    FROM products
    GROUP BY product_id
    HAVING COUNT(*) > 1
) AS dup;

-- orders --

SELECT COUNT(*) AS duplicate_orders
FROM (
    SELECT order_id
    FROM orders
    GROUP BY order_id
    HAVING COUNT(*) > 1
) AS dup;

-- order_items --

SELECT COUNT(*) AS duplicate_order_items
FROM (
    SELECT order_item_id
    FROM order_items
    GROUP BY order_item_id
    HAVING COUNT(*) > 1
) AS dup;

-- discounts --
(Assuming duplicates are based on both product_id and order_id combination)

SELECT COUNT(*) AS duplicate_discounts
FROM (
    SELECT product_id, order_id
    FROM discounts
    GROUP BY product_id, order_id
    HAVING COUNT(*) > 1
) AS dup;

-- returns ?? --

SELECT COUNT(*) AS duplicate_returns
FROM (
    SELECT order_id, product_id
    FROM returns
    GROUP BY order_id, product_id
    HAVING COUNT(*) > 1
) AS dup;

-- access logs --

SELECT COUNT(*) AS duplicate_access
FROM (
    SELECT order_id
    FROM shipping
    GROUP BY order_id
    HAVING COUNT(*) > 1
) AS dup;


-- shipping --

SELECT COUNT(*) AS duplicate_shipping
FROM (
    SELECT order_id
    FROM shipping
    GROUP BY order_id
    HAVING COUNT(*) > 1
) AS dup;

