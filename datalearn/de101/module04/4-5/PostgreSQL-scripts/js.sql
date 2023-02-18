drop schema if exists js cascade;
create schema js;

drop table if exists js.buy_methods;

CREATE TABLE js.buy_methods (
                buy_code CHAR(4) NOT NULL,
                buy_desc CHAR(25) NOT NULL,
                PRIMARY KEY (buy_code)
);

drop table if exists js.payment_methods;

CREATE TABLE js.payment_methods (
                pay_code CHAR(4) NOT NULL,
                pay_desc CHAR(25) NOT NULL,
                PRIMARY KEY (pay_code)
);

drop table if exists js.countries;

CREATE TABLE js.countries (
                cou_id INT NOT NULL,
                country_name CHAR(30) NOT NULL,
                PRIMARY KEY (cou_id)
);

drop table if exists js.cities;

CREATE TABLE js.cities (
                city_id INT NOT NULL,
                city_name CHAR(30) NOT NULL,
                cou_id INT NOT NULL,
                PRIMARY KEY (city_id)
);

drop table if exists js.customers;

CREATE TABLE js.customers (
                cus_id INT NOT NULL,
                cus_name CHAR(30) NOT NULL,
                cus_lastname CHAR(30) NOT NULL,
                add_street CHAR(50),
                add_zipcode CHAR(10),
                city_id INT NOT NULL,
                PRIMARY KEY (cus_id)
);

drop table if exists js.invoices;

CREATE TABLE js.invoices (
                invoice_number INT NOT NULL,
                buy_code CHAR(4) NOT NULL,
                inv_date DATE NOT NULL,
                pay_code CHAR(4) NOT NULL,
                inv_price NUMERIC(8,2) DEFAULT 0 NOT NULL,
                cus_id INT NOT NULL,
                PRIMARY KEY (invoice_number)
);

drop table if exists js.manufacturers;

CREATE TABLE js.manufacturers (
                man_code CHAR(3) NOT NULL,
                man_desc CHAR(25) NOT NULL,
                PRIMARY KEY (man_code)
);

drop table if exists js.products;

CREATE TABLE js.products (
                pro_code CHAR(8) NOT NULL,
                man_code CHAR(3) NOT NULL,
                pro_name CHAR(35) NOT NULL,
                pro_description CHAR(100),
                pro_type CHAR(10) DEFAULT 'PUZZLE' NOT NULL,
                pro_theme CHAR(50),
                pro_pieces INT,
                pro_packaging CHAR(20),
                pro_shape CHAR(20),
                pro_style CHAR(20),
                pro_buy_price NUMERIC(6,2) DEFAULT 0 NOT NULL,
                pro_sel_price NUMERIC(6,2) DEFAULT 0 NOT NULL,
                pro_stock INT DEFAULT 0 NOT NULL,
                pro_stock_min INT DEFAULT 0 NOT NULL,
                pro_stock_max INT DEFAULT 0 NOT NULL,
                PRIMARY KEY (pro_code, man_code)
);

drop table if exists js.invoices_detail;

CREATE TABLE js.invoices_detail (
                invoice_number INT NOT NULL,
                linenr INT NOT NULL,
                pro_code CHAR(8) NOT NULL,
                man_code CHAR(3) NOT NULL,
                cant_prod INT NOT NULL,
                price_unit NUMERIC(6,2) NOT NULL,
                price NUMERIC(8,2) NOT NULL,
                PRIMARY KEY (invoice_number, linenr)
);


ALTER TABLE js.invoices ADD CONSTRAINT buy_place_invoices_fk
FOREIGN KEY (buy_code)
REFERENCES js.buy_methods (buy_code)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE js.invoices ADD CONSTRAINT payment_methods_invoices_fk
FOREIGN KEY (pay_code)
REFERENCES js.payment_methods (pay_code)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE js.cities ADD CONSTRAINT countries_cities_fk
FOREIGN KEY (cou_id)
REFERENCES js.countries (cou_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE js.customers ADD CONSTRAINT cities_clients_fk
FOREIGN KEY (city_id)
REFERENCES js.cities (city_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE js.invoices ADD CONSTRAINT clients_invoices_fk
FOREIGN KEY (cus_id)
REFERENCES js.customers (cus_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE js.invoices_detail ADD CONSTRAINT invoices_invoices_detail_fk
FOREIGN KEY (invoice_number)
REFERENCES js.invoices (invoice_number)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE js.products ADD CONSTRAINT manufacturers_products_fk
FOREIGN KEY (man_code)
REFERENCES js.manufacturers (man_code)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE js.invoices_detail ADD CONSTRAINT products_invoices_detail_fk
FOREIGN KEY (pro_code, man_code)
REFERENCES js.products (pro_code, man_code)
ON DELETE NO ACTION
ON UPDATE NO ACTION;