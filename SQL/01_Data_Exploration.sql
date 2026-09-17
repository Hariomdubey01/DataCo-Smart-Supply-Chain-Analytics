/* ============================================================
   DATACO SMART SUPPLY CHAIN ANALYTICS
   SQL PROJECT - DATA EXPLORATION & VALIDATION

   Database  : MySQL
   Dataset   : DataCo Smart Supply Chain Dataset
   Rows      : 180,519
   Columns   : 53

   Author    : Hariom Dubey
   ============================================================ */


/* ============================================================
   1. CREATE DATABASE
   ============================================================ */

CREATE DATABASE IF NOT EXISTS dataco_supply_chain;

USE dataco_supply_chain;


/* ============================================================
   2. CREATE MAIN TABLE
   ============================================================ */

DROP TABLE IF EXISTS datacosupplychaindataset;

CREATE TABLE datacosupplychaindataset (

    `Type` VARCHAR(50),

    `Days for shipping (real)` INT,
    `Days for shipment (scheduled)` INT,

    `Benefit per order` DECIMAL(15,4),
    `Sales per customer` DECIMAL(15,4),

    `Delivery Status` VARCHAR(50),
    `Late_delivery_risk` INT,

    `Category Id` INT,
    `Category Name` VARCHAR(150),

    `Customer City` VARCHAR(100),
    `Customer Country` VARCHAR(100),
    `Customer Email` VARCHAR(150),
    `Customer Fname` VARCHAR(100),
    `Customer Id` INT,
    `Customer Lname` VARCHAR(100),
    `Customer Password` VARCHAR(255),
    `Customer Segment` VARCHAR(100),
    `Customer State` VARCHAR(100),
    `Customer Street` VARCHAR(255),
    `Customer Zipcode` VARCHAR(50),

    `Department Id` INT,
    `Department Name` VARCHAR(150),

    `Latitude` DECIMAL(12,8),
    `Longitude` DECIMAL(12,8),

    `Market` VARCHAR(100),

    `Order City` VARCHAR(100),
    `Order Country` VARCHAR(100),
    `Order Customer Id` INT,

    `order date (DateOrders)` DATETIME,

    `Order Id` INT,

    `Order Item Cardprod Id` INT,
    `Order Item Discount` DECIMAL(15,4),
    `Order Item Discount Rate` DECIMAL(10,6),
    `Order Item Id` INT,
    `Order Item Product Price` DECIMAL(15,4),
    `Order Item Profit Ratio` DECIMAL(10,6),
    `Order Item Quantity` INT,

    `Sales` DECIMAL(15,4),
    `Order Item Total` DECIMAL(15,4),
    `Order Profit Per Order` DECIMAL(15,4),

    `Order Region` VARCHAR(100),
    `Order State` VARCHAR(150),
    `Order Status` VARCHAR(100),
    `Order Zipcode` VARCHAR(50),

    `Product Card Id` INT,
    `Product Category Id` INT,
    `Product Description` TEXT,
    `Product Image` TEXT,
    `Product Name` VARCHAR(255),
    `Product Price` DECIMAL(15,4),
    `Product Status` INT,

    `shipping date (DateOrders)` DATETIME,

    `Shipping Mode` VARCHAR(100)
);


/* ============================================================
   3. CHECK TABLE STRUCTURE
   ============================================================ */

DESCRIBE datacosupplychaindataset;


/* ============================================================
   4. DATA IMPORT
   ============================================================

   IMPORTANT:
   Replace the path below with the actual location of your CSV.

   Example Windows path:

   C:/Users/hario/Downloads/DataCo Smart Supply Chain Analytics/DataCoSupplyChainDataset.csv

   Run this only AFTER MySQL Workbench allows LOCAL INFILE.
   ============================================================ */


/*
LOAD DATA LOCAL INFILE
'C:/Users/hario/Downloads/DataCo Smart Supply Chain Analytics/DataCoSupplyChainDataset.csv'

INTO TABLE datacosupplychaindataset

CHARACTER SET latin1

FIELDS TERMINATED BY ','
ENCLOSED BY '"'

LINES TERMINATED BY '\r\n'

IGNORE 1 LINES;
*/


/* ============================================================
   5. BASIC DATA VALIDATION
   ============================================================ */

SELECT
    COUNT(*) AS total_rows
FROM datacosupplychaindataset;


/* ============================================================
   6. UNIQUE ORDERS
   ============================================================ */

SELECT
    COUNT(DISTINCT `Order Id`) AS total_orders
FROM datacosupplychaindataset;


/* ============================================================
   7. UNIQUE CUSTOMERS
   ============================================================ */

SELECT
    COUNT(DISTINCT `Order Customer Id`) AS total_customers
FROM datacosupplychaindataset;


/* ============================================================
   8. UNIQUE PRODUCTS
   ============================================================ */

SELECT
    COUNT(DISTINCT `Product Card Id`) AS total_products
FROM datacosupplychaindataset;


/* ============================================================
   9. TOTAL QUANTITY SOLD
   ============================================================ */

SELECT
    SUM(`Order Item Quantity`) AS total_quantity_sold
FROM datacosupplychaindataset;


/* ============================================================
   10. TOTAL SALES
   ============================================================ */

SELECT
    ROUND(SUM(`Sales`), 2) AS total_sales
FROM datacosupplychaindataset;


/* ============================================================
   11. TOTAL PROFIT
   ============================================================ */

SELECT
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit
FROM datacosupplychaindataset;


/* ============================================================
   12. PROFIT MARGIN
   ============================================================ */

SELECT
    ROUND(
        SUM(`Order Profit Per Order`)
        / NULLIF(SUM(`Sales`), 0) * 100,
        2
    ) AS profit_margin_percentage
FROM datacosupplychaindataset;


/* ============================================================
   13. AVERAGE ORDER VALUE
   ============================================================ */

SELECT
    ROUND(
        SUM(`Sales`)
        / NULLIF(COUNT(DISTINCT `Order Id`), 0),
        2
    ) AS average_order_value
FROM datacosupplychaindataset;


/* ============================================================
   14. AVERAGE SHIPPING DAYS
   ============================================================ */

SELECT
    ROUND(
        AVG(`Days for shipping (real)`),
        2
    ) AS average_shipping_days
FROM datacosupplychaindataset;


/* ============================================================
   15. LATE DELIVERY RISK
   ============================================================ */

SELECT
    ROUND(
        AVG(`Late_delivery_risk`) * 100,
        2
    ) AS late_delivery_risk_percentage
FROM datacosupplychaindataset;


/* ============================================================
   16. DATE RANGE
   ============================================================ */

SELECT
    MIN(`order date (DateOrders)`) AS first_order_date,
    MAX(`order date (DateOrders)`) AS last_order_date
FROM datacosupplychaindataset;


/* ============================================================
   17. DELIVERY STATUS DISTRIBUTION
   ============================================================ */

SELECT
    `Delivery Status`,
    COUNT(*) AS order_items,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM datacosupplychaindataset),
        2
    ) AS percentage
FROM datacosupplychaindataset
GROUP BY `Delivery Status`
ORDER BY order_items DESC;


/* ============================================================
   18. SHIPPING MODE DISTRIBUTION
   ============================================================ */

SELECT
    `Shipping Mode`,
    COUNT(DISTINCT `Order Id`) AS total_orders,
    ROUND(
        COUNT(DISTINCT `Order Id`) * 100.0 /
        (SELECT COUNT(DISTINCT `Order Id`)
         FROM datacosupplychaindataset),
        2
    ) AS order_share_percentage
FROM datacosupplychaindataset
GROUP BY `Shipping Mode`
ORDER BY total_orders DESC;


/* ============================================================
   19. NULL VALUE CHECK
   ============================================================ */

SELECT
    SUM(`Category Name` IS NULL) AS category_nulls,
    SUM(`Customer Country` IS NULL) AS customer_country_nulls,
    SUM(`Customer Segment` IS NULL) AS customer_segment_nulls,
    SUM(`Market` IS NULL) AS market_nulls,
    SUM(`Sales` IS NULL) AS sales_nulls,
    SUM(`Order Profit Per Order` IS NULL) AS profit_nulls,
    SUM(`Product Name` IS NULL) AS product_name_nulls,
    SUM(`Shipping Mode` IS NULL) AS shipping_mode_nulls
FROM datacosupplychaindataset;


/* ============================================================
   20. CUSTOMER SEGMENT OVERVIEW
   ============================================================ */

SELECT
    `Customer Segment`,
    COUNT(DISTINCT `Order Customer Id`) AS customers,
    COUNT(DISTINCT `Order Id`) AS orders,
    ROUND(SUM(`Sales`), 2) AS sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS profit
FROM datacosupplychaindataset
GROUP BY `Customer Segment`
ORDER BY sales DESC;


/* ============================================================
   21. MARKET OVERVIEW
   ============================================================ */

SELECT
    `Market`,
    COUNT(DISTINCT `Order Id`) AS orders,
    COUNT(DISTINCT `Order Customer Id`) AS customers,
    ROUND(SUM(`Sales`), 2) AS sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS profit
FROM datacosupplychaindataset
GROUP BY `Market`
ORDER BY sales DESC;


/* ============================================================
   22. CATEGORY OVERVIEW
   ============================================================ */

SELECT
    `Category Name`,
    COUNT(DISTINCT `Order Id`) AS orders,
    SUM(`Order Item Quantity`) AS quantity_sold,
    ROUND(SUM(`Sales`), 2) AS sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS profit
FROM datacosupplychaindataset
GROUP BY `Category Name`
ORDER BY sales DESC;


/* ============================================================
   23. SHIPPING MODE PERFORMANCE
   ============================================================ */

SELECT
    `Shipping Mode`,
    COUNT(DISTINCT `Order Id`) AS orders,

    ROUND(
        AVG(`Days for shipping (real)`),
        2
    ) AS avg_shipping_days,

    ROUND(
        AVG(`Late_delivery_risk`) * 100,
        2
    ) AS late_delivery_risk_percentage,

    ROUND(
        SUM(`Sales`),
        2
    ) AS sales,

    ROUND(
        SUM(`Order Profit Per Order`),
        2
    ) AS profit

FROM datacosupplychaindataset

GROUP BY `Shipping Mode`

ORDER BY late_delivery_risk_percentage DESC;


/* ============================================================
   24. TOP 10 PRODUCTS BY SALES
   ============================================================ */

SELECT
    `Product Name`,
    COUNT(DISTINCT `Order Id`) AS orders,
    SUM(`Order Item Quantity`) AS quantity_sold,
    ROUND(SUM(`Sales`), 2) AS sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS profit

FROM datacosupplychaindataset

GROUP BY `Product Name`

ORDER BY sales DESC

LIMIT 10;


/* ============================================================
   25. TOP 10 PRODUCTS BY PROFIT
   ============================================================ */

SELECT
    `Product Name`,
    ROUND(SUM(`Sales`), 2) AS sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS profit

FROM datacosupplychaindataset

GROUP BY `Product Name`

ORDER BY profit DESC

LIMIT 10;


/* ============================================================
   26. TOP 10 COUNTRIES BY SALES
   ============================================================ */

SELECT
    `Order Country`,
    COUNT(DISTINCT `Order Id`) AS orders,
    COUNT(DISTINCT `Order Customer Id`) AS customers,
    ROUND(SUM(`Sales`), 2) AS sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS profit

FROM datacosupplychaindataset

GROUP BY `Order Country`

ORDER BY sales DESC

LIMIT 10;


/* ============================================================
   27. TOP 10 COUNTRIES BY PROFIT
   ============================================================ */

SELECT
    `Order Country`,
    ROUND(SUM(`Sales`), 2) AS sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS profit

FROM datacosupplychaindataset

GROUP BY `Order Country`

ORDER BY profit DESC

LIMIT 10;


/* ============================================================
   28. MONTHLY SALES TREND
   ============================================================ */

SELECT
    DATE_FORMAT(
        `order date (DateOrders)`,
        '%Y-%m'
    ) AS order_month,

    ROUND(SUM(`Sales`), 2) AS sales,

    ROUND(
        SUM(`Order Profit Per Order`),
        2
    ) AS profit,

    COUNT(DISTINCT `Order Id`) AS orders

FROM datacosupplychaindataset

GROUP BY order_month

ORDER BY order_month;


/* ============================================================
   29. YEARLY PERFORMANCE
   ============================================================ */

SELECT
    YEAR(`order date (DateOrders)`) AS order_year,

    COUNT(DISTINCT `Order Id`) AS orders,

    COUNT(DISTINCT `Order Customer Id`) AS customers,

    ROUND(SUM(`Sales`), 2) AS sales,

    ROUND(
        SUM(`Order Profit Per Order`),
        2
    ) AS profit,

    ROUND(
        SUM(`Order Profit Per Order`)
        / NULLIF(SUM(`Sales`), 0) * 100,
        2
    ) AS profit_margin_percentage

FROM datacosupplychaindataset

GROUP BY order_year

ORDER BY order_year;


/* ============================================================
   30. FINAL PROJECT KPI VALIDATION
   ============================================================ */

SELECT

    COUNT(*) AS total_rows,

    COUNT(DISTINCT `Order Id`) AS total_orders,

    COUNT(DISTINCT `Order Customer Id`) AS total_customers,

    COUNT(DISTINCT `Product Card Id`) AS total_products,

    SUM(`Order Item Quantity`) AS quantity_sold,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(
        SUM(`Order Profit Per Order`),
        2
    ) AS total_profit,

    ROUND(
        SUM(`Order Profit Per Order`)
        / NULLIF(SUM(`Sales`), 0) * 100,
        2
    ) AS profit_margin_percentage,

    ROUND(
        SUM(`Sales`)
        / NULLIF(COUNT(DISTINCT `Order Id`), 0),
        2
    ) AS average_order_value,

    ROUND(
        AVG(`Days for shipping (real)`),
        2
    ) AS average_shipping_days,

    ROUND(
        AVG(`Late_delivery_risk`) * 100,
        2
    ) AS late_delivery_risk_percentage

FROM datacosupplychaindataset;


/* ============================================================
   END OF DATA EXPLORATION
   ============================================================ */
