CREATE DATABASE Fraud_Detection;
SHOW DATABASES;
USE Fraud_Detection;

-- Create Customer Table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    city VARCHAR(30),
    status ENUM('active', 'inactive') DEFAULT 'active'
);

-- Create Cards Tables
CREATE TABLE cards (
    card_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    card_number VARCHAR(16) UNIQUE NOT NULL,
    card_type ENUM('debit', 'credit'),
    expiry_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Create transaction Table
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    card_id INT,
    transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10, 2),
    merchant VARCHAR(50),
    location VARCHAR(30),
    status ENUM('success', 'failed'),
    FOREIGN KEY (card_id) REFERENCES cards(card_id)
);

-- Create Suspicious Activity Table
CREATE TABLE suspicious_activity (
    activity_id INT PRIMARY KEY AUTO_INCREMENT,
    transaction_id INT,
    reason VARCHAR(100),
    flagged_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id)
);

SHOW TABLES;

-- Insert Sample Customers
INSERT INTO customers (name, email, phone, city)
VALUES
('Alice Brown', 'alice.b@example.com', '9876543210', 'New York'),
('Bob Smith', 'bob.s@example.com', '9876543211', 'Los Angeles'),
('Charlie Davis', 'charlie.d@example.com', '9876543212', 'Chicago');

-- Insert Sample Cards
INSERT INTO cards (customer_id, card_number, card_type, expiry_date)
VALUES
(1, '1234567890123456', 'credit', '2026-12-31'),
(2, '2345678901234567', 'debit', '2025-09-30'),
(3, '3456789012345678', 'credit', '2027-03-15');


-- Insert Sample Transactions
INSERT INTO transactions (card_id, amount, merchant, location, status)
VALUES
(1, 1200.50, 'Amazon', 'New York', 'success'),
(1, 5000.00, 'BestBuy', 'Boston', 'success'),
(2, 45.75, 'Walmart', 'Los Angeles', 'success'),
(3, 9999.99, 'Luxury Cars', 'Miami', 'success'),
(3, 15000.00, 'Jewelry Store', 'Chicago', 'success');

SELECT * FROM customers;
SELECT * FROM cards;
SELECT * FROM transactions;

-- Detect Suspicious Transactions Using Stored Procedure
-- Create a Stored Procedure to Identify Suspicious Transactions:
CREATE PROCEDURE detect_suspicious_transactions()
BEGIN
    INSERT INTO suspicious_activity (transaction_id, reason)
    SELECT transaction_id,
        CASE
            WHEN amount > 5000 THEN 'High-value transaction'
            WHEN location NOT IN ('New York', 'Los Angeles', 'Chicago') THEN 'Unusual location'
            ELSE 'Other'
        END
    FROM transactions
    WHERE amount > 5000 OR location NOT IN ('New York', 'Los Angeles', 'Chicago');
END //

DELIMITER ;

-- Execute the Procedure
CALL detect_suspicious_transactions();

SELECT * FROM suspicious_activity;

-- Create Index on transactions Table:

CREATE INDEX idx_amount_status ON transactions (amount, status);
SHOW INDEX FROM transactions;

-- Create a View for Monthly Fraud Summary

-- Create a View to Simplify Reporting:

CREATE VIEW monthly_fraud_summary AS
SELECT c.name, COUNT(sa.activity_id) AS suspicious_count
FROM customers c
JOIN cards ca ON c.customer_id = ca.customer_id
JOIN transactions t ON ca.card_id = t.card_id
LEFT JOIN suspicious_activity sa ON t.transaction_id = sa.transaction_id
GROUP BY c.customer_id;

SELECT * FROM monthly_fraud_summary;