/* =============================================================================
   DDL: Dimension Tables — OfficeProducts Data Warehouse
   Schema: access
   Database: Oracle SQL
   Project: Data Warehousing Project
   Authors: Antonius Dimitri Adhisatrio (24253701), Nyan Tun Aye (23198368)
   ============================================================================= */


/* -----------------------------------------------------------------------------
   1. dim_postal_code
   (No FK dependencies — create first)
----------------------------------------------------------------------------- */
CREATE TABLE dim_postal_code (
    postal_code NUMBER(4, 0)    PRIMARY KEY,
    region      VARCHAR2(255)   NOT NULL,
    city        VARCHAR2(255)   NOT NULL,
    district    VARCHAR2(255)   NOT NULL
);


/* -----------------------------------------------------------------------------
   2. dim_calendar
   (No FK dependencies)
----------------------------------------------------------------------------- */
CREATE TABLE dim_calendar (
    date_id      DATE            PRIMARY KEY,
    year         NUMBER(4, 0)    NOT NULL,
    quarter      NUMBER(1, 0)    NOT NULL,
    month        NUMBER(2, 0)    NOT NULL,
    day          NUMBER(2, 0)    NOT NULL,
    day_name     VARCHAR2(10)    NOT NULL,
    week_day_flag NUMBER(1, 0)   NOT NULL,
    holiday_flag  NUMBER(1, 0)   NOT NULL
);


/* -----------------------------------------------------------------------------
   3. dim_channel
----------------------------------------------------------------------------- */
CREATE TABLE dim_channel (
    channel_id        VARCHAR2(3)     PRIMARY KEY,
    channel_type      VARCHAR2(20)    NOT NULL,
    channel_desc      VARCHAR2(255)   NOT NULL,
    active_flag       NUMBER(1, 0)    DEFAULT 1 NOT NULL,
    created_timestamp TIMESTAMP       DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_timestamp TIMESTAMP       DEFAULT CURRENT_TIMESTAMP NOT NULL
);


/* -----------------------------------------------------------------------------
   4. dim_payment
----------------------------------------------------------------------------- */
CREATE TABLE dim_payment (
    payment_id        VARCHAR2(6)     PRIMARY KEY,
    payment_type      VARCHAR2(20)    NOT NULL,
    description       VARCHAR2(255),
    payment_term      VARCHAR2(50)    NOT NULL,
    payment_method    VARCHAR2(10)    NOT NULL,
    uom               VARCHAR2(10)    NOT NULL,
    payment_fee_value NUMBER(5, 2)    NOT NULL,
    effective_from    DATE,
    effective_to      DATE,
    created_timestamp TIMESTAMP       DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_timestamp TIMESTAMP       DEFAULT CURRENT_TIMESTAMP NOT NULL
);


/* -----------------------------------------------------------------------------
   5. dim_supplier
----------------------------------------------------------------------------- */
CREATE TABLE dim_supplier (
    supplier_id       VARCHAR2(5)     PRIMARY KEY,
    supplier_name     VARCHAR2(30)    NOT NULL,
    supplier_type     VARCHAR2(10)    NOT NULL,
    contact_type      VARCHAR2(30)    NOT NULL,
    contact_detail    VARCHAR2(255)   NOT NULL,
    address_line1     VARCHAR2(255)   NOT NULL,
    address_line2     VARCHAR2(255),
    city              VARCHAR2(255)   NOT NULL,
    state             VARCHAR2(255)   NOT NULL,
    postal_code       NUMBER(4, 0)    NOT NULL,
    active_flag       NUMBER(1, 0)    DEFAULT 1 NOT NULL,
    created_timestamp TIMESTAMP       DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_timestamp TIMESTAMP       DEFAULT CURRENT_TIMESTAMP NOT NULL
);


/* -----------------------------------------------------------------------------
   6. dim_client
   (FK → dim_postal_code)
----------------------------------------------------------------------------- */
CREATE TABLE dim_client (
    client_id           VARCHAR2(10)    PRIMARY KEY,
    client_name         VARCHAR2(30)    NOT NULL,
    client_type         VARCHAR2(10)    NOT NULL,
    contact_type        VARCHAR2(30)    NOT NULL,
    contact_detail      VARCHAR2(255)   NOT NULL,
    address_line1       VARCHAR2(255)   NOT NULL,
    address_line2       VARCHAR2(255),
    city                VARCHAR2(255)   NOT NULL,
    state               VARCHAR2(255)   NOT NULL,
    postal_code         NUMBER(4, 0)    NOT NULL,
    active_flag         NUMBER(1, 0)    DEFAULT 1 NOT NULL,
    last_order_timestamp TIMESTAMP,
    created_timestamp   TIMESTAMP       NOT NULL,
    updated_timestamp   TIMESTAMP       NOT NULL,
    FOREIGN KEY (postal_code) REFERENCES dim_postal_code(postal_code)
);


/* -----------------------------------------------------------------------------
   7. dim_product
   (FK → dim_supplier)
----------------------------------------------------------------------------- */
CREATE TABLE dim_product (
    product_id        VARCHAR2(6)     PRIMARY KEY,
    product_name      VARCHAR2(30)    NOT NULL,
    description       VARCHAR2(255),
    uom               VARCHAR2(10)    NOT NULL,
    price             NUMBER(5, 2)    NOT NULL,
    product_type      VARCHAR2(30)    NOT NULL,
    supplier_id       VARCHAR2(5)     NOT NULL,
    active_flag       NUMBER(1, 0)    DEFAULT 1 NOT NULL,
    created_timestamp TIMESTAMP       DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_timestamp TIMESTAMP       DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (supplier_id) REFERENCES dim_supplier(supplier_id)
);


/* -----------------------------------------------------------------------------
   8. dim_promotion
----------------------------------------------------------------------------- */
CREATE TABLE dim_promotion (
    promotion_code    VARCHAR2(6)     PRIMARY KEY,
    description       VARCHAR2(255),
    promotion_type    VARCHAR2(10)    NOT NULL,
    uom               VARCHAR2(10)    NOT NULL,
    promotion_value   NUMBER(5, 2)    NOT NULL,
    effective_from    DATE,
    effective_to      DATE,
    active_flag       NUMBER(1, 0)    DEFAULT 1 NOT NULL,
    created_timestamp TIMESTAMP       DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_timestamp TIMESTAMP       DEFAULT CURRENT_TIMESTAMP NOT NULL
);


/* -----------------------------------------------------------------------------
   9. dim_warehouse
   (FK → dim_postal_code)
----------------------------------------------------------------------------- */
CREATE TABLE dim_warehouse (
    warehouse_id      VARCHAR2(5)     PRIMARY KEY,
    address_line1     VARCHAR2(255)   NOT NULL,
    address_line2     VARCHAR2(255),
    city              VARCHAR2(255)   NOT NULL,
    state             VARCHAR2(255)   NOT NULL,
    postal_code       NUMBER(4, 0)    NOT NULL,
    active_flag       NUMBER(1, 0)    DEFAULT 1 NOT NULL,
    created_timestamp TIMESTAMP       DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_timestamp TIMESTAMP       DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (postal_code) REFERENCES dim_postal_code(postal_code)
);


/* -----------------------------------------------------------------------------
   10. dim_shipped_to
   (FK → dim_postal_code)
----------------------------------------------------------------------------- */
CREATE TABLE dim_shipped_to (
    shipped_to_id     VARCHAR2(5)     PRIMARY KEY,
    customer_id       VARCHAR2(10)    NOT NULL,
    customer_name     VARCHAR2(30)    NOT NULL,
    address_line1     VARCHAR2(255)   NOT NULL,
    address_line2     VARCHAR2(255),
    city              VARCHAR2(255)   NOT NULL,
    state             VARCHAR2(255)   NOT NULL,
    postal_code       NUMBER(4, 0)    NOT NULL,
    active_flag       NUMBER(1, 0)    DEFAULT 1 NOT NULL,
    created_timestamp TIMESTAMP       DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_timestamp TIMESTAMP       DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (postal_code) REFERENCES dim_postal_code(postal_code)
);
