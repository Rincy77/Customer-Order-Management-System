-- Customer Order Management System

CREATE DATABASE CUSTOMER_MANAGEMENT_SYSTEM;
USE CUSTOMER_MANAGEMENT_SYSTEM;

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    Address VARCHAR(255)
);

-- insert new customer
INSERT INTO Customers (FirstName, LastName, Email, Phone, Address)
VALUES 
('Rahul', 'Kumar', 'rahul.kumar@gmail.com', '1234567890', '123 Main St'),
('Sri', 'Devi', 'sri.devi@gmail.com', '1234567891', '456 Main St'),
('Uma', 'Devi', 'uma.devi@gmail.com', '1234567892', '879 Main St'),
('Sri', 'Dhanya','sri.dhanya@gmail.com', '1234567893', '165 Main St'),
('Magdelene', 'Aiswarya', 'mag.ais@gmail.com','1234567894', '432 Main St');

CREATE TABLE Products (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(100),
    Price DECIMAL(10, 2),
    StockQuantity INT
);

-- insert new product
INSERT INTO Products (ProductName, Price, StockQuantity)
VALUES 
('Product A',29.99, 100),
('Product B',89.99, 100),
('Pillow',284.99, 100),
('Chair',290.00, 100),
('Bed Cover',375.00, 100);

update Products set ProductName="Scissor" where ProductID=1;
update Products set ProductName="Bucket" where ProductID=2;


CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    OrderDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

ALTER TABLE Orders MODIFY COLUMN OrderDate DATE;
Desc Orders;

-- create new order
INSERT INTO Orders (CustomerID,TotalAmount)
VALUES 
(1,59.98),
(2,269.97),
(2,179.98),
(4,580.00),
(5,1125.00);


CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10, 2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
-- Add products to an order
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, Price)
VALUES 
(1, 1, 2, 29.99),
(2, 2, 3, 89.99),
(3, 2, 2, 89.99),
(4, 4, 2, 290.00),
(5, 5, 3, 375.00);

update OrderDetails set quantity=3 where OrderID=2;
update OrderDetails set quantity=2 where OrderID=3;

CREATE TABLE Inventory (
    ProductID INT PRIMARY KEY,
    StockQuantity INT,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- insert Products stock
INSERT INTO Inventory (ProductID,StockQuantity) VALUES
(1,98),
(2,95),
(3,100),
(4,98),
(5,97);

-- Update an inventory after an order
UPDATE Inventory
SET StockQuantity = StockQuantity - 2
WHERE ProductID = 1;

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    PaymentDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    PaymentAmount DECIMAL(10, 2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Record a payment
INSERT INTO Payments (OrderID, PaymentAmount)
VALUES
 (1, 59.98),
 (2, 269.97),
 (3, 179.98),
 (4, 580.00),
 (5, 1125.00);
 
SELECT * FROM Customers;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM OrderDetails;
SELECT * FROM Inventory;
SELECT * FROM Payments;

-- Get all orders with Customer Details

SELECT Orders.OrderID, Orders.OrderDate, Orders.TotalAmount,
Customers.FirstName, Customers.LastName, Customers.Email
FROM Orders
JOIN Customers ON Orders.CustomerID = Customers.CustomerID;


-- Get all the products details with stock quantity

SELECT Products.ProductID, Products.ProductName, Products.Price,
Products.StockQuantity,Inventory.StockQuantity AS Updated_Stock
FROM Products JOIN Inventory ON Products.ProductID=Inventory.ProductID;

-- Get customers with orders exceeding a certain amount

SELECT FirstName, LastName, Email
FROM Customers
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Orders
    WHERE TotalAmount > 100
);