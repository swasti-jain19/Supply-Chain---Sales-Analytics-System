-- General Traffic & Behavior Analysis --

-- 1. Peak Traffic Hours--

SELECT hour, COUNT(*) AS url_hits
FROM access_logs
GROUP BY hour
ORDER BY url_hits DESC;

-- 2. Most Accessed Product Categories --

SELECT category, COUNT(*) AS views
FROM access_logs
GROUP BY category
ORDER BY views DESC;

-- 3. Department-wise Daily Traffic --

SELECT date, department, COUNT(*) AS total_visits
FROM access_logs
GROUP BY date, department
ORDER BY date, total_visits DESC;

-- 4. Most Popular Products by Clicks --

SELECT product, COUNT(*) AS views
FROM access_logs
GROUP BY product
ORDER BY views DESC
LIMIT 10;


-- 5. Month-over-Month Traffic --

SELECT month, COUNT(*) AS visits
FROM access_logs
GROUP BY month
ORDER BY visits DESC;

-- 6. Hourly Traffic Trend for a Specific Product --

SELECT hour, COUNT(*) AS hits
FROM access_logs
WHERE product = 'Nike Men''s Dri-FIT Victory Golf Polo'
GROUP BY hour
ORDER BY hour;

-- 7. Top 5 Departments by Access Count --

SELECT department, COUNT(*) AS total_hits
FROM access_logs
GROUP BY department
ORDER BY total_hits DESC
LIMIT 5;

-- 8. Category-wise Daily Performance --

SELECT date, category, COUNT(*) AS views
FROM access_logs
GROUP BY date, category
ORDER BY date, views DESC;


-- 9. Detect Low-Traffic Products --

SELECT product, COUNT(*) AS views
FROM access_logs
GROUP BY product
HAVING COUNT(*) < 1000
ORDER BY views;

	
-- 10. Most Active Days (by visit count) --

SELECT date, COUNT(*) AS hits
FROM access_logs
GROUP BY date
ORDER BY hits DESC
LIMIT 7;


-- 11. Department-wise Unique Products Accessed --

SELECT department, COUNT(DISTINCT product) AS unique_products
FROM access_logs
GROUP BY department
ORDER BY unique_products DESC;


-- 12. Category Access Frequency Across Months --

SELECT month, category, COUNT(*) AS access_count
FROM access_logs
GROUP BY month, category
ORDER BY month, access_count DESC;


-- 13. Least Accessed Categories --

SELECT category, COUNT(*) AS views
FROM access_logs
GROUP BY category
ORDER BY views ASC
LIMIT 5;


-- 14. Product Popularity in Each Department --

SELECT department, product, COUNT(*) AS hits
FROM access_logs
GROUP BY department, product
ORDER BY department, hits DESC;


-- 15. Weekend vs Weekday Traffic (requires date function support) --

SELECT TO_CHAR(date, 'Day') AS day_of_week, COUNT(*) AS hits
FROM access_logs
GROUP BY day_of_week
ORDER BY hits DESC;

-- 16. Consistent High Performers (Every Month Accessed) --

SELECT product as Consistent_High_Performers
FROM access_logs
GROUP BY product
HAVING COUNT(DISTINCT month) = (SELECT COUNT(DISTINCT month) FROM access_logs);

-- 17. Top Departments per Category --

SELECT category, department, COUNT(*) AS views
FROM access_logs
GROUP BY category, department
ORDER BY category, views DESC;

-- 18. Heatmap Prep: Hourly Traffic by Day --

SELECT date, hour, COUNT(*) AS hits
FROM access_logs
GROUP BY date, hour
ORDER BY date, hour;

-- 19. Month-over-Month Growth in Accesses

WITH monthly_accesses AS (
    SELECT 
        TO_CHAR(date, 'YYYY-MM') AS month,
        COUNT(*) AS total_accesses
    FROM access_logs
    GROUP BY TO_CHAR(date, 'YYYY-MM')
)
SELECT 
    month,
    total_accesses,
    LAG(total_accesses) OVER (ORDER BY month) AS previous_month_accesses,
    ROUND(
        CASE 
            WHEN LAG(total_accesses) OVER (ORDER BY month) = 0 THEN NULL
            ELSE ( (total_accesses - LAG(total_accesses) OVER (ORDER BY month)) * 100.0 / LAG(total_accesses) OVER (ORDER BY month) )
        END,
        2
    ) AS percentage_change
FROM monthly_accesses
ORDER BY month;

-- 20. Most Common Product-Category Pair

SELECT product, category, COUNT(*) AS frequency
FROM access_logs
GROUP BY product, category
ORDER BY frequency DESC
LIMIT 1;
