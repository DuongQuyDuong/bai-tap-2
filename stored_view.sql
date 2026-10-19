USE classicmodels;

-- 1. Tạo VIEW
CREATE OR REPLACE VIEW customer_views AS
SELECT customerNumber, customerName, phone
FROM customers;

-- Kiểm tra VIEW
SELECT * FROM customer_views;

-- 2. Cập nhật VIEW
CREATE OR REPLACE VIEW customer_views AS
SELECT customerNumber, customerName,
       contactFirstName, contactLastName, phone
FROM customers
WHERE city = 'Nantes';

-- Kiểm tra VIEW sau khi cập nhật
SELECT * FROM customer_views;

-- 3. Xóa VIEW
DROP VIEW IF EXISTS customer_views;

-- Kiểm tra VIEW còn tồn tại không
SHOW FULL TABLES
WHERE Table_type = 'VIEW';