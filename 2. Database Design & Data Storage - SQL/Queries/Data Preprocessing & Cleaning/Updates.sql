-- updates --

DROP TABLE website_traffic

CREATE TABLE ACCESS_LOGS(
	product VARCHAR(255),
	category VARCHAR(255),
	date DATE,
	month VARCHAR(20),
	hour INT,
	department VARCHAR(255),
	ip VARCHAR(255),
	url VARCHAR(255)
)

COPY ACCESS_LOGS(
    product, category, date	, month, hour, department, ip, url
	)
FROM 'C:\DA\Projects\Supply Chain & Sales Analytics System\Cleaned Data\cleaned_access_logs.csv'
DELIMITER ','
CSV HEADER;

ALTER TABLE customers DROP COLUMN order_zipcode,
DROP COLUMN customer_email

ALTER TABLE orders DROP COLUMN order_zipcode