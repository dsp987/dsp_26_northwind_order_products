DROP TABLE IF EXISTS dw.fact_orders CASCADE

CREATE TABLE dw.fact_orders(
    order_date_sk       VARCHAR(20) PRIMARY KEY,
    required_date_sk    INTEGER NOT NULL REFERENCES dw.dim_required_date(required_date_sk),
    shipped_date_sk     INTEGER NOT NULL REFERENCES dw.dim_shipped_date(shipped_date_sk),
    employee_sk         INTEGER NOT NULL REFERENCES dw.dim_employee(employee_id_sk),
    branck_sk           INTEGER NOT NULL REFERENCES dw.dim_branch(branch_sk),
    customer_sk         INTEGER NOT NULL REFERENCES dw.dim_customer(customer_sk),
    freight             NUMERIC(10,2) NOT NULL    
);

SELECT * FROM dw.fact_orders

CREATE INDEX ix_fs_order_date       ON dw.fact_orders(order_date_sk);
CREATE INDEX ix_fs_required_date    ON dw.fact_orders(required_date_sk);
CREATE INDEX ix_fs_shipped_date     ON dw.fact_orders(shipped_date_sk);
CREATE INDEX ix_fs_branch           ON dw.fact_orders(branck_sk);
CREATE INDEX ix_fs_employee         ON dw.fact_orders(employee_sk);
CREATE INDEX ix_fs_customer         ON dw.fact_orders(customer_sk);  

--###########################################################################################################################################

--OBS: Até aqui observamos a construção da tabela fato, com suas respectivas SK(chaves candidatas), porém, há apenas um atributo calculável (freight)
--e outros não foram incluídos por ser de única fonte. É necessário fazer alterações e inclusão de tabela dimensão sobre compras para completar
--a tabela fato