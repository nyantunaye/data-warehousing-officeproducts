/* =============================================================================
   Analytical Queries — OfficeProducts Data Warehouse
   Database: Oracle SQL
   Project: Data Warehousing Project
   Authors: Antonius Dimitri Adhisatrio (24253701), Nyan Tun Aye (23198368)
   ============================================================================= */


/* -----------------------------------------------------------------------------
   QUERY 1: Top 3 Countries by Total Sales Amount
   (Image 14 & 17)
----------------------------------------------------------------------------- */
WITH sales_agg AS (
    SELECT
        country_iso_code,
        country_name,
        SUM(sales_amount) AS sales,
        RANK() OVER (ORDER BY SUM(sales_amount) DESC) AS rnk
    FROM
        sales_country
    GROUP BY
        country_iso_code, country_name
)
SELECT
    country_iso_code  "Country ISO Code",
    country_name      "Country Name",
    sales             sales
FROM
    sales_agg
WHERE
    rnk <= 3
ORDER BY
    sales DESC;

/* Expected results (Image 14):
   1  US  United States of America  52910773.15
   2  DE  Germany                    9210129.22
   3  JP  Japan                      7207880.09  */


/* -----------------------------------------------------------------------------
   QUERY 2: Best-Selling Product Per Year (Top 1 by Quantity Sold)
   (Image 15)
----------------------------------------------------------------------------- */
WITH sum_sold AS (
    SELECT
        calendar_year,
        prod_name,
        SUM(quantity_sold) AS quantity,
        RANK() OVER (
            PARTITION BY calendar_year
            ORDER BY SUM(quantity_sold) DESC
        ) AS rnk
    FROM
        sh.sales       -- Oracle sample SH schema
    GROUP BY
        calendar_year, prod_name
)
SELECT
    calendar_year,
    prod_name,
    quantity  total_quantity
FROM
    sum_sold
WHERE
    rnk = 1
ORDER BY
    calendar_year;

/* Expected results (Image 15):
   1998  O/S Documentation Set - English   4729
   1999  Mouse Pad                          4603
   2000  1.44MB External 3.5" Diskette     4353
   2001  Keyboard Wrist Rest               4587  */


/* -----------------------------------------------------------------------------
   QUERY 3: Sales by Channel for the Best-Selling Product
   (Image 16)
----------------------------------------------------------------------------- */
WITH max_prod AS (
    SELECT prod_id
    FROM   sh.sales
    GROUP BY prod_id
    ORDER BY SUM(quantity_sold) DESC
    FETCH FIRST 1 ROW ONLY
)
SELECT
    prod_id,
    sl.channel_id,
    channel_desc,
    COUNT(*)            AS num_trans,
    SUM(quantity_sold)  AS total_quantity
FROM
    sh.sales sl
    INNER JOIN sh.channels ch
        ON sl.channel_id = ch.channel_id
    INNER JOIN dim_time dt
        ON sl.time_id = dt.time_id
WHERE
    prod_id = (SELECT * FROM max_prod)
GROUP BY
    prod_id, sl.channel_id, channel_desc
ORDER BY
    total_quantity DESC;

/* Expected results (Image 16):
   18  3  Direct Sales   1198  1198
   18  2  Partners        666   666
   18  4  Internet        494   494  */


/* -----------------------------------------------------------------------------
   QUERY 4: Promotion Analysis — Materialised View
   (Image 18)
----------------------------------------------------------------------------- */

-- Create materialised view
CREATE MATERIALIZED VIEW Promotion_Analysis_mv AS
    SELECT
        promo_id,
        prod_id,
        SUM(amount_sold) total_sales
    FROM
        sh.sales
    GROUP BY
        promo_id, prod_id;

-- Query the materialised view
SELECT *
FROM   Promotion_Analysis_mv;

/* Sample results (Image 18):
   999   19   600229.34
   999   33   1014718.35
   999   40   1251974.58
   999   43   394496.38
   999   46   230247.3    */


/* -----------------------------------------------------------------------------
   QUERY 5: Promotion Sales Rollup (Subtotals by Promo and Product)
   (Image 19)
----------------------------------------------------------------------------- */
SELECT
    COALESCE(TO_CHAR(promo_id), 'ALL PROMO')  promo_id,
    COALESCE(TO_CHAR(prod_id),  'ALL PROD')   prod_id,
    COUNT(promo_id)  count_promo,
    COUNT(prod_id)   count_prod,
    SUM(total_sales) total_sales
FROM
    Promotion_Analysis_mv
GROUP BY
    ROLLUP(promo_id, prod_id)
ORDER BY
    count_promo DESC;

/* Sample results (Image 19):
   ALL PROMO  ALL PROD   212  212  98205831.21
   999        ALL PROD    72   72  94504520.79
   351        ALL PROD    71   71  1224503.26
   350        ALL PROD    57   57  1562875.84   */


/* -----------------------------------------------------------------------------
   QUERY 6: Month-to-Date (MTD) and Year-to-Date (YTD) Sales by Channel
   (Image 20)
----------------------------------------------------------------------------- */
WITH mtd_channel AS (
    SELECT
        calendar_year,
        month_desc,
        channel_desc,
        SUM(amount_sold) AS total_mtd
    FROM
        sh.sales sl
        INNER JOIN sh.channels ch  ON sl.channel_id = ch.channel_id
        INNER JOIN sh.times t      ON sl.time_id     = t.time_id
    GROUP BY
        calendar_year, month_desc, channel_desc
),
mtd AS (
    SELECT
        calendar_year,
        month_desc,
        channel_desc,
        total_mtd
    FROM mtd_channel
)
SELECT
    calendar_year,
    month_desc,
    channel_desc,
    total_mtd                                                          AS mtd_channel_sales,
    SUM(total_mtd) OVER (
        PARTITION BY calendar_year
        ORDER BY month_desc
    )                                                                  AS ytd_channel_sales
FROM
    mtd
GROUP BY
    calendar_year, month_desc, channel_desc, total_mtd

UNION ALL

SELECT
    calendar_year,
    CONCAT(month_desc, '-TOTAL'),
    channel_desc,
    total_mtd,
    SUM(total_mtd) OVER (PARTITION BY calendar_year ORDER BY month_desc)
FROM
    mtd
GROUP BY
    calendar_year, month_desc, channel_desc, total_mtd

ORDER BY
    calendar_year, month_desc, channel_desc;

/* Sample results (Image 20 — 1998 data):
   1998  1998-10         Direct Sales   1344301.23   ...
   1998  1998-10-TOTAL   ALL CHANNELS   1921230.06   19978996.86
   1998  1998-11         Direct Sales   1344301.23   14547417.97
   ...                                                             */
