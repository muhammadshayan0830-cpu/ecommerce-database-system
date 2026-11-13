-- B103 E-commerce Database System
-- MySQL 8.0.16+ recommended (CHECK constraints are enforced from 8.0.16).
-- This script rebuilds the project schema. BACK UP any existing ecommerce_gisma
-- database before running it: DROP DATABASE permanently removes its contents.

DROP DATABASE IF EXISTS ecommerce_gisma;
CREATE DATABASE ecommerce_gisma
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;
USE ecommerce_gisma;

CREATE TABLE Customers (
    customer_id INT UNSIGNED AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(254) NOT NULL,
    phone_number VARCHAR(25),
    registration_date DATE NOT NULL,
    country VARCHAR(60) NOT NULL,
    PRIMARY KEY (customer_id),
    CONSTRAINT uq_customers_email UNIQUE (email),
    INDEX idx_customers_country (country)
) ENGINE=InnoDB;

CREATE TABLE Suppliers (
    supplier_id INT UNSIGNED AUTO_INCREMENT,
    supplier_name VARCHAR(120) NOT NULL,
    contact_name VARCHAR(100),
    phone VARCHAR(25),
    country VARCHAR(60) NOT NULL,
    PRIMARY KEY (supplier_id),
    INDEX idx_suppliers_name (supplier_name)
) ENGINE=InnoDB;

CREATE TABLE Products (
    product_id INT UNSIGNED AUTO_INCREMENT,
    product_name VARCHAR(120) NOT NULL,
    category VARCHAR(60) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT UNSIGNED NOT NULL DEFAULT 0,
    supplier_id INT UNSIGNED NOT NULL,
    PRIMARY KEY (product_id),
    CONSTRAINT chk_products_price CHECK (price >= 0),
    CONSTRAINT fk_products_supplier
      FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
      ON UPDATE CASCADE ON DELETE RESTRICT,
    INDEX idx_products_category (category),
    INDEX idx_products_supplier (supplier_id)
) ENGINE=InnoDB;

CREATE TABLE Orders (
    order_id INT UNSIGNED AUTO_INCREMENT,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    o_status ENUM('Pending','Processing','Shipped','Delivered','Cancelled')
      NOT NULL DEFAULT 'Pending',
    customer_id INT UNSIGNED NOT NULL,
    PRIMARY KEY (order_id),
    CONSTRAINT chk_orders_total CHECK (total_amount >= 0),
    CONSTRAINT fk_orders_customer
      FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
      ON UPDATE CASCADE ON DELETE RESTRICT,
    INDEX idx_orders_customer_date (customer_id, order_date),
    INDEX idx_orders_status (o_status)
) ENGINE=InnoDB;

CREATE TABLE Order_Details (
    order_detail_id INT UNSIGNED AUTO_INCREMENT,
    order_id INT UNSIGNED NOT NULL,
    product_id INT UNSIGNED NOT NULL,
    quantity INT UNSIGNED NOT NULL,
    price_each DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (order_detail_id),
    CONSTRAINT chk_order_details_quantity CHECK (quantity > 0),
    CONSTRAINT chk_order_details_price CHECK (price_each >= 0),
    CONSTRAINT uq_order_product UNIQUE (order_id, product_id),
    CONSTRAINT fk_order_details_order
      FOREIGN KEY (order_id) REFERENCES Orders(order_id)
      ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_order_details_product
      FOREIGN KEY (product_id) REFERENCES Products(product_id)
      ON UPDATE CASCADE ON DELETE RESTRICT,
    INDEX idx_order_details_product (product_id)
) ENGINE=InnoDB;

CREATE TABLE Transactions (
    transaction_id INT UNSIGNED AUTO_INCREMENT,
    transaction_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('Card','PayPal','Bank Transfer','Cash on Delivery')
      NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    transaction_status ENUM('Pending','Successful','Failed','Refunded')
      NOT NULL DEFAULT 'Pending',
    order_id INT UNSIGNED NOT NULL,
    PRIMARY KEY (transaction_id),
    CONSTRAINT chk_transactions_amount CHECK (amount >= 0),
    CONSTRAINT fk_transactions_order
      FOREIGN KEY (order_id) REFERENCES Orders(order_id)
      ON UPDATE CASCADE ON DELETE RESTRICT,
    INDEX idx_transactions_order (order_id),
    INDEX idx_transactions_date (transaction_date)
) ENGINE=InnoDB;

-- End of schema creation.
