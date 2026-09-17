/* ============================================================
   DATACO SMART SUPPLY CHAIN ANALYTICS
   SQL PROJECT - PRODUCT & CATEGORY ANALYSIS

   Database : dataco_supply_chain
   Table    : datacosupplychaindataset
   Database : MySQL

   Purpose:
   - Product performance analysis
   - Category performance analysis
   - Revenue and profitability analysis
   - Quantity analysis
   - Top/Bottom products
   - Product concentration / Pareto analysis
   ============================================================ */


USE dataco_supply_chain;


/* ============================================================
   1. OVERALL PRODUCT PORTFOLIO
   ============================================================ */

SELECT
    COUNT(DISTINCT `Product Card Id`) AS total_products,

    COUNT(DISTINCT `Category Name`) AS total_categories,

    SUM(`Order Item Quantity`) AS total_quantity_sold,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit

FROM datacosupplychaindataset;


/* ============================================================
   2. CATEGORY PERFORMANCE OVERVIEW
   ============================================================ */

SELECT
    `Category Name` AS category,

    COUNT(DISTINCT `Product Card Id`) AS products,

    COUNT(DISTINCT `Order Id`) AS orders,

    SUM(`Order Item Quantity`) AS quantity_sold,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,

    ROUND(
        SUM(`Order Profit Per Order`)
        / NULLIF(SUM(`Sales`), 0) * 100,
        2
    ) AS profit_margin_percentage

FROM datacosupplychaindataset

GROUP BY `Category Name`

ORDER BY total_sales DESC;


/* ============================================================
   3. TOP 10 CATEGORIES BY SALES
   ============================================================ */

SELECT
    `Category Name` AS category,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    SUM(`Order Item Quantity`) AS quantity_sold,

    COUNT(DISTINCT `Order Id`) AS total_orders

FROM datacosupplychaindataset

GROUP BY `Category Name`

ORDER BY total_sales DESC

LIMIT 10;


/* ============================================================
   4. TOP 10 CATEGORIES BY PROFIT
   ============================================================ */

SELECT
    `Category Name` AS category,

    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(
        SUM(`Order Profit Per Order`)
        / NULLIF(SUM(`Sales`), 0) * 100,
        2
    ) AS profit_margin_percentage

FROM datacosupplychaindataset

GROUP BY `Category Name`

ORDER BY total_profit DESC

LIMIT 10;


/* ============================================================
   5. TOP 10 CATEGORIES BY QUANTITY SOLD
   ============================================================ */

SELECT
    `Category Name` AS category,

    SUM(`Order Item Quantity`) AS quantity_sold,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit

FROM datacosupplychaindataset

GROUP BY `Category Name`

ORDER BY quantity_sold DESC

LIMIT 10;


/* ============================================================
   6. CATEGORY SALES CONTRIBUTION
   ============================================================ */

SELECT
    `Category Name` AS category,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(
        SUM(`Sales`) * 100.0 /
        (
            SELECT SUM(`Sales`)
            FROM datacosupplychaindataset
        ),
        2
    ) AS sales_contribution_percentage

FROM datacosupplychaindataset

GROUP BY `Category Name`

ORDER BY total_sales DESC;


/* ============================================================
   7. CATEGORY PROFIT CONTRIBUTION
   ============================================================ */

SELECT
    `Category Name` AS category,

    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,

    ROUND(
        SUM(`Order Profit Per Order`) * 100.0 /
        (
            SELECT SUM(`Order Profit Per Order`)
            FROM datacosupplychaindataset
        ),
        2
    ) AS profit_contribution_percentage

FROM datacosupplychaindataset

GROUP BY `Category Name`

ORDER BY total_profit DESC;


/* ============================================================
   8. SALES PER UNIT BY CATEGORY
   ============================================================ */

SELECT
    `Category Name` AS category,

    SUM(`Order Item Quantity`) AS quantity_sold,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(
        SUM(`Sales`)
        / NULLIF(SUM(`Order Item Quantity`), 0),
        2
    ) AS sales_per_unit

FROM datacosupplychaindataset

GROUP BY `Category Name`

ORDER BY sales_per_unit DESC;


/* ============================================================
   9. PROFIT PER UNIT BY CATEGORY
   ============================================================ */

SELECT
    `Category Name` AS category,

    SUM(`Order Item Quantity`) AS quantity_sold,

    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,

    ROUND(
        SUM(`Order Profit Per Order`)
        / NULLIF(SUM(`Order Item Quantity`), 0),
        2
    ) AS profit_per_unit

FROM datacosupplychaindataset

GROUP BY `Category Name`

ORDER BY profit_per_unit DESC;


/* ============================================================
   10. PRODUCT-LEVEL PERFORMANCE
   ============================================================ */

SELECT
    `Product Card Id` AS product_id,

    `Product Name` AS product_name,

    `Category Name` AS category,

    COUNT(DISTINCT `Order Id`) AS total_orders,

    SUM(`Order Item Quantity`) AS quantity_sold,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,

    ROUND(
        SUM(`Order Profit Per Order`)
        / NULLIF(SUM(`Sales`), 0) * 100,
        2
    ) AS profit_margin_percentage

FROM datacosupplychaindataset

GROUP BY
    `Product Card Id`,
    `Product Name`,
    `Category Name`

ORDER BY total_sales DESC;


/* ============================================================
   11. TOP 10 PRODUCTS BY SALES
   ============================================================ */

SELECT
    `Product Card Id` AS product_id,

    `Product Name` AS product_name,

    `Category Name` AS category,

    COUNT(DISTINCT `Order Id`) AS orders,

    SUM(`Order Item Quantity`) AS quantity_sold,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit

FROM datacosupplychaindataset

GROUP BY
    `Product Card Id`,
    `Product Name`,
    `Category Name`

ORDER BY total_sales DESC

LIMIT 10;


/* ============================================================
   12. TOP 10 PRODUCTS BY PROFIT
   ============================================================ */

SELECT
    `Product Card Id` AS product_id,

    `Product Name` AS product_name,

    `Category Name` AS category,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,

    ROUND(
        SUM(`Order Profit Per Order`)
        / NULLIF(SUM(`Sales`), 0) * 100,
        2
    ) AS profit_margin_percentage

FROM datacosupplychaindataset

GROUP BY
    `Product Card Id`,
    `Product Name`,
    `Category Name`

ORDER BY total_profit DESC

LIMIT 10;


/* ============================================================
   13. TOP 10 PRODUCTS BY QUANTITY SOLD
   ============================================================ */

SELECT
    `Product Card Id` AS product_id,

    `Product Name` AS product_name,

    `Category Name` AS category,

    SUM(`Order Item Quantity`) AS quantity_sold,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit

FROM datacosupplychaindataset

GROUP BY
    `Product Card Id`,
    `Product Name`,
    `Category Name`

ORDER BY quantity_sold DESC

LIMIT 10;


/* ============================================================
   14. TOP 10 PRODUCTS BY PROFIT MARGIN
   ============================================================ */

SELECT
    `Product Card Id` AS product_id,

    `Product Name` AS product_name,

    `Category Name` AS category,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,

    ROUND(
        SUM(`Order Profit Per Order`)
        / NULLIF(SUM(`Sales`), 0) * 100,
        2
    ) AS profit_margin_percentage

FROM datacosupplychaindataset

GROUP BY
    `Product Card Id`,
    `Product Name`,
    `Category Name`

HAVING total_sales > 1000

ORDER BY profit_margin_percentage DESC

LIMIT 10;


/* ============================================================
   15. BOTTOM 10 PRODUCTS BY SALES
   ============================================================ */

SELECT
    `Product Card Id` AS product_id,

    `Product Name` AS product_name,

    `Category Name` AS category,

    SUM(`Order Item Quantity`) AS quantity_sold,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit

FROM datacosupplychaindataset

GROUP BY
    `Product Card Id`,
    `Product Name`,
    `Category Name`

ORDER BY total_sales ASC

LIMIT 10;


/* ============================================================
   16. BOTTOM 10 PRODUCTS BY PROFIT
   ============================================================ */

SELECT
    `Product Card Id` AS product_id,

    `Product Name` AS product_name,

    `Category Name` AS category,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,

    ROUND(
        SUM(`Order Profit Per Order`)
        / NULLIF(SUM(`Sales`), 0) * 100,
        2
    ) AS profit_margin_percentage

FROM datacosupplychaindataset

GROUP BY
    `Product Card Id`,
    `Product Name`,
    `Category Name`

ORDER BY total_profit ASC

LIMIT 10;


/* ============================================================
   17. HIGH SALES + LOW PROFIT PRODUCTS
   ============================================================ */

SELECT
    `Product Card Id` AS product_id,

    `Product Name` AS product_name,

    `Category Name` AS category,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,

    ROUND(
        SUM(`Order Profit Per Order`)
        / NULLIF(SUM(`Sales`), 0) * 100,
        2
    ) AS profit_margin_percentage

FROM datacosupplychaindataset

GROUP BY
    `Product Card Id`,
    `Product Name`,
    `Category Name`

HAVING
    total_sales > 50000

ORDER BY profit_margin_percentage ASC;


/* ============================================================
   18. HIGH SALES + NEGATIVE PROFIT PRODUCTS
   ============================================================ */

SELECT
    `Product Card Id` AS product_id,

    `Product Name` AS product_name,

    `Category Name` AS category,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit

FROM datacosupplychaindataset

GROUP BY
    `Product Card Id`,
    `Product Name`,
    `Category Name`

HAVING
    total_sales > 50000
    AND total_profit < 0

ORDER BY total_sales DESC;


/* ============================================================
   19. PRODUCT PRICE ANALYSIS
   ============================================================ */

SELECT
    `Category Name` AS category,

    ROUND(
        AVG(`Product Price`),
        2
    ) AS average_product_price,

    ROUND(
        MIN(`Product Price`),
        2
    ) AS minimum_product_price,

    ROUND(
        MAX(`Product Price`),
        2
    ) AS maximum_product_price,

    COUNT(DISTINCT `Product Card Id`) AS products

FROM datacosupplychaindataset

GROUP BY `Category Name`

ORDER BY average_product_price DESC;


/* ============================================================
   20. PRODUCT PRICE VS SALES
   ============================================================ */

SELECT
    `Product Card Id` AS product_id,

    `Product Name` AS product_name,

    `Category Name` AS category,

    ROUND(AVG(`Product Price`), 2) AS product_price,

    SUM(`Order Item Quantity`) AS quantity_sold,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit

FROM datacosupplychaindataset

GROUP BY
    `Product Card Id`,
    `Product Name`,
    `Category Name`

ORDER BY total_sales DESC

LIMIT 20;


/* ============================================================
   21. DISCOUNT BY CATEGORY
   ============================================================ */

SELECT
    `Category Name` AS category,

    ROUND(
        AVG(`Order Item Discount`),
        2
    ) AS average_discount,

    ROUND(
        AVG(`Order Item Discount Rate`) * 100,
        2
    ) AS average_discount_rate_percentage,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,

    ROUND(
        SUM(`Order Profit Per Order`)
        / NULLIF(SUM(`Sales`), 0) * 100,
        2
    ) AS profit_margin_percentage

FROM datacosupplychaindataset

GROUP BY `Category Name`

ORDER BY average_discount_rate_percentage DESC;


/* ============================================================
   22. CATEGORY PERFORMANCE RANKING
   ============================================================ */

WITH category_performance AS (

    SELECT
        `Category Name` AS category,

        SUM(`Sales`) AS total_sales,

        SUM(`Order Profit Per Order`) AS total_profit

    FROM datacosupplychaindataset

    GROUP BY `Category Name`

)

SELECT
    category,

    ROUND(total_sales, 2) AS total_sales,

    ROUND(total_profit, 2) AS total_profit,

    RANK() OVER (
        ORDER BY total_sales DESC
    ) AS sales_rank,

    RANK() OVER (
        ORDER BY total_profit DESC
    ) AS profit_rank

FROM category_performance

ORDER BY sales_rank;


/* ============================================================
   23. PRODUCT SALES RANKING
   ============================================================ */

WITH product_performance AS (

    SELECT
        `Product Card Id` AS product_id,

        `Product Name` AS product_name,

        `Category Name` AS category,

        SUM(`Sales`) AS total_sales,

        SUM(`Order Profit Per Order`) AS total_profit

    FROM datacosupplychaindataset

    GROUP BY
        `Product Card Id`,
        `Product Name`,
        `Category Name`

)

SELECT
    product_id,

    product_name,

    category,

    ROUND(total_sales, 2) AS total_sales,

    ROUND(total_profit, 2) AS total_profit,

    RANK() OVER (
        ORDER BY total_sales DESC
    ) AS sales_rank,

    RANK() OVER (
        ORDER BY total_profit DESC
    ) AS profit_rank

FROM product_performance

ORDER BY sales_rank;


/* ============================================================
   24. PRODUCT PARETO / 80-20 ANALYSIS
   ============================================================ */

WITH product_sales AS (

    SELECT
        `Product Card Id` AS product_id,

        `Product Name` AS product_name,

        SUM(`Sales`) AS total_sales

    FROM datacosupplychaindataset

    GROUP BY
        `Product Card Id`,
        `Product Name`

),

ranked_products AS (

    SELECT
        product_id,

        product_name,

        total_sales,

        SUM(total_sales) OVER (
            ORDER BY total_sales DESC
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ) AS cumulative_sales,

        SUM(total_sales) OVER () AS overall_sales

    FROM product_sales

)

SELECT
    product_id,

    product_name,

    ROUND(total_sales, 2) AS total_sales,

    ROUND(
        cumulative_sales,
        2
    ) AS cumulative_sales,

    ROUND(
        cumulative_sales
        / NULLIF(overall_sales, 0) * 100,
        2
    ) AS cumulative_sales_percentage

FROM ranked_products

ORDER BY total_sales DESC;


/* ============================================================
   25. PRODUCTS REQUIRED TO REACH 80% OF SALES
   ============================================================ */

WITH product_sales AS (

    SELECT
        `Product Card Id` AS product_id,

        `Product Name` AS product_name,

        SUM(`Sales`) AS total_sales

    FROM datacosupplychaindataset

    GROUP BY
        `Product Card Id`,
        `Product Name`

),

ranked_products AS (

    SELECT
        product_id,

        product_name,

        total_sales,

        SUM(total_sales) OVER (
            ORDER BY total_sales DESC
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ) AS cumulative_sales,

        SUM(total_sales) OVER () AS overall_sales

    FROM product_sales

),

pareto AS (

    SELECT
        product_id,

        product_name,

        total_sales,

        cumulative_sales,

        cumulative_sales
        / NULLIF(overall_sales, 0) * 100
        AS cumulative_percentage

    FROM ranked_products

)

SELECT
    COUNT(*) AS products_needed_for_80_percent_sales

FROM pareto

WHERE cumulative_percentage <= 80;


/* ============================================================
   26. TOP PRODUCTS SALES CONTRIBUTION
   ============================================================ */

WITH product_sales AS (

    SELECT
        `Product Card Id` AS product_id,

        `Product Name` AS product_name,

        SUM(`Sales`) AS total_sales

    FROM datacosupplychaindataset

    GROUP BY
        `Product Card Id`,
        `Product Name`

),

ranked_products AS (

    SELECT
        product_id,

        product_name,

        total_sales,

        ROW_NUMBER() OVER (
            ORDER BY total_sales DESC
        ) AS product_rank

    FROM product_sales

)

SELECT
    product_rank,

    product_name,

    ROUND(total_sales, 2) AS total_sales,

    ROUND(
        total_sales * 100.0 /
        (
            SELECT SUM(total_sales)
            FROM product_sales
        ),
        2
    ) AS sales_contribution_percentage

FROM ranked_products

WHERE product_rank <= 10

ORDER BY product_rank;


/* ============================================================
   27. CATEGORY × PRODUCT PERFORMANCE
   ============================================================ */

SELECT
    `Category Name` AS category,

    `Product Name` AS product_name,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,

    SUM(`Order Item Quantity`) AS quantity_sold

FROM datacosupplychaindataset

GROUP BY
    `Category Name`,
    `Product Name`

ORDER BY
    category,
    total_sales DESC;


/* ============================================================
   28. TOP PRODUCT WITHIN EACH CATEGORY
   ============================================================ */

WITH product_category_sales AS (

    SELECT
        `Category Name` AS category,

        `Product Name` AS product_name,

        SUM(`Sales`) AS total_sales

    FROM datacosupplychaindataset

    GROUP BY
        `Category Name`,
        `Product Name`

),

ranked_products AS (

    SELECT
        category,

        product_name,

        total_sales,

        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY total_sales DESC
        ) AS product_rank

    FROM product_category_sales

)

SELECT
    category,

    product_name,

    ROUND(total_sales, 2) AS total_sales

FROM ranked_products

WHERE product_rank = 1

ORDER BY total_sales DESC;


/* ============================================================
   29. CATEGORY SALES VS PROFIT RANK
   ============================================================ */

WITH category_data AS (

    SELECT
        `Category Name` AS category,

        SUM(`Sales`) AS total_sales,

        SUM(`Order Profit Per Order`) AS total_profit

    FROM datacosupplychaindataset

    GROUP BY `Category Name`

)

SELECT
    category,

    ROUND(total_sales, 2) AS total_sales,

    ROUND(total_profit, 2) AS total_profit,

    RANK() OVER (
        ORDER BY total_sales DESC
    ) AS sales_rank,

    RANK() OVER (
        ORDER BY total_profit DESC
    ) AS profit_rank,

    sales_rank - profit_rank AS rank_difference

FROM (

    SELECT
        category,

        total_sales,

        total_profit,

        RANK() OVER (
            ORDER BY total_sales DESC
        ) AS sales_rank,

        RANK() OVER (
            ORDER BY total_profit DESC
        ) AS profit_rank

    FROM category_data

) ranked

ORDER BY ABS(rank_difference) DESC;


/* ============================================================
   30. PRODUCT BUSINESS CLASSIFICATION
   ============================================================ */

WITH product_data AS (

    SELECT
        `Product Card Id` AS product_id,

        `Product Name` AS product_name,

        `Category Name` AS category,

        SUM(`Sales`) AS total_sales,

        SUM(`Order Profit Per Order`) AS total_profit

    FROM datacosupplychaindataset

    GROUP BY
        `Product Card Id`,
        `Product Name`,
        `Category Name`

)

SELECT
    product_id,

    product_name,

    category,

    ROUND(total_sales, 2) AS total_sales,

    ROUND(total_profit, 2) AS total_profit,

    ROUND(
        total_profit
        / NULLIF(total_sales, 0) * 100,
        2
    ) AS profit_margin_percentage,

    CASE

        WHEN total_sales >= 100000
             AND total_profit > 0
            THEN 'High Sales - Profitable'

        WHEN total_sales >= 100000
             AND total_profit <= 0
            THEN 'High Sales - Low/Negative Profit'

        WHEN total_sales < 100000
             AND total_profit > 0
            THEN 'Low Sales - Profitable'

        ELSE 'Low Sales - Low/Negative Profit'

    END AS product_classification

FROM product_data

ORDER BY total_sales DESC;


/* ============================================================
   31. PRODUCT PERFORMANCE BY MARKET
   ============================================================ */

SELECT
    `Market`,

    `Product Name` AS product_name,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,

    SUM(`Order Item Quantity`) AS quantity_sold

FROM datacosupplychaindataset

GROUP BY
    `Market`,
    `Product Name`

ORDER BY
    `Market`,
    total_sales DESC;


/* ============================================================
   32. FINAL PRODUCT ANALYSIS SUMMARY
   ============================================================ */

SELECT

    COUNT(DISTINCT `Product Card Id`) AS total_products,

    COUNT(DISTINCT `Category Name`) AS total_categories,

    SUM(`Order Item Quantity`) AS total_quantity_sold,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(
        SUM(`Order Profit Per Order`),
        2
    ) AS total_profit,

    ROUND(
        SUM(`Order Profit Per Order`)
        / NULLIF(SUM(`Sales`), 0) * 100,
        2
    ) AS overall_profit_margin

FROM datacosupplychaindataset;


/* ============================================================
   END OF PRODUCT & CATEGORY ANALYSIS
   ============================================================ */
