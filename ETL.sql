--Load the data into DimInventory
INSERT INTO Retail_Inventory_DW.dbo.Dim_Inventory (Inventory_Level)
SELECT DISTINCT Inventory_Level 
FROM Retail_Inventory_DB.dbo.Inventory

--Load the data into DimProduct
INSERT INTO Retail_Inventory_DW.dbo.Dim_Product (Product_ID,Category,Price)
SELECT DISTINCT Product_ID,Category,Price
FROM Retail_Inventory_DB.dbo.Products

--Load the data into DimStore
INSERT INTO Retail_Inventory_DW.dbo.Dim_Store(Store_ID,Region)
SELECT DISTINCT Store_ID,Region
FROM Retail_Inventory_DB.dbo.Stores


--Load the data into DimForecast
INSERT INTO Retail_Inventory_DW.dbo.Dim_Forecast(Demand_Forecast)
SELECT DISTINCT Demand_Forecast
FROM Retail_Inventory_DB.dbo.Forecast

--Load the data into DimPromotion
INSERT INTO Retail_Inventory_DW.dbo.Dim_Promotion(Discount,Holiday_Promotion)
SELECT DISTINCT Discount,Holiday_Promotion
FROM Retail_Inventory_DB.dbo.promotions

--Load the data into Dimcompetitor
INSERT INTO Retail_Inventory_DW.dbo.Dim_Competitor(Product_ID,Region,Competitor_Pricing)
SELECT DISTINCT Product_ID,Region,Competitor_Pricing
FROM Retail_Inventory_DB.dbo.Competitor

--Load the data into DimWeather
INSERT INTO Retail_Inventory_DW.dbo.Dim_Weather(Weather_Condition,Region)
SELECT DISTINCT Weather_Condition,Region
FROM Retail_Inventory_DB.dbo.Weather

--Load the data into DimDate
INSERT INTO Retail_Inventory_DW.dbo.Dim_Date(Date,Day,Month,Quarter,Year,DayOfWeek,Holiday_Promotion,Seasonality)
SELECT DISTINCT
Date,
DAY(Date) AS Day,
MONTH(Date) AS Month,
DATEPART(QUARTER, Date) AS Quarter,                 
YEAR(Date) AS Year,
DATENAME(WEEKDAY, Date) AS DayOfWeek,               
Holiday_Promotion,
Seasonality
FROM Retail_Inventory_DB.dbo.Dates

--Load the data in FactSales
INSERT INTO Retail_Inventory_DW.dbo.Fact_Sales (
    Product_Key,
    Store_Key,
    Inventory_Key,
    Date_Key,
    Weather_Key,
    Promotion_Key,
    Competitor_Key,
    Forecast_Key,
    Unit_Sold,
    Unit_Ordered
)
SELECT
    dp.Product_Key,
    ds.Store_Key,
    di.Inventory_Key,
    dd.Date_Key,
    dw.Weather_Key,
    dpromo.Promotion_Key,
    dc.Competitor_Key,
    df.Forecast_Key,
    s.Units_Sold,
    s.Units_Ordered
FROM Retail_Inventory_DB.dbo.Sales s
-- Join Product
JOIN Retail_Inventory_DB.dbo.Products p ON s.Product_ID = p.Product_Entry_ID
JOIN Retail_Inventory_DW.dbo.Dim_Product dp ON p.Product_ID = dp.Product_ID

-- Join Store
JOIN Retail_Inventory_DB.dbo.Stores st ON s.Store_ID = st.Store_Region_ID
JOIN Retail_Inventory_DW.dbo.Dim_Store ds ON st.Store_ID = ds.Store_ID

-- Join Date
JOIN Retail_Inventory_DB.dbo.Dates d ON CAST(s.Date AS DATE) = CAST(d.Date AS DATE)
JOIN Retail_Inventory_DW.dbo.Dim_Date dd ON 
    dd.Date = d.Date AND 
    dd.Holiday_Promotion = d.Holiday_Promotion AND 
    dd.Seasonality = d.Seasonality

-- Join Weather
JOIN Retail_Inventory_DB.dbo.Weather w ON CAST(s.Date AS DATE) = CAST(w.Date AS DATE) AND st.Region = w.Region
JOIN Retail_Inventory_DW.dbo.Dim_Weather dw ON dw.Weather_Condition = w.Weather_Condition AND dw.Region = w.Region

-- Join Promotion
JOIN Retail_Inventory_DB.dbo.Promotions promo ON CAST(s.Date AS DATE) = CAST(promo.Date AS DATE) AND promo.Product_ID = s.Product_ID
JOIN Retail_Inventory_DW.dbo.Dim_Promotion dpromo ON dpromo.Discount = promo.Discount AND dpromo.Holiday_Promotion = promo.Holiday_Promotion

-- Join Inventory
JOIN Retail_Inventory_DB.dbo.Inventory i ON CAST(s.Date AS DATE) = CAST(i.Date AS DATE) AND i.Product_ID = s.Product_ID AND i.Store_ID = s.Store_ID
JOIN Retail_Inventory_DW.dbo.Dim_Inventory di ON di.Inventory_Level = i.Inventory_Level

-- Join Forecast
JOIN Retail_Inventory_DB.dbo.Forecast f ON CAST(s.Date AS DATE) = CAST(f.Date AS DATE) AND f.Product_ID = s.Product_ID AND f.Store_ID = s.Store_ID
JOIN Retail_Inventory_DW.dbo.Dim_Forecast df ON df.Demand_Forecast = f.Demand_Forecast

-- Join Competitor
JOIN Retail_Inventory_DB.dbo.Competitor c ON CAST(s.Date AS DATE) = CAST(c.Date AS DATE) AND c.Product_ID = s.Product_ID
JOIN Retail_Inventory_DW.dbo.Dim_Competitor dc ON dc.Product_ID = c.Product_ID AND dc.Region = c.Region AND dc.Competitor_Pricing = c.Competitor_Pricing;