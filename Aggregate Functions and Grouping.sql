-- Create database  
drop database ecommerce;
CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

-- Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    address TEXT
);

-- Categories table
CREATE TABLE Categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL
);

-- Products table
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock INT DEFAULT 0,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

-- Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Order_Items table (junction table)
CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Shipping table
CREATE TABLE Shipping (
    shipping_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT UNIQUE,
    shipping_address TEXT,
    shipped_date DATETIME,
    delivery_date DATETIME,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- Payments table
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT UNIQUE,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10, 2),
    payment_method VARCHAR(50),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);
-- Insert Customers
INSERT INTO Customers (name, email, phone, address)
VALUES 
('Alice Smith', 'alice@example.com', '9876543210', '123 Main Street'),
('Bob Johnson', 'bob@example.com', NULL, '456 Oak Avenue'),
('Charlie Lee', 'charlie@example.com', '9123456789', NULL);

-- Insert Categories
INSERT INTO Categories (category_name)
VALUES ('Electronics'), ('Clothing'), ('Books');

-- Insert Products
INSERT INTO Products (product_name, price, stock, category_id)
VALUES 
('Smartphone', 25000.00, 50, 1),
('T-Shirt', 499.00, 100, 2),
('Novel', 299.00, DEFAULT, 3),
('Headphones', 1999.00, 20, NULL);  -- Product without category

-- Insert Orders
INSERT INTO Orders (customer_id, order_date, status)
VALUES 
(1, NOW(), 'Shipped'),
(2, NOW(), 'Processing'),
(3, NOW(), 'Delivered');

-- Insert Order_Items
INSERT INTO Order_Items (order_id, product_id, quantity, price)
VALUES 
(1, 1, 1, 25000.00),
(1, 4, 2, 1999.00),
(2, 2, 3, 499.00),
(3, 3, 1, 299.00);

-- Insert Shipping
INSERT INTO Shipping (order_id, shipping_address, shipped_date, delivery_date)
VALUES 
(1, '123 Main Street', '2025-06-25 10:00:00', '2025-06-27 18:00:00'),
(3, '789 Hill Street', '2025-06-24 14:00:00', '2025-06-26 16:00:00');

-- Insert Payments
INSERT INTO Payments (order_id, amount, payment_method)
VALUES 
(1, 28998.00, 'Credit Card'),
(2, 1497.00, 'Cash on Delivery'),
(3, 299.00, 'UPI');

-- Count total number of customers
SELECT COUNT(*) AS total_customers FROM Customers;

-- Count number of orders
SELECT COUNT(*) AS total_orders FROM Orders;

-- Total sales amount from all order items
SELECT SUM(price * quantity) AS total_sales FROM Order_Items;

-- Total payment collected (from Payments table)
SELECT SUM(amount) AS total_payment_received FROM Payments;

-- Average price of products per category
SELECT 
    cat.category_name,
    AVG(p.price) AS avg_price
FROM Products p
JOIN Categories cat ON p.category_id = cat.category_id
GROUP BY p.category_id;
