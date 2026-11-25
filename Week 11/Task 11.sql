CREATE DATABASE Amazon_Ecommerce_DB;
USE Amazon_Ecommerce_DB;

CREATE TABLE customer (
    Customer_ID INT AUTO_INCREMENT PRIMARY KEY,
    Customer_Name VARCHAR(100) NOT NULL,
    Email VARCHAR(150) NOT NULL UNIQUE,
    Phone VARCHAR(15),
    Password VARCHAR(255) NOT NULL,
    Registration_Date DATE NOT NULL
);

CREATE TABLE seller (
    Seller_ID INT AUTO_INCREMENT PRIMARY KEY,
    Seller_Name VARCHAR(100) NOT NULL,
    Email VARCHAR(150) NOT NULL UNIQUE,
    Phone VARCHAR(15),
    Business_Name VARCHAR(150) NOT NULL,
    Address VARCHAR(255)
);

CREATE TABLE category (
    Category_ID INT AUTO_INCREMENT PRIMARY KEY,
    Category_Name VARCHAR(100) NOT NULL UNIQUE,
    Description VARCHAR(255)
);

CREATE TABLE address (
    Address_ID INT AUTO_INCREMENT PRIMARY KEY,
    Customer_ID INT NOT NULL,
    House_No VARCHAR(30),
    Street VARCHAR(120) NOT NULL,
    City VARCHAR(80) NOT NULL,
    State VARCHAR(80) NOT NULL,
    Pincode VARCHAR(10) NOT NULL,
    CONSTRAINT fk_address_customer
        FOREIGN KEY (Customer_ID) REFERENCES customer(Customer_ID)
);

CREATE TABLE delivery_partner (
    Delivery_Partner_ID INT AUTO_INCREMENT PRIMARY KEY,
    Partner_Name VARCHAR(100) NOT NULL,
    Phone VARCHAR(15),
    Company_Name VARCHAR(120) NOT NULL
);

CREATE TABLE product (
    Product_ID INT AUTO_INCREMENT PRIMARY KEY,
    Product_Name VARCHAR(150) NOT NULL,
    Description TEXT,
    Price DECIMAL(10,2) NOT NULL,
    Category_ID INT NOT NULL,
    Seller_ID INT NOT NULL,
    CONSTRAINT chk_product_price CHECK (Price >= 0),
    CONSTRAINT fk_product_category
        FOREIGN KEY (Category_ID) REFERENCES category(Category_ID),
    CONSTRAINT fk_product_seller
        FOREIGN KEY (Seller_ID) REFERENCES seller(Seller_ID)
);

CREATE TABLE shopping_cart (
    Cart_ID INT AUTO_INCREMENT PRIMARY KEY,
    Customer_ID INT NOT NULL UNIQUE,
    Created_Date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Cart_Status VARCHAR(20) NOT NULL DEFAULT 'Active',
    CONSTRAINT fk_cart_customer
        FOREIGN KEY (Customer_ID) REFERENCES customer(Customer_ID)
);

CREATE TABLE cart_items (
    Cart_Item_ID INT AUTO_INCREMENT PRIMARY KEY,
    Cart_ID INT NOT NULL,
    Product_ID INT NOT NULL,
    Quantity INT NOT NULL,
    Subtotal DECIMAL(10,2) NOT NULL,
    CONSTRAINT chk_cart_item_quantity CHECK (Quantity > 0),
    CONSTRAINT chk_cart_item_subtotal CHECK (Subtotal >= 0),
    CONSTRAINT uq_cart_product UNIQUE (Cart_ID, Product_ID),
    CONSTRAINT fk_cart_items_cart
        FOREIGN KEY (Cart_ID) REFERENCES shopping_cart(Cart_ID),
    CONSTRAINT fk_cart_items_product
        FOREIGN KEY (Product_ID) REFERENCES product(Product_ID)
);

CREATE TABLE orders (
    Order_ID INT AUTO_INCREMENT PRIMARY KEY,
    Customer_ID INT NOT NULL,
    Order_Date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Total_Amount DECIMAL(12,2) NOT NULL,
    Order_Status VARCHAR(30) NOT NULL DEFAULT 'Pending',
    Delivery_Address_ID INT NOT NULL,
    CONSTRAINT chk_order_total CHECK (Total_Amount >= 0),
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (Customer_ID) REFERENCES customer(Customer_ID),
    CONSTRAINT fk_orders_address
        FOREIGN KEY (Delivery_Address_ID) REFERENCES address(Address_ID)
);

CREATE TABLE order_details (
    Order_Detail_ID INT AUTO_INCREMENT PRIMARY KEY,
    Order_ID INT NOT NULL,
    Product_ID INT NOT NULL,
    Quantity INT NOT NULL,
    Unit_Price DECIMAL(10,2) NOT NULL,
    Subtotal DECIMAL(12,2) NOT NULL,
    CONSTRAINT chk_order_detail_quantity CHECK (Quantity > 0),
    CONSTRAINT chk_order_detail_price CHECK (Unit_Price >= 0),
    CONSTRAINT chk_order_detail_subtotal CHECK (Subtotal >= 0),
    CONSTRAINT uq_order_product UNIQUE (Order_ID, Product_ID),
    CONSTRAINT fk_order_details_order
        FOREIGN KEY (Order_ID) REFERENCES orders(Order_ID),
    CONSTRAINT fk_order_details_product
        FOREIGN KEY (Product_ID) REFERENCES product(Product_ID)
);

CREATE TABLE payment (
    Payment_ID INT AUTO_INCREMENT PRIMARY KEY,
    Order_ID INT NOT NULL,
    Payment_Method VARCHAR(30) NOT NULL,
    Payment_Date DATETIME,
    Amount DECIMAL(12,2) NOT NULL,
    Payment_Status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    Transaction_ID VARCHAR(100) UNIQUE,
    CONSTRAINT chk_payment_amount CHECK (Amount >= 0),
    CONSTRAINT fk_payment_order
        FOREIGN KEY (Order_ID) REFERENCES orders(Order_ID)
);

CREATE TABLE delivery (
    Delivery_ID INT AUTO_INCREMENT PRIMARY KEY,
    Order_ID INT NOT NULL,
    Delivery_Partner_ID INT NOT NULL,
    Tracking_Number VARCHAR(100) NOT NULL UNIQUE,
    Shipping_Date DATE,
    Expected_Delivery_Date DATE,
    Actual_Delivery_Date DATE,
    Delivery_Status VARCHAR(30) NOT NULL DEFAULT 'Preparing',
    CONSTRAINT fk_delivery_order
        FOREIGN KEY (Order_ID) REFERENCES orders(Order_ID),
    CONSTRAINT fk_delivery_partner
        FOREIGN KEY (Delivery_Partner_ID)
        REFERENCES delivery_partner(Delivery_Partner_ID)
);
-- up Task 3 -- 

INSERT INTO customer
(Customer_ID, Customer_Name, Email, Phone, Password, Registration_Date)
VALUES
(1, 'Arun Kumar', 'arun@example.com', '9876543210', 'demo_hash_001', '2026-01-10'),
(2, 'Priya Devi', 'priya@example.com', '9876543211', 'demo_hash_002', '2026-01-12'),
(3, 'Rahul Raj', 'rahul@example.com', '9876543212', 'demo_hash_003', '2026-01-15'),
(4, 'Meena S', 'meena@example.com', '9876543213', 'demo_hash_004', '2026-01-20'),
(5, 'Karthik M', 'karthik@example.com', '9876543214', 'demo_hash_005', '2026-02-01');

INSERT INTO seller
(Seller_ID, Seller_Name, Email, Phone, Business_Name, Address)
VALUES
(1, 'Tech World', 'techworld@example.com', '9000011111', 'Tech World Electronics', 'Coimbatore'),
(2, 'Home Needs', 'homeneeds@example.com', '9000022222', 'Home Needs Store', 'Chennai'),
(3, 'Book Point', 'bookpoint@example.com', '9000033333', 'Book Point', 'Madurai');

INSERT INTO category
(Category_ID, Category_Name, Description)
VALUES
(1, 'Electronics', 'Electronic devices and accessories'),
(2, 'Home Appliances', 'Products for home use'),
(3, 'Books', 'Educational and general books');

INSERT INTO address
(Address_ID, Customer_ID, House_No, Street, City, State, Pincode)
VALUES
(1, 1, '12A', 'Main Road', 'Thoothukudi', 'Tamil Nadu', '628001'),
(2, 2, '24B', 'Gandhi Street', 'Coimbatore', 'Tamil Nadu', '641001'),
(3, 3, '8', 'Beach Road', 'Chennai', 'Tamil Nadu', '600001'),
(4, 4, '17C', 'Market Street', 'Madurai', 'Tamil Nadu', '625001'),
(5, 5, '5A', 'North Street', 'Tirunelveli', 'Tamil Nadu', '627001');

INSERT INTO delivery_partner
(Delivery_Partner_ID, Partner_Name, Phone, Company_Name)
VALUES
(1, 'Ravi Kumar', '9111100001', 'FastTrack Logistics'),
(2, 'Suresh M', '9111100002', 'SafeShip Couriers'),
(3, 'Vijay R', '9111100003', 'Quick Delivery Services');

INSERT INTO product
(Product_ID, Product_Name, Description, Price, Category_ID, Seller_ID)
VALUES
(1, 'Wireless Mouse', 'USB wireless optical mouse', 599.00, 1, 1),
(2, 'Bluetooth Headphones', 'Over-ear Bluetooth headphones', 1499.00, 1, 1),
(3, 'Electric Kettle', '1.5 litre electric kettle', 1199.00, 2, 2),
(4, 'Mixer Grinder', 'Three-jar mixer grinder', 2499.00, 2, 2),
(5, 'DBMS Fundamentals', 'Database Management Systems textbook', 650.00, 3, 3),
(6, 'SQL for Beginners', 'Introduction to SQL programming', 450.00, 3, 3);

INSERT INTO shopping_cart
(Cart_ID, Customer_ID, Created_Date, Cart_Status)
VALUES
(1, 1, '2026-02-10 10:00:00', 'Checked Out'),
(2, 2, '2026-02-11 11:30:00', 'Active'),
(3, 3, '2026-02-12 09:15:00', 'Checked Out'),
(4, 4, '2026-02-13 14:20:00', 'Active'),
(5, 5, '2026-02-14 16:45:00', 'Checked Out');

INSERT INTO cart_items
(Cart_Item_ID, Cart_ID, Product_ID, Quantity, Subtotal)
VALUES
(1, 1, 1, 2, 1198.00),
(2, 1, 2, 1, 1499.00),
(3, 2, 3, 1, 1199.00),
(4, 3, 5, 2, 1300.00),
(5, 4, 4, 1, 2499.00),
(6, 5, 6, 2, 900.00);

INSERT INTO orders
(Order_ID, Customer_ID, Order_Date, Total_Amount, Order_Status, Delivery_Address_ID)
VALUES
(1, 1, '2026-02-15 10:30:00', 2697.00, 'Delivered', 1),
(2, 2, '2026-02-16 12:00:00', 1199.00, 'Shipped', 2),
(3, 3, '2026-02-17 15:45:00', 1300.00, 'Confirmed', 3),
(4, 5, '2026-02-18 09:20:00', 900.00, 'Pending', 5);

INSERT INTO order_details
(Order_Detail_ID, Order_ID, Product_ID, Quantity, Unit_Price, Subtotal)
VALUES
(1, 1, 1, 2, 599.00, 1198.00),
(2, 1, 2, 1, 1499.00, 1499.00),
(3, 2, 3, 1, 1199.00, 1199.00),
(4, 3, 5, 2, 650.00, 1300.00),
(5, 4, 6, 2, 450.00, 900.00);

INSERT INTO payment
(Payment_ID, Order_ID, Payment_Method, Payment_Date, Amount, Payment_Status, Transaction_ID)
VALUES
(1, 1, 'UPI', '2026-02-15 10:35:00', 2697.00, 'Successful', 'TXN-AMZ-1001'),
(2, 2, 'Credit Card', '2026-02-16 12:05:00', 1199.00, 'Successful', 'TXN-AMZ-1002'),
(3, 3, 'Net Banking', '2026-02-17 15:50:00', 1300.00, 'Successful', 'TXN-AMZ-1003'),
(4, 4, 'UPI', '2026-02-18 09:25:00', 900.00, 'Pending', 'TXN-AMZ-1004');

INSERT INTO delivery
(Delivery_ID, Order_ID, Delivery_Partner_ID, Tracking_Number,
 Shipping_Date, Expected_Delivery_Date, Actual_Delivery_Date, Delivery_Status)
VALUES
(1, 1, 1, 'AMZ-TRK-1001', '2026-02-15', '2026-02-18', '2026-02-17', 'Delivered'),
(2, 2, 2, 'AMZ-TRK-1002', '2026-02-17', '2026-02-20', NULL, 'In Transit'),
(3, 3, 3, 'AMZ-TRK-1003', NULL, '2026-02-22', NULL, 'Preparing'),
(4, 4, 1, 'AMZ-TRK-1004', NULL, '2026-02-23', NULL, 'Preparing');

SELECT 'customer' AS Table_Name, COUNT(*) AS Total_Records FROM customer
UNION ALL
SELECT 'seller', COUNT(*) FROM seller
UNION ALL
SELECT 'category', COUNT(*) FROM category
UNION ALL
SELECT 'address', COUNT(*) FROM address
UNION ALL
SELECT 'delivery_partner', COUNT(*) FROM delivery_partner
UNION ALL
SELECT 'product', COUNT(*) FROM product
UNION ALL
SELECT 'shopping_cart', COUNT(*) FROM shopping_cart
UNION ALL
SELECT 'cart_items', COUNT(*) FROM cart_items
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_details', COUNT(*) FROM order_details
UNION ALL
SELECT 'payment', COUNT(*) FROM payment
UNION ALL
SELECT 'delivery', COUNT(*) FROM delivery;

SELECT Customer_ID, Customer_Name, Email, Phone, Registration_Date
FROM customer
ORDER BY Customer_ID;

SELECT Seller_ID, Seller_Name, Email, Business_Name, Phone
FROM seller
ORDER BY Seller_ID;

SELECT Category_ID, Category_Name, Description
FROM category
ORDER BY Category_ID;

SELECT Address_ID, Customer_ID, House_No, Street, City, State, Pincode
FROM address
ORDER BY Address_ID;

SELECT Delivery_Partner_ID, Partner_Name, Phone, Company_Name
FROM delivery_partner
ORDER BY Delivery_Partner_ID;

SELECT Product_ID, Product_Name, Price, Category_ID, Seller_ID
FROM product
ORDER BY Product_ID;

SELECT Cart_ID, Customer_ID, Created_Date, Cart_Status
FROM shopping_cart
ORDER BY Cart_ID;

SELECT Cart_ID, Product_ID, Quantity, Subtotal
FROM cart_items
ORDER BY Cart_ID, Product_ID;

SELECT Order_ID, Customer_ID, Order_Date, Total_Amount, Order_Status, Delivery_Address_ID
FROM orders
ORDER BY Order_ID;

SELECT Order_Detail_ID, Order_ID, Product_ID, Quantity, Unit_Price, Subtotal
FROM order_details
ORDER BY Order_ID, Product_ID;

SELECT Payment_ID, Order_ID, Payment_Method, Payment_Date, Amount, Payment_Status, Transaction_ID
FROM payment
ORDER BY Payment_ID;

SELECT Delivery_ID, Tracking_Number, Order_ID, Delivery_Partner_ID, Delivery_Status
FROM delivery
ORDER BY Delivery_ID;

SELECT c.Customer_ID, c.Customer_Name, c.Email,
       o.Order_ID, o.Order_Date, o.Total_Amount, o.Order_Status
FROM customer c
LEFT JOIN orders o ON c.Customer_ID = o.Customer_ID
ORDER BY c.Customer_ID, o.Order_ID;

SELECT p.Product_ID, p.Product_Name, p.Price,
       c.Category_Name, s.Seller_Name, s.Business_Name
FROM product p
JOIN category c ON p.Category_ID = c.Category_ID
JOIN seller s ON p.Seller_ID = s.Seller_ID
ORDER BY p.Product_ID;

SELECT o.Order_ID, c.Customer_Name,
       a.Street, a.City, a.State, a.Pincode
FROM orders o
JOIN customer c ON o.Customer_ID = c.Customer_ID
JOIN address a ON o.Delivery_Address_ID = a.Address_ID
ORDER BY o.Order_ID;

SELECT d.Delivery_ID, d.Tracking_Number, d.Delivery_Status,
       dp.Partner_Name, dp.Company_Name, dp.Phone
FROM delivery d
JOIN delivery_partner dp
  ON d.Delivery_Partner_ID = dp.Delivery_Partner_ID
ORDER BY d.Delivery_ID;

SELECT s.Seller_ID, s.Seller_Name, s.Business_Name,
       COUNT(p.Product_ID) AS Number_Of_Products
FROM seller s
LEFT JOIN product p ON s.Seller_ID = p.Seller_ID
GROUP BY s.Seller_ID, s.Seller_Name, s.Business_Name
ORDER BY s.Seller_ID;

SELECT s.Seller_ID, s.Seller_Name, s.Phone,
       p.Product_ID, p.Product_Name
FROM seller s
LEFT JOIN product p ON s.Seller_ID = p.Seller_ID
ORDER BY s.Seller_ID, p.Product_ID;

SELECT Seller_ID, Seller_Name, Business_Name
FROM seller
ORDER BY Seller_ID;

SELECT o.Order_ID,
       o.Total_Amount AS Stored_Order_Total,
       COALESCE(SUM(od.Subtotal), 0) AS Calculated_Order_Total
FROM orders o
LEFT JOIN order_details od ON o.Order_ID = od.Order_ID
GROUP BY o.Order_ID, o.Total_Amount
ORDER BY o.Order_ID;

SELECT ci.Cart_Item_ID, ci.Cart_ID, ci.Product_ID,
       ci.Quantity, p.Price,
       ci.Subtotal AS Stored_Subtotal,
       (ci.Quantity * p.Price) AS Calculated_Subtotal
FROM cart_items ci
JOIN product p ON ci.Product_ID = p.Product_ID
ORDER BY ci.Cart_Item_ID;

SELECT Email, COUNT(*) AS Occurrences
FROM customer
GROUP BY Email
HAVING COUNT(*) > 1;

SELECT Cart_ID, Product_ID, COUNT(*) AS Occurrences
FROM cart_items
GROUP BY Cart_ID, Product_ID
HAVING COUNT(*) > 1;

SELECT Order_ID, Product_ID, COUNT(*) AS Occurrences
FROM order_details
GROUP BY Order_ID, Product_ID
HAVING COUNT(*) > 1;

-- up Task 4 -- 

SHOW TABLES;

SELECT Order_ID, Product_ID, Quantity
FROM order_details
ORDER BY Order_ID, Product_ID;

SELECT Cart_ID, Product_ID, Quantity
FROM cart_items
ORDER BY Cart_ID, Product_ID;

SELECT Order_ID, Customer_ID, Order_Date, Total_Amount
FROM orders
ORDER BY Order_ID;

SELECT Product_ID, Product_Name, Price, Category_ID, Seller_ID
FROM product
ORDER BY Product_ID;

SELECT Order_ID, Product_ID, Quantity, Unit_Price, Subtotal
FROM order_details
ORDER BY Order_ID, Product_ID;

SHOW INDEX FROM order_details;

SELECT o.Order_ID, o.Order_Date, p.Product_Name, od.Quantity, od.Unit_Price
FROM orders AS o
JOIN order_details AS od ON o.Order_ID = od.Order_ID
JOIN product AS p ON p.Product_ID = od.Product_ID
ORDER BY o.Order_ID, p.Product_ID;

-- up Task 5 -- 

SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = DATABASE() AND CONSTRAINT_TYPE IN ('PRIMARY KEY','UNIQUE')
ORDER BY TABLE_NAME, CONSTRAINT_TYPE, CONSTRAINT_NAME;

SELECT TABLE_NAME, COLUMN_NAME, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = DATABASE() AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY TABLE_NAME, COLUMN_NAME;

SELECT p.Product_ID, p.Product_Name, p.Seller_ID, s.Seller_Name, s.Business_Name
FROM product AS p JOIN seller AS s ON p.Seller_ID = s.Seller_ID
ORDER BY p.Product_ID;

SELECT p.Product_ID, p.Product_Name, p.Category_ID, c.Category_Name
FROM product AS p JOIN category AS c ON p.Category_ID = c.Category_ID
ORDER BY p.Product_ID;

SELECT TABLE_NAME, INDEX_NAME, GROUP_CONCAT(COLUMN_NAME ORDER BY SEQ_IN_INDEX) AS Key_Columns
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME IN ('cart_items','order_details')
AND NON_UNIQUE = 0
GROUP BY TABLE_NAME, INDEX_NAME ORDER BY TABLE_NAME, INDEX_NAME;

WITH assignment AS (
  SELECT 101 AS Student_ID, 'C01' AS Course_ID, 'I01' AS Instructor_ID
  UNION ALL SELECT 102, 'C01', 'I01'
  UNION ALL SELECT 101, 'C02', 'I02'
), instructor_course AS (
  SELECT DISTINCT Instructor_ID, Course_ID FROM assignment
), student_instructor AS (
  SELECT DISTINCT Student_ID, Instructor_ID FROM assignment
)
SELECT si.Student_ID, si.Instructor_ID, ic.Course_ID
FROM student_instructor AS si
JOIN instructor_course AS ic ON si.Instructor_ID = ic.Instructor_ID
ORDER BY si.Student_ID, ic.Course_ID;

SELECT o.Order_ID, c.Customer_Name, p.Product_Name,
       od.Quantity, od.Unit_Price, od.Subtotal, o.Total_Amount,
       a.City AS Delivery_City
FROM orders AS o
JOIN customer AS c ON c.Customer_ID = o.Customer_ID
JOIN order_details AS od ON od.Order_ID = o.Order_ID
JOIN product AS p ON p.Product_ID = od.Product_ID
JOIN address AS a ON a.Address_ID = o.Delivery_Address_ID
ORDER BY o.Order_ID, od.Order_Detail_ID;

SELECT p.Product_ID, p.Product_Name, p.Description, p.Price,
       c.Category_ID, c.Category_Name, s.Seller_ID, s.Seller_Name, s.Business_Name
FROM product p JOIN category c ON p.Category_ID = c.Category_ID
JOIN seller s ON p.Seller_ID = s.Seller_ID ORDER BY p.Product_ID;

SHOW TABLES;

SELECT p.Product_ID, p.Product_Name, p.Price, c.Category_Name, s.Seller_Name
FROM product p JOIN category c ON p.Category_ID = c.Category_ID
JOIN seller s ON p.Seller_ID = s.Seller_ID ORDER BY p.Product_ID;

SELECT p.Product_ID, p.Product_Name, p.Price FROM product p
JOIN category c ON p.Category_ID = c.Category_ID
WHERE c.Category_Name = 'Electronics' ORDER BY p.Product_ID;

SELECT Product_ID, Product_Name, Price FROM product
WHERE Price > 1000 ORDER BY Product_ID;

SELECT c.Category_Name, COUNT(*) AS Product_Count
FROM product p JOIN category c ON p.Category_ID = c.Category_ID
GROUP BY c.Category_Name ORDER BY c.Category_Name;

SELECT DATABASE() AS Current_Database;

DESCRIBE customer;
DESCRIBE seller;
DESCRIBE category;
DESCRIBE address;
DESCRIBE delivery_partner;
DESCRIBE product;
DESCRIBE shopping_cart;
DESCRIBE cart_items;
DESCRIBE orders;
DESCRIBE order_details;
DESCRIBE payment;
DESCRIBE delivery;

SHOW TABLES;

SELECT TABLE_NAME, COLUMN_NAME FROM information_schema.KEY_COLUMN_USAGE WHERE TABLE_SCHEMA = DATABASE() AND CONSTRAINT_NAME = 'PRIMARY' ORDER BY TABLE_NAME, ORDINAL_POSITION;

SELECT TABLE_NAME, COLUMN_NAME, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME FROM information_schema.KEY_COLUMN_USAGE WHERE TABLE_SCHEMA = DATABASE() AND REFERENCED_TABLE_NAME IS NOT NULL ORDER BY TABLE_NAME, COLUMN_NAME;

SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = DATABASE() ORDER BY TABLE_NAME, CONSTRAINT_TYPE;

SELECT TABLE_NAME, COLUMN_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE TABLE_SCHEMA = DATABASE() AND CONSTRAINT_NAME='PRIMARY' ORDER BY TABLE_NAME;

SELECT TABLE_NAME, COLUMN_NAME, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE TABLE_SCHEMA = DATABASE() AND REFERENCED_TABLE_NAME IS NOT NULL ORDER BY TABLE_NAME, COLUMN_NAME;

SELECT k.TABLE_NAME,k.CONSTRAINT_NAME,k.COLUMN_NAME,k.ORDINAL_POSITION FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE k JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS t ON k.CONSTRAINT_SCHEMA=t.CONSTRAINT_SCHEMA AND k.TABLE_NAME=t.TABLE_NAME AND k.CONSTRAINT_NAME=t.CONSTRAINT_NAME WHERE k.TABLE_SCHEMA=DATABASE() AND t.CONSTRAINT_TYPE='UNIQUE' ORDER BY k.TABLE_NAME,k.CONSTRAINT_NAME,k.ORDINAL_POSITION;

SELECT t.TABLE_NAME,t.CONSTRAINT_NAME,c.CHECK_CLAUSE,t.ENFORCED FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS t JOIN INFORMATION_SCHEMA.CHECK_CONSTRAINTS c ON t.CONSTRAINT_SCHEMA=c.CONSTRAINT_SCHEMA AND t.CONSTRAINT_NAME=c.CONSTRAINT_NAME WHERE t.TABLE_SCHEMA=DATABASE() AND t.CONSTRAINT_TYPE='CHECK';

SELECT TABLE_NAME,COLUMN_NAME,COLUMN_DEFAULT FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND COLUMN_DEFAULT IS NOT NULL ORDER BY TABLE_NAME,ORDINAL_POSITION;

SELECT TABLE_NAME,COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND IS_NULLABLE='NO' ORDER BY TABLE_NAME,ORDINAL_POSITION;

SELECT TABLE_NAME,COLUMN_NAME,EXTRA FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND EXTRA LIKE '%auto_increment%';

START TRANSACTION;
INSERT INTO customer (Customer_Name,Email,Password,Registration_Date) VALUES ('Week10 Demo',CONCAT(UUID(),'@example.com'),'demo_only',CURRENT_DATE);
SET @demo_customer=LAST_INSERT_ID();
SELECT Customer_ID,Customer_Name,Email FROM customer WHERE Customer_ID=@demo_customer;
ROLLBACK;


START TRANSACTION;
INSERT INTO customer (Customer_Name,Email,Password,Registration_Date) VALUES ('Week10 Demo',CONCAT(UUID(),'@example.com'),'demo_only',CURRENT_DATE);
SET @demo_customer=LAST_INSERT_ID();
INSERT INTO customer (Customer_ID,Customer_Name,Email,Password,Registration_Date) VALUES (@demo_customer,'Duplicate',CONCAT(UUID(),'@example.com'),'demo_only',CURRENT_DATE);
ROLLBACK;


START TRANSACTION;
INSERT INTO address (Customer_ID,Street,City,State,Pincode) VALUES (-1,'Demo Street','Demo City','Tamil Nadu','000000');
ROLLBACK;


START TRANSACTION;
INSERT INTO customer (Customer_Name,Email,Password,Registration_Date) VALUES ('Week10 Demo',CONCAT(UUID(),'@example.com'),'demo_only',CURRENT_DATE);
SET @demo_customer=LAST_INSERT_ID();
INSERT INTO customer (Customer_Name,Email,Password,Registration_Date) SELECT 'Duplicate Email',Email,'demo_only',CURRENT_DATE FROM customer WHERE Customer_ID=@demo_customer;
ROLLBACK;

START TRANSACTION;
INSERT INTO product (Product_Name,Price,Category_ID,Seller_ID) SELECT 'Invalid Price',-10,c.Category_ID,s.Seller_ID FROM category c CROSS JOIN seller s LIMIT 1;
ROLLBACK;

START TRANSACTION;
INSERT INTO customer (Customer_Name,Email,Password,Registration_Date) VALUES ('Week10 Demo',CONCAT(UUID(),'@example.com'),'demo_only',CURRENT_DATE);
SET @demo_customer=LAST_INSERT_ID();
INSERT INTO shopping_cart (Customer_ID) VALUES (@demo_customer);
SELECT Cart_ID,Customer_ID,Created_Date,Cart_Status FROM shopping_cart WHERE Customer_ID=@demo_customer;
ROLLBACK;

START TRANSACTION;
INSERT INTO customer (Customer_Name,Email,Password,Registration_Date) VALUES (NULL,CONCAT(UUID(),'@example.com'),'demo_only',CURRENT_DATE);
ROLLBACK;

SELECT TABLE_NAME,CONSTRAINT_TYPE,COUNT(*) AS Total FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = DATABASE() GROUP BY TABLE_NAME,CONSTRAINT_TYPE ORDER BY TABLE_NAME,CONSTRAINT_TYPE;
SHOW CREATE TABLE product;
SHOW CREATE TABLE shopping_cart;


INSERT INTO customer (Customer_ID,Customer_Name,Email,Phone,Password,Registration_Date) VALUES
(1101, 'Ananya', 'w11.customer1@example.com', NULL, 'demo_hash_w11_1', '2026-03-01'),
(1102, 'Vikram', 'w11.customer2@example.com', NULL, 'demo_hash_w11_2', '2026-03-01'),
(1103, 'Divya', 'w11.customer3@example.com', NULL, 'demo_hash_w11_3', '2026-03-01'),
(1104, 'Naveen', 'w11.customer4@example.com', NULL, 'demo_hash_w11_4', '2026-03-01'),
(1105, 'Keerthi', 'w11.customer5@example.com', NULL, 'demo_hash_w11_5', '2026-03-01'),
(1106, 'Sanjay', 'w11.customer6@example.com', NULL, 'demo_hash_w11_6', '2026-03-01'),
(1107, 'Lavanya', 'w11.customer7@example.com', NULL, 'demo_hash_w11_7', '2026-03-01'),
(1108, 'Ajay', 'w11.customer8@example.com', NULL, 'demo_hash_w11_8', '2026-03-01'),
(1109, 'Nisha', 'w11.customer9@example.com', NULL, 'demo_hash_w11_9', '2026-03-01'),
(1110, 'Varun', 'w11.customer10@example.com', NULL, 'demo_hash_w11_10', '2026-03-01'),
(1111, 'Kavya', 'w11.customer11@example.com', NULL, 'demo_hash_w11_11', '2026-03-01'),
(1112, 'Rohit', 'w11.customer12@example.com', NULL, 'demo_hash_w11_12', '2026-03-01'),
(1113, 'Deepa', 'w11.customer13@example.com', NULL, 'demo_hash_w11_13', '2026-03-01'),
(1114, 'Manoj', 'w11.customer14@example.com', NULL, 'demo_hash_w11_14', '2026-03-01'),
(1115, 'Ishita', 'w11.customer15@example.com', NULL, 'demo_hash_w11_15', '2026-03-01');


INSERT INTO seller (Seller_ID,Seller_Name,Email,Phone,Business_Name,Address) VALUES
(1101, 'Week11 Seller 1', 'w11.seller1@example.com', NULL, 'Demo Business 1', 'Tamil Nadu'),
(1102, 'Week11 Seller 2', 'w11.seller2@example.com', NULL, 'Demo Business 2', 'Tamil Nadu'),
(1103, 'Week11 Seller 3', 'w11.seller3@example.com', NULL, 'Demo Business 3', 'Tamil Nadu'),
(1104, 'Week11 Seller 4', 'w11.seller4@example.com', NULL, 'Demo Business 4', 'Tamil Nadu'),
(1105, 'Week11 Seller 5', 'w11.seller5@example.com', NULL, 'Demo Business 5', 'Tamil Nadu'),
(1106, 'Week11 Seller 6', 'w11.seller6@example.com', NULL, 'Demo Business 6', 'Tamil Nadu'),
(1107, 'Week11 Seller 7', 'w11.seller7@example.com', NULL, 'Demo Business 7', 'Tamil Nadu');

INSERT INTO category (Category_ID,Category_Name,Description) VALUES
(1101, 'Fashion', 'Fashion products'),
(1102, 'Sports', 'Sports products'),
(1103, 'Beauty', 'Beauty products'),
(1104, 'Grocery', 'Grocery products'),
(1105, 'Accessories', 'Accessories products');


INSERT INTO address (Address_ID,Customer_ID,House_No,Street,City,State,Pincode) VALUES
(1101, 1101, '10', 'Demo Street', 'Thoothukudi', 'Tamil Nadu', '628001'),
(1102, 1102, '11', 'Demo Street', 'Chennai', 'Tamil Nadu', '600001'),
(1103, 1103, '12', 'Demo Street', 'Madurai', 'Tamil Nadu', '625001'),
(1104, 1104, '13', 'Demo Street', 'Coimbatore', 'Tamil Nadu', '641001'),
(1105, 1105, '14', 'Demo Street', 'Tirunelveli', 'Tamil Nadu', '627001'),
(1106, 1106, '15', 'Demo Street', 'Thoothukudi', 'Tamil Nadu', '628001'),
(1107, 1107, '16', 'Demo Street', 'Chennai', 'Tamil Nadu', '600001'),
(1108, 1108, '17', 'Demo Street', 'Madurai', 'Tamil Nadu', '625001'),
(1109, 1109, '18', 'Demo Street', 'Coimbatore', 'Tamil Nadu', '641001'),
(1110, 1110, '19', 'Demo Street', 'Tirunelveli', 'Tamil Nadu', '627001'),
(1111, 1111, '20', 'Demo Street', 'Thoothukudi', 'Tamil Nadu', '628001'),
(1112, 1112, '21', 'Demo Street', 'Chennai', 'Tamil Nadu', '600001'),
(1113, 1113, '22', 'Demo Street', 'Madurai', 'Tamil Nadu', '625001'),
(1114, 1114, '23', 'Demo Street', 'Coimbatore', 'Tamil Nadu', '641001'),
(1115, 1115, '24', 'Demo Street', 'Tirunelveli', 'Tamil Nadu', '627001'),
(1116, 1101, '25', 'Demo Street', 'Thoothukudi', 'Tamil Nadu', '628001'),
(1117, 1102, '26', 'Demo Street', 'Chennai', 'Tamil Nadu', '600001'),
(1118, 1103, '27', 'Demo Street', 'Madurai', 'Tamil Nadu', '625001'),
(1119, 1104, '28', 'Demo Street', 'Coimbatore', 'Tamil Nadu', '641001'),
(1120, 1105, '29', 'Demo Street', 'Tirunelveli', 'Tamil Nadu', '627001');


INSERT INTO delivery_partner (Delivery_Partner_ID,Partner_Name,Phone,Company_Name) VALUES
(1101, 'Demo Ravi', NULL, 'Demo Express'),
(1102, 'Demo Kumar', NULL, 'Demo Logistics');


INSERT INTO product (Product_ID,Product_Name,Description,Price,Category_ID,Seller_ID) VALUES
(1101, 'USB Cable', 'Sample USB Cable', 199, 1, 1101),
(1102, 'Keyboard', 'Sample Keyboard', 299, 1, 1102),
(1103, 'Monitor', 'Sample Monitor', 399, 1, 1103),
(1104, 'Desk Lamp', 'Sample Desk Lamp', 499, 2, 1104),
(1105, 'Rice Cooker', 'Sample Rice Cooker', 599, 2, 1105),
(1106, 'Toaster', 'Sample Toaster', 699, 2, 1106),
(1107, 'Python Handbook', 'Sample Python Handbook', 799, 3, 1107),
(1108, 'Java Handbook', 'Sample Java Handbook', 899, 3, 1101),
(1109, 'Notebook', 'Sample Notebook', 999, 3, 1102),
(1110, 'Cotton Shirt', 'Sample Cotton Shirt', 1099, 1101, 1103),
(1111, 'Jeans', 'Sample Jeans', 1199, 1101, 1104),
(1112, 'Running Shoes', 'Sample Running Shoes', 1299, 1101, 1105),
(1113, 'Football', 'Sample Football', 1399, 1102, 1106),
(1114, 'Yoga Mat', 'Sample Yoga Mat', 1499, 1102, 1107),
(1115, 'Badminton Racket', 'Sample Badminton Racket', 1599, 1102, 1101),
(1116, 'Face Wash', 'Sample Face Wash', 1699, 1103, 1102),
(1117, 'Shampoo', 'Sample Shampoo', 1799, 1103, 1103),
(1118, 'Soap', 'Sample Soap', 1899, 1103, 1104),
(1119, 'Rice Pack', 'Sample Rice Pack', 1999, 1104, 1105),
(1120, 'Tea Pack', 'Sample Tea Pack', 2099, 1104, 1106),
(1121, 'Oats', 'Sample Oats', 2199, 1104, 1107),
(1122, 'Laptop Sleeve', 'Sample Laptop Sleeve', 2299, 1105, 1101),
(1123, 'Wallet', 'Sample Wallet', 2399, 1105, 1102),
(1124, 'Backpack', 'Sample Backpack', 2499, 1105, 1103);

INSERT INTO shopping_cart (Cart_ID,Customer_ID,Created_Date,Cart_Status) VALUES
(1101, 1101, '2026-03-02 10:00:00', 'Active'),
(1102, 1102, '2026-03-02 10:00:00', 'Checked Out'),
(1103, 1103, '2026-03-02 10:00:00', 'Abandoned'),
(1104, 1104, '2026-03-02 10:00:00', 'Active'),
(1105, 1105, '2026-03-02 10:00:00', 'Checked Out'),
(1106, 1106, '2026-03-02 10:00:00', 'Abandoned'),
(1107, 1107, '2026-03-02 10:00:00', 'Active'),
(1108, 1108, '2026-03-02 10:00:00', 'Checked Out'),
(1109, 1109, '2026-03-02 10:00:00', 'Abandoned'),
(1110, 1110, '2026-03-02 10:00:00', 'Active'),
(1111, 1111, '2026-03-02 10:00:00', 'Checked Out'),
(1112, 1112, '2026-03-02 10:00:00', 'Abandoned'),
(1113, 1113, '2026-03-02 10:00:00', 'Active'),
(1114, 1114, '2026-03-02 10:00:00', 'Checked Out'),
(1115, 1115, '2026-03-02 10:00:00', 'Abandoned');

INSERT INTO cart_items (Cart_Item_ID,Cart_ID,Product_ID,Quantity,Subtotal) VALUES
(1101, 1101, 1101, 1, 199),
(1102, 1102, 1102, 2, 598),
(1103, 1103, 1103, 3, 1197),
(1104, 1104, 1104, 1, 499),
(1105, 1105, 1105, 2, 1198),
(1106, 1106, 1106, 3, 2097),
(1107, 1107, 1107, 1, 799),
(1108, 1108, 1108, 2, 1798),
(1109, 1109, 1109, 3, 2997),
(1110, 1110, 1110, 1, 1099),
(1111, 1111, 1111, 2, 2398),
(1112, 1112, 1112, 3, 3897),
(1113, 1113, 1113, 1, 1399),
(1114, 1114, 1114, 2, 2998),
(1115, 1115, 1115, 3, 4797),
(1116, 1101, 1108, 1, 899),
(1117, 1102, 1109, 2, 1998),
(1118, 1103, 1110, 3, 3297),
(1119, 1104, 1111, 1, 1199),
(1120, 1105, 1112, 2, 2598),
(1121, 1106, 1113, 3, 4197),
(1122, 1107, 1114, 1, 1499),
(1123, 1108, 1115, 2, 3198),
(1124, 1109, 1116, 3, 5097),
(1125, 1110, 1117, 1, 1799),
(1126, 1111, 1118, 2, 3798),
(1127, 1112, 1119, 3, 5997),
(1128, 1113, 1120, 1, 2099),
(1129, 1114, 1121, 2, 4398),
(1130, 1115, 1122, 3, 6897),
(1131, 1101, 1115, 1, 1599),
(1132, 1102, 1116, 2, 3398),
(1133, 1103, 1117, 3, 5397),
(1134, 1104, 1118, 1, 1899);


INSERT INTO orders (Order_ID,Customer_ID,Order_Date,Total_Amount,Order_Status,Delivery_Address_ID) VALUES
(1101, 1101, '2026-03-03 10:00:00', 3596, 'Delivered', 1101),
(1102, 1102, '2026-03-03 10:00:00', 3996, 'Shipped', 1102),
(1103, 1103, '2026-03-03 10:00:00', 4396, 'Confirmed', 1103),
(1104, 1104, '2026-03-03 10:00:00', 2897, 'Pending', 1104),
(1105, 1105, '2026-03-03 10:00:00', 3197, 'Cancelled', 1105),
(1106, 1106, '2026-03-03 10:00:00', 3497, 'Delivered', 1106),
(1107, 1107, '2026-03-03 10:00:00', 3797, 'Shipped', 1107),
(1108, 1108, '2026-03-03 10:00:00', 4097, 'Confirmed', 1108),
(1109, 1109, '2026-03-03 10:00:00', 4397, 'Pending', 1109),
(1110, 1110, '2026-03-03 10:00:00', 4697, 'Cancelled', 1110),
(1111, 1111, '2026-03-03 10:00:00', 4997, 'Delivered', 1111),
(1112, 1112, '2026-03-03 10:00:00', 5297, 'Shipped', 1112),
(1113, 1113, '2026-03-03 10:00:00', 5597, 'Confirmed', 1113),
(1114, 1114, '2026-03-03 10:00:00', 5897, 'Pending', 1114),
(1115, 1115, '2026-03-03 10:00:00', 6197, 'Cancelled', 1115),
(1116, 1101, '2026-03-03 10:00:00', 6497, 'Delivered', 1101),
(1117, 1102, '2026-03-03 10:00:00', 6797, 'Shipped', 1102),
(1118, 1103, '2026-03-03 10:00:00', 2297, 'Confirmed', 1103),
(1119, 1104, '2026-03-03 10:00:00', 2597, 'Pending', 1104),
(1120, 1105, '2026-03-03 10:00:00', 2897, 'Cancelled', 1105),
(1121, 1106, '2026-03-03 10:00:00', 3197, 'Delivered', 1106),
(1122, 1107, '2026-03-03 10:00:00', 3497, 'Shipped', 1107),
(1123, 1108, '2026-03-03 10:00:00', 3797, 'Confirmed', 1108),
(1124, 1109, '2026-03-03 10:00:00', 4097, 'Pending', 1109),
(1125, 1110, '2026-03-03 10:00:00', 1997, 'Cancelled', 1110),
(1126, 1111, '2026-03-03 10:00:00', 2297, 'Delivered', 1111);


INSERT INTO order_details (Order_Detail_ID,Order_ID,Product_ID,Quantity,Unit_Price,Subtotal) VALUES
(1101, 1101, 1101, 1, 199, 199),
(1102, 1101, 1108, 2, 899, 1798),
(1103, 1101, 1115, 1, 1599, 1599),
(1104, 1102, 1102, 1, 299, 299),
(1105, 1102, 1109, 2, 999, 1998),
(1106, 1102, 1116, 1, 1699, 1699),
(1107, 1103, 1103, 1, 399, 399),
(1108, 1103, 1110, 2, 1099, 2198),
(1109, 1103, 1117, 1, 1799, 1799),
(1110, 1104, 1104, 1, 499, 499),
(1111, 1104, 1111, 2, 1199, 2398),
(1112, 1105, 1105, 1, 599, 599),
(1113, 1105, 1112, 2, 1299, 2598),
(1114, 1106, 1106, 1, 699, 699),
(1115, 1106, 1113, 2, 1399, 2798),
(1116, 1107, 1107, 1, 799, 799),
(1117, 1107, 1114, 2, 1499, 2998),
(1118, 1108, 1108, 1, 899, 899),
(1119, 1108, 1115, 2, 1599, 3198),
(1120, 1109, 1109, 1, 999, 999),
(1121, 1109, 1116, 2, 1699, 3398),
(1122, 1110, 1110, 1, 1099, 1099),
(1123, 1110, 1117, 2, 1799, 3598),
(1124, 1111, 1111, 1, 1199, 1199),
(1125, 1111, 1118, 2, 1899, 3798),
(1126, 1112, 1112, 1, 1299, 1299),
(1127, 1112, 1119, 2, 1999, 3998),
(1128, 1113, 1113, 1, 1399, 1399),
(1129, 1113, 1120, 2, 2099, 4198),
(1130, 1114, 1114, 1, 1499, 1499),
(1131, 1114, 1121, 2, 2199, 4398),
(1132, 1115, 1115, 1, 1599, 1599),
(1133, 1115, 1122, 2, 2299, 4598),
(1134, 1116, 1116, 1, 1699, 1699),
(1135, 1116, 1123, 2, 2399, 4798),
(1136, 1117, 1117, 1, 1799, 1799),
(1137, 1117, 1124, 2, 2499, 4998),
(1138, 1118, 1118, 1, 1899, 1899),
(1139, 1118, 1101, 2, 199, 398),
(1140, 1119, 1119, 1, 1999, 1999),
(1141, 1119, 1102, 2, 299, 598),
(1142, 1120, 1120, 1, 2099, 2099),
(1143, 1120, 1103, 2, 399, 798),
(1144, 1121, 1121, 1, 2199, 2199),
(1145, 1121, 1104, 2, 499, 998),
(1146, 1122, 1122, 1, 2299, 2299),
(1147, 1122, 1105, 2, 599, 1198),
(1148, 1123, 1123, 1, 2399, 2399),
(1149, 1123, 1106, 2, 699, 1398),
(1150, 1124, 1124, 1, 2499, 2499),
(1151, 1124, 1107, 2, 799, 1598),
(1152, 1125, 1101, 1, 199, 199),
(1153, 1125, 1108, 2, 899, 1798),
(1154, 1126, 1102, 1, 299, 299),
(1155, 1126, 1109, 2, 999, 1998);


INSERT INTO payment (Payment_ID,Order_ID,Payment_Method,Payment_Date,Amount,Payment_Status,Transaction_ID) VALUES
(1101, 1101, 'UPI', '2026-03-03 10:05:00', 3596, 'Successful', 'W11-TXN-1101'),
(1102, 1102, 'Credit Card', '2026-03-03 10:05:00', 3996, 'Successful', 'W11-TXN-1102'),
(1103, 1103, 'Debit Card', '2026-03-03 10:05:00', 4396, 'Successful', 'W11-TXN-1103'),
(1104, 1104, 'Net Banking', NULL, 2897, 'Pending', 'W11-TXN-1104'),
(1105, 1105, 'Cash on Delivery', '2026-03-03 10:05:00', 3197, 'Refunded', 'W11-TXN-1105'),
(1106, 1106, 'UPI', '2026-03-03 10:05:00', 3497, 'Successful', 'W11-TXN-1106'),
(1107, 1107, 'Credit Card', '2026-03-03 10:05:00', 3797, 'Successful', 'W11-TXN-1107'),
(1108, 1108, 'Debit Card', '2026-03-03 10:05:00', 4097, 'Successful', 'W11-TXN-1108'),
(1109, 1109, 'Net Banking', NULL, 4397, 'Pending', 'W11-TXN-1109'),
(1110, 1110, 'Cash on Delivery', '2026-03-03 10:05:00', 4697, 'Refunded', 'W11-TXN-1110'),
(1111, 1111, 'UPI', '2026-03-03 10:05:00', 4997, 'Successful', 'W11-TXN-1111'),
(1112, 1112, 'Credit Card', '2026-03-03 10:05:00', 5297, 'Successful', 'W11-TXN-1112'),
(1113, 1113, 'Debit Card', '2026-03-03 10:05:00', 5597, 'Successful', 'W11-TXN-1113'),
(1114, 1114, 'Net Banking', NULL, 5897, 'Pending', 'W11-TXN-1114'),
(1115, 1115, 'Cash on Delivery', '2026-03-03 10:05:00', 6197, 'Refunded', 'W11-TXN-1115'),
(1116, 1116, 'UPI', '2026-03-03 10:05:00', 6497, 'Successful', 'W11-TXN-1116'),
(1117, 1117, 'Credit Card', '2026-03-03 10:05:00', 6797, 'Successful', 'W11-TXN-1117'),
(1118, 1118, 'Debit Card', '2026-03-03 10:05:00', 2297, 'Successful', 'W11-TXN-1118'),
(1119, 1119, 'Net Banking', NULL, 2597, 'Pending', 'W11-TXN-1119'),
(1120, 1120, 'Cash on Delivery', '2026-03-03 10:05:00', 2897, 'Refunded', 'W11-TXN-1120'),
(1121, 1121, 'UPI', '2026-03-03 10:05:00', 3197, 'Successful', 'W11-TXN-1121'),
(1122, 1122, 'Credit Card', '2026-03-03 10:05:00', 3497, 'Successful', 'W11-TXN-1122'),
(1123, 1123, 'Debit Card', '2026-03-03 10:05:00', 3797, 'Successful', 'W11-TXN-1123'),
(1124, 1124, 'Net Banking', NULL, 4097, 'Pending', 'W11-TXN-1124'),
(1125, 1125, 'Cash on Delivery', '2026-03-03 10:05:00', 1997, 'Refunded', 'W11-TXN-1125'),
(1126, 1126, 'UPI', '2026-03-03 10:05:00', 2297, 'Successful', 'W11-TXN-1126');


INSERT INTO delivery (Delivery_ID,Order_ID,Delivery_Partner_ID,Tracking_Number,Shipping_Date,Expected_Delivery_Date,Actual_Delivery_Date,Delivery_Status) VALUES
(1101, 1101, 1101, 'W11-TRK-1101', '2026-03-04', '2026-03-08', '2026-03-06', 'Delivered'),
(1102, 1102, 1102, 'W11-TRK-1102', '2026-03-04', '2026-03-08', NULL, 'In Transit'),
(1103, 1103, 1101, 'W11-TRK-1103', NULL, '2026-03-08', NULL, 'Preparing'),
(1104, 1104, 1102, 'W11-TRK-1104', NULL, '2026-03-08', NULL, 'Preparing'),
(1105, 1105, 1101, 'W11-TRK-1105', NULL, '2026-03-08', NULL, 'Cancelled'),
(1106, 1106, 1102, 'W11-TRK-1106', '2026-03-04', '2026-03-08', '2026-03-06', 'Delivered'),
(1107, 1107, 1101, 'W11-TRK-1107', '2026-03-04', '2026-03-08', NULL, 'In Transit'),
(1108, 1108, 1102, 'W11-TRK-1108', NULL, '2026-03-08', NULL, 'Preparing'),
(1109, 1109, 1101, 'W11-TRK-1109', NULL, '2026-03-08', NULL, 'Preparing'),
(1110, 1110, 1102, 'W11-TRK-1110', NULL, '2026-03-08', NULL, 'Cancelled'),
(1111, 1111, 1101, 'W11-TRK-1111', '2026-03-04', '2026-03-08', '2026-03-06', 'Delivered'),
(1112, 1112, 1102, 'W11-TRK-1112', '2026-03-04', '2026-03-08', NULL, 'In Transit'),
(1113, 1113, 1101, 'W11-TRK-1113', NULL, '2026-03-08', NULL, 'Preparing'),
(1114, 1114, 1102, 'W11-TRK-1114', NULL, '2026-03-08', NULL, 'Preparing'),
(1115, 1115, 1101, 'W11-TRK-1115', NULL, '2026-03-08', NULL, 'Cancelled'),
(1116, 1116, 1102, 'W11-TRK-1116', '2026-03-04', '2026-03-08', '2026-03-06', 'Delivered'),
(1117, 1117, 1101, 'W11-TRK-1117', '2026-03-04', '2026-03-08', NULL, 'In Transit'),
(1118, 1118, 1102, 'W11-TRK-1118', NULL, '2026-03-08', NULL, 'Preparing'),
(1119, 1119, 1101, 'W11-TRK-1119', NULL, '2026-03-08', NULL, 'Preparing'),
(1120, 1120, 1102, 'W11-TRK-1120', NULL, '2026-03-08', NULL, 'Cancelled'),
(1121, 1121, 1101, 'W11-TRK-1121', '2026-03-04', '2026-03-08', '2026-03-06', 'Delivered'),
(1122, 1122, 1102, 'W11-TRK-1122', '2026-03-04', '2026-03-08', NULL, 'In Transit'),
(1123, 1123, 1101, 'W11-TRK-1123', NULL, '2026-03-08', NULL, 'Preparing'),
(1124, 1124, 1102, 'W11-TRK-1124', NULL, '2026-03-08', NULL, 'Preparing'),
(1125, 1125, 1101, 'W11-TRK-1125', NULL, '2026-03-08', NULL, 'Cancelled'),
(1126, 1126, 1102, 'W11-TRK-1126', '2026-03-04', '2026-03-08', '2026-03-06', 'Delivered');

SELECT 'customer' AS Table_Name, COUNT(*) AS Record_Count FROM customer
UNION ALL
SELECT 'seller' AS Table_Name, COUNT(*) AS Record_Count FROM seller
UNION ALL
SELECT 'category' AS Table_Name, COUNT(*) AS Record_Count FROM category
UNION ALL
SELECT 'address' AS Table_Name, COUNT(*) AS Record_Count FROM address
UNION ALL
SELECT 'delivery_partner' AS Table_Name, COUNT(*) AS Record_Count FROM delivery_partner
UNION ALL
SELECT 'product' AS Table_Name, COUNT(*) AS Record_Count FROM product
UNION ALL
SELECT 'shopping_cart' AS Table_Name, COUNT(*) AS Record_Count FROM shopping_cart
UNION ALL
SELECT 'cart_items' AS Table_Name, COUNT(*) AS Record_Count FROM cart_items
UNION ALL
SELECT 'orders' AS Table_Name, COUNT(*) AS Record_Count FROM orders
UNION ALL
SELECT 'order_details' AS Table_Name, COUNT(*) AS Record_Count FROM order_details
UNION ALL
SELECT 'payment' AS Table_Name, COUNT(*) AS Record_Count FROM payment
UNION ALL
SELECT 'delivery' AS Table_Name, COUNT(*) AS Record_Count FROM delivery;




