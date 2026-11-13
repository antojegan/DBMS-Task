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
