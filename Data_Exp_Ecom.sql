-- Find the average orders per customer
SELECT AVG(total_orders) as orders_per_customer
FROM (
    SELECT COUNT(*) AS total_orders
    FROM cleaned_orders2
    GROUP BY customer_id
) AS t1;


-- Find the minimum orders per customer
SELECT COUNT(*) AS total_orders
    FROM cleaned_orders2
    GROUP BY customer_id
    ORDER BY 1;


-- Find the maximum orders per customer
SELECT COUNT(*) AS total_orders
    FROM cleaned_orders2
    GROUP BY customer_id
    ORDER BY 1 DESC;


-- Find the order quantities for each year
SELECT YEAR(order_date), COUNT(*) AS total_orders
    FROM cleaned_orders2
    GROUP BY 1
    ORDER BY 1;


-- Find the sales performance for each year
SELECT YEAR(order_date), ROUND(SUM(unit_price_usd)) AS total_orders
    FROM cleaned_orders2
    GROUP BY 1
    ORDER BY 1;


-- Find top categories by sales performance
SELECT product_category, ROUND(SUM(unit_price_usd))
FROM cleaned_orders2
GROUP BY 1
ORDER BY 2 DESC;


-- Find top products by sales performance
SELECT product_name, ROUND(SUM(unit_price_usd))
FROM cleaned_orders2
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


-- Find top countries by sales performance
SELECT country, ROUND(SUM(unit_price_usd))
FROM cleaned_orders2
GROUP BY 1
ORDER BY 2 DESC;


-- Number of orders by order status
SELECT order_status, count(*) AS orders
FROM cleaned_orders2
GROUP BY 1
ORDER BY 2 DESC;
