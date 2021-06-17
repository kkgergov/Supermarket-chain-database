drop table if exists Store, Customer, Employee, Payment, Orders, ProductLine, Product, OrderDetails;

create table Store(
	StoreID int generated always as identity (START WITH 1 INCREMENT BY 1),
	Phone varchar(15),
	Country varchar(30),
	City varchar(30),
	AdressLine varchar(255),
	
	primary key(StoreID)
);

create table Employee(
	EmployeeID int generated always as identity (START WITH 1 INCREMENT BY 1),
	employee_StoreID int not null,
	FirstName varchar(30),
	MiddleInitial char(1),
	LastName varchar(30),
	Email varchar(50),
	JobTitle varchar(50),
	reports_to int,
	
	primary key(EmployeeID),
	foreign key (employee_StoreID) references Store(StoreID),
	foreign key (reports_to) references Employee(EmployeeID)
);

create table Customer(
	CustomerID int generated always as identity (START WITH 1 INCREMENT BY 1),
	customer_EmployeeID int,
	FirstName varchar(30),
	MiddleInitial char(1),
	LastName varchar(30),
	CreditLimit decimal(15,2),
	Phone varchar(15),
	PostalCode int,
	
	primary key(CustomerID),
	foreign key (customer_EmployeeID) references Employee(EmployeeID)
);

create table Payment(
	PaymentID int generated always as identity (START WITH 1 INCREMENT BY 1),
	payment_CustomerID int not null,
	PaymentDate timestamp,
	Amount decimal(15,2),
	
	primary key(PaymentID),
	foreign key (payment_CustomerID) references Customer(CustomerID)
);

create table Orders(
	OrderID int generated always as identity (START WITH 1 INCREMENT BY 1),
	order_CustomerID int not null,
	OrderDate timestamp,
	Status varchar(20),
	MiscComments varchar(255),
	
	primary key(OrderID),
	foreign key (order_CustomerID) references Customer(CustomerID)
);

create table ProductLine(
	ProductLineID int generated always as identity (START WITH 1 INCREMENT BY 1),
	CompanyName varchar(30),
	
	primary key(ProductLineID)
);

create table Product(
	ProductID int generated always as identity (START WITH 1 INCREMENT BY 1),
	product_ProductLineID int not null,
	ProductName varchar(50),
	Description varchar(255),
	QuantityInStock int,
	Price decimal(15,2),
	
	constraint fk foreign key (product_ProductLineID) references ProductLine(ProductLineID),
	primary key(ProductID)
);

create table OrderDetails(
	details_ProductID int not null,
	details_OrderID int not null,
	QuantityOrdered int,
	
	foreign key (details_ProductID) references Product(ProductID),
	foreign key (details_OrderID) references Orders(OrderID),
	unique (details_ProductID, details_OrderID)
);