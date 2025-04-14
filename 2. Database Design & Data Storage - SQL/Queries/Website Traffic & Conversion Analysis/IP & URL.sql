-- IP & URL-Based Advanced Queries --

-- Most Frequent Visitors (by IP) --

SELECT ip, COUNT(*) AS visits
FROM access_logs
GROUP BY ip
ORDER BY visits DESC
LIMIT 10;

-- Top Visited URLs --

SELECT url, COUNT(*) AS visits
FROM access_logs
GROUP BY url
ORDER BY visits DESC
LIMIT 10;

-- IP-wise Product Interest --

SELECT ip, product, COUNT(*) AS access_count
FROM access_logs
GROUP BY ip, product
ORDER BY access_count DESC;

-- Frequent IPs by Department --

SELECT department, ip, COUNT(*) AS hits
FROM access_logs
GROUP BY department, ip
ORDER BY department, hits DESC;

-- Suspicious Activity: High Activity IPs in Short Timeframes --

SELECT ip, date, hour, COUNT(*) AS hits
FROM access_logs
GROUP BY ip, date, hour
HAVING COUNT(*) > 25
ORDER BY hits DESC;


-- URLs Frequently Accessed from Same IP --

SELECT 
    ip,
    COUNT(*) AS access_count
FROM access_logs
GROUP BY ip
HAVING COUNT(*) > 5  -- filter to focus on frequent access (optional)
ORDER BY access_count DESC
LIMIT 100; 


-- IP Addresses Visiting Multiple Departments --

SELECT 
    ip,
    COUNT(DISTINCT department) AS departments_accessed,
    STRING_AGG(DISTINCT department, ', ') AS department_names
FROM access_logs
GROUP BY ip
HAVING COUNT(DISTINCT department) > 4
ORDER BY departments_accessed DESC;


-- IP Address with Maximum Category Exploration --

SELECT ip, COUNT(DISTINCT category) AS unique_categories
FROM access_logs
GROUP BY ip
ORDER BY unique_categories DESC
LIMIT 1;