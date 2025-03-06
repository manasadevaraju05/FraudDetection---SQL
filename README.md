# Fraud Detection SQL Project
## Project Overview
This project focuses on detecting potential fraudulent transactions in a financial dataset using SQL.
It involves data exploration, identifying patterns, and writing SQL queries to extract insights.
## Dataset Description
- Tables: transactions, customers, accounts
- Key Columns: transaction_id, customer_id, transaction_date, amount, transaction_type
- account_balance, customer_name, location
## Objectives
- Detect unusually large transactions.
- Identify transactions occurring at unusual times.
- Highlight customers with a high volume of transactions in a short period.
## Key SQL Concepts Used
- JOINs (INNER, LEFT)
- Aggregate functions (SUM, COUNT, AVG)
- CASE statements
- Common Table Expressions (CTEs)
- Views and Indexing
## Key SQL Queries & Examples
Detecting large transactions: sql

SELECT customer_id, amount
FROM transactions
WHERE amount > 10000;

- Unusual transaction times: sql
  
SELECT transaction_id, transaction_date
FROM transactions
WHERE HOUR(transaction_date) NOT BETWEEN 6 AND 22;

## Insights & Analysis
- Found 5% of transactions exceeding $10,000.
- Identified unusual transaction times between 2 AM to 4 AM.
## Getting Started
1. Clone the repo: git clone <repo_url>
2. Import the SQL scripts in your SQL environment.
## Technologies Used
- SQL (MySQL/PostgreSQL)
- Git & GitHub for version control

