-- 1. Missing Values in Each Table --

-- Example for the "orders" table
SELECT 
  SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS order_id_missing,
  SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) AS date_missing,
  SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS customer_id_missing,
  SUM(CASE WHEN order_status IS NULL THEN 1 ELSE 0 END) AS status_missing,
  SUM(CASE WHEN order_region IS NULL THEN 1 ELSE 0 END) AS region_missing,
  SUM(CASE WHEN order_state IS NULL THEN 1 ELSE 0 END) AS state_missing,
  SUM(CASE WHEN sales IS NULL THEN 1 ELSE 0 END) AS sales_missing,
  SUM(CASE WHEN order_profit_per_order IS NULL THEN 1 ELSE 0 END) AS profit_missing,
  SUM(CASE WHEN order_item_total IS NULL THEN 1 ELSE 0 END) AS item_total_missing,
  SUM(CASE WHEN order_zipcode IS NULL THEN 1 ELSE 0 END) AS zipcode_missing
FROM orders;

-- Example for the "departments" table

SELECT 
  SUM(CASE WHEN department_id IS NULL THEN 1 ELSE 0 END) AS department_id_missing,
  SUM(CASE WHEN department_name IS NULL THEN 1 ELSE 0 END) AS department_name_missing
FROM departments;

-- Example for the "categories" table

SELECT 
  SUM(CASE WHEN product_category_id IS NULL THEN 1 ELSE 0 END) AS product_category_id_missing,
  SUM(CASE WHEN category_name IS NULL THEN 1 ELSE 0 END) AS category_name_missing,
  SUM(CASE WHEN department_id IS NULL THEN 1 ELSE 0 END) AS department_id_missing
FROM categories;

-- Example for the "customers" table

SELECT 
  SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS customer_id_missing,
  SUM(CASE WHEN customer_fname IS NULL THEN 1 ELSE 0 END) AS fname_missing,
  SUM(CASE WHEN customer_lname IS NULL THEN 1 ELSE 0 END) AS lname_missing,
  SUM(CASE WHEN customer_email IS NULL THEN 1 ELSE 0 END) AS email_missing,
  SUM(CASE WHEN customer_segment IS NULL THEN 1 ELSE 0 END) AS segment_missing,
  SUM(CASE WHEN order_city IS NULL THEN 1 ELSE 0 END) AS city_missing,
  SUM(CASE WHEN order_state IS NULL THEN 1 ELSE 0 END) AS state_missing,
  SUM(CASE WHEN order_country IS NULL THEN 1 ELSE 0 END) AS country_missing,
  SUM(CASE WHEN order_zipcode IS NULL THEN 1 ELSE 0 END) AS zipcode_missing
FROM customers;

-- Example for the "products" table

SELECT 
  SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS product_id_missing,
  SUM(CASE WHEN product_name IS NULL THEN 1 ELSE 0 END) AS product_name_missing,
  SUM(CASE WHEN product_category_id IS NULL THEN 1 ELSE 0 END) AS category_id_missing,
  SUM(CASE WHEN product_price IS NULL THEN 1 ELSE 0 END) AS price_missing
FROM products;

-- Example for the "order_items" table

SELECT 
  SUM(CASE WHEN order_item_id IS NULL THEN 1 ELSE 0 END) AS id_missing,
  SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS order_id_missing,
  SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS product_id_missing,
  SUM(CASE WHEN order_item_quantity IS NULL THEN 1 ELSE 0 END) AS qty_missing,
  SUM(CASE WHEN order_item_product_price IS NULL THEN 1 ELSE 0 END) AS price_missing,
  SUM(CASE WHEN order_item_discount IS NULL THEN 1 ELSE 0 END) AS discount_missing,
  SUM(CASE WHEN order_item_discount_rate IS NULL THEN 1 ELSE 0 END) AS discount_rate_missing,
  SUM(CASE WHEN order_item_profit_ratio IS NULL THEN 1 ELSE 0 END) AS profit_ratio_missing
FROM order_items;

-- Example for the "discounts" table

SELECT 
  SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS product_id_missing,
  SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS order_id_missing,
  SUM(CASE WHEN discount_percentage IS NULL THEN 1 ELSE 0 END) AS percentage_missing,
  SUM(CASE WHEN discount_amount IS NULL THEN 1 ELSE 0 END) AS amount_missing
FROM discounts;

-- Example for the "returns" table

SELECT 
  SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS order_id_missing,
  SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS product_id_missing,
  SUM(CASE WHEN refund_amount IS NULL THEN 1 ELSE 0 END) AS refund_missing
FROM returns;

-- Example for the "website_traffic" table

SELECT 
  SUM(CASE WHEN product_card_id IS NULL THEN 1 ELSE 0 END) AS product_card_id_missing,
  SUM(CASE WHEN product_category_id IS NULL THEN 1 ELSE 0 END) AS category_id_missing,
  SUM(CASE WHEN date IS NULL THEN 1 ELSE 0 END) AS date_missing,
  SUM(CASE WHEN department IS NULL THEN 1 ELSE 0 END) AS department_missing,
  SUM(CASE WHEN order_state IS NULL THEN 1 ELSE 0 END) AS state_missing
FROM website_traffic;

-- Example for the "shipping" table

SELECT 
  SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS order_id_missing,
  SUM(CASE WHEN shipping_mode IS NULL THEN 1 ELSE 0 END) AS mode_missing,
  SUM(CASE WHEN shipping_date IS NULL THEN 1 ELSE 0 END) AS date_missing,
  SUM(CASE WHEN days_for_shipping_real IS NULL THEN 1 ELSE 0 END) AS real_days_missing,
  SUM(CASE WHEN days_for_shipment_scheduled IS NULL THEN 1 ELSE 0 END) AS scheduled_days_missing,
  SUM(CASE WHEN delivery_status IS NULL THEN 1 ELSE 0 END) AS delivery_status_missing,
  SUM(CASE WHEN late_delivery_risk IS NULL THEN 1 ELSE 0 END) AS risk_flag_missing
FROM shipping;

-- no  Missing Values found
