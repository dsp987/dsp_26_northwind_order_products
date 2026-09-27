DROP TABLE IF EXISTS staging.orders CASCADE;
CREATE TABLE staging.orders(
    order_id            VARCHAR(50)         PRIMARY KEY,
    customer_id         VARCHAR(50)         NOT NULL,
    employee_id         VARCHAR(50)         NOT NULL,
    order_date          TIMESTAMP           NOT NULL,
    required_date       TIMESTAMP           NOT NULL,
    shipped_date        TIMESTAMP           NOT NULL,
    ship_via            VARCHAR(50)          NOT NULL,
    freight             NUMERIC(10,2)       NOT NULL,
    ship_name           VARCHAR(100)        NOT NULL,
    ship_address        VARCHAR(100)        NOT NULL,
    ship_city           VARCHAR(70)         NOT NULL,
    ship_region         VARCHAR(50)         NOT NULL,
    ship_postal_code    VARCHAR(50)          NOT NULL,
    ship_country        VARCHAR(50)         NOT NULL
);

-- SELECT * FROM raw.orders;

INSERT INTO staging.orders(
    order_id, customer_id, employee_id,
    order_date, required_date, shipped_date,
    ship_via, freight, ship_name, ship_address,
    ship_city, ship_region, ship_postal_code, ship_country
)
SELECT
    TRIM(order_id),
    TRIM(customer_id),
    COALESCE(TRIM(employee_id),'00'),
    TRIM(order_date)::TIMESTAMP,
    TRIM(required_date)::TIMESTAMP,
    COALESCE(TRIM(shipped_date),'1900-01-01')::TIMESTAMP,
    TRIM(ship_via),
    TRIM(freight)::NUMERIC(10,2),
    INITCAP(TRIM(ship_name)),
    INITCAP(TRIM(ship_address)),
    INITCAP(TRIM(ship_city)),
    COALESCE(TRIM(ship_region), 'NC'),
    COALESCE(TRIM(ship_postal_code),'0000-000'),
    INITCAP(TRIM(ship_country))
FROM raw.orders;

SELECT COUNT(*) FROM staging.orders;

SELECT
    MIN(order_date),
    MAX(order_date)
FROM staging.orders    


