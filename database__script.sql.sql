CREATE DATABASE  MegaStore_DB;
USE MegaStore_DB;
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(15),
    role ENUM('Admin', 'Customer') DEFAULT 'Customer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL
);
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    category_id INT,
    product_name VARCHAR(150) NOT NULL,
    price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
    stock_quantity INT DEFAULT 0,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2),
    status ENUM('Pending', 'Shipped', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('Cash', 'Credit Card', 'FonePay', 'Khalti', 'Esewa') NOT NULL,
    amount_paid DECIMAL(10, 2) NOT NULL,
    payment_status ENUM('Pending', 'Completed', 'Failed') DEFAULT 'Pending',
    transaction_id VARCHAR(100) UNIQUE,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE
);
INSERT INTO Users (full_name, email, password, phone, role) VALUES 
('Sundar Thapa', 'sundar@test.com', 'admin123', '9800000001', 'Admin'),
('Hari Kumar', 'hari@test.com', 'user123', '9800000002', 'Customer');

DELIMITER $$

CREATE PROCEDURE FinalPopulateUsers()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 500 DO
        INSERT INTO Users (full_name, email, password, phone, role)
        VALUES (
            CONCAT('Customer_', i), 
            CONCAT('user', i, '@gmail.com'), 
            'hashed_password_example', 
            CONCAT('98', FLOOR(10000000 + RAND() * 89999999)), 
            'Customer'
        );
        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;


CALL FinalPopulateUsers();
select * from Users limit 100;

INSERT INTO Categories (category_name) VALUES 
('Electronics'), 
('Mobile Phones'), 
('Laptops'), 
('Fashion'), 
('Home Appliances'), 
('Books'), 
('Groceries'), 
('Health & Beauty');

DELIMITER $$

CREATE PROCEDURE Populate500Categories()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 500 DO
        INSERT INTO Categories (category_name)
        VALUES (
            CONCAT('Category-', i) -- Category-1, Category-2, etc.
        );
        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

-- call function,
CALL Populate500Categories();
select * from Categories limit 100;

SELECT COUNT(*) FROM Categories;

INSERT INTO Products (category_id, product_name, price, stock_quantity) 
VALUES (1, 'Samsung Galaxy S23', 95000.00, 20);

DELIMITER $$

CREATE PROCEDURE Populate500Products()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 500 DO
        INSERT INTO Products (category_id, product_name, price, stock_quantity)
        VALUES (
            FLOOR(1 + (RAND() * 10)), -- Random Category (1-10)
            CONCAT('Product-', i), 
            ROUND(100 + (RAND() * 10000), 2), -- Price between 100 and 10000
            FLOOR(10 + (RAND() * 100))        -- Stock between 10 and 110
        );
        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;
CALL Populate500Products();


INSERT INTO Orders (user_id, total_amount, status) 
VALUES (1, 5500.50, 'Pending');




DELIMITER $$

CREATE PROCEDURE Populate500Orders()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 500 DO
        INSERT INTO Orders (user_id, total_amount, status)
        VALUES (
            FLOOR(1 + (RAND() * 500)), -- 1 dekhi 500 bhitra ko random User ID
            ROUND(1000 + (RAND() * 10000), 2), -- 1000 dekhi 10000 ko random amount
            ELT(FLOOR(1 + (RAND() * 4)), 'Pending', 'Shipped', 'Delivered', 'Cancelled')
        );
        SET i = i + 1;
    END WHILE;
END$$R ;
DELIMITER ;


CALL Populate500Orders();




CALL Populate500OrderItems();

INSERT INTO Payments (order_id, payment_method, amount_paid, payment_status, transaction_id) 
VALUES (1, 'Khalti', 95000.00, 'Completed', 'KH-123456');

DELIMITER $$

CREATE PROCEDURE Populate500Payments()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 500 DO
        INSERT INTO Payments (order_id, payment_method, amount_paid, payment_status, transaction_id)
        VALUES (
            i, 
            ELT(FLOOR(1 + (RAND() * 5)), 'Cash', 'Credit Card', 'FonePay', 'Khalti', 'Esewa'), 
            ROUND(500 + (RAND() * 5000), 2), 
            'Completed',
            CONCAT('TXN-', UUID_SHORT()) -- Unique Transaction ID
        );
        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

CALL Populate500Payments();

SELECT COUNT(*) FROM products;


SELECT COUNT(*) FROM payments;
SELECT COUNT(*) FROM Order_Items;


DROP PROCEDURE IF EXISTS Populate500Payments;
INSERT INTO Order_Items (order_id, product_id, quantity, unit_price) 
VALUES (1, 1, 1, 95000.00);

DELIMITER $$

CREATE PROCEDURE Populate500Payments()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 500 DO
        INSERT INTO Payments (order_id, payment_method, amount_paid, payment_status, transaction_id)
        VALUES (
            -- Yesle 1 dekhi 859 bhitra ko eauta random Order ID select garchha
            FLOOR(1 + (RAND() * 858)), 
            ELT(FLOOR(1 + (RAND() * 3)), 'Esewa', 'Khalti', 'Cash'), 
            ROUND(500 + (RAND() * 2000), 2), 
            'Completed',
            CONCAT('TXN-', UUID_SHORT())
        );
        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

CALL Populate500Payments();
DROP PROCEDURE IF EXISTS Populate500OrderItems;

CALL Populate500OrderItems();
INSERT INTO Order_Items (order_id, product_id, quantity, unit_price) 
VALUES (1, 1, 1, 95000.00);

DELIMITER $$

CREATE PROCEDURE Populate500OrderItems()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 500 DO
        INSERT INTO Order_Items (order_id, product_id, quantity, unit_price)
        VALUES (
            FLOOR(1 + (RAND() * 858)),  -- Tapaiko 859 ota order matching range
            FLOOR(1 + (RAND() * 1501)), -- Tapaiko 1502 ota product matching range
            FLOOR(1 + (RAND() * 5)), 
            ROUND(100 + (RAND() * 5000), 2)
        );
        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;
CALL Populate500OrderItems();
-- join table
SELECT 
    U.full_name AS Customer_Name,
    O.order_id,
    O.total_amount AS Order_Value,
    P.payment_method,
    P.payment_status
FROM Users U
JOIN Orders O ON U.user_id = O.user_id
JOIN Payments P ON O.order_id = P.order_id
LIMIT 100;


-- Query: Identify Duplicate Users by Email
-- Purpose: To find accounts that might have been registered multiple times with the same email.

SELECT email, COUNT(*) as occurrence 
FROM Users 
GROUP BY email 
HAVING occurrence > 1;

-- Query: Delete Duplicate Entries (Keep only the latest one)
-- Skills: Using Self-Join for Data Cleaning.
DELETE u1 FROM Users u1
INNER JOIN Users u2 
WHERE u1.user_id < u2.user_id AND u1.email = u2.email;  


-- Query: Seasonal Price Update (Bulk Update)
-- Purpose: To increase the price of all products in a specific category (e.g., Electronics) by 5% for a sale.
-- Skills: Mathematical operations in Update statements.

UPDATE Products 
SET price = price * 1.05 
WHERE category_id = (SELECT category_id FROM Categories WHERE category_name = 'Electronics');

-- Query: Stock replenishment (Inventory Update)
-- Purpose: To add 50 units of stock to products that are nearly sold out.

UPDATE Products 
SET stock_quantity = stock_quantity + 50 
WHERE stock_quantity < 5;



-- Query: Calculate Total Revenue per Category
-- Purpose: To identify which product categories are generating the most income.
-- Skills: Multi-table Joins, Aggregation (SUM), Grouping.

SELECT 
    c.category_name AS 'Category', 
    COUNT(oi.order_item_id) AS 'Items_Sold', 
    SUM(oi.quantity * oi.unit_price) AS 'Total_Revenue'
FROM Categories c
JOIN Products p ON c.category_id = p.category_id
JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY c.category_name
ORDER BY Total_Revenue DESC;

-- Query: Identify Top 5 High-Spending Customers
-- Purpose: Marketing analysis to find loyal customers for potential rewards/discounts.
-- Skills: Data Filtering, Sorting (DESC), Limit.

SELECT 
    u.full_name AS 'Customer', 
    SUM(o.total_amount) AS 'Total_Spent'
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.full_name
ORDER BY Total_Spent DESC
LIMIT 5;

-- Query: Low Stock Inventory Alert
-- Purpose: To provide a list of products that need restocking immediately.
-- Business Logic: Threshold set to less than 10 units.

SELECT 
    product_name, 
    stock_quantity 
FROM Products 
WHERE stock_quantity < 10 
ORDER BY stock_quantity ASC;

-- Query: Most Preferred Payment Methods
-- Purpose: To understand customer payment behavior and gateway popularity.

SELECT 
    payment_method, 
    COUNT(*) AS 'Transactions'
FROM Payments 
GROUP BY payment_method 
ORDER BY Transactions DESC;


-- Query: Order Status Distribution
-- Purpose: To monitor business operations and track pending vs delivered shipments.
-- Skills: Counting and Categorical grouping.

SELECT 
    status, 
    COUNT(*) AS 'Total_Orders'
FROM Orders 
GROUP BY status;


-- Query: Top 5 Products by Sales Volume
-- Purpose: To identify high-demand products based on quantity sold.
-- Skills: Joins, SUM on Quantity.

SELECT 
    p.product_name, 
    SUM(oi.quantity) AS 'Units_Sold'
FROM Products p
JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY Units_Sold DESC
LIMIT 5;


-- Query: Monthly Sales Performance
-- Purpose: To track revenue growth month-over-month.
-- Skills: DATE_FORMAT, SUM, Grouping by Time.

SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS 'Month', 
    COUNT(order_id) AS 'Total_Orders', 
    SUM(total_amount) AS 'Monthly_Revenue'
FROM Orders
GROUP BY Month
ORDER BY Month DESC;

-- Query: Create a Business Dashboard View
-- Purpose: To simplify complex joins into a single readable table for managers.
-- Skills: Database Objects (VIEW).

CREATE VIEW Sales_Dashboard AS
SELECT 
    o.order_id, 
    u.full_name AS 'Customer', 
    p.product_name, 
    oi.quantity, 
    (oi.quantity * oi.unit_price) AS 'Subtotal',
    o.order_date
FROM Orders o
JOIN Users u ON o.user_id = u.user_id
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id;

-- you can view data--
 SELECT * FROM Sales_Dashboard;



