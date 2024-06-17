-- inventory-schema.sql

-- Creación de la tabla de Productos
CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(255) NOT NULL,
    Description TEXT,
    Price DECIMAL(10, 2),
    CategoryID INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- Creación de la tabla de Categorías
CREATE TABLE Categories (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(255) NOT NULL,
    Description TEXT
);

-- Creación de la tabla de Proveedores
CREATE TABLE Suppliers (
    SupplierID INT AUTO_INCREMENT PRIMARY KEY,
    SupplierName VARCHAR(255) NOT NULL,
    ContactName VARCHAR(255),
    Address VARCHAR(255),
    City VARCHAR(100),
    PostalCode VARCHAR(10),
    Country VARCHAR(100),
    Phone VARCHAR(20)
);

-- Creación de la tabla de Inventario
CREATE TABLE Inventory (
    InventoryID INT AUTO_INCREMENT PRIMARY KEY,
    ProductID INT NOT NULL,
    SupplierID INT,
    Quantity INT DEFAULT 0,
    ReorderLevel INT,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

-- Creación de la tabla de Movimientos de Inventario
CREATE TABLE InventoryTransactions (
    TransactionID INT AUTO_INCREMENT PRIMARY KEY,
    InventoryID INT NOT NULL,
    TransactionType VARCHAR(50), -- 'entrada', 'salida'
    Quantity INT,
    TransactionDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (InventoryID) REFERENCES Inventory(InventoryID)
);

-- Índices para mejorar el rendimiento en búsquedas frecuentes
CREATE INDEX IDX_Products_Name ON Products(ProductName);
CREATE INDEX IDX_Categories_Name ON Categories(CategoryName);
CREATE INDEX IDX_Suppliers_Name ON Suppliers(SupplierName);

-- Vistas para facilitar consultas recurrentes
CREATE VIEW v_ProductInventory AS
SELECT
    p.ProductID,
    p.ProductName,
    c.CategoryName,
    s.SupplierName,
    i.Quantity,
    i.ReorderLevel
FROM
    Inventory i
JOIN
    Products p ON i.ProductID = p.ProductID
LEFT JOIN
    Categories c ON p.CategoryID = c.CategoryID
LEFT JOIN
    Suppliers s ON i.SupplierID = s.SupplierID;

-- Procedimientos almacenados para operaciones comunes
CREATE PROCEDURE sp_UpdateInventory (@ProductID INT, @Quantity INT, @TransactionType VARCHAR(50))
AS
BEGIN
    -- Actualizar inventario
    UPDATE Inventory
    SET Quantity = CASE 
        WHEN @TransactionType = 'entrada' THEN Quantity + @Quantity
        WHEN @TransactionType = 'salida' THEN Quantity - @Quantity
        ELSE Quantity
    END
    WHERE ProductID = @ProductID;

    -- Registrar la transacción
    INSERT INTO InventoryTransactions (InventoryID, TransactionType, Quantity)
    VALUES ((SELECT InventoryID FROM Inventory WHERE ProductID = @ProductID), @TransactionType, @Quantity);
END;
