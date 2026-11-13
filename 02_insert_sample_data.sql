-- Sample data for demonstrations. Run after 01_create_database.sql.
USE ecommerce_gisma;

INSERT INTO Customers
(first_name,last_name,email,phone_number,registration_date,country) VALUES
('Aisha','Khan','aisha.khan@example.com','+4915111111111','2026-01-10','Germany'),
('Omar','Ali','omar.ali@example.com','+4915222222222','2026-02-14','Germany'),
('Sara','Ahmed','sara.ahmed@example.com','+971501234567','2026-03-02','UAE'),
('Daniel','Weber','daniel.weber@example.com','+4916333333333','2026-04-20','Germany'),
('Maya','Singh','maya.singh@example.com','+447700900123','2026-05-05','United Kingdom');

INSERT INTO Suppliers (supplier_name,contact_name,phone,country) VALUES
('Berlin Tech Supply','Lena Fischer','+49301110001','Germany'),
('Global Accessories Ltd','Adam Smith','+442071110002','United Kingdom'),
('UAE Electronics Trading','Hassan Noor','+97145550003','UAE');

INSERT INTO Products (product_name,category,price,stock,supplier_id) VALUES
('Wireless Mouse','Accessories',19.99,120,1),
('Mechanical Keyboard','Accessories',69.50,45,1),
('USB-C Hub','Electronics',34.00,60,2),
('Laptop Stand','Office',29.90,35,2),
('Noise Cancelling Headphones','Electronics',119.00,20,3),
('Webcam','Electronics',49.99,30,1);

INSERT INTO Orders (order_date,total_amount,o_status,customer_id) VALUES
('2026-10-01 10:15:00',89.49,'Delivered',1),
('2026-10-03 14:30:00',34.00,'Shipped',2),
('2026-10-05 09:00:00',148.90,'Processing',3),
('2026-10-08 16:45:00',49.99,'Pending',1),
('2026-10-10 11:20:00',69.50,'Delivered',4);

INSERT INTO Order_Details (order_id,product_id,quantity,price_each) VALUES
(1,1,1,19.99),(1,2,1,69.50),
(2,3,1,34.00),
(3,4,1,29.90),(3,5,1,119.00),
(4,6,1,49.99),
(5,2,1,69.50);

INSERT INTO Transactions
(transaction_date,payment_method,amount,transaction_status,order_id) VALUES
('2026-10-01 10:20:00','Card',89.49,'Successful',1),
('2026-10-03 14:35:00','PayPal',34.00,'Successful',2),
('2026-10-05 09:05:00','Bank Transfer',148.90,'Pending',3),
('2026-10-08 16:50:00','Card',49.99,'Pending',4),
('2026-10-10 11:25:00','Card',69.50,'Successful',5);
