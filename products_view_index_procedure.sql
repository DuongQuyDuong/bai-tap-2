-- BAI THUC HANH: VIEW, INDEX, STORED PROCEDURE (MySQL 8.0)
-- Chay toan bo script tren MySQL Workbench.
-- CHU Y: Script tao lai bang Products va xoa du lieu cu trong database demo.

CREATE DATABASE IF NOT EXISTS demo;
USE demo;

-- 1. TAO BANG VA DU LIEU MAU
DROP TABLE IF EXISTS Products;
CREATE TABLE Products (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    productCode VARCHAR(30) NOT NULL,
    productName VARCHAR(100) NOT NULL,
    productPrice DECIMAL(12,2) NOT NULL,
    productAmount INT NOT NULL,
    productDescription TEXT,
    productStatus VARCHAR(30) NOT NULL
);

INSERT INTO Products (productCode, productName, productPrice, productAmount, productDescription, productStatus) VALUES
('P001', 'Laptop Lenovo', 18000000, 10, 'Laptop van phong va hoc tap', 'AVAILABLE'),
('P002', 'Chuot Logitech', 350000, 45, 'Chuot khong day', 'AVAILABLE'),
('P003', 'Ban phim co', 1200000, 20, 'Ban phim co RGB', 'AVAILABLE'),
('P004', 'Man hinh Dell', 4200000, 12, 'Man hinh 24 inch', 'AVAILABLE'),
('P005', 'Tai nghe Sony', 1500000, 18, 'Tai nghe chong on', 'AVAILABLE'),
('P006', 'Laptop Asus', 21000000, 8, 'Laptop cho lap trinh', 'AVAILABLE'),
('P007', 'Chuot Razer', 990000, 13, 'Chuot gaming', 'AVAILABLE'),
('P008', 'Webcam Logitech', 1350000, 7, 'Webcam Full HD', 'AVAILABLE'),
('P009', 'Loa Bluetooth', 800000, 0, 'Loa di dong', 'OUT_OF_STOCK'),
('P010', 'SSD Samsung', 1750000, 23, 'SSD 1TB', 'AVAILABLE');

-- 2. EXPLAIN TRUOC KHI TAO INDEX
EXPLAIN SELECT * FROM Products WHERE productCode = 'P003';
EXPLAIN SELECT * FROM Products WHERE productName = 'Laptop Lenovo' AND productPrice = 18000000;

-- 3. TAO INDEX
CREATE UNIQUE INDEX idx_product_code ON Products(productCode);
CREATE INDEX idx_product_name_price ON Products(productName, productPrice);

-- EXPLAIN SAU KHI TAO INDEX: so sanh possible_keys, key, type, rows
EXPLAIN SELECT * FROM Products WHERE productCode = 'P003';
EXPLAIN SELECT * FROM Products WHERE productName = 'Laptop Lenovo' AND productPrice = 18000000;
SHOW INDEX FROM Products;
-- Luu y: Bang chi co 10 dong nen MySQL co the van chon full table scan.

-- 4. VIEW: TAO, SUA, XEM VA XOA
CREATE OR REPLACE VIEW product_view AS
SELECT productCode, productName, productPrice, productStatus
FROM Products;
SELECT * FROM product_view;

CREATE OR REPLACE VIEW product_view AS
SELECT productCode, productName, productPrice, productStatus
FROM Products
WHERE productStatus = 'AVAILABLE';
SELECT * FROM product_view;

DROP VIEW IF EXISTS product_view;

-- 5. STORED PROCEDURES: GET ALL, INSERT, UPDATE, DELETE
DROP PROCEDURE IF EXISTS sp_get_all_products;
DROP PROCEDURE IF EXISTS sp_add_product;
DROP PROCEDURE IF EXISTS sp_update_product;
DROP PROCEDURE IF EXISTS sp_delete_product;

DELIMITER //
CREATE PROCEDURE sp_get_all_products()
BEGIN
    SELECT * FROM Products ORDER BY Id;
END //

CREATE PROCEDURE sp_add_product(
    IN p_code VARCHAR(30),
    IN p_name VARCHAR(100),
    IN p_price DECIMAL(12,2),
    IN p_amount INT,
    IN p_description TEXT,
    IN p_status VARCHAR(30)
)
BEGIN
    INSERT INTO Products(productCode, productName, productPrice, productAmount, productDescription, productStatus)
    VALUES(p_code, p_name, p_price, p_amount, p_description, p_status);
END //

CREATE PROCEDURE sp_update_product(
    IN p_id INT,
    IN p_code VARCHAR(30),
    IN p_name VARCHAR(100),
    IN p_price DECIMAL(12,2),
    IN p_amount INT,
    IN p_description TEXT,
    IN p_status VARCHAR(30)
)
BEGIN
    UPDATE Products
    SET productCode = p_code,
        productName = p_name,
        productPrice = p_price,
        productAmount = p_amount,
        productDescription = p_description,
        productStatus = p_status
    WHERE Id = p_id;
END //

CREATE PROCEDURE sp_delete_product(IN p_id INT)
BEGIN
    DELETE FROM Products WHERE Id = p_id;
END //
DELIMITER ;

-- 6. KIEM TRA CAC PROCEDURE
CALL sp_get_all_products();
CALL sp_add_product('P011', 'USB Kingston', 250000, 30, 'USB 64GB', 'AVAILABLE');
SELECT * FROM Products WHERE productCode = 'P011';

-- Tim Id dua tren productCode de tranh phu thuoc AUTO_INCREMENT
SET @new_product_id = (SELECT Id FROM Products WHERE productCode = 'P011');
CALL sp_update_product(@new_product_id, 'P011', 'USB Kingston 128GB', 390000, 25, 'USB 128GB', 'AVAILABLE');
SELECT * FROM Products WHERE Id = @new_product_id;
CALL sp_delete_product(@new_product_id);
SELECT * FROM Products WHERE productCode = 'P011';
CALL sp_get_all_products();
