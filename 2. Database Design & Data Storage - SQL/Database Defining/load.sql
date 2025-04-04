COPY departments (
    department_id,department_name
)
FROM 'C:\DA\Projects\Supply Chain & Sales Analytics System\2. Database Design & Data Storage - SQL\Database Defining\tables\departments.csv'
DELIMITER ','
CSV HEADER;

COPY categories (
    product_category_id, category_name, department_id
)
FROM 'C:\DA\Projects\Supply Chain & Sales Analytics System\2. Database Design & Data Storage - SQL\Database Defining\tables\categories.csv'
DELIMITER ','
CSV HEADER;

COPY customers (
    customer_id, customer_fname, customer_lname, customer_email,
    customer_segment, order_city, order_state, order_country, order_zipcode
)
FROM 'C:\DA\Projects\Supply Chain & Sales Analytics System\2. Database Design & Data Storage - SQL\Database Defining\tables\customers.csv'
DELIMITER ','
CSV HEADER;

COPY products (
    product_id, product_name, product_category_id,
    product_price
)
FROM 'C:\DA\Projects\Supply Chain & Sales Analytics System\2. Database Design & Data Storage - SQL\Database Defining\tables\products.csv'
DELIMITER ','
CSV HEADER;

COPY orders (
    order_id, order_date, customer_id, order_status, order_region,
    order_state, sales, order_profit_per_order, order_item_total, order_zipcode
)
FROM 'C:\DA\Projects\Supply Chain & Sales Analytics System\2. Database Design & Data Storage - SQL\Database Defining\tables\orders.csv'
DELIMITER ','
CSV HEADER;

COPY order_items (
    order_item_id, order_id, product_id,
    order_item_quantity, order_item_product_price,
    order_item_discount, order_item_discount_rate, order_item_profit_ratio
)
FROM 'C:\DA\Projects\Supply Chain & Sales Analytics System\2. Database Design & Data Storage - SQL\Database Defining\tables\order_items.csv'
DELIMITER ','
CSV HEADER;


COPY discounts (
    discount_id, product_id, order_id,
    discount_percentage, discount_amount
)
FROM 'C:\DA\Projects\Supply Chain & Sales Analytics System\2. Database Design & Data Storage - SQL\Database Defining\tables\discounts.csv'
DELIMITER ','
CSV HEADER;

COPY returns (
    return_id, order_id, product_id, return_reason, refund_amount
)
FROM 'C:\DA\Projects\Supply Chain & Sales Analytics System\2. Database Design & Data Storage - SQL\Database Defining\tables\returns.csv'
DELIMITER ','
CSV HEADER;

COPY website_traffic (
    product_card_id, product_category_id, date, department, order_state
)
FROM 'C:\DA\Projects\Supply Chain & Sales Analytics System\2. Database Design & Data Storage - SQL\Database Defining\tables\website_traffic.csv'
DELIMITER ','
CSV HEADER;

COPY shipping (
    order_id, shipping_mode, shipping_date,
    days_for_shipping_real, days_for_shipment_scheduled,
    delivery_status, late_delivery_risk
)
FROM 'C:\DA\Projects\Supply Chain & Sales Analytics System\2. Database Design & Data Storage - SQL\Database Defining\tables\shipping.csv'
DELIMITER ','
CSV HEADER;

