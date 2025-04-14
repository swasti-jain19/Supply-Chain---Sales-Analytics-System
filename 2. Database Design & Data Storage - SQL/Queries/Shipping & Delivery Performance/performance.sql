-- 1. What is the average shipping time for each shipping mode? --

SELECT 
    shipping_mode,
    ROUND(AVG(days_for_shipping_real),2) AS avg_shipping_time_in_days
FROM shipping
GROUP BY shipping_mode
ORDER BY avg_shipping_time_in_days;

-- 2. Which shipping method has the highest on-time delivery rate? --

SELECT 
    shipping_mode,
    ROUND(SUM(CASE WHEN late_delivery_risk = FALSE THEN 1 ELSE 0 END)::decimal / COUNT(*) * 100, 2) AS on_time_delivery_percentage
FROM shipping
GROUP BY shipping_mode
ORDER BY on_time_delivery_percentage DESC
LIMIT 1;


-- 3. What percentage of shipments are delayed beyond the expected delivery date? --

SELECT 
    ROUND(SUM(CASE WHEN days_for_shipping_real > days_for_shipment_scheduled THEN 1 ELSE 0 END)::decimal / COUNT(*) * 100, 2) AS delayed_percentage
FROM shipping;

-- 4. Identify regions with the highest number of shipping delays. --

SELECT 
    o.order_region,
    COUNT(*) AS delayed_shipments
FROM shipping s
JOIN orders o ON s.order_id = o.order_id
WHERE s.days_for_shipping_real > s.days_for_shipment_scheduled
GROUP BY o.order_region
ORDER BY delayed_shipments DESC;

-- 5. What is the refund rate due to delivery issues? --

SELECT 
    ROUND(COUNT(DISTINCT r.order_id)::decimal / (SELECT COUNT(*) FROM orders) * 100, 2) AS refund_rate_delivery_issues
FROM returns r
JOIN shipping s ON r.order_id = s.order_id
WHERE s.late_delivery_risk = TRUE;

-- 6. Which shipping mode has the lowest average delivery delay? --
-- This helps identify the most efficient shipping method based on how far off it is from the expected schedule. --

SELECT 
    shipping_mode,
    ROUND(AVG(days_for_shipping_real - days_for_shipment_scheduled), 2) AS avg_delay_days
FROM shipping
GROUP BY shipping_mode
ORDER BY avg_delay_days;


-- 7. What is the average delivery delay per customer segment and shipping mode combination?

SELECT 
    c.customer_segment,
    s.shipping_mode,
    ROUND(AVG(s.days_for_shipping_real - s.days_for_shipment_scheduled), 2) AS avg_delivery_delay
FROM shipping s
JOIN orders o ON s.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_segment, s.shipping_mode
ORDER BY c.customer_segment, avg_delivery_delay;


-- 8. Identify customers who frequently experience late deliveries.

SELECT 
    c.customer_id,
    c.customer_fname || ' ' || c.customer_lname AS customer_name,
    c.order_city,
    COUNT(*) AS late_deliveries
FROM shipping s
JOIN orders o ON s.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
WHERE s.days_for_shipping_real > s.days_for_shipment_scheduled
GROUP BY c.customer_id, customer_name, c.order_city
ORDER BY late_deliveries DESC , c.order_city
LIMIT 10;


-- 9.  Total orders shipped per day of the week

SELECT 
    TO_CHAR(s.shipping_date, 'Day') AS day_of_week,
    COUNT(*) AS total_shipments
FROM shipping s
GROUP BY day_of_week
ORDER BY total_shipments DESC;

-- 10. Calculate shipping delay ratio per state (late vs total)

SELECT 
    o.order_state,
    ROUND(
        100.0 * SUM(CASE WHEN s.days_for_shipping_real > s.days_for_shipment_scheduled THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS delay_ratio_percentage
FROM shipping s
JOIN orders o ON s.order_id = o.order_id
GROUP BY o.order_state
ORDER BY delay_ratio_percentage DESC;
