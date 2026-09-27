DROP TABLE IF NOT EXISTS raw.orders CASCADE
CREATE TABLE raw.orders(
    order_id            TEXT,
    customer_id         TEXT,
    employee_id         TEXT,
    order_date          TEXT,
    required_date       TEXT,
    shipped_date        TEXT,
    ship_via            TEXT,
    freight             TEXT,
    ship_name           TEXT,
    ship_address        TEXT,
    ship_city           TEXT,
    ship_region         TEXT,
    ship_postal_code    TEXT,
    ship_country        TEXT
);

SELECT * FROM raw.orders
LIMIT 5;

--###########################################################################################################################################
--v1.0.0
DROP TABLE IF EXISTS raw.orders_details CASCADE;
CREATE TABLE raw.orders_details(
    order_id        TEXT,
    product_id      TEXT,
    unit_price      TEXT,
    quantity        TEXT,
    discount        TEXT
);

SELECT * FROM raw.orders_details;
