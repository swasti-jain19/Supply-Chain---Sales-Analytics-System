-- create table that are not dependent on any other tables -- 

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(255) UNIQUE
);

CREATE TABLE categories (
    product_category_id INT PRIMARY KEY,
    category_name VARCHAR(255),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_fname VARCHAR(255),
    customer_lname VARCHAR(255),
    customer_email VARCHAR(255) UNIQUE,
    customer_segment VARCHAR(255),
    order_city VARCHAR(255),
    order_state VARCHAR(255),
    order_country VARCHAR(255),
    order_zipcode VARCHAR(20)
);


-- create table that are dependent on previous tables -- 


CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    product_category_id INT,
    product_price FLOAT,
    FOREIGN KEY (product_category_id) REFERENCES categories(product_category_id)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT,
    order_status VARCHAR(255),
    order_region VARCHAR(255),
    order_state VARCHAR(255),
    sales FLOAT,
    order_profit_per_order FLOAT,
    order_item_total FLOAT,
    order_zipcode VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);


-- create table that are dependent on above tables -- 


CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    order_item_quantity INT,
    order_item_product_price FLOAT,
    order_item_discount FLOAT,
    order_item_discount_rate FLOAT,
    order_item_profit_ratio FLOAT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE discounts (
    discount_id SERIAL PRIMARY KEY,
    product_id INT,
    order_id INT,
    discount_percentage FLOAT,
    discount_amount FLOAT,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE returns (
    return_id SERIAL PRIMARY KEY,
    order_id INT,
    product_id INT,
    refund_amount FLOAT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE website_traffic (
    product_card_id INT,
    product_category_id INT,
    date DATE,
    department VARCHAR(255),
    order_state VARCHAR(255),
    FOREIGN KEY (product_category_id) REFERENCES categories(product_category_id)
);

CREATE TABLE shipping (
    order_id INT,
    shipping_mode VARCHAR(255),
    shipping_date DATE,
    days_for_shipping_real INT,
    days_for_shipment_scheduled INT,
    delivery_status VARCHAR(255),
    late_delivery_risk BOOLEAN,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

