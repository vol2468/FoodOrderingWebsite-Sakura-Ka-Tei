CREATE DATABASE orders;
go

USE orders;
go

DROP TABLE review;
DROP TABLE shipment;
DROP TABLE productinventory;
DROP TABLE warehouse;
DROP TABLE orderproduct;
DROP TABLE incart;
DROP TABLE product;
DROP TABLE category;
DROP TABLE ordersummary;
DROP TABLE paymentmethod;
DROP TABLE customer;


CREATE TABLE customer (
    customerId          INT IDENTITY,
    firstName           VARCHAR(40),
    lastName            VARCHAR(40),
    email               VARCHAR(50),
    phonenum            VARCHAR(20),
    address             VARCHAR(50),
    city                VARCHAR(40),
    state               VARCHAR(20),
    postalCode          VARCHAR(20),
    country             VARCHAR(40),
    userid              VARCHAR(20),
    password            VARCHAR(30),
    PRIMARY KEY (customerId)
);

CREATE TABLE paymentmethod (
    paymentMethodId     INT IDENTITY,
    paymentType         VARCHAR(20),
    paymentNumber       VARCHAR(30),
    paymentExpiryDate   DATE,
    customerId          INT,
    PRIMARY KEY (paymentMethodId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE ordersummary (
    orderId             INT IDENTITY,
    orderDate           DATETIME,
    totalAmount         DECIMAL(10,2),
    shiptoAddress       VARCHAR(50),
    shiptoCity          VARCHAR(40),
    shiptoState         VARCHAR(20),
    shiptoPostalCode    VARCHAR(20),
    shiptoCountry       VARCHAR(40),
    customerId          INT,
    PRIMARY KEY (orderId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE category (
    categoryId          INT IDENTITY,
    categoryName        VARCHAR(50),    
    PRIMARY KEY (categoryId)
);

CREATE TABLE product (
    productId           INT IDENTITY,
    productName         VARCHAR(40),
    productPrice        DECIMAL(10,2),
    productImageURL     VARCHAR(100),
    productImage        VARBINARY(MAX),
    productDesc         VARCHAR(1000),
    categoryId          INT,
    PRIMARY KEY (productId),
    FOREIGN KEY (categoryId) REFERENCES category(categoryId)
);

CREATE TABLE orderproduct (
    orderId             INT,
    productId           INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (orderId, productId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE incart (
    orderId             INT,
    productId           INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (orderId, productId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE warehouse (
    warehouseId         INT IDENTITY,
    warehouseName       VARCHAR(30),    
    PRIMARY KEY (warehouseId)
);

CREATE TABLE shipment (
    shipmentId          INT IDENTITY,
    shipmentDate        DATETIME,   
    shipmentDesc        VARCHAR(100),   
    warehouseId         INT, 
    PRIMARY KEY (shipmentId),
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE productinventory ( 
    productId           INT,
    warehouseId         INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (productId, warehouseId),   
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE review (
    reviewId            INT IDENTITY,
    reviewRating        INT,
    reviewDate          DATETIME,   
    customerId          INT,
    productId           INT,
    reviewComment       VARCHAR(1000),          
    PRIMARY KEY (reviewId),
    FOREIGN KEY (customerId) REFERENCES customer(customerId)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO category(categoryName) VALUES ('Sushi');
INSERT INTO category(categoryName) VALUES ('Seafood');
INSERT INTO category(categoryName) VALUES ('Set Menu');
INSERT INTO category(categoryName) VALUES ('Donburi');
INSERT INTO category(categoryName) VALUES ('Noodle');
INSERT INTO category(categoryName) VALUES ('Hot Pot');
INSERT INTO category(categoryName) VALUES ('Skewer');

INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Tuna', 1, 'Nigiri (fish on top of rice) with tuna',6.50);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Salmon',1,'Nigiri (fish on top of rice) with salmon',6.50);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Hamachi',1,'Nigiri (fish on top of rice) with young yellowtail',6.50);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Seabream',1,'Nigiri (fish on top of rice) with seabream',6.50);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Bonito',1,'Nigiri (fish on top of rice) with bonito',6.50);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Squid',1,'Nigiri (fish on top of rice) with squid',6.50);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Boiled Octopus',1,'Nigiri (fish on top of rice) with boiled octopus',6.50);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Grilled Eel',1,'Nigiri (fish on top of rice) with grilled eel',8.50);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Ikura',1,'Gunkanmaki (roll) with salmon roe',6.50);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Tuna Mayo Salad',1,'Gunkanmaki (roll) with tuna mayo salad',6.50);

INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Natto',1,'Gunkanmaki (roll) with Natto',6.50);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Negitoro',1,'Gunkanmaki (roll) with minced tuna',6.50);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Cucumber',1,'Gunkanmaki (roll) with cucumber',5.50);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Fried Bean Curd',1,'Seasoned sushi rice encased in a sweet, marinated tofu pouch',7.50);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Seafood Don',2,'Succulent raw fish, tender octopus, and sweet shrimp arranged over a bowl of seasoned sushi rice',26.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Ikura Don',2,'Salmon roe on top of rice',19.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Chirashi Zushi',2,'Colorful sashimi on a bed of seasoned sushi rice',22.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Samon Ikura Don',2,'Samon and salmon roe on top of rice',21.50);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Soy Marinated Tuna Don',2,'Soy marinated tuna on top of rice',19.50);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Unaju',2,'Grilled eel on top of rice',25.00);

INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Fugu Sashimi',2,'Blowfish Sashimi',20.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Assorted Sashimi',2,'Fatty tuna, medium fatty tuna, salmon, young yellowtail, seabream, bigfin squid, shrimp',31.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Tonkatsu Teishoku',3,'Pork cutlets, with salad, miso soup, and rice',19.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Karaage Teishoku',3,'Japanese style fried chicken, with salad, miso soup, and rice',19.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Gyukatsu Teishoku',3,'Beef cutlets, with salad, miso soup, and rice',19.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Katsu Don',4,'Fried pork cutlets, onions, and beaten eggs on top of rice, smothered in a sweet and savory sauce',19.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Oyako Don',4,'Simmered chicken, onions, and beaten eggs over a bed of rice',16.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Teriyaki Chicken Don',4,'Grilled chicken, glazed in teriyaki sauce on a bed of rice',19.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Tenpura Don',4,'Fried shrimp and vegetables sit on top of rice',21.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Gyu Don',4,'Thinly sliced beef, caramelized onions, and a savory soy-based sauce meld together over a bed of rice',22.00);

INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Buta Don',4,'Tender sliced pork, seasoned to perfection, lay on top of rice,',22.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Kake Udon',5,'Chewy Sanuki Udon noodles in a flavorful fish stock broth',15.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Zaru Udon',5,'Chilled Udon noodles dipped in a dark, sweet broth, topped with nori (seaweed)',15.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Bukkake Udon',5,'Chewy Sanuki Udon noodles in a flavorful fish stock broth and soy sause broth',15.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Kamaage Udon',5,'Udon noodle pulled straight from the Udon boiler, served with hot dipping Bukkake broth',15.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Kitsune Udon',5,'Udon noodle topped with sweetly boiled fried tofu',15.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Yamakake Udon',5,'Udon noodle topped with grated Japanese yam',15.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Tsukimi Udon',5,'Udon noodle topped with a raw egg',16.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Kamatama Udon',5,'Udon noodle pulled straight from the Udon boiler with a raw egg to create a creamy flavor, served with hot dipping Bukkake broth',18.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Curry Udon',5,'Udon noodles with Japanese style curry',18.00);

INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Beef Udon',5,'Kake Udon with stewed beef',21.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Zaru Soba',5,'Chilled Soba noodles dipped in a dark, sweet broth, topped with nori (seaweed)',15.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Yamakake Soba',5,'Soba noodle topped with grated Japanese yam',15.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Oroshi Soba',5,'Soba noodles topped with grated Daikon radish in a flavorful fish stock broth and soy sause broth',15.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Shabu Shabu',6,'Dip, swirl, and savor the freshness of thinly sliced meats, vibrant vegetables, and tofu in a simmering pot',25.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Sukiyaki',6,'Succulent beef, tofu, vegetables, and glass noodles simmer in a sweet and savory soy-based broth',25.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Negima',7,'Chicken thigh with green onion',5.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Hatsu',7,'Chicken heart',5.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Sunagimo',7,'Chicken gizzard',5.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Tebasaki',7,'Chicken wing tips',5.50);

INSERT INTO warehouse(warehouseName) VALUES ('Main warehouse');
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (1, 1, 5, 6.50);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (2, 1, 10, 6.50);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (3, 1, 3, 6.50);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (4, 1, 2, 6.50);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (5, 1, 6, 6.50);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (6, 1, 3, 6.50);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (7, 1, 1, 6.50);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (8, 1, 1, 8.50);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (9, 1, 2, 6.50);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (10, 1, 3, 6.50);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (11, 1, 5, 6.50);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (12, 1, 6, 6.50);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (13, 1, 3, 5.50);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (14, 1, 1, 7.50);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (15, 1, 3, 26.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (16, 1, 2, 19.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (17, 1, 5, 22.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (18, 1, 1, 21.50);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (19, 1, 2, 19.50);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (20, 1, 6, 25.50);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (21, 1, 2, 20.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (22, 1, 7, 31.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (23, 1, 10, 19.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (24, 1, 8, 19.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (25, 1, 15, 19.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (26, 1, 1, 19.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (27, 1, 1, 16.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (28, 1, 1, 19.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (29, 1, 2, 21.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (30, 1, 1, 22.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (31, 1, 2, 22.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (32, 1, 2, 15.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (33, 1, 2, 15.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (34, 1, 2, 15.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (35, 1, 2, 15.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (36, 1, 1, 15.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (37, 1, 5, 15.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (38, 1, 4, 16.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (39, 1, 4, 18.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (40, 1, 9, 18.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (41, 1, 1, 21.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (42, 1, 1, 15.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (43, 1, 2, 15.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (44, 1, 1, 15.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (45, 1, 1, 25.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (46, 1, 1, 25.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (47, 1, 1, 5.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (48, 1, 1, 5.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (49, 1, 1, 5.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (50, 1, 3, 5.50);

INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Taii', 'Hirano', 'vol2468@gmail.com', '707-777-1414', '3333 University Way', 'Kelowna', 'BC', 'V1V 1V7', 'Canada', 'taikiichi' , 'taii');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Yuki', 'Isomura', 'moyo@gmail.com', '666-111-2222', '3333 University Way', 'Kelowna', 'BC', 'V1V 1V7', 'Canada', 'moyo' , 'yuki');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Arnold', 'Anderson', 'a.anderson@gmail.com', '204-111-2222', '103 AnyWhere Street', 'Winnipeg', 'MB', 'R3X 45T', 'Canada', 'arnold' , '304Arnold!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Bobby', 'Brown', 'bobby.brown@hotmail.ca', '572-342-8911', '222 Bush Avenue', 'Boston', 'MA', '22222', 'United States', 'bobby' , '304Bobby!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Candace', 'Cole', 'cole@charity.org', '333-444-5555', '333 Central Crescent', 'Chicago', 'IL', '33333', 'United States', 'candace' , '304Candace!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Darren', 'Doe', 'oe@doe.com', '250-807-2222', '444 Dover Lane', 'Kelowna', 'BC', 'V1V 2X9', 'Canada', 'darren' , '304Darren!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Elizabeth', 'Elliott', 'engel@uiowa.edu', '555-666-7777', '555 Everwood Street', 'Iowa City', 'IA', '52241', 'United States', 'beth' , '304Beth!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Test', 'User', 'ubc@ubc.ca', '250-807-8000', '3333 University Way', 'Kelowna', 'BC', 'V1V 1V7', 'Canada', 'testuser' , 'test');

-- Order 1 can be shipped as have enough inventory
DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (1, '2023-12-01 10:25:55', 91.50)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 2, 3, 6.50)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 20, 2, 25.00)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 17, 1, 22.00);

INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (2, '2023-12-01 18:00:00', 25.00)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 20, 1, 25.00);

-- Order 3 cannot be shipped as do not have enough inventory for item 7
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (3, '2023-12-02 3:30:22', 89.00)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 31, 2, 22.00)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 34, 3, 15.00);

INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (2, '2023-12-03 05:45:11', 171.50)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 3, 2, 6.50)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 8, 3, 8.50)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 13, 2, 5.50)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 28, 2, 19.00)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 29, 4, 21.00);

INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (5, '2023-12-03 10:25:55', 186.00)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 39, 4, 18.00)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 19, 2, 19.50)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 20, 3, 25.00);

-- New SQL DDL for lab 10
UPDATE Product SET productImageURL = 'img/1.jpg' WHERE ProductId = 1;
UPDATE Product SET productImageURL = 'img/2.jpg' WHERE ProductId = 2;
UPDATE Product SET productImageURL = 'img/3.jpg' WHERE ProductId = 3;
UPDATE Product SET productImageURL = 'img/4.jpg' WHERE ProductId = 4;
UPDATE Product SET productImageURL = 'img/5.jpg' WHERE ProductId = 5;
UPDATE Product SET productImageURL = 'img/6.jpg' WHERE ProductId = 6;
UPDATE Product SET productImageURL = 'img/7.jpg' WHERE ProductId = 7;
UPDATE Product SET productImageURL = 'img/8.jpg' WHERE ProductId = 8;
UPDATE Product SET productImageURL = 'img/9.jpg' WHERE ProductId = 9;
UPDATE Product SET productImageURL = 'img/10.jpg' WHERE ProductId = 10;
UPDATE Product SET productImageURL = 'img/11.jpg' WHERE ProductId = 11;
UPDATE Product SET productImageURL = 'img/12.jpg' WHERE ProductId = 12;
UPDATE Product SET productImageURL = 'img/13.jpg' WHERE ProductId = 13;
UPDATE Product SET productImageURL = 'img/14.jpg' WHERE ProductId = 14;
UPDATE Product SET productImageURL = 'img/15.jpg' WHERE ProductId = 15;
UPDATE Product SET productImageURL = 'img/16.jpg' WHERE ProductId = 16;
UPDATE Product SET productImageURL = 'img/17.jpg' WHERE ProductId = 17;
UPDATE Product SET productImageURL = 'img/18.jpg' WHERE ProductId = 18;
UPDATE Product SET productImageURL = 'img/19.jpg' WHERE ProductId = 19;
UPDATE Product SET productImageURL = 'img/20.jpg' WHERE ProductId = 20;
UPDATE Product SET productImageURL = 'img/21.jpg' WHERE ProductId = 21;
UPDATE Product SET productImageURL = 'img/22.jpg' WHERE ProductId = 22;
UPDATE Product SET productImageURL = 'img/23.jpg' WHERE ProductId = 23;
UPDATE Product SET productImageURL = 'img/24.jpg' WHERE ProductId = 24;
UPDATE Product SET productImageURL = 'img/25.jpg' WHERE ProductId = 25;
UPDATE Product SET productImageURL = 'img/26.jpg' WHERE ProductId = 26;
UPDATE Product SET productImageURL = 'img/27.jpg' WHERE ProductId = 27;
UPDATE Product SET productImageURL = 'img/28.jpg' WHERE ProductId = 28;
UPDATE Product SET productImageURL = 'img/29.jpg' WHERE ProductId = 29;
UPDATE Product SET productImageURL = 'img/30.jpg' WHERE ProductId = 30;
UPDATE Product SET productImageURL = 'img/31.jpg' WHERE ProductId = 31;
UPDATE Product SET productImageURL = 'img/32.jpg' WHERE ProductId = 32;
UPDATE Product SET productImageURL = 'img/33.jpg' WHERE ProductId = 33;
UPDATE Product SET productImageURL = 'img/34.jpg' WHERE ProductId = 34;
UPDATE Product SET productImageURL = 'img/35.jpg' WHERE ProductId = 35;
UPDATE Product SET productImageURL = 'img/36.jpg' WHERE ProductId = 36;
UPDATE Product SET productImageURL = 'img/37.jpg' WHERE ProductId = 37;
UPDATE Product SET productImageURL = 'img/38.jpg' WHERE ProductId = 38;
UPDATE Product SET productImageURL = 'img/39.jpg' WHERE ProductId = 39;
UPDATE Product SET productImageURL = 'img/40.jpg' WHERE ProductId = 40;
UPDATE Product SET productImageURL = 'img/41.jpg' WHERE ProductId = 41;
UPDATE Product SET productImageURL = 'img/42.jpg' WHERE ProductId = 42;
UPDATE Product SET productImageURL = 'img/43.jpg' WHERE ProductId = 43;
UPDATE Product SET productImageURL = 'img/44.jpg' WHERE ProductId = 44;
UPDATE Product SET productImageURL = 'img/45.jpg' WHERE ProductId = 45;
UPDATE Product SET productImageURL = 'img/46.jpg' WHERE ProductId = 46;
UPDATE Product SET productImageURL = 'img/47.jpg' WHERE ProductId = 47;
UPDATE Product SET productImageURL = 'img/48.jpg' WHERE ProductId = 48;
UPDATE Product SET productImageURL = 'img/49.jpg' WHERE ProductId = 49;
UPDATE Product SET productImageURL = 'img/50.jpg' WHERE ProductId = 50;