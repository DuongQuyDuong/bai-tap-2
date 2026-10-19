
USE classicmodels;

-- 1. PROCEDURE IN
DROP PROCEDURE IF EXISTS getCusById;

DELIMITER //

CREATE PROCEDURE getCusById(IN cusNum INT)
BEGIN
    SELECT * FROM customers
    WHERE customerNumber = cusNum;
END //

DELIMITER ;

-- Kiểm tra IN
CALL getCusById(175);


-- 2. PROCEDURE OUT
DROP PROCEDURE IF EXISTS GetCustomersCountByCity;

DELIMITER //

CREATE PROCEDURE GetCustomersCountByCity(
    IN in_city VARCHAR(50),
    OUT total INT
)
BEGIN
    SELECT COUNT(customerNumber)
    INTO total
    FROM customers
    WHERE city = in_city;
END //

DELIMITER ;

-- Kiểm tra OUT
CALL GetCustomersCountByCity('Lyon', @total);
SELECT @total AS TongKhachHang;
-- 3. PROCEDURE INOUT
DROP PROCEDURE IF EXISTS SetCounter;

DELIMITER //

CREATE PROCEDURE SetCounter(
    INOUT counter INT,
    IN inc INT
)
BEGIN
    SET counter = counter + inc;
END //

DELIMITER ;

-- Kiểm tra INOUT
SET @counter = 1;

CALL SetCounter(@counter, 1);
CALL SetCounter(@counter, 1);
CALL SetCounter(@counter, 5);

SELECT @counter AS KetQua;