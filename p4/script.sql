SET NOCOUNT ON
GO

USE master
GO
if exists (select * from sysdatabases where name='NortedatabaseDW')
		drop database NortedatabaseDW
go

DECLARE @device_directory NVARCHAR(520)
SELECT @device_directory = SUBSTRING(filename, 1, CHARINDEX(N'master.mdf', LOWER(filename)) - 1)
FROM master.dbo.sysaltfiles WHERE dbid = 1 AND fileid = 1

EXECUTE (N'CREATE DATABASE NortedatabaseDW
  ON PRIMARY (NAME = N''NortedatabaseDW'', FILENAME = N''' + @device_directory + N'nortewndw.mdf'')
  LOG ON (NAME = N''NortedatabaseDW_log'',  FILENAME = N''' + @device_directory + N'nortewndw.ldf'')')
go

set quoted_identifier on
GO






CREATE TABLE "Empleados" (
	"EmployeeID" "int" IDENTITY (1, 1) NOT NULL ,
	"LastName" nvarchar (20) NOT NULL ,
	"FirstName" nvarchar (10) NOT NULL ,
	"City" nvarchar (15) NULL ,
	"PhotoPath" nvarchar (255) NULL ,
	CONSTRAINT "PK_Empleados" PRIMARY KEY  CLUSTERED 
	(
		"EmployeeID"
	)
)
GO

CREATE TABLE "Categorias" (
	"CategoryID" "int" IDENTITY (1, 1) NOT NULL ,
	"CategoryName" nvarchar (15) NOT NULL ,
	"Description" nvarchar (max) NULL ,
	"Picture" "image" NULL ,
	CONSTRAINT "PK_Categorias" PRIMARY KEY  CLUSTERED 
	(
		"CategoryID"
	)
)
GO

CREATE TABLE "Clientes" (
	"CustomerID" nchar (5) NOT NULL ,
	"CompanyName" nvarchar (40) NOT NULL ,
	"ContactName" nvarchar (30) NULL ,
	"City" nvarchar (15) NULL ,
	"Country" nvarchar (15) NULL ,
	CONSTRAINT "PK_Clientes" PRIMARY KEY  CLUSTERED 
	(
		"CustomerID"
	)
)
GO

CREATE TABLE "Transportes" (
	"ShipperID" "int" IDENTITY (1, 1) NOT NULL ,
	"CompanyName" nvarchar (40) NOT NULL ,
	"Phone" nvarchar (24) NULL ,
	CONSTRAINT "PK_Transportes" PRIMARY KEY  CLUSTERED 
	(
		"ShipperID"
	)
)
GO

CREATE TABLE "Proveedores" (
	"SupplierID" "int" IDENTITY (1, 1) NOT NULL ,
	"CompanyName" nvarchar (40) NOT NULL ,
	"ContactName" nvarchar (30) NULL ,
	"City" nvarchar (15) NULL ,
	"Country" nvarchar (15) NULL ,
	CONSTRAINT "PK_Proveedores" PRIMARY KEY  CLUSTERED 
	(
		"SupplierID"
	)
)
GO




CREATE TABLE "Ordenes" (
	"OrderID" "int" IDENTITY (1, 1) NOT NULL ,
	"CustomerID" nchar (5) NULL ,
	"EmployeeID" "int" NULL ,
	"OrderDate" "datetime" NULL ,
	"RequiredDate" "datetime" NULL ,
	"ShippedDate" "datetime" NULL ,
	"ShipVia" "int" NULL ,
	"Freight" "money" NULL CONSTRAINT "DF_Ordenes_Freight" DEFAULT (0),
	"ShipName" nvarchar (40) NULL ,
	"ShipAddress" nvarchar (60) NULL ,
	"ShipCity" nvarchar (15) NULL ,
	"ShipRegion" nvarchar (15) NULL ,
	"ShipPostalCode" nvarchar (10) NULL ,
	"ShipCountry" nvarchar (15) NULL ,
	CONSTRAINT "PK_Ordenes" PRIMARY KEY  CLUSTERED 
	(
		"OrderID"
	),
	CONSTRAINT "FK_Ordenes_Clientes" FOREIGN KEY 
	(
		"CustomerID"
	) REFERENCES "dbo"."Clientes" (
		"CustomerID"
	),
	CONSTRAINT "FK_Ordenes_Empleados" FOREIGN KEY 
	(
		"EmployeeID"
	) REFERENCES "dbo"."Empleados" (
		"EmployeeID"
	),
	CONSTRAINT "FK_Ordenes_Transportes" FOREIGN KEY 
	(
		"ShipVia"
	) REFERENCES "dbo"."Transportes" (
		"ShipperID"
	)
)
GO
 CREATE  INDEX "CustomerID" ON "dbo"."Ordenes"("CustomerID")
GO
 CREATE  INDEX "ClientesOrdenes" ON "dbo"."Ordenes"("CustomerID")
GO
 CREATE  INDEX "EmployeeID" ON "dbo"."Ordenes"("EmployeeID")
GO
 CREATE  INDEX "EmpleadosOrdenes" ON "dbo"."Ordenes"("EmployeeID")
GO
 CREATE  INDEX "OrderDate" ON "dbo"."Ordenes"("OrderDate")
GO
 CREATE  INDEX "ShippedDate" ON "dbo"."Ordenes"("ShippedDate")
GO
 CREATE  INDEX "TransportesOrdenes" ON "dbo"."Ordenes"("ShipVia")
GO
 CREATE  INDEX "ShipPostalCode" ON "dbo"."Ordenes"("ShipPostalCode")
GO


CREATE TABLE "Productos" (
	"ProductID" "int" IDENTITY (1, 1) NOT NULL ,
	"ProductName" nvarchar (40) NOT NULL ,
	"SupplierID" "int" NULL ,
	"CategoryID" "int" NULL ,
	"QuantityPerUnit" nvarchar (20) NULL ,
	"UnitPrice" "money" NULL CONSTRAINT "DF_Productos_UnitPrice" DEFAULT (0),
	"UnitsInStock" "smallint" NULL CONSTRAINT "DF_Productos_UnitsInStock" DEFAULT (0),
	"UnitsOnOrder" "smallint" NULL CONSTRAINT "DF_Productos_UnitsOnOrder" DEFAULT (0),
	"ReorderLevel" "smallint" NULL CONSTRAINT "DF_Productos_ReorderLevel" DEFAULT (0),
	"Discontinued" "bit" NOT NULL CONSTRAINT "DF_Productos_Discontinued" DEFAULT (0),
	CONSTRAINT "PK_Productos" PRIMARY KEY  CLUSTERED 
	(
		"ProductID"
	),
	CONSTRAINT "FK_Productos_Categorias" FOREIGN KEY 
	(
		"CategoryID"
	) REFERENCES "dbo"."Categorias" (
		"CategoryID"
	),
	CONSTRAINT "FK_Productos_Proveedores" FOREIGN KEY 
	(
		"SupplierID"
	) REFERENCES "dbo"."Proveedores" (
		"SupplierID"
	),
	CONSTRAINT "CK_Productos_UnitPrice" CHECK (UnitPrice >= 0),
	CONSTRAINT "CK_ReorderLevel" CHECK (ReorderLevel >= 0),
	CONSTRAINT "CK_UnitsInStock" CHECK (UnitsInStock >= 0),
	CONSTRAINT "CK_UnitsOnOrder" CHECK (UnitsOnOrder >= 0)
)
GO
 CREATE  INDEX "CategoriasProductos" ON "dbo"."Productos"("CategoryID")
GO
 CREATE  INDEX "CategoryID" ON "dbo"."Productos"("CategoryID")
GO
 CREATE  INDEX "ProductName" ON "dbo"."Productos"("ProductName")
GO
 CREATE  INDEX "SupplierID" ON "dbo"."Productos"("SupplierID")
GO
 CREATE  INDEX "ProveedoresProductos" ON "dbo"."Productos"("SupplierID")
GO

CREATE TABLE "DetalleOrdenes" (
	"OrderID" "int" NOT NULL ,
	"ProductID" "int" NOT NULL ,
	"UnitPrice" "money" NOT NULL CONSTRAINT "DF_Order_Details_UnitPrice" DEFAULT (0),
	"Quantity" "smallint" NOT NULL CONSTRAINT "DF_Order_Details_Quantity" DEFAULT (1),
	"Discount" "real" NOT NULL CONSTRAINT "DF_Order_Details_Discount" DEFAULT (0),
	CONSTRAINT "PK_Order_Details" PRIMARY KEY  CLUSTERED 
	(
		"OrderID",
		"ProductID"
	),
	CONSTRAINT "FK_Order_Details_Ordenes" FOREIGN KEY 
	(
		"OrderID"
	) REFERENCES "dbo"."Ordenes" (
		"OrderID"
	),
	CONSTRAINT "FK_Order_Details_Productos" FOREIGN KEY 
	(
		"ProductID"
	) REFERENCES "dbo"."Productos" (
		"ProductID"
	),
	CONSTRAINT "CK_Discount" CHECK (Discount >= 0 and (Discount <= 1)),
	CONSTRAINT "CK_Quantity" CHECK (Quantity > 0),
	CONSTRAINT "CK_UnitPrice" CHECK (UnitPrice >= 0)
)
CREATE TABLE "DimTime" (
	"IDTime" "datetime" NOT NULL ,
	"Date" date,
	"Year" int NOT NULL,
	"month" nvarchar(15) NULL,
	"Trimester" nvarchar(15) NULL,
	"dayweek" nvarchar(15) NULL,
	CONSTRAINT "PK_IDTime" PRIMARY KEY(IDTime)
)
GO
GO
 CREATE  INDEX "OrderID" ON "dbo"."DetalleOrdenes"("OrderID")
GO
 CREATE  INDEX "OrdenesOrder_Details" ON "dbo"."DetalleOrdenes"("OrderID")
GO
 CREATE  INDEX "ProductID" ON "dbo"."DetalleOrdenes"("ProductID")
GO
 CREATE  INDEX "ProductosOrder_Details" ON "dbo"."DetalleOrdenes"("ProductID")
GO