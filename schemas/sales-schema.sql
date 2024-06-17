-- sales-schema.sql

-- Creación de la tabla de Clientes
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    Address VARCHAR(255),
    City VARCHAR(50),
    State VARCHAR(50),
    PostalCode VARCHAR(10),
    Country VARCHAR(50)
);

-- Creación de la tabla de Productos
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Description TEXT,
    Price DECIMAL(10,2),
    Category VARCHAR(50),
    Stock INT
);

-- Creación de la tabla de Ventas
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    CustomerID INT,
    SaleDate DATETIME,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Creación de la tabla Detalles de Ventas
CREATE TABLE SaleDetails (
    SaleDetailID INT PRIMARY KEY,
    SaleID INT,
    ProductID INT,
    Quantity INT,
    PriceEach DECIMAL(10,2),
    FOREIGN KEY (SaleID) REFERENCES Sales(SaleID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Creación de la tabla de Categorías de Productos
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(100),
    Description TEXT
);

-- Relación entre Productos y Categorías
ALTER TABLE Products
ADD CONSTRAINT FK_Products_Categories
FOREIGN KEY (Category) REFERENCES Categories(CategoryName);

-- Ejemplos de índices para mejorar la performance en búsquedas
CREATE INDEX IDX_Customers_Name ON Customers(FirstName, LastName);
CREATE INDEX IDX_Products_Name ON Products(ProductName);
CREATE INDEX IDX_Sales_Date ON Sales(SaleDate);

-- Vistas para simplificar consultas complejas
CREATE VIEW v_SalesSummary AS
SELECT
    s.SaleID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    s.SaleDate,
    s.TotalAmount
FROM
    Sales s
JOIN
    Customers c ON s.CustomerID = c.CustomerID
ORDER BY
    s.SaleDate DESC;

-- Procedimientos almacenados para operaciones comunes
CREATE PROCEDURE sp_GetCustomerPurchases(@CustomerID INT)
AS
BEGIN
    SELECT
        s.SaleID,
        s.SaleDate,
        sd.ProductID,
        p.ProductName,
        sd.Quantity,
        sd.PriceEach,
        (sd.Quantity * sd.PriceEach) AS TotalPrice
    FROM
        Sales s
    JOIN
        SaleDetails sd ON s.SaleID = sd.SaleID
    JOIN
        Products p ON sd.ProductID = p.ProductID
    WHERE
        s.CustomerID = @CustomerID;
END;
