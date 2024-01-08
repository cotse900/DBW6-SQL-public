CREATE TABLE [Products_dimension] (
  [ProductID] INT,
  [SKU] INT,
  [ProductName] VARCHAR(50) not null, --added
  [ProductVariant] VARCHAR(50), --renamed
  [ProductPrice] Decimal(10,2) not null check ([ProductPrice] >= 0) default 0.0,
  [ProductDesc] VARCHAR(255),
  [ProductCost] Decimal(10,2) not null check ([ProductCost] >= 0) default 0.0, --added in v2
  check ([ProductPrice] > [ProductCost]),
  PRIMARY KEY ([ProductID])
);

CREATE TABLE [Stores_dimension] (
  [StoreID] INT,
  [StoreName] VARCHAR(50) not null,
  [StoreAddress] VARCHAR(255) not null,
  [StoreProvince] VARCHAR(50) not null,
  [CityRegion] VARCHAR(50) not null,
  [PostalCode] VARCHAR(10) not null,
  PRIMARY KEY ([StoreID]) --renamed
);

CREATE TABLE [Date_dimension] (
  [DateID] INT,
  [Date_] Date not null, --renamed
  [Quarter] INT not null,
  [Year] INT not null check ([Year] > 2020),
  PRIMARY KEY ([DateID])
);

CREATE TABLE [Payment_dimension] (
  [PaymentID] INT,
  [PaymentType] VARCHAR(50) not null,
  [PaymentAmount] Decimal(10,2) not null default 0.0,
  PRIMARY KEY ([PaymentID])
);

CREATE TABLE [Customers_dimension] (
  [CustomerID] INT,
  [CustFirstName] VARCHAR(255) not null,
  [CustFamilyName] VARCHAR(255),
  [CustAddress] VARCHAR(255) not null,
  [CustDOB] Date not null check ([CustDOB] > '1901-01-01'),
  [Gender] VARCHAR(20) not null,
  PRIMARY KEY ([CustomerID])
);

CREATE TABLE [AgeGroup_dimension] (
  [AgeGroupID] INT,
  [AgeGroupName] VARCHAR(50) not null,
  [AgeBegin] INT not null check ([AgeBegin] >= 0),
  [AgeEnd] INT not null check ([AgeEnd] > 0),
  check ([AgeEnd] > [AgeBegin]),
  PRIMARY KEY ([AgeGroupID])
);

CREATE TABLE [Salesrep_dimension] (
  [SalesRepID] INT,
  [SalesRepName] VARCHAR(255) not null,
  [JobTitle] VARCHAR(50) not null,
  [Gender] VARCHAR(20) not null, --updated
  [ManagerID] INT,
  PRIMARY KEY ([SalesRepID])
);

CREATE TABLE [Marketing_campaign_dimension] (
  [MktID] INT,
  [MktName] VARCHAR(50) not null,
  [MktDesc] VARCHAR(255) not null,
  [Discount] Decimal(10,2) not null check ([Discount] >= 0) default 0.0, --rename
  [MktStartDate] Date not null check ([MktStartDate] > '2020-01-01'),
  [MktEndDate] Date not null,
  check ([MktEndDate] >= [MktStartDate]),
  PRIMARY KEY ([MktID])
);

CREATE TABLE [Sales_fact] (
  [SurrogateID] INT,
  [Transaction_ID_DD] INT not null,
  [SalesID] INT not null,
  [ProductID] INT not null,
  [StoreID] INT not null,
  [DateID] INT not null,
  [PaymentID] INT not null,
  [CustomerID] INT not null,
  [AgeGroupID] INT not null,
  [SalesRepID] INT not null,
  [MktID] INT not null,
  [Quantity] Decimal(10,2) not null default 0.0,
  [ListPrice] Decimal(10,2) not null default 0.0,
  [Revenue] Decimal(10,2) not null default 0.0, --ListPrice X Qty - Discount
  [Tax] Decimal(10,2) not null default 0.0, --Revenue X 0.13
  [DiscountAmount] Decimal(10,2) not null default 0.0, --deleted profit; discount = discount X qty when ListPrice > 10
  PRIMARY KEY ([SurrogateID]),
  CONSTRAINT [FK_Sales_fact.ProductID]
    FOREIGN KEY ([ProductID])
      REFERENCES [Products_dimension]([ProductID]),
  CONSTRAINT [FK_Sales_fact.StoreID]
    FOREIGN KEY ([StoreID])
      REFERENCES [Stores_dimension]([StoreID]),
  CONSTRAINT [FK_Sales_fact.DateID]
    FOREIGN KEY ([DateID])
      REFERENCES [Date_dimension]([DateID]),
  CONSTRAINT [FK_Sales_fact.PaymentID]
    FOREIGN KEY ([PaymentID])
      REFERENCES [Payment_dimension]([PaymentID]),
  CONSTRAINT [FK_Sales_fact.CustomerID]
    FOREIGN KEY ([CustomerID])
      REFERENCES [Customers_dimension]([CustomerID]),
  CONSTRAINT [FK_Sales_fact.AgeGroupID]
    FOREIGN KEY ([AgeGroupID])
      REFERENCES [AgeGroup_dimension]([AgeGroupID]),
  CONSTRAINT [FK_Sales_fact.SalesRepID]
    FOREIGN KEY ([SalesRepID])
      REFERENCES [Salesrep_dimension]([SalesRepID]),
  CONSTRAINT [FK_Sales_fact.MktID]
    FOREIGN KEY ([MktID])
      REFERENCES [Marketing_campaign_dimension]([MktID])
);

CREATE TABLE [Definition] (
  [DefID] INT,
  [TableName] VARCHAR(50) not null,
  [ColumnName] VARCHAR(50) not null,
  [DefDesc] VARCHAR(255) not null,
  PRIMARY KEY ([DefID])
);
--20 products
INSERT INTO [Products_dimension] ([ProductID], [SKU], [ProductName], [ProductVariant], [ProductPrice], [ProductDesc], [ProductCost])
VALUES
  (10001, 1001, 'Golf Club', 'Red', 250.00, 'High-quality golf club', 70.00),
  (10002, 1002, 'Magnet Set', 'Assorted Colors', 2.50, 'Decorative magnets', 0.50),
  (10003, 1003, 'Bedroom Door Sign', 'Wooden', 15.99, 'Custom bedroom door sign', 5.00),
  (10004, 1004, 'Graduation Plaque', 'Gold', 45.00, 'Personalized graduation plaque', 15.00),
  (10005, 1005, 'Retirement Plaque', 'Oak', 55.99, 'Retirement celebration plaque', 5.99),
  (10006, 1006, 'Sports Jersey', 'Blue', 75.00, 'Authentic sports jersey', 10.00),
  (10007, 1007, 'License Plate', 'Silver', 40.00, 'Custom license plate', 9.00),
  (10008, 1008, 'Coffee Mug Corelle', 'White', 5.99, 'Classic coffee mug by Corelle', 2.00),
  (10009, 1009, 'Sunglasses', 'Black', 20.50, 'Stylish sunglasses', 3.50),
  (10010, 1010, 'Laptop Bag Thule', 'Gray', 35.99, 'Durable laptop bag by Thule', 9.00),
  (10011, 1011, 'Desk Lamp Henkel', 'Silver', 21.99, 'Modern desk lamp by Henkel', 8.00),
  (10012, 1012, 'Plant Pot', 'Terracotta', 14.75, 'Plant pot for indoor plants', 5.00),
  (10013, 1013, 'Tablet Stand', 'Silver', 29.99, 'Adjustable tablet stand for convenience', 5.00),
  (10014, 1014, 'Laptop Backpack', 'Blue', 29.95, 'Backpack for a laptop', 8.00),
  (10015, 1015, 'Ceramic Bowl Corelle', 'Green', 6.99, 'Ceramic bowl Corelle', 1.99),
  (10016, 1016, 'Sculpture Art Piece', 'Bronze', 45.00, 'Handcrafted bronze sculpture art piece', 9.00),
  (10017, 1017, 'Earrings Claire', 'Silver', 12.00, 'Earrings by Claire', 2.00),
  (10018, 1018, 'Pencil Set Pentep', 'Assorted Colors', 5.99, 'Set of colorful pencils by Pentep', 1.99),
  (10019, 1019, 'Toothbrush Holder Colgate', 'White', 4.50, 'White toothbrush holder by Colgate', 1.20),
  (10020, 1020, 'Bluetooth Speaker Antek', 'Red', 39.99, 'Portable Bluetooth speaker Antek', 5.99);
--5 stores
INSERT INTO [Stores_dimension] ([StoreID], [StoreName], [StoreAddress], [StoreProvince], [CityRegion], [PostalCode])
VALUES
  (81001, 'Eglinton', '123 Eglinton Ave', 'Ontario', 'Toronto', 'M4P 1G2'),
  (81002, 'Scarborough', '456 McCowan Rd', 'Ontario', 'Toronto', 'M1J 2K2'),
  (81003, 'Hamilton', '789 James St S', 'Ontario', 'Hamilton', 'L8P 3B4'),
  (81004, 'Ottawa', '101 Bank St', 'Ontario', 'Ottawa', 'K1P 1H7'),
  (81005, 'Sudbury', '321 Elgin St', 'Ontario', 'Sudbury', 'P3E 3N5');
--5 dates
INSERT INTO [Date_dimension] ([DateID], [Date_], [Quarter], [Year])
VALUES
  (23278, '2023-10-05', 4, 2023),
  (23279, '2023-10-06', 4, 2023),
  (23280, '2023-10-07', 4, 2023),
  (23281, '2023-10-08', 4, 2023),
  (23282, '2023-10-09', 4, 2023);
--2 payment methods
INSERT INTO [Payment_dimension] ([PaymentID], [PaymentType], [PaymentAmount])
VALUES
  (101, 'Credit Card', 0.00),
  (102, 'Debit Card', 0.00);
--10 customers
INSERT INTO [Customers_dimension] ([CustomerID], [CustFirstName], [CustFamilyName], [CustAddress], [CustDOB], [Gender])
VALUES
(50001, 'Lisa', 'Simpson', '101 Maple St, Hamilton', '2016-05-09', 'Female'),
(50002, 'Maggie', 'Simpson', '321 Birch St, Hamilton', '2019-02-22', 'Female'),
(50003, 'Bart', 'Simpson', '789 Oak St, Toronto', '2003-04-01', 'Male'),
(50004, 'Milhouse', 'Van Houten', '222 Elm St, Sudbury', '2001-08-02', 'Male'),
(50005, 'Homer', 'Simpson', '123 Main St, Toronto', '1970-05-12', 'Male'),
(50006, 'Marge', 'Simpson', '456 Elm St, Toronto', '1972-04-19', 'Female'),
(50007, 'Ned', 'Flanders', '555 Pine St, Ottawa', '1950-02-28', 'Male'),
(50008, 'Seymour', 'Skinner', '777 Spruce St, Ottawa', '1965-09-23', 'Male'),
(50009, 'Apu', 'Nahasapeemapetilon', '999 Cedar St, Sudbury', '1976-12-15', 'Male'),
(50010, 'Abraham', 'Simpson', '111 Oak St, Sudbury', '1920-11-25', 'Male');

--4 age groups
INSERT INTO [AgeGroup_dimension] ([AgeGroupID], [AgeGroupName], [AgeBegin], [AgeEnd])
VALUES
  (40001, 'Infants', 0, 12),
  (40002, 'Teenagers', 13, 25),
  (40003, 'Adults', 26, 59),
  (40004, 'Seniors', 60, 120);
--10 sales reps
INSERT INTO [Salesrep_dimension] ([SalesRepID], [SalesRepName], [JobTitle], [Gender], [ManagerID])
VALUES
  (30001, 'Monkey D. Luffy', 'Sales Manager', 'Male', NULL),
  (30002, 'Roronoa Zoro', 'Sales Representative', 'Male', 30001),
  (30003, 'Usopp', 'Sales Representative', 'Male', 30001),
  (30004, 'Sanji', 'Sales Representative', 'Male', 30001),
  (30005, 'Tony Tony Chopper', 'Sales Representative', 'Male', 30001),
  (30006, 'Nami', 'Sales Representative', 'Female', 30001),
  (30007, 'Nico Robin', 'Sales Representative', 'Female', 30001),
  (30008, 'Nefertari Vivi', 'Sales Representative', 'Female', 30001),
  (30009, 'Boa Hancock', 'Sales Representative', 'Female', 30001),
  (30010, 'Jewelry Bonney', 'Sales Representative', 'Female', 30001);
--1 marketing campaign
INSERT INTO [Marketing_campaign_dimension] ([MktID], [MktName], [MktDesc], [Discount], [MktStartDate], [MktEndDate])
VALUES
  (90001, 'Thanksgiving 2023', 'Big discounts for the fall season', 5.00, '2023-10-1', '2023-10-9');
--10 definitions
INSERT INTO [Definition] ([DefID], [TableName], [ColumnName], [DefDesc])
VALUES
  (1001, 'Products_dimension', 'ProductName', 'Name of the product.'),
  (1002, 'Products_dimension', 'ProductColour', 'Color or variant of the product.'),
  (1003, 'Stores_dimension', 'StoreName', 'Name of the store.'),
  (1004, 'Date_dimension', 'Date_', 'Date of transaction.'),
  (1005, 'Payment_dimension', 'PaymentType', 'Type of payment.'),
  (1006, 'Sales_fact', 'SalesID', 'Unique identifier for each sales record in the Sales_fact table.'),
  (1007, 'Customers_dimension', 'CustDOB', 'Date of birth of the customer.'),
  (1008, 'AgeGroup_dimension', 'AgeGroupName', 'Name of the age group, connected to Customers_dimension'),
  (1009, 'Salesrep_dimension', 'JobTitle', 'Job title of the sales representative.'),
  (1010, 'Marketing_campaign_dimension', 'MktName', 'Name of the marketing campaign.');
--100 sales fact entries

INSERT INTO [Sales_fact] ([SurrogateID], [Transaction_ID_DD], [SalesID], [ProductID], [StoreID], [DateID], [PaymentID], [CustomerID], [AgeGroupID], [SalesRepID], [MktID], [Quantity], [ListPrice], [Revenue], [Tax], [DiscountAmount]) VALUES
	(1, 60001, 75001, 10002, 81004, 23280, 102, 50009, 40003, 30001, 90001, 7, 2.5, 17.5, 2.275, 0),
	(2, 60002, 75002, 10013, 81004, 23279, 101, 50003, 40002, 30007, 90001, 6, 29.99, 149.94, 19.4922, 30),
	(3, 60003, 75003, 10009, 81005, 23278, 101, 50007, 40003, 30001, 90001, 3, 20.5, 46.5, 6.045, 15),
	(4, 60004, 75004, 10013, 81001, 23280, 101, 50010, 40004, 30001, 90001, 2, 29.99, 49.98, 6.4974, 10),
	(5, 60005, 75005, 10018, 81004, 23278, 101, 50010, 40004, 30008, 90001, 10, 5.99, 59.9, 7.787, 0),
	(6, 60006, 75006, 10015, 81005, 23278, 102, 50001, 40001, 30008, 90001, 7, 6.99, 48.93, 6.3609, 0),
	(7, 60007, 75007, 10016, 81003, 23278, 102, 50007, 40003, 30002, 90001, 6, 45, 240, 31.2, 30),
	(8, 60008, 75008, 10005, 81005, 23281, 101, 50004, 40002, 30001, 90001, 9, 55.99, 458.91, 59.6583, 45),
	(9, 60009, 75009, 10017, 81005, 23279, 102, 50008, 40003, 30003, 90001, 1, 12, 7, 0.91, 5),
	(10, 60010, 75010, 10011, 81003, 23278, 101, 50009, 40003, 30002, 90001, 6, 21.99, 101.94, 13.2522, 30),
	(11, 60011, 75011, 10002, 81002, 23278, 101, 50010, 40004, 30007, 90001, 9, 2.5, 22.5, 2.925, 0),
	(12, 60012, 75012, 10005, 81003, 23278, 102, 50008, 40003, 30006, 90001, 9, 55.99, 458.91, 59.6583, 45),
	(13, 60013, 75013, 10002, 81001, 23280, 102, 50006, 40003, 30006, 90001, 5, 2.5, 12.5, 1.625, 0),
	(14, 60014, 75014, 10002, 81002, 23280, 102, 50010, 40004, 30003, 90001, 1, 2.5, 2.5, 0.325, 0),
	(15, 60015, 75015, 10005, 81002, 23278, 101, 50004, 40002, 30001, 90001, 1, 55.99, 50.99, 6.6287, 5),
	(16, 60016, 75016, 10009, 81002, 23278, 102, 50007, 40003, 30008, 90001, 10, 20.5, 155, 20.15, 50),
	(17, 60017, 75017, 10005, 81004, 23282, 102, 50007, 40003, 30009, 90001, 6, 55.99, 305.94, 39.7722, 30),
	(18, 60018, 75018, 10015, 81004, 23280, 102, 50005, 40003, 30001, 90001, 4, 6.99, 27.96, 3.6348, 0),
	(19, 60019, 75019, 10010, 81005, 23281, 102, 50006, 40003, 30006, 90001, 7, 35.99, 216.93, 28.2009, 35),
	(20, 60020, 75020, 10012, 81002, 23279, 102, 50005, 40003, 30002, 90001, 4, 14.75, 39, 5.07, 20),
	(21, 60021, 75021, 10020, 81001, 23278, 102, 50004, 40002, 30004, 90001, 5, 39.99, 174.95, 22.7435, 25),
	(22, 60022, 75022, 10012, 81003, 23280, 102, 50004, 40002, 30003, 90001, 7, 14.75, 68.25, 8.8725, 35),
	(23, 60023, 75023, 10014, 81004, 23282, 102, 50006, 40003, 30004, 90001, 6, 29.95, 149.7, 19.461, 30),
	(24, 60024, 75024, 10006, 81001, 23282, 102, 50007, 40003, 30001, 90001, 9, 75, 630, 81.9, 45),
	(25, 60025, 75025, 10008, 81005, 23278, 102, 50006, 40003, 30005, 90001, 9, 5.99, 53.91, 7.0083, 0),
	(26, 60026, 75026, 10010, 81004, 23278, 102, 50005, 40003, 30007, 90001, 7, 35.99, 216.93, 28.2009, 35),
	(27, 60027, 75027, 10013, 81002, 23280, 102, 50005, 40003, 30003, 90001, 3, 29.99, 74.97, 9.7461, 15),
	(28, 60028, 75028, 10018, 81004, 23280, 102, 50003, 40002, 30002, 90001, 3, 5.99, 17.97, 2.3361, 0),
	(29, 60029, 75029, 10013, 81003, 23279, 101, 50006, 40003, 30002, 90001, 8, 29.99, 199.92, 25.9896, 40),
	(30, 60030, 75030, 10019, 81001, 23278, 101, 50008, 40003, 30004, 90001, 5, 4.5, 22.5, 2.925, 0),
	(31, 60031, 75031, 10001, 81003, 23278, 102, 50005, 40003, 30003, 90001, 5, 250, 1225, 159.25, 25),
	(32, 60032, 75032, 10011, 81001, 23281, 102, 50001, 40001, 30004, 90001, 9, 21.99, 152.91, 19.8783, 45),
	(33, 60033, 75033, 10007, 81002, 23281, 101, 50002, 40001, 30009, 90001, 9, 40, 315, 40.95, 45),
	(34, 60034, 75034, 10019, 81001, 23279, 101, 50002, 40001, 30001, 90001, 4, 4.5, 18, 2.34, 0),
	(35, 60035, 75035, 10011, 81002, 23278, 102, 50010, 40004, 30009, 90001, 3, 21.99, 50.97, 6.6261, 15),
	(36, 60036, 75036, 10013, 81005, 23279, 102, 50001, 40001, 30005, 90001, 4, 29.99, 99.96, 12.9948, 20),
	(37, 60037, 75037, 10016, 81001, 23278, 101, 50004, 40002, 30004, 90001, 1, 45, 40, 5.2, 5),
	(38, 60038, 75038, 10009, 81003, 23279, 101, 50003, 40002, 30006, 90001, 4, 20.5, 62, 8.06, 20),
	(39, 60039, 75039, 10020, 81002, 23280, 101, 50006, 40003, 30008, 90001, 4, 39.99, 139.96, 18.1948, 20),
	(40, 60040, 75040, 10001, 81004, 23282, 101, 50009, 40003, 30006, 90001, 4, 250, 980, 127.4, 20),
	(41, 60041, 75041, 10005, 81001, 23278, 101, 50003, 40002, 30004, 90001, 6, 55.99, 305.94, 39.7722, 30),
	(42, 60042, 75042, 10008, 81004, 23279, 102, 50007, 40003, 30006, 90001, 1, 5.99, 5.99, 0.7787, 0),
	(43, 60043, 75043, 10008, 81004, 23279, 102, 50010, 40004, 30002, 90001, 3, 5.99, 17.97, 2.3361, 0),
	(44, 60044, 75044, 10009, 81002, 23280, 101, 50007, 40003, 30003, 90001, 6, 20.5, 93, 12.09, 30),
	(45, 60045, 75045, 10007, 81005, 23281, 102, 50009, 40003, 30006, 90001, 8, 40, 280, 36.4, 40),
	(46, 60046, 75046, 10005, 81001, 23278, 102, 50003, 40002, 30001, 90001, 7, 55.99, 356.93, 46.4009, 35),
	(47, 60047, 75047, 10001, 81004, 23280, 102, 50006, 40003, 30009, 90001, 1, 250, 245, 31.85, 5),
	(48, 60048, 75048, 10010, 81004, 23281, 101, 50007, 40003, 30002, 90001, 3, 35.99, 92.97, 12.0861, 15),
	(49, 60049, 75049, 10006, 81003, 23280, 101, 50007, 40003, 30006, 90001, 7, 75, 490, 63.7, 35),
	(50, 60050, 75050, 10010, 81005, 23278, 102, 50006, 40003, 30004, 90001, 8, 35.99, 247.92, 32.2296, 40),
	(51, 60051, 75051, 10011, 81001, 23278, 102, 50005, 40003, 30009, 90001, 1, 21.99, 16.99, 2.2087, 5),
	(52, 60052, 75052, 10009, 81002, 23282, 102, 50001, 40001, 30008, 90001, 5, 20.5, 77.5, 10.075, 25),
	(53, 60053, 75053, 10006, 81003, 23280, 101, 50010, 40004, 30006, 90001, 6, 75, 420, 54.6, 30),
	(54, 60054, 75054, 10005, 81003, 23282, 102, 50002, 40001, 30002, 90001, 6, 55.99, 305.94, 39.7722, 30),
	(55, 60055, 75055, 10012, 81001, 23280, 102, 50004, 40002, 30008, 90001, 5, 14.75, 48.75, 6.3375, 25),
	(56, 60056, 75056, 10005, 81004, 23280, 102, 50002, 40001, 30005, 90001, 7, 55.99, 356.93, 46.4009, 35),
	(57, 60057, 75057, 10014, 81002, 23278, 102, 50008, 40003, 30001, 90001, 9, 29.95, 224.55, 29.1915, 45),
	(58, 60058, 75058, 10009, 81003, 23282, 102, 50004, 40002, 30006, 90001, 4, 20.5, 62, 8.06, 20),
	(59, 60059, 75059, 10013, 81004, 23282, 101, 50010, 40004, 30008, 90001, 6, 29.99, 149.94, 19.4922, 30),
	(60, 60060, 75060, 10001, 81005, 23282, 102, 50010, 40004, 30007, 90001, 4, 250, 980, 127.4, 20),
	(61, 60061, 75061, 10003, 81001, 23281, 101, 50009, 40003, 30001, 90001, 9, 15.99, 98.91, 12.8583, 45),
	(62, 60062, 75062, 10014, 81001, 23281, 101, 50006, 40003, 30002, 90001, 8, 29.95, 199.6, 25.948, 40),
	(63, 60063, 75063, 10005, 81003, 23278, 102, 50005, 40003, 30007, 90001, 1, 55.99, 50.99, 6.6287, 5),
	(64, 60064, 75064, 10016, 81004, 23280, 102, 50003, 40002, 30003, 90001, 4, 45, 160, 20.8, 20),
	(65, 60065, 75065, 10011, 81004, 23280, 101, 50008, 40003, 30007, 90001, 4, 21.99, 67.96, 8.8348, 20),
	(66, 60066, 75066, 10009, 81002, 23279, 101, 50008, 40003, 30003, 90001, 6, 20.5, 93, 12.09, 30),
	(67, 60067, 75067, 10009, 81004, 23278, 101, 50002, 40001, 30004, 90001, 3, 20.5, 46.5, 6.045, 15),
	(68, 60068, 75068, 10017, 81001, 23278, 102, 50009, 40003, 30001, 90001, 5, 12, 35, 4.55, 25),
	(69, 60069, 75069, 10015, 81003, 23279, 101, 50002, 40001, 30007, 90001, 8, 6.99, 55.92, 7.2696, 0),
	(70, 60070, 75070, 10018, 81004, 23282, 101, 50010, 40004, 30005, 90001, 10, 5.99, 59.9, 7.787, 0),
	(71, 60071, 75071, 10011, 81003, 23282, 102, 50010, 40004, 30003, 90001, 4, 21.99, 67.96, 8.8348, 20),
	(72, 60072, 75072, 10009, 81004, 23280, 102, 50010, 40004, 30004, 90001, 3, 20.5, 46.5, 6.045, 15),
	(73, 60073, 75073, 10001, 81002, 23281, 101, 50009, 40003, 30003, 90001, 4, 250, 980, 127.4, 20),
	(74, 60074, 75074, 10013, 81005, 23280, 101, 50003, 40002, 30006, 90001, 6, 29.99, 149.94, 19.4922, 30),
	(75, 60075, 75075, 10014, 81002, 23282, 101, 50004, 40002, 30002, 90001, 8, 29.95, 199.6, 25.948, 40),
	(76, 60076, 75076, 10019, 81003, 23282, 101, 50006, 40003, 30004, 90001, 8, 4.5, 36, 4.68, 0),
	(77, 60077, 75077, 10005, 81002, 23280, 102, 50004, 40002, 30006, 90001, 3, 55.99, 152.97, 19.8861, 15),
	(78, 60078, 75078, 10018, 81002, 23282, 102, 50010, 40004, 30008, 90001, 9, 5.99, 53.91, 7.0083, 0),
	(79, 60079, 75079, 10001, 81005, 23278, 101, 50008, 40003, 30006, 90001, 7, 250, 1715, 222.95, 35),
	(80, 60080, 75080, 10007, 81002, 23279, 101, 50002, 40001, 30008, 90001, 1, 40, 35, 4.55, 5),
	(81, 60081, 75081, 10004, 81003, 23280, 101, 50003, 40002, 30007, 90001, 6, 45, 240, 31.2, 30),
	(82, 60082, 75082, 10012, 81005, 23282, 102, 50005, 40003, 30006, 90001, 4, 14.75, 39, 5.07, 20),
	(83, 60083, 75083, 10006, 81001, 23278, 102, 50005, 40003, 30001, 90001, 1, 75, 70, 9.1, 5),
	(84, 60084, 75084, 10011, 81003, 23278, 102, 50006, 40003, 30002, 90001, 9, 21.99, 152.91, 19.8783, 45),
	(85, 60085, 75085, 10014, 81005, 23279, 102, 50007, 40003, 30007, 90001, 9, 29.95, 224.55, 29.1915, 45),
	(86, 60086, 75086, 10017, 81003, 23280, 101, 50007, 40003, 30009, 90001, 1, 12, 7, 0.91, 5),
	(87, 60087, 75087, 10001, 81003, 23282, 102, 50001, 40001, 30001, 90001, 5, 250, 1225, 159.25, 25),
	(88, 60088, 75088, 10016, 81003, 23279, 102, 50001, 40001, 30002, 90001, 1, 45, 40, 5.2, 5),
	(89, 60089, 75089, 10016, 81005, 23279, 102, 50001, 40001, 30002, 90001, 8, 45, 320, 41.6, 40),
	(90, 60090, 75090, 10002, 81002, 23280, 102, 50007, 40003, 30006, 90001, 5, 2.5, 12.5, 1.625, 0),
	(91, 60091, 75091, 10007, 81005, 23280, 101, 50005, 40003, 30005, 90001, 1, 40, 35, 4.55, 5),
	(92, 60092, 75092, 10009, 81001, 23279, 101, 50002, 40001, 30006, 90001, 10, 20.5, 155, 20.15, 50),
	(93, 60093, 75093, 10006, 81005, 23282, 102, 50003, 40002, 30003, 90001, 6, 75, 420, 54.6, 30),
	(94, 60094, 75094, 10001, 81002, 23281, 101, 50006, 40003, 30001, 90001, 5, 250, 1225, 159.25, 25),
	(95, 60095, 75095, 10019, 81005, 23282, 101, 50008, 40003, 30005, 90001, 7, 4.5, 31.5, 4.095, 0),
	(96, 60096, 75096, 10004, 81004, 23280, 101, 50006, 40003, 30005, 90001, 4, 45, 160, 20.8, 20),
	(97, 60097, 75097, 10015, 81003, 23280, 101, 50001, 40001, 30001, 90001, 6, 6.99, 41.94, 5.4522, 0),
	(98, 60098, 75098, 10002, 81004, 23279, 102, 50010, 40004, 30001, 90001, 3, 2.5, 7.5, 0.975, 0),
	(99, 60099, 75099, 10009, 81004, 23281, 101, 50002, 40001, 30006, 90001, 7, 20.5, 108.5, 14.105, 35),
	(100, 60100, 75100, 10014, 81001, 23281, 102, 50003, 40002, 30002, 90001, 9, 29.95, 224.55, 29.1915, 45);
--post-production
Select * from AgeGroup_dimension;
Select * from Customers_dimension;
Select * from Date_dimension;
Select * from Definition;
Select * from Marketing_campaign_dimension;
Select * from Payment_dimension;
Select count(*) from Products_dimension;
Select top 10 * from Products_dimension;
Select count(*) from Sales_fact;
Select top 10 * from Sales_fact;
Select * from Salesrep_dimension;
Select * from Stores_dimension;

DROP TABLE [Sales_fact];
DROP TABLE [Products_dimension];
DROP TABLE [Stores_dimension];
DROP TABLE [Date_dimension];
DROP TABLE [Payment_dimension];
DROP TABLE [Customers_dimension];
DROP TABLE [AgeGroup_dimension];
DROP TABLE [Salesrep_dimension];
DROP TABLE [Marketing_campaign_dimension];
DROP TABLE [Definition];