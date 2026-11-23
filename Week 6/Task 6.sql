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