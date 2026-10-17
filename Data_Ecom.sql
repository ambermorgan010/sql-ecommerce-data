-- Create database
CREATE DATABASE ecommerce_retail_transactions;




-- Create table
CREATE TABLE orders (
    order_id VARCHAR(25),
    customer_id VARCHAR(25),
    order_date VARCHAR(25),
    product_category VARCHAR(25),
    product_name VARCHAR(25),
    quantity VARCHAR(25),
    unit_price_usd VARCHAR(25),
    discount_percent VARCHAR(25),
    payment_method VARCHAR(25),
    shipping_city VARCHAR(25),
    country VARCHAR(25),
    order_status VARCHAR(25),
    customer_rating VARCHAR(25)
);



-- Import raw data
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 26.7/Uploads/ecommerce_retail_transactions_raw.csv"
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;




-- Create secondary table for cleaning data
CREATE TABLE cleaned_orders LIKE orders;




-- Mirror raw data
INSERT INTO cleaned_orders SELECT * FROM orders;




-- Create temporary table for staging, adding duplicate count `rn`
CREATE TABLE `cleaned_orders2` (
  `order_id` varchar(25) DEFAULT NULL,
  `customer_id` varchar(25) DEFAULT NULL,
  `order_date` varchar(25) DEFAULT NULL,
  `product_category` varchar(25) DEFAULT NULL,
  `product_name` varchar(25) DEFAULT NULL,
  `quantity` varchar(25) DEFAULT NULL,
  `unit_price_usd` varchar(25) DEFAULT NULL,
  `discount_percent` varchar(25) DEFAULT NULL,
  `payment_method` varchar(25) DEFAULT NULL,
  `shipping_city` varchar(25) DEFAULT NULL,
  `country` varchar(25) DEFAULT NULL,
  `order_status` varchar(25) DEFAULT NULL,
  `customer_rating` varchar(25) DEFAULT NULL,
  `rn` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci




-- Insert data & duplicate count
INSERT INTO cleaned_orders2
SELECT *,
    ROW_NUMBER() OVER (
        PARTITION BY order_id) AS rn
FROM orders;



-- Remove duplicate orders
DELETE
FROM cleaned_orders2
WHERE rn > 1;


ALTER TABLE cleaned_orders2
DROP COLUMN rn;


-- Convert to date format
UPDATE cleaned_orders2
SET order_date = STR_TO_DATE(order_date, '%Y-%m-%d');


ALTER TABLE cleaned_orders2
MODIFY COLUMN order_date DATE;




-- Standardize payment_method format
UPDATE cleaned_orders2
SET payment_method = 'Debit'
WHERE payment_method LIKE 'debit%';


UPDATE cleaned_orders2
SET payment_method = 'Credit'
WHERE payment_method LIKE 'credit%';


UPDATE cleaned_orders2
SET payment_method = 'UPI'
WHERE payment_method LIKE 'upi' OR payment_method LIKE 'u.p.i';


UPDATE cleaned_orders2
SET payment_method = 'Cash on delivery'
WHERE payment_method LIKE 'cod' OR payment_method LIKE 'c.o.d' OR payment_method LIKE 'cash%';


UPDATE cleaned_orders2
SET payment_method = 'PayPal'
WHERE payment_method LIKE 'pay%';


UPDATE cleaned_orders2
SET payment_method = 'Net banking'
WHERE payment_method LIKE 'net%';


-- Standardize country format
UPDATE cleaned_orders2
SET country = 'Australia'
WHERE country LIKE 'au%';


UPDATE cleaned_orders2
SET country = 'United States'
WHERE country LIKE 'us%' OR country LIKE 'u.s%' OR country LIKE '%states';


UPDATE cleaned_orders2
SET country = 'United Kingdom'
WHERE country LIKE 'uk%' OR country LIKE 'u.k%' OR country LIKE '%kingdom';


UPDATE cleaned_orders2
SET country = 'United Arab Emirates'
WHERE country LIKE 'ua%' OR country LIKE 'u.a%' OR country LIKE '%emirates';


UPDATE cleaned_orders2
SET country = 'Germany'
WHERE country LIKE 'de' OR country LIKE 'ge%';


UPDATE cleaned_orders2
SET country = 'India'
WHERE country LIKE 'in%';


UPDATE cleaned_orders2
SET country = 'Canada'
WHERE country LIKE 'ca%';
