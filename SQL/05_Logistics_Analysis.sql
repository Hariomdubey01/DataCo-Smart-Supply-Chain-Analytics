/* ============================================================
   DATACO SMART SUPPLY CHAIN ANALYTICS
   SQL PROJECT - LOGISTICS & DELIVERY ANALYSIS

   Database : dataco_supply_chain
   Table    : datacosupplychaindataset
   Database : MySQL

   Purpose:
   - Delivery performance analysis
   - Late delivery risk analysis
   - Shipping mode performance
   - Actual vs scheduled shipping
   - Market and regional logistics analysis
   - Delivery status analysis
   - Logistics bottleneck identification
   ============================================================ */


USE dataco_supply_chain;


/* ============================================================
   1. OVERALL LOGISTICS PERFORMANCE
   ============================================================ */

SELECT

    COUNT(DISTINCT `Order Id`) AS total_shipments,

    ROUND(
        AVG(`Days for shipping (real)`),
        2
    ) AS average_shipping_days,

    ROUND(
        AVG(`Days for shipment (scheduled)`),
        2
    ) AS average_scheduled_shipping_days,

    ROUND(
        AVG(`Late_delivery_risk`) * 100,
        2
    ) AS late_delivery_risk_percentage

FROM datacosupplychaindataset;


/* ============================================================
   2. DELIVERY STATUS DISTRIBUTION
   ============================================================ */

SELECT

    `Delivery Status` AS delivery_status,

    COUNT(DISTINCT `Order Id`) AS total_shipments,

    ROUND(
        COUNT(DISTINCT `Order Id`) * 100.0 /
        (
            SELECT COUNT(DISTINCT `Order Id`)
            FROM datacosupplychaindataset
        ),
        2
    ) AS shipment_percentage

FROM datacosupplychaindataset

GROUP BY `Delivery Status`

ORDER BY total_shipments DESC;


/* ============================================================
   3. LATE DELIVERY ANALYSIS
   ============================================================ */

SELECT

    COUNT(DISTINCT `Order Id`) AS total_shipments,

    COUNT(
        DISTINCT CASE
            WHEN `Late_delivery_risk` = 1
            THEN `Order Id`
        END
    ) AS late_shipments,

    ROUND(
        COUNT(
            DISTINCT CASE
                WHEN `Late_delivery_risk` = 1
                THEN `Order Id`
            END
        ) * 100.0
        /
        NULLIF(COUNT(DISTINCT `Order Id`), 0),
        2
    ) AS late_delivery_risk_percentage

FROM datacosupplychaindataset;


/* ============================================================
   4. SHIPPING MODE PERFORMANCE
   ============================================================ */

SELECT

    `Shipping Mode` AS shipping_mode,

    COUNT(DISTINCT `Order Id`) AS total_shipments,

    ROUND(
        AVG(`Days for shipping (real)`),
        2
    ) AS average_actual_shipping_days,

    ROUND(
        AVG(`Days for shipment (scheduled)`),
        2
    ) AS average_scheduled_shipping_days,

    ROUND(
        AVG(`Late_delivery_risk`) * 100,
        2
    ) AS late_delivery_risk_percentage,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit

FROM datacosupplychaindataset

GROUP BY `Shipping Mode`

ORDER BY late_delivery_risk_percentage DESC;


/* ============================================================
   5. SHIPPING MODE ORDER SHARE
   ============================================================ */

SELECT

    `Shipping Mode` AS shipping_mode,

    COUNT(DISTINCT `Order Id`) AS total_shipments,

    ROUND(
        COUNT(DISTINCT `Order Id`) * 100.0 /
        (
            SELECT COUNT(DISTINCT `Order Id`)
            FROM datacosupplychaindataset
        ),
        2
    ) AS shipment_share_percentage

FROM datacosupplychaindataset

GROUP BY `Shipping Mode`

ORDER BY total_shipments DESC;


/* ============================================================
   6. ACTUAL VS SCHEDULED SHIPPING DAYS
   ============================================================ */

SELECT

    ROUND(
        AVG(`Days for shipping (real)`),
        2
    ) AS average_actual_days,

    ROUND(
        AVG(`Days for shipment (scheduled)`),
        2
    ) AS average_scheduled_days,

    ROUND(
        AVG(`Days for shipping (real)`)
        -
        AVG(`Days for shipment (scheduled)`),
        2
    ) AS average_shipping_delay

FROM datacosupplychaindataset;


/* ============================================================
   7. SHIPPING DELAY BY SHIPPING MODE
   ============================================================ */

SELECT

    `Shipping Mode` AS shipping_mode,

    ROUND(
        AVG(`Days for shipping (real)`),
        2
    ) AS actual_shipping_days,

    ROUND(
        AVG(`Days for shipment (scheduled)`),
        2
    ) AS scheduled_shipping_days,

    ROUND(
        AVG(`Days for shipping (real)`)
        -
        AVG(`Days for shipment (scheduled)`),
        2
    ) AS average_shipping_delay

FROM datacosupplychaindataset

GROUP BY `Shipping Mode`

ORDER BY average_shipping_delay DESC;


/* ============================================================
   8. SHIPPING DELAY BAND
   ============================================================ */

SELECT

    CASE

        WHEN `Days for shipping (real)`
             <
             `Days for shipment (scheduled)`
            THEN 'Early'

        WHEN `Days for shipping (real)`
             =
             `Days for shipment (scheduled)`
            THEN 'On Schedule'

        ELSE 'Delayed'

    END AS shipping_performance,

    COUNT(DISTINCT `Order Id`) AS total_shipments,

    ROUND(
        COUNT(DISTINCT `Order Id`) * 100.0 /
        (
            SELECT COUNT(DISTINCT `Order Id`)
            FROM datacosupplychaindataset
        ),
        2
    ) AS shipment_percentage

FROM datacosupplychaindataset

GROUP BY shipping_performance

ORDER BY total_shipments DESC;


/* ============================================================
   9. SHIPPING DELAY BY MARKET
   ============================================================ */

SELECT

    `Market`,

    COUNT(DISTINCT `Order Id`) AS total_shipments,

    ROUND(
        AVG(`Days for shipping (real)`),
        2
    ) AS average_shipping_days,

    ROUND(
        AVG(`Days for shipment (scheduled)`),
        2
    ) AS average_scheduled_days,

    ROUND(
        AVG(`Days for shipping (real)`)
        -
        AVG(`Days for shipment (scheduled)`),
        2
    ) AS average_shipping_delay,

    ROUND(
        AVG(`Late_delivery_risk`) * 100,
        2
    ) AS late_delivery_risk_percentage

FROM datacosupplychaindataset

GROUP BY `Market`

ORDER BY late_delivery_risk_percentage DESC;


/* ============================================================
   10. SHIPPING DELAY BY REGION
   ============================================================ */

SELECT

    `Order Region` AS region,

    COUNT(DISTINCT `Order Id`) AS total_shipments,

    ROUND(
        AVG(`Days for shipping (real)`),
        2
    ) AS average_shipping_days,

    ROUND(
        AVG(`Days for shipment (scheduled)`),
        2
    ) AS average_scheduled_days,

    ROUND(
        AVG(`Days for shipping (real)`)
        -
        AVG(`Days for shipment (scheduled)`),
        2
    ) AS average_shipping_delay,

    ROUND(
        AVG(`Late_delivery_risk`) * 100,
        2
    ) AS late_delivery_risk_percentage

FROM datacosupplychaindataset

GROUP BY `Order Region`

ORDER BY late_delivery_risk_percentage DESC;


/* ============================================================
   11. TOP 10 REGIONS BY LATE DELIVERY RISK
   ============================================================ */

SELECT

    `Order Region` AS region,

    COUNT(DISTINCT `Order Id`) AS total_shipments,

    ROUND(
        AVG(`Late_delivery_risk`) * 100,
        2
    ) AS late_delivery_risk_percentage,

    ROUND(
        AVG(`Days for shipping (real)`),
        2
    ) AS average_shipping_days

FROM datacosupplychaindataset

GROUP BY `Order Region`

ORDER BY late_delivery_risk_percentage DESC

LIMIT 10;


/* ============================================================
   12. DELIVERY STATUS BY MARKET
   ============================================================ */

SELECT

    `Market`,

    `Delivery Status` AS delivery_status,

    COUNT(DISTINCT `Order Id`) AS total_shipments

FROM datacosupplychaindataset

GROUP BY
    `Market`,
    `Delivery Status`

ORDER BY
    `Market`,
    total_shipments DESC;


/* ============================================================
   13. DELIVERY STATUS BY SHIPPING MODE
   ============================================================ */

SELECT

    `Shipping Mode` AS shipping_mode,

    `Delivery Status` AS delivery_status,

    COUNT(DISTINCT `Order Id`) AS total_shipments

FROM datacosupplychaindataset

GROUP BY
    `Shipping Mode`,
    `Delivery Status`

ORDER BY
    `Shipping Mode`,
    total_shipments DESC;


/* ============================================================
   14. LATE DELIVERIES BY MARKET
   ============================================================ */

SELECT

    `Market`,

    COUNT(
        DISTINCT CASE
            WHEN `Late_delivery_risk` = 1
            THEN `Order Id`
        END
    ) AS late_shipments,

    COUNT(DISTINCT `Order Id`) AS total_shipments,

    ROUND(
        COUNT(
            DISTINCT CASE
                WHEN `Late_delivery_risk` = 1
                THEN `Order Id`
            END
        ) * 100.0
        /
        NULLIF(COUNT(DISTINCT `Order Id`), 0),
        2
    ) AS late_delivery_risk_percentage

FROM datacosupplychaindataset

GROUP BY `Market`

ORDER BY late_delivery_risk_percentage DESC;


/* ============================================================
   15. LATE DELIVERIES BY SHIPPING MODE
   ============================================================ */

SELECT

    `Shipping Mode` AS shipping_mode,

    COUNT(
        DISTINCT CASE
            WHEN `Late_delivery_risk` = 1
            THEN `Order Id`
        END
    ) AS late_shipments,

    COUNT(DISTINCT `Order Id`) AS total_shipments,

    ROUND(
        COUNT(
            DISTINCT CASE
                WHEN `Late_delivery_risk` = 1
                THEN `Order Id`
            END
        ) * 100.0
        /
        NULLIF(COUNT(DISTINCT `Order Id`), 0),
        2
    ) AS late_delivery_risk_percentage

FROM datacosupplychaindataset

GROUP BY `Shipping Mode`

ORDER BY late_delivery_risk_percentage DESC;


/* ============================================================
   16. LATE DELIVERIES BY CUSTOMER SEGMENT
   ============================================================ */

SELECT

    `Customer Segment` AS customer_segment,

    COUNT(DISTINCT `Order Id`) AS total_shipments,

    COUNT(
        DISTINCT CASE
            WHEN `Late_delivery_risk` = 1
            THEN `Order Id`
        END
    ) AS late_shipments,

    ROUND(
        AVG(`Late_delivery_risk`) * 100,
        2
    ) AS late_delivery_risk_percentage

FROM datacosupplychaindataset

GROUP BY `Customer Segment`

ORDER BY late_delivery_risk_percentage DESC;


/* ============================================================
   17. LATE DELIVERIES BY REGION AND SHIPPING MODE
   ============================================================ */

SELECT

    `Order Region` AS region,

    `Shipping Mode` AS shipping_mode,

    COUNT(DISTINCT `Order Id`) AS total_shipments,

    ROUND(
        AVG(`Late_delivery_risk`) * 100,
        2
    ) AS late_delivery_risk_percentage,

    ROUND(
        AVG(`Days for shipping (real)`),
        2
    ) AS average_shipping_days

FROM datacosupplychaindataset

GROUP BY
    `Order Region`,
    `Shipping Mode`

ORDER BY late_delivery_risk_percentage DESC;


/* ============================================================
   18. LATE DELIVERY RISK BY CATEGORY
   ============================================================ */

SELECT

    `Category Name` AS category,

    COUNT(DISTINCT `Order Id`) AS total_shipments,

    COUNT(
        DISTINCT CASE
            WHEN `Late_delivery_risk` = 1
            THEN `Order Id`
        END
    ) AS late_shipments,

    ROUND(
        AVG(`Late_delivery_risk`) * 100,
        2
    ) AS late_delivery_risk_percentage

FROM datacosupplychaindataset

GROUP BY `Category Name`

ORDER BY late_delivery_risk_percentage DESC;


/* ============================================================
   19. DELIVERY PERFORMANCE BY ORDER STATUS
   ============================================================ */

SELECT

    `Order Status`,

    COUNT(DISTINCT `Order Id`) AS total_shipments,

    ROUND(
        AVG(`Late_delivery_risk`) * 100,
        2
    ) AS late_delivery_risk_percentage,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit

FROM datacosupplychaindataset

GROUP BY `Order Status`

ORDER BY late_delivery_risk_percentage DESC;


/* ============================================================
   20. SHIPPING MODE × MARKET
   ============================================================ */

SELECT

    `Market`,

    `Shipping Mode` AS shipping_mode,

    COUNT(DISTINCT `Order Id`) AS total_shipments,

    ROUND(
        AVG(`Days for shipping (real)`),
        2
    ) AS average_shipping_days,

    ROUND(
        AVG(`Late_delivery_risk`) * 100,
        2
    ) AS late_delivery_risk_percentage

FROM datacosupplychaindataset

GROUP BY
    `Market`,
    `Shipping Mode`

ORDER BY
    `Market`,
    late_delivery_risk_percentage DESC;


/* ============================================================
   21. SHIPPING MODE × CUSTOMER SEGMENT
   ============================================================ */

SELECT

    `Shipping Mode` AS shipping_mode,

    `Customer Segment` AS customer_segment,

    COUNT(DISTINCT `Order Id`) AS total_shipments,

    ROUND(
        AVG(`Late_delivery_risk`) * 100,
        2
    ) AS late_delivery_risk_percentage,

    ROUND(
        AVG(`Days for shipping (real)`),
        2
    ) AS average_shipping_days

FROM datacosupplychaindataset

GROUP BY
    `Shipping Mode`,
    `Customer Segment`

ORDER BY late_delivery_risk_percentage DESC;


/* ============================================================
   22. TOP 10 MARKETS / REGIONS BY SHIPPING DELAY
   ============================================================ */

SELECT

    `Market`,

    `Order Region` AS region,

    COUNT(DISTINCT `Order Id`) AS total_shipments,

    ROUND(
        AVG(`Days for shipping (real)`)
        -
        AVG(`Days for shipment (scheduled)`),
        2
    ) AS average_shipping_delay,

    ROUND(
        AVG(`Late_delivery_risk`) * 100,
        2
    ) AS late_delivery_risk_percentage

FROM datacosupplychaindataset

GROUP BY
    `Market`,
    `Order Region`

ORDER BY average_shipping_delay DESC

LIMIT 10;


/* ============================================================
   23. LOGISTICS REVENUE IMPACT
   ============================================================ */

SELECT

    `Delivery Status` AS delivery_status,

    COUNT(DISTINCT `Order Id`) AS total_shipments,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,

    ROUND(
        SUM(`Order Profit Per Order`)
        / NULLIF(SUM(`Sales`), 0) * 100,
        2
    ) AS profit_margin_percentage

FROM datacosupplychaindataset

GROUP BY `Delivery Status`

ORDER BY total_sales DESC;


/* ============================================================
   24. LATE VS NON-LATE SALES
   ============================================================ */

SELECT

    CASE

        WHEN `Late_delivery_risk` = 1
            THEN 'Late Delivery Risk'

        ELSE 'No Late Delivery Risk'

    END AS delivery_risk_status,

    COUNT(DISTINCT `Order Id`) AS total_shipments,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit

FROM datacosupplychaindataset

GROUP BY delivery_risk_status

ORDER BY total_shipments DESC;


/* ============================================================
   25. STANDARD CLASS SHARE
   ============================================================ */

SELECT

    COUNT(
        DISTINCT CASE
            WHEN `Shipping Mode` = 'Standard Class'
            THEN `Order Id`
        END
    ) AS standard_class_shipments,

    COUNT(DISTINCT `Order Id`) AS total_shipments,

    ROUND(

        COUNT(
            DISTINCT CASE
                WHEN `Shipping Mode` = 'Standard Class'
                THEN `Order Id`
            END
        ) * 100.0

        /

        NULLIF(
            COUNT(DISTINCT `Order Id`),
            0
        ),

        2

    ) AS standard_class_share_percentage

FROM datacosupplychaindataset;


/* ============================================================
   26. STANDARD CLASS DELIVERY PERFORMANCE
   ============================================================ */

SELECT

    `Shipping Mode`,

    COUNT(DISTINCT `Order Id`) AS total_shipments,

    ROUND(
        AVG(`Late_delivery_risk`) * 100,
        2
    ) AS late_delivery_risk_percentage,

    ROUND(
        AVG(`Days for shipping (real)`),
        2
    ) AS average_shipping_days

FROM datacosupplychaindataset

WHERE `Shipping Mode` = 'Standard Class'

GROUP BY `Shipping Mode`;


/* ============================================================
   27. SHIPPING MODE RISK CLASSIFICATION
   ============================================================ */

SELECT

    `Shipping Mode` AS shipping_mode,

    COUNT(DISTINCT `Order Id`) AS total_shipments,

    ROUND(
        AVG(`Late_delivery_risk`) * 100,
        2
    ) AS late_delivery_risk_percentage,

    CASE

        WHEN AVG(`Late_delivery_risk`) >= 0.75
            THEN 'Very High Risk'

        WHEN AVG(`Late_delivery_risk`) >= 0.50
            THEN 'High Risk'

        WHEN AVG(`Late_delivery_risk`) >= 0.25
            THEN 'Moderate Risk'

        ELSE 'Low Risk'

    END AS logistics_risk_classification

FROM datacosupplychaindataset

GROUP BY `Shipping Mode`

ORDER BY late_delivery_risk_percentage DESC;


/* ============================================================
   28. MONTHLY DELIVERY PERFORMANCE
   ============================================================ */

SELECT

    YEAR(`order date (DateOrders)`) AS order_year,

    MONTH(`order date (DateOrders)`) AS order_month,

    DATE_FORMAT(
        `order date (DateOrders)`,
        '%Y-%m'
    ) AS year_month,

    COUNT(DISTINCT `Order Id`) AS total_shipments,

    ROUND(
        AVG(`Days for shipping (real)`),
        2
    ) AS average_shipping_days,

    ROUND(
        AVG(`Late_delivery_risk`) * 100,
        2
    ) AS late_delivery_risk_percentage

FROM datacosupplychaindataset

GROUP BY

    YEAR(`order date (DateOrders)`),

    MONTH(`order date (DateOrders)`),

    DATE_FORMAT(
        `order date (DateOrders)`,
        '%Y-%m'
    )

ORDER BY
    order_year,
    order_month;


/* ============================================================
   29. YEARLY DELIVERY PERFORMANCE
   ============================================================ */

SELECT

    YEAR(`order date (DateOrders)`) AS order_year,

    COUNT(DISTINCT `Order Id`) AS total_shipments,

    ROUND(
        AVG(`Days for shipping (real)`),
        2
    ) AS average_shipping_days,

    ROUND(
        AVG(`Days for shipment (scheduled)`),
        2
    ) AS average_scheduled_days,

    ROUND(
        AVG(`Late_delivery_risk`) * 100,
        2
    ) AS late_delivery_risk_percentage

FROM datacosupplychaindataset

GROUP BY YEAR(`order date (DateOrders)`)

ORDER BY order_year;


/* ============================================================
   30. LOGISTICS BOTTLENECK IDENTIFICATION
   ============================================================ */

SELECT

    `Shipping Mode` AS shipping_mode,

    `Market`,

    COUNT(DISTINCT `Order Id`) AS total_shipments,

    ROUND(
        AVG(`Days for shipping (real)`)
        -
        AVG(`Days for shipment (scheduled)`),
        2
    ) AS average_shipping_delay,

    ROUND(
        AVG(`Late_delivery_risk`) * 100,
        2
    ) AS late_delivery_risk_percentage,

    CASE

        WHEN AVG(`Late_delivery_risk`) >= 0.75
            THEN 'Critical Bottleneck'

        WHEN AVG(`Late_delivery_risk`) >= 0.50
            THEN 'High Priority'

        WHEN AVG(`Late_delivery_risk`) >= 0.25
            THEN 'Monitor'

        ELSE 'Lower Priority'

    END AS logistics_priority

FROM datacosupplychaindataset

GROUP BY
    `Shipping Mode`,
    `Market`

ORDER BY
    late_delivery_risk_percentage DESC;


/* ============================================================
   31. TOP 10 HIGH-RISK SHIPPING COMBINATIONS
   ============================================================ */

SELECT

    `Shipping Mode` AS shipping_mode,

    `Order Region` AS region,

    `Market`,

    COUNT(DISTINCT `Order Id`) AS total_shipments,

    ROUND(
        AVG(`Late_delivery_risk`) * 100,
        2
    ) AS late_delivery_risk_percentage,

    ROUND(
        AVG(`Days for shipping (real)`),
        2
    ) AS average_shipping_days

FROM datacosupplychaindataset

GROUP BY
    `Shipping Mode`,
    `Order Region`,
    `Market`

HAVING total_shipments >= 100

ORDER BY late_delivery_risk_percentage DESC

LIMIT 10;


/* ============================================================
   32. LOGISTICS PERFORMANCE BY COUNTRY
   ============================================================ */

SELECT

    `Order Country` AS country,

    COUNT(DISTINCT `Order Id`) AS total_shipments,

    ROUND(
        AVG(`Days for shipping (real)`),
        2
    ) AS average_shipping_days,

    ROUND(
        AVG(`Late_delivery_risk`) * 100,
        2
    ) AS late_delivery_risk_percentage,

    ROUND(SUM(`Sales`), 2) AS total_sales

FROM datacosupplychaindataset

GROUP BY `Order Country`

ORDER BY late_delivery_risk_percentage DESC

LIMIT 20;


/* ============================================================
   33. LOGISTICS PERFORMANCE BY REGION
   ============================================================ */

SELECT

    `Order Region` AS region,

    COUNT(DISTINCT `Order Id`) AS total_shipments,

    ROUND(
        AVG(`Days for shipping (real)`),
        2
    ) AS average_shipping_days,

    ROUND(
        AVG(`Days for shipment (scheduled)`),
        2
    ) AS average_scheduled_days,

    ROUND(
        AVG(`Late_delivery_risk`) * 100,
        2
    ) AS late_delivery_risk_percentage,

    ROUND(SUM(`Sales`), 2) AS total_sales

FROM datacosupplychaindataset

GROUP BY `Order Region`

ORDER BY late_delivery_risk_percentage DESC;


/* ============================================================
   34. DELIVERY RISK × SALES IMPACT
   ============================================================ */

SELECT

    `Market`,

    COUNT(DISTINCT `Order Id`) AS total_shipments,

    ROUND(SUM(`Sales`), 2) AS total_sales,

    ROUND(
        AVG(`Late_delivery_risk`) * 100,
        2
    ) AS late_delivery_risk_percentage,

    ROUND(
        SUM(
            CASE
                WHEN `Late_delivery_risk` = 1
                THEN `Sales`
                ELSE 0
            END
        ),
        2
    ) AS sales_under_late_delivery_risk

FROM datacosupplychaindataset

GROUP BY `Market`

ORDER BY sales_under_late_delivery_risk DESC;


/* ============================================================
   35. FINAL LOGISTICS KPI SUMMARY
   ============================================================ */

SELECT

    COUNT(DISTINCT `Order Id`)
        AS total_shipments,

    ROUND(
        AVG(`Days for shipping (real)`),
        2
    ) AS average_shipping_days,

    ROUND(
        AVG(`Days for shipment (scheduled)`),
        2
    ) AS average_scheduled_shipping_days,

    ROUND(
        AVG(`Days for shipping (real)`)
        -
        AVG(`Days for shipment (scheduled)`),
        2
    ) AS average_shipping_delay,

    ROUND(
        AVG(`Late_delivery_risk`) * 100,
        2
    ) AS late_delivery_risk_percentage,

    COUNT(
        DISTINCT CASE
            WHEN `Late_delivery_risk` = 1
            THEN `Order Id`
        END
    ) AS late_shipments

FROM datacosupplychaindataset;


/* ============================================================
   END OF LOGISTICS & DELIVERY ANALYSIS
   ============================================================ */
