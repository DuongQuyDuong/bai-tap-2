
-- 1. Tạo database
CREATE DATABASE IF NOT EXISTS company;
USE company;

-- 2. Tạo bảng employees
CREATE TABLE IF NOT EXISTS employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    department VARCHAR(50) NOT NULL,
    salary DECIMAL(10,2) NOT NULL
);

-- 3. Xóa trigger cũ nếu đã tồn tại
DROP TRIGGER IF EXISTS update_department;

-- 4. Tạo Trigger
DELIMITER //

CREATE TRIGGER update_department
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary >= 5000 THEN
        SET NEW.department = 'Management';
    ELSEIF NEW.salary >= 3000 THEN
        SET NEW.department = 'Sales';
    ELSE
        SET NEW.department = 'Support';
    END IF;
END //

DELIMITER ;

-- 5. Xóa dữ liệu demo cũ để tránh trùng
TRUNCATE TABLE employees;

-- 6. Thêm dữ liệu nhân viên
INSERT INTO employees (name, department, salary)
VALUES
    ('John Doe', 'A', 3500),
    ('Jane Smith', 'A', 2000),
    ('David Johnson', 'A', 6000);

-- 7. Xem kết quả
SELECT * FROM employees;

-- 8. Kiểm tra trigger
SHOW TRIGGERS FROM company;
