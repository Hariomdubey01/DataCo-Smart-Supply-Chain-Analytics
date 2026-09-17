/* ============================================================
   DATACO SMART SUPPLY CHAIN ANALYTICS
   SQL PROJECT - CUSTOMER & MARKET ANALYSIS

   Database : dataco_supply_chain
   Table    : datacosupplychaindataset
   Database : MySQL

   Purpose:
   - Customer analysis
   - Customer segment analysis
   - Repeat customer analysis
   - Market performance
   - Country performance
   - Regional analysis
   - Customer revenue contribution
   - Customer concentration
   ============================================================ */


USE dataco_supply_chain;


/* ============================================================
   1. OVERALL CUSTOMER & MARKET OVERVIEW
   ============================================================ */

SELECT

    COUNT(DISTINCT `Order Customer Id`) AS total_customers,

    COUNT(DISTINCT `Market`) AS total_markets,

    COUNT(DISTINCT `Order Country`) AS total_countries,

    COUNT(DISTINCT `Order Region`) AS total_regions,

    COUNT(DISTINCT `Order Id`) AS total_orders,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit

FROM datacosupplychaindataset;


/* ============================================================
   2. CUSTOMER SEGMENT PERFORMANCE
   ============================================================ */

SELECT

    `Customer Segment` AS customer_segment,

    COUNT(DISTINCT `Order Customer Id`) AS customers,

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

GROUP BY `Customer Segment`

ORDER BY total_sales DESC;


/* ============================================================
   3. CUSTOMER SEGMENT SALES CONTRIBUTION
   ============================================================ */

SELECT

    `Customer Segment` AS customer_segment,

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

GROUP BY `Customer Segment`

ORDER BY total_sales DESC;


/* ============================================================
   4. CUSTOMER SEGMENT AVERAGE ORDER VALUE
   ============================================================ */

SELECT

    `Customer Segment` AS customer_segment,

    COUNT(DISTINCT `Order Id`) AS total_orders,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(
        SUM(`Sales`)
        / NULLIF(COUNT(DISTINCT `Order Id`), 0),
        2
    ) AS average_order_value

FROM datacosupplychaindataset

GROUP BY `Customer Segment`

ORDER BY average_order_value DESC;


/* ============================================================
   5. CUSTOMER SEGMENT QUANTITY ANALYSIS
   ============================================================ */

SELECT

    `Customer Segment` AS customer_segment,

    SUM(`Order Item Quantity`) AS quantity_sold,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(
        SUM(`Sales`)
        / NULLIF(SUM(`Order Item Quantity`), 0),
        2
    ) AS sales_per_unit

FROM datacosupplychaindataset

GROUP BY `Customer Segment`

ORDER BY quantity_sold DESC;


/* ============================================================
   6. CUSTOMER-LEVEL PERFORMANCE
   ============================================================ */

SELECT

    `Order Customer Id` AS customer_id,

    `Customer Segment` AS customer_segment,

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
    `Order Customer Id`,
    `Customer Segment`

ORDER BY total_sales DESC;


/* ============================================================
   7. TOP 10 CUSTOMERS BY SALES
   ============================================================ */

SELECT

    `Order Customer Id` AS customer_id,

    `Customer Segment` AS customer_segment,

    COUNT(DISTINCT `Order Id`) AS total_orders,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit

FROM datacosupplychaindataset

GROUP BY
    `Order Customer Id`,
    `Customer Segment`

ORDER BY total_sales DESC

LIMIT 10;


/* ============================================================
   8. TOP 10 CUSTOMERS BY PROFIT
   ============================================================ */

SELECT

    `Order Customer Id` AS customer_id,

    `Customer Segment` AS customer_segment,

    COUNT(DISTINCT `Order Id`) AS total_orders,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit

FROM datacosupplychaindataset

GROUP BY
    `Order Customer Id`,
    `Customer Segment`

ORDER BY total_profit DESC

LIMIT 10;


/* ============================================================
   9. CUSTOMER ORDER FREQUENCY
   ============================================================ */

SELECT

    `Order Customer Id` AS customer_id,

    COUNT(DISTINCT `Order Id`) AS total_orders,

    ROUND(SUM(`Sales`), 2) AS total_sales

FROM datacosupplychaindataset

GROUP BY `Order Customer Id`

ORDER BY total_orders DESC

LIMIT 20;


/* ============================================================
   10. REPEAT CUSTOMER ANALYSIS
   ============================================================ */

WITH customer_orders AS (

    SELECT

        `Order Customer Id` AS customer_id,

        COUNT(DISTINCT `Order Id`) AS total_orders

    FROM datacosupplychaindataset

    GROUP BY `Order Customer Id`

)

SELECT

    COUNT(*) AS total_customers,

    SUM(
        CASE
            WHEN total_orders = 1 THEN 1
            ELSE 0
        END
    ) AS one_time_customers,

    SUM(
        CASE
            WHEN total_orders > 1 THEN 1
            ELSE 0
        END
    ) AS repeat_customers,

    ROUND(
        SUM(
            CASE
                WHEN total_orders > 1 THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS repeat_customer_rate_percentage

FROM customer_orders;


/* ============================================================
   11. CUSTOMER ORDER FREQUENCY DISTRIBUTION
   ============================================================ */

WITH customer_orders AS (

    SELECT

        `Order Customer Id` AS customer_id,

        COUNT(DISTINCT `Order Id`) AS total_orders

    FROM datacosupplychaindataset

    GROUP BY `Order Customer Id`

)

SELECT

    CASE

        WHEN total_orders = 1
            THEN '1 Order'

        WHEN total_orders BETWEEN 2 AND 3
            THEN '2-3 Orders'

        WHEN total_orders BETWEEN 4 AND 5
            THEN '4-5 Orders'

        WHEN total_orders BETWEEN 6 AND 10
            THEN '6-10 Orders'

        ELSE '10+ Orders'

    END AS customer_order_group,

    COUNT(*) AS customers

FROM customer_orders

GROUP BY customer_order_group

ORDER BY customers DESC;


/* ============================================================
   12. CUSTOMER AVERAGE ORDER VALUE
   ============================================================ */

SELECT

    `Order Customer Id` AS customer_id,

    COUNT(DISTINCT `Order Id`) AS total_orders,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(
        SUM(`Sales`)
        / NULLIF(COUNT(DISTINCT `Order Id`), 0),
        2
    ) AS average_order_value

FROM datacosupplychaindataset

GROUP BY `Order Customer Id`

ORDER BY average_order_value DESC

LIMIT 20;


/* ============================================================
   13. MARKET PERFORMANCE
   ============================================================ */

SELECT

    `Market`,

    COUNT(DISTINCT `Order Customer Id`) AS customers,

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

GROUP BY `Market`

ORDER BY total_sales DESC;


/* ============================================================
   14. MARKET SALES CONTRIBUTION
   ============================================================ */

SELECT

    `Market`,

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

GROUP BY `Market`

ORDER BY total_sales DESC;


/* ============================================================
   15. MARKET AVERAGE ORDER VALUE
   ============================================================ */

SELECT

    `Market`,

    COUNT(DISTINCT `Order Id`) AS total_orders,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(
        SUM(`Sales`)
        / NULLIF(COUNT(DISTINCT `Order Id`), 0),
        2
    ) AS average_order_value

FROM datacosupplychaindataset

GROUP BY `Market`

ORDER BY average_order_value DESC;


/* ============================================================
   16. TOP 10 COUNTRIES BY SALES
   ============================================================ */

SELECT

    `Order Country` AS country,

    `Market`,

    COUNT(DISTINCT `Order Customer Id`) AS customers,

    COUNT(DISTINCT `Order Id`) AS orders,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit

FROM datacosupplychaindataset

GROUP BY
    `Order Country`,
    `Market`

ORDER BY total_sales DESC

LIMIT 10;


/* ============================================================
   17. TOP 10 COUNTRIES BY PROFIT
   ============================================================ */

SELECT

    `Order Country` AS country,

    `Market`,

    COUNT(DISTINCT `Order Id`) AS orders,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,

    ROUND(
        SUM(`Order Profit Per Order`)
        / NULLIF(SUM(`Sales`), 0) * 100,
        2
    ) AS profit_margin_percentage

FROM datacosupplychaindataset

GROUP BY
    `Order Country`,
    `Market`

ORDER BY total_profit DESC

LIMIT 10;


/* ============================================================
   18. REGIONAL CUSTOMER ANALYSIS
   ============================================================ */

SELECT

    `Order Region` AS region,

    COUNT(DISTINCT `Order Customer Id`) AS customers,

    COUNT(DISTINCT `Order Id`) AS orders,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,

    ROUND(
        SUM(`Order Profit Per Order`)
        / NULLIF(SUM(`Sales`), 0) * 100,
        2
    ) AS profit_margin_percentage

FROM datacosupplychaindataset

GROUP BY `Order Region`

ORDER BY total_sales DESC;


/* ============================================================
   19. TOP 10 REGIONS BY SALES
   ============================================================ */

SELECT

    `Order Region` AS region,

    COUNT(DISTINCT `Order Customer Id`) AS customers,

    COUNT(DISTINCT `Order Id`) AS orders,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit

FROM datacosupplychaindataset

GROUP BY `Order Region`

ORDER BY total_sales DESC

LIMIT 10;


/* ============================================================
   20. MARKET × CUSTOMER SEGMENT
   ============================================================ */

SELECT

    `Market`,

    `Customer Segment` AS customer_segment,

    COUNT(DISTINCT `Order Customer Id`) AS customers,

    COUNT(DISTINCT `Order Id`) AS orders,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit

FROM datacosupplychaindataset

GROUP BY
    `Market`,
    `Customer Segment`

ORDER BY
    `Market`,
    total_sales DESC;


/* ============================================================
   21. TOP CUSTOMER SEGMENT IN EACH MARKET
   ============================================================ */

WITH segment_market_sales AS (

    SELECT

        `Market`,

        `Customer Segment` AS customer_segment,

        SUM(`Sales`) AS total_sales

    FROM datacosupplychaindataset

    GROUP BY
        `Market`,
        `Customer Segment`

),

ranked_segments AS (

    SELECT

        `Market`,

        customer_segment,

        total_sales,

        ROW_NUMBER() OVER (

            PARTITION BY `Market`

            ORDER BY total_sales DESC

        ) AS segment_rank

    FROM segment_market_sales

)

SELECT

    `Market`,

    customer_segment,

    ROUND(total_sales, 2) AS total_sales

FROM ranked_segments

WHERE segment_rank = 1

ORDER BY total_sales DESC;


/* ============================================================
   22. MARKET × REGION PERFORMANCE
   ============================================================ */

SELECT

    `Market`,

    `Order Region` AS region,

    COUNT(DISTINCT `Order Id`) AS orders,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit

FROM datacosupplychaindataset

GROUP BY
    `Market`,
    `Order Region`

ORDER BY
    `Market`,
    total_sales DESC;


/* ============================================================
   23. COUNTRY CUSTOMER PENETRATION
   ============================================================ */

SELECT

    `Order Country` AS country,

    COUNT(DISTINCT `Order Customer Id`) AS customers,

    COUNT(DISTINCT `Order Id`) AS orders,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(
        SUM(`Sales`)
        / NULLIF(COUNT(DISTINCT `Order Customer Id`), 0),
        2
    ) AS sales_per_customer

FROM datacosupplychaindataset

GROUP BY `Order Country`

ORDER BY sales_per_customer DESC

LIMIT 20;


/* ============================================================
   24. MARKET SALES PER CUSTOMER
   ============================================================ */

SELECT

    `Market`,

    COUNT(DISTINCT `Order Customer Id`) AS customers,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(
        SUM(`Sales`)
        / NULLIF(COUNT(DISTINCT `Order Customer Id`), 0),
        2
    ) AS sales_per_customer

FROM datacosupplychaindataset

GROUP BY `Market`

ORDER BY sales_per_customer DESC;


/* ============================================================
   25. CUSTOMER REVENUE CONCENTRATION
   ============================================================ */

WITH customer_sales AS (

    SELECT

        `Order Customer Id` AS customer_id,

        SUM(`Sales`) AS total_sales

    FROM datacosupplychaindataset

    GROUP BY `Order Customer Id`

),

ranked_customers AS (

    SELECT

        customer_id,

        total_sales,

        SUM(total_sales) OVER (

            ORDER BY total_sales DESC

            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW

        ) AS cumulative_sales,

        SUM(total_sales) OVER () AS overall_sales

    FROM customer_sales

)

SELECT

    customer_id,

    ROUND(total_sales, 2) AS total_sales,

    ROUND(cumulative_sales, 2) AS cumulative_sales,

    ROUND(
        cumulative_sales
        / NULLIF(overall_sales, 0) * 100,
        2
    ) AS cumulative_sales_percentage

FROM ranked_customers

ORDER BY total_sales DESC;


/* ============================================================
   26. CUSTOMERS REQUIRED TO GENERATE 80% OF SALES
   ============================================================ */

WITH customer_sales AS (

    SELECT

        `Order Customer Id` AS customer_id,

        SUM(`Sales`) AS total_sales

    FROM datacosupplychaindataset

    GROUP BY `Order Customer Id`

),

ranked_customers AS (

    SELECT

        customer_id,

        total_sales,

        SUM(total_sales) OVER (

            ORDER BY total_sales DESC

            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW

        ) AS cumulative_sales,

        SUM(total_sales) OVER () AS overall_sales

    FROM customer_sales

),

customer_pareto AS (

    SELECT

        customer_id,

        total_sales,

        cumulative_sales,

        cumulative_sales
        / NULLIF(overall_sales, 0) * 100
        AS cumulative_percentage

    FROM ranked_customers

)

SELECT

    COUNT(*) AS customers_within_80_percent_sales

FROM customer_pareto

WHERE cumulative_percentage <= 80;


/* ============================================================
   27. TOP 10 CUSTOMERS SALES CONTRIBUTION
   ============================================================ */

WITH customer_sales AS (

    SELECT

        `Order Customer Id` AS customer_id,

        SUM(`Sales`) AS total_sales

    FROM datacosupplychaindataset

    GROUP BY `Order Customer Id`

),

ranked_customers AS (

    SELECT

        customer_id,

        total_sales,

        ROW_NUMBER() OVER (
            ORDER BY total_sales DESC
        ) AS customer_rank

    FROM customer_sales

)

SELECT

    customer_rank,

    customer_id,

    ROUND(total_sales, 2) AS total_sales,

    ROUND(
        total_sales * 100.0 /
        (
            SELECT SUM(total_sales)
            FROM customer_sales
        ),
        2
    ) AS sales_contribution_percentage

FROM ranked_customers

WHERE customer_rank <= 10

ORDER BY customer_rank;


/* ============================================================
   28. CUSTOMER SEGMENT × MARKET PROFITABILITY
   ============================================================ */

SELECT

    `Market`,

    `Customer Segment` AS customer_segment,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,

    ROUND(
        SUM(`Order Profit Per Order`)
        / NULLIF(SUM(`Sales`), 0) * 100,
        2
    ) AS profit_margin_percentage

FROM datacosupplychaindataset

GROUP BY
    `Market`,
    `Customer Segment`

ORDER BY
    `Market`,
    total_profit DESC;


/* ============================================================
   29. BEST MARKET BY PROFIT MARGIN
   ============================================================ */

SELECT

    `Market`,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,

    ROUND(
        SUM(`Order Profit Per Order`)
        / NULLIF(SUM(`Sales`), 0) * 100,
        2
    ) AS profit_margin_percentage

FROM datacosupplychaindataset

GROUP BY `Market`

ORDER BY profit_margin_percentage DESC

LIMIT 1;


/* ============================================================
   30. LARGEST MARKET BY SALES
   ============================================================ */

SELECT

    `Market`,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    COUNT(DISTINCT `Order Customer Id`) AS customers,

    COUNT(DISTINCT `Order Id`) AS orders

FROM datacosupplychaindataset

GROUP BY `Market`

ORDER BY total_sales DESC

LIMIT 1;


/* ============================================================
   31. LARGEST MARKET BY CUSTOMER COUNT
   ============================================================ */

SELECT

    `Market`,

    COUNT(DISTINCT `Order Customer Id`) AS customers,

    COUNT(DISTINCT `Order Id`) AS orders,

    ROUND(SUM(`Sales`), 2) AS total_sales

FROM datacosupplychaindataset

GROUP BY `Market`

ORDER BY customers DESC

LIMIT 1;


/* ============================================================
   32. CUSTOMER SEGMENT WITH HIGHEST SALES
   ============================================================ */

SELECT

    `Customer Segment` AS customer_segment,

    COUNT(DISTINCT `Order Customer Id`) AS customers,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit

FROM datacosupplychaindataset

GROUP BY `Customer Segment`

ORDER BY total_sales DESC

LIMIT 1;


/* ============================================================
   33. CUSTOMER VALUE CLASSIFICATION
   ============================================================ */

WITH customer_value AS (

    SELECT

        `Order Customer Id` AS customer_id,

        COUNT(DISTINCT `Order Id`) AS total_orders,

        SUM(`Sales`) AS total_sales,

        SUM(`Order Profit Per Order`) AS total_profit

    FROM datacosupplychaindataset

    GROUP BY `Order Customer Id`

)

SELECT

    customer_id,

    total_orders,

    ROUND(total_sales, 2) AS total_sales,

    ROUND(total_profit, 2) AS total_profit,

    CASE

        WHEN total_orders > 5
             AND total_sales >= 5000
            THEN 'High Value Customer'

        WHEN total_orders > 1
             AND total_sales >= 2000
            THEN 'Repeat Customer'

        WHEN total_orders = 1
             AND total_sales >= 1000
            THEN 'High Value One-Time Customer'

        ELSE 'Standard Customer'

    END AS customer_classification

FROM customer_value

ORDER BY total_sales DESC;


/* ============================================================
   34. CUSTOMER SALES BY YEAR
   ============================================================ */

SELECT

    YEAR(`order date (DateOrders)`) AS order_year,

    `Customer Segment` AS customer_segment,

    COUNT(DISTINCT `Order Customer Id`) AS customers,

    COUNT(DISTINCT `Order Id`) AS orders,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit

FROM datacosupplychaindataset

GROUP BY

    YEAR(`order date (DateOrders)`),
    `Customer Segment`

ORDER BY

    order_year,
    total_sales DESC;


/* ============================================================
   35. FINAL CUSTOMER & MARKET SUMMARY
   ============================================================ */

SELECT

    COUNT(DISTINCT `Order Customer Id`)
        AS total_customers,

    COUNT(DISTINCT `Market`)
        AS total_markets,

    COUNT(DISTINCT `Order Country`)
        AS total_countries,

    COUNT(DISTINCT `Order Region`)
        AS total_regions,

    COUNT(DISTINCT `Order Id`)
        AS total_orders,

    ROUND(SUM(`Sales`), 2)
        AS total_sales,

    ROUND(SUM(`Order Profit Per Order`), 2)
        AS total_profit,

    ROUND(
        SUM(`Sales`)
        / NULLIF(COUNT(DISTINCT `Order Customer Id`), 0),
        2
    ) AS sales_per_customer

FROM datacosupplychaindataset;


/* ============================================================
   END OF CUSTOMER & MARKET ANALYSIS
   ============================================================ */
