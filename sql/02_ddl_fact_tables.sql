/* =============================================================================
   DDL: Fact Tables — OfficeProducts Data Warehouse
   Schema: access
   Database: Oracle SQL
   Project: Data Warehousing Project
   Authors: Antonius Dimitri Adhisatrio (24253701), Nyan Tun Aye (23198368)

   NOTE: Run 01_ddl_dimension_tables.sql BEFORE this script.
   ============================================================================= */


/* -----------------------------------------------------------------------------
   1. fact_transaction_header
   FK → dim_calendar, dim_client, dim_channel, dim_payment
----------------------------------------------------------------------------- */
CREATE TABLE fact_transaction_header (
    transaction_id            VARCHAR2(8)     PRIMARY KEY,
    "date"                    DATE            NOT NULL,
    client_id                 VARCHAR2(10)    NOT NULL,
    transaction_type          VARCHAR2(10)    NOT NULL,
    channel_id                VARCHAR2(3)     NOT NULL,
    payment_id                VARCHAR2(6)     NOT NULL,
    total_price               NUMBER(5, 2)    DEFAULT 0 NOT NULL,
    total_shipping_cost       NUMBER(5, 2)    DEFAULT 0 NOT NULL,
    payment_term_fee          NUMBER(5, 2)    DEFAULT 0 NOT NULL,
    total_transaction_amount  NUMBER(5, 2)    DEFAULT 0 NOT NULL,
    transaction_status        VARCHAR2(10)    NOT NULL,
    created_timestamp         TIMESTAMP       NOT NULL,
    updated_timestamp         TIMESTAMP       NOT NULL,
    FOREIGN KEY ("date")       REFERENCES dim_calendar(date_id),
    FOREIGN KEY (client_id)    REFERENCES dim_client(client_id),
    FOREIGN KEY (channel_id)   REFERENCES dim_channel(channel_id),
    FOREIGN KEY (payment_id)   REFERENCES dim_payment(payment_id)
);


/* -----------------------------------------------------------------------------
   2. fact_transaction_line_items
   FK → fact_transaction_header, dim_product, dim_promotion,
        dim_warehouse, dim_shipped_to, dim_calendar
----------------------------------------------------------------------------- */
CREATE TABLE fact_transaction_line_items (
    line_id           VARCHAR2(10)    PRIMARY KEY,
    transaction_id    VARCHAR2(8)     NOT NULL,
    line_number       NUMBER(4, 0)    NOT NULL,
    product_id        VARCHAR2(6)     NOT NULL,
    promotion_code    VARCHAR2(6),
    uom               VARCHAR2(10)    NOT NULL,
    quantity          NUMBER(3, 0)    DEFAULT 0 NOT NULL,
    price             NUMBER(5, 2)    DEFAULT 0 NOT NULL,
    shipping_cost     NUMBER(5, 2)    DEFAULT 0 NOT NULL,
    promotion_amount  NUMBER(5, 2)    DEFAULT 0 NOT NULL,
    total_price       NUMBER(5, 2)    DEFAULT 0 NOT NULL,
    warehouse_id      VARCHAR2(5)     NOT NULL,
    shipped_to_id     VARCHAR2(5)     NOT NULL,
    shipping_type     VARCHAR2(3)     NOT NULL,
    shipping_date     DATE,
    delivered_date    DATE,
    line_status       VARCHAR2(10)    NOT NULL,
    created_timestamp TIMESTAMP       NOT NULL,
    updated_timestamp TIMESTAMP       NOT NULL,
    FOREIGN KEY (transaction_id)  REFERENCES fact_transaction_header(transaction_id),
    FOREIGN KEY (product_id)      REFERENCES dim_product(product_id),
    FOREIGN KEY (promotion_code)  REFERENCES dim_promotion(promotion_code),
    FOREIGN KEY (warehouse_id)    REFERENCES dim_warehouse(warehouse_id),
    FOREIGN KEY (shipped_to_id)   REFERENCES dim_shipped_to(shipped_to_id),
    FOREIGN KEY (shipping_date)   REFERENCES dim_calendar(date_id),
    FOREIGN KEY (delivered_date)  REFERENCES dim_calendar(date_id)
);
