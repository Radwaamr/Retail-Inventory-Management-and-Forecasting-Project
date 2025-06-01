CREATE DATABASE Retail_Inventory_DW;
USE Retail_Inventory_DW;

CREATE TABLE Dim_Date(
    Date_Key int PRIMARY KEY IDENTITY(1,1),
	Date DATE ,
	Day INT ,
	Month INT ,
	Quarter NVARCHAR(2) ,
	Year INT,
	DayOfWeek INT,
	Holiday_Promotion INT ,
	Seasonality VARCHAR(20)
	);

ALTER TABLE Dim_Date ALTER COLUMN DayOfWeek NVARCHAR(20);

CREATE TABLE Dim_Store(
	Store_Key INT PRIMARY KEY IDENTITY(1,1),
	Store_ID NVARCHAR(10),
	Region VARCHAR(50)
	);

CREATE TABLE Dim_Product(
	Product_Key INT PRIMARY KEY IDENTITY(1,1),
	Product_ID NVARCHAR(10),
	Category NVARCHAR(50),
	Price FLOAT
	);

CREATE TABLE Dim_Weather(
	Weather_Key INT PRIMARY KEY IDENTITY(1,1),
	Weather_Condition NVARCHAR(20),
	Region VARCHAR(50)
	);

CREATE TABLE Dim_Promotion (
	Promotion_Key INT PRIMARY KEY IDENTITY(1,1),
	Discount INT,
	Holiday_Promotion INT
	);

CREATE TABLE Dim_Inventory(
	Inventory_Key INT PRIMARY KEY IDENTITY(1,1),
	Inventory_Level INT 
	);

CREATE TABLE Dim_Forecast(
	Forecast_Key INT PRIMARY KEY IDENTITY(1,1),
	Demand_Forecast FLOAT
	);
	 
CREATE TABLE Dim_Competitor(
	Competitor_Key INT PRIMARY KEY IDENTITY(1,1),
	Product_ID INT , 
	Region VARCHAR(20),
	Competitor_Pricing FLOAT
	);
	 
CREATE TABLE Fact_Sales(
	Sales_ID INT PRIMARY KEY IDENTITY(1,1),
	Product_Key INT,
	Store_Key INT,
	Inventory_Key INT,
	Date_Key INT,
	Weather_Key INT,
	Promotion_Key INT,
	Competitor_Key INT,
	Forecast_Key INT,
	Unit_Sold INT,
	Unit_Ordered INT,
	FOREIGN KEY (Product_Key) REFERENCES Dim_Product(Product_Key),
	FOREIGN KEY (Store_Key) REFERENCES Dim_Store(Store_Key),
	FOREIGN KEY (Inventory_Key) REFERENCES Dim_Inventory(Inventory_Key),
	FOREIGN KEY (Date_Key) REFERENCES Dim_Date(Date_Key),
	FOREIGN KEY (Promotion_Key) REFERENCES Dim_Promotion(Promotion_Key),
	FOREIGN KEY (Competitor_Key) REFERENCES Dim_Competitor(Competitor_Key),
	FOREIGN KEY (Forecast_Key) REFERENCES Dim_Forecast(Forecast_Key),
	FOREIGN KEY (Weather_Key) REFERENCES Dim_Weather(Weather_Key)
	);




