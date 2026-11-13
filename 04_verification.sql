-- Verification checks
USE ecommerce_gisma;
SELECT COUNT(*) AS customer_count FROM Customers;
SELECT COUNT(*) AS supplier_count FROM Suppliers;
SELECT COUNT(*) AS product_count FROM Products;
SELECT COUNT(*) AS order_count FROM Orders;
SELECT COUNT(*) AS order_detail_count FROM Order_Details;
SELECT COUNT(*) AS transaction_count FROM Transactions;

SELECT TABLE_NAME, COLUMN_NAME, CONSTRAINT_NAME, REFERENCED_TABLE_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'ecommerce_gisma'
  AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY TABLE_NAME, COLUMN_NAME;
