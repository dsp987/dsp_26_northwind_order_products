SELECT ship_address,ship_city, ship_region, ship_postal_code,ship_country
FROM staging.orders

--definir as tabelas dimensões
    --dim_order_date
    --dim_required_date
    --dim_shipped_date
    --dim_branch
    --dim_employee
    --dim_customer
    --dim_orders_details

--###########################################################################################################################################

--dim_order_date
 DROP TABLE IF EXISTS dw.dim_order_date CASCADE;
 CREATE TABLE dw.dim_order_date(
    order_date_sk                   INTEGER     PRIMARY KEY, --YYYYMMDD
    order_date_full                 DATE        NOT NULL UNIQUE,
    order_day                       SMALLINT    NOT NULL,
    order_month                     SMALLINT    NOT NULL,
    order_month_name                VARCHAR(15) NOT NULL,
    order_quarter                   SMALLINT    NOT NULL,
    order_year                      SMALLINT    NOT NULL,
    order_day_of_week               VARCHAR(15) NOT NULL,
    order_date_is_weekend           BOOLEAN     NOT NULL
 );
 INSERT INTO dw.dim_order_date 
 SELECT
    CAST(TO_CHAR(d, 'YYYYMMDD') AS INTEGER),                    --order_date_sk
    d::DATE,                                                    --order_date_full    
    EXTRACT(DAY FROM d)::SMALLINT,                              --order_day
    EXTRACT(MONTH FROM d)::SMALLINT,                            --order_month    
    TO_CHAR(d, 'TMMonth'),                                      --order_month_name            
    EXTRACT(QUARTER FROM d)::SMALLINT,                          --order_quarter
    EXTRACT(YEAR FROM d)::SMALLINT,                             --order_year
    TO_CHAR(d, 'TMDay'),                                        --order_day_of_week
    EXTRACT(DOW FROM d) IN (0,6)                                --order_date_is_weekend    
 FROM generate_series(DATE '1996-07-04', DATE '1998-05-06', INTERVAL '1 day') g(d);

SELECT * FROM dw.dim_order_date

--###########################################################################################################################################

--dim_required_date

 DROP TABLE IF EXISTS dw.dim_required_date CASCADE;
 CREATE TABLE dw.dim_required_date(
    required_date_sk                   INTEGER     PRIMARY KEY, --YYYYMMDD
    required_date_full                 DATE        NOT NULL UNIQUE,
    required_day                       SMALLINT    NOT NULL,
    required_month                     SMALLINT    NOT NULL,
    required_month_name                VARCHAR(15) NOT NULL,
    required_quarter                   SMALLINT    NOT NULL,
    required_year                      SMALLINT    NOT NULL,
    required_day_of_week               VARCHAR(15) NOT NULL,
    required_date_is_weekend           BOOLEAN     NOT NULL
 );
 INSERT INTO dw.dim_required_date 
 SELECT
    CAST(TO_CHAR(d, 'YYYYMMDD') AS INTEGER),                    --required_date_sk
    d::DATE,                                                    --required_date_full    
    EXTRACT(DAY FROM d)::SMALLINT,                              --required_day
    EXTRACT(MONTH FROM d)::SMALLINT,                            --required_month    
    TO_CHAR(d, 'TMMonth'),                                      --required_month_name            
    EXTRACT(QUARTER FROM d)::SMALLINT,                          --required_quarter
    EXTRACT(YEAR FROM d)::SMALLINT,                             --required_year
    TO_CHAR(d, 'TMDay'),                                        --required_day_of_week
    EXTRACT(DOW FROM d) IN (0,6)                                --required_date_is_weekend    
 FROM generate_series(DATE '1996-07-04', DATE '1998-05-06', INTERVAL '1 day') g(d);

 SELECT * FROM dw.dim_required_date

--###########################################################################################################################################

--dim_shipped_date

 DROP TABLE IF EXISTS dw.dim_shipped_date CASCADE;
 CREATE TABLE dw.dim_shipped_date(
    shipped_date_sk                   INTEGER     PRIMARY KEY, --YYYYMMDD
    shipped_date_full                 DATE        NOT NULL UNIQUE,
    shipped_day                       SMALLINT    NOT NULL,
    shipped_month                     SMALLINT    NOT NULL,
    shipped_month_name                VARCHAR(15) NOT NULL,
    shipped_quarter                   SMALLINT    NOT NULL,
    shipped_year                      SMALLINT    NOT NULL,
    shipped_day_of_week               VARCHAR(15) NOT NULL,
    shipped_date_is_weekend           BOOLEAN     NOT NULL
 );
 INSERT INTO dw.dim_shipped_date 
 SELECT
    CAST(TO_CHAR(d, 'YYYYMMDD') AS INTEGER),                    --shipped_date_sk
    d::DATE,                                                    --shipped_date_full    
    EXTRACT(DAY FROM d)::SMALLINT,                              --shipped_day
    EXTRACT(MONTH FROM d)::SMALLINT,                            --shipped_month    
    TO_CHAR(d, 'TMMonth'),                                      --shipped_month_name            
    EXTRACT(QUARTER FROM d)::SMALLINT,                          --shipped_quarter
    EXTRACT(YEAR FROM d)::SMALLINT,                             --shipped_year
    TO_CHAR(d, 'TMDay'),                                        --shipped_day_of_week
    EXTRACT(DOW FROM d) IN (0,6)                                --shipped_date_is_weekend    
 FROM generate_series(DATE '1996-07-04', DATE '1998-05-06', INTERVAL '1 day') g(d);

 SELECT * FROM dw.dim_shipped_date

 --###########################################################################################################################################

--dim_branch

DROP TABLE IF EXISTS dw.dim_branch CASCADE;
CREATE TABLE dw.dim_branch (
    branch_sk   SERIAL          PRIMARY KEY UNIQUE,
    city        VARCHAR(100)    NOT NULL,
    region      VARCHAR(50)     NOT NULL,
    country     VARCHAR(100)    NOT NULL
);

SELECT * FROM dw.dim_branch;

--###########################################################################################################################################

--dim_employee

DROP TABLE IF EXISTS dw.dim_employee;
CREATE TABLE dw.dim_employee(
    employee_id_sk  SERIAL PRIMARY KEY,
    order_id        CHAR(6) NOT NULL,
    order_date      DATE NOT NULL
);

SELECT * FROM dw.dim_employee

--###########################################################################################################################################

--dim_customer

DROP TABLE IF EXISTS dw.dim_customer CASCADE;
CREATE TABLE dw.dim_customer(
    customer_sk     SERIAL PRIMARY KEY,
    freight         NUMERIC(10,2) NOT NULL,
    ship_address    VARCHAR(100) NOT NULL
);

SELECT * FROM dw.dim_customer

--###########################################################################################################################################

--dim_orders_details

DROP TABLE IF EXISTS dw.dim_orders_details CASCADE;
CREATE TABLE dw.dim_orders_details(
    order_sk        SERIAL PRIMARY KEY,
    product_id      VARCHAR(50)     NOT NULL,
    unit_price      NUMERIC(10,2)   NOT NULL,
    quantity        INTEGER         NOT NULL,
    discount        NUMERIC(10,2)   NOT NULL
);

SELECT * FROM dw.dim_orders_details

--###########################################################################################################################################

--carga das dimensões

INSERT INTO dw.dim_branch(city, region, country)
SELECT DISTINCT ship_city, ship_region, ship_country FROM staging.orders

SELECT * FROM dw.dim_branch

--*****************************************************************************

INSERT INTO dw.dim_employee(order_id, order_date)
SELECT DISTINCT order_id, order_date FROM staging.orders

SELECT * FROM dw.dim_employee

--*****************************************************************************

INSERT INTO dw.dim_customer(freight, ship_address)
SELECT DISTINCT freight, ship_address FROM staging.orders

SELECT * FROM dw.dim_customer

--*****************************************************************************

INSERT INTO dw.dim_orders_details(product_id, unit_price, quantity, discount)
SELECT DISTINCT product_id, unit_price, quantity, discount FROM staging.orders_details

SELECT * FROM dw.dim_orders_details

--###########################################################################################################################################

--Verificação das tabelas dimensões
SELECT 'employee' AS dimensao, COUNT(*) AS linhas FROM dw.dim_employee 
UNION ALL
SELECT 'branch', COUNT(*) FROM dw.dim_branch
UNION ALL
SELECT 'customer', COUNT(*) FROM dw.dim_customer
UNION ALL
SELECT 'orders_details', COUNT(*) FROM dw.dim_orders_details;


--###########################################################################################################################################

