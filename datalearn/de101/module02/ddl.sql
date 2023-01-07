-- ************************************** categories

CREATE TABLE categories
(
 cat_id   int NOT NULL PRIMARY KEY,
 cat_name varchar(50) NOT NULL
);

-- ************************************** sub_categories

CREATE TABLE sub_categories
(
 sub_cat_id   int NOT NULL PRIMARY KEY,
 sub_cat_name varchar(50) NOT NULL,
 cat_id       int NOT NULL
);

-- ************************************** products

CREATE TABLE products
(
 product_id   int NOT NULL PRIMARY KEY,
 product_name varchar(50) NOT NULL,
 sub_cat_id   int NOT NULL
);

-- ************************************** managers

CREATE TABLE managers
(
 manager_id   int NOT NULL PRIMARY KEY,
 manager_name varchar(50) NOT NULL
);

-- ************************************** resposibilities

CREATE TABLE resposibilities
(
 region_id  int NOT NULL,
 manager_id int NOT NULL
);

-- ************************************** countries

CREATE TABLE countries
(
 country_id   int NOT NULL PRIMARY KEY,
 country_name varchar(50) NOT NULL
);

-- ************************************** regions

CREATE TABLE regions
(
 region_id   int NOT NULL PRIMARY KEY,
 region_name varchar(50) NOT NULL,
 country_id  int NOT NULL
);

-- ************************************** states

CREATE TABLE states
(
 state_id   int NOT NULL PRIMARY KEY,
 state_name varchar(50) NOT NULL,
 region_id  int NOT NULL
);

-- ************************************** cities

CREATE TABLE cities
(
 city_id   int NOT NULL PRIMARY KEY,
 city_name varchar(50) NOT NULL,
 state_id  int NOT NULL
);

-- ************************************** postal_codes

CREATE TABLE postal_codes
(
 postal_code_id int NOT NULL PRIMARY KEY,
 postal_code int NOT NULL,
 city_id     int NOT NULL
);

-- ************************************** segment
CREATE TABLE segment
(
 segment_id   int NOT NULL PRIMARY KEY,
 segment_name varchar(50) NOT NULL
);

-- ************************************** customers

CREATE TABLE customers
(
 customer_id   varchar(50) NOT NULL PRIMARY KEY,
 customer_name varchar(50) NOT NULL
);

-- ************************************** ship_mode

CREATE TABLE ship_mode
(
 ship_id   int NOT NULL PRIMARY KEY,
 ship_name varchar(50) NOT NULL
);

-- ************************************** calendar

CREATE TABLE calendar
(
 date     date NOT NULL PRIMARY KEY,
 year     int NOT NULL,
 quartal  int NOT NULL,
 month    int NOT NULL,
 week     int NOT NULL,
 week_day int NOT NULL,
 day      int NOT NULL
);

-- ************************************** sales

CREATE TABLE sales
(
 row_id      int NOT NULL PRIMARY KEY,
 order_id    varchar(15) NOT NULL,
 order_date  date NOT NULL,
 ship_id     int NOT NULL,
 ship_date   date NOT NULL,
 product_id  int NOT NULL,
 segment_id  int NOT NULL,
 costumer_id varchar(50) NOT NULL,
 postal_code int NOT NULL,
 sales       real NOT NULL,
 profit      real NOT NULL,
 quantity    int NOT NULL,
 discount    real NOT NULL
);

