-- Demonstration queries. Run after 01_create_database.sql and 02_insert_sample_data.sql.
USE ecommerce_gisma;

-- 1. READ: list customers
SELECT * FROM Customers ORDER BY customer_id;

-- 2. READ: list available products
SELECT product_id, product_name, category, price, stock
FROM Products WHERE stock > 0 ORDER BY product_name;

-- 3. CREATE: add a temporary demonstration customer
INSERT INTO Customers
(first_name,last_name,email,phone_number,registration_date,country)
VALUES ('Test','Customer','test.customer@example.com',NULL,CURDATE(),'Germany');

-- 4. UPDATE: change the test customer's phone number
UPDATE Customers
SET phone_number = '+4917000000000'
WHERE email = 'test.customer@example.com';

-- 5. DELETE: remove only the isolated test customer (no orders reference it)
DELETE FROM Customers
WHERE email = 'test.customer@example.com';

-- 6. JOIN: customers and their orders
SELECT c.customer_id, CONCAT(c.first_name,' ',c.last_name) AS customer_name,
       o.order_id, o.order_date, o.o_status, o.total_amount
FROM Customers c
INNER JOIN Orders o ON o.customer_id = c.customer_id
ORDER BY o.order_date;

-- 7. JOIN: order line items with product descriptions
SELECT o.order_id, p.product_name, od.quantity, od.price_each,
       (od.quantity * od.price_each) AS line_total
FROM Order_Details od
INNER JOIN Orders o ON o.order_id = od.order_id
INNER JOIN Products p ON p.product_id = od.product_id
ORDER BY o.order_id, p.product_name;

-- 8. JOIN: supplier catalogue
SELECT s.supplier_name, p.product_name, p.category, p.price, p.stock
FROM Suppliers s
INNER JOIN Products p ON p.supplier_id = s.supplier_id
ORDER BY s.supplier_name, p.product_name;

-- 9. AGGREGATION: sales value by order status
SELECT o_status, COUNT(*) AS number_of_orders,
       SUM(total_amount) AS order_value
FROM Orders
GROUP BY o_status
ORDER BY order_value DESC;

-- 10. AGGREGATION: customer order totals (including customers with no orders)
SELECT c.customer_id, CONCAT(c.first_name,' ',c.last_name) AS customer_name,
       COUNT(o.order_id) AS order_count,
       COALESCE(SUM(o.total_amount),0) AS lifetime_order_value
FROM Customers c
LEFT JOIN Orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY lifetime_order_value DESC;

-- 11. AGGREGATION: successful payment totals by method
SELECT payment_method, COUNT(*) AS successful_transactions,
       SUM(amount) AS amount_collected
FROM Transactions
WHERE transaction_status = 'Successful'
GROUP BY payment_method
ORDER BY amount_collected DESC;

-- 12. FILTER: orders above a chosen threshold
SELECT order_id, order_date, total_amount, o_status
FROM Orders
WHERE total_amount >= 50
ORDER BY total_amount DESC;

-- 13. SUBQUERY: products priced above the average product price
SELECT product_id, product_name, price
FROM Products
WHERE price > (SELECT AVG(price) FROM Products)
ORDER BY price DESC;

-- 14. DATA QUALITY: verify that each order header total matches its detail lines.
-- This is a diagnostic query; a non-zero difference indicates a mismatch.
SELECT o.order_id, o.total_amount AS stored_total,
       COALESCE(SUM(od.quantity * od.price_each),0) AS calculated_total,
       o.total_amount - COALESCE(SUM(od.quantity * od.price_each),0) AS difference
FROM Orders o
LEFT JOIN Order_Details od ON od.order_id = o.order_id
GROUP BY o.order_id, o.total_amount
ORDER BY o.order_id;

-- 15. SCHEMA VERIFICATION
SHOW TABLES;
SHOW CREATE TABLE Order_Details;
