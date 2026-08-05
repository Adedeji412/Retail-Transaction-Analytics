CREATE DATABASE retail_portfolio;
USE retail_portfolio;

CREATE TABLE hh_demographic (
	household_key INT PRIMARY KEY,
	AGE_DESC VARCHAR(50),
	MARITAL_STATUS_CODE VARCHAR(50),
	INCOME_DESC VARCHAR(50),
	HOMEOWNER_DESC VARCHAR(50),
	HH_COMP_DESC VARCHAR(50),
	HOUSEHOLD_SIZE_DESC VARCHAR(50),
	KID_CATEGPRY_DESC VARCHAR(50)
);

CREATE TABLE PRODUCT (
 PRODUCT_ID INT PRIMARY KEY,
 MANUFACTURER INT,
 DEPARTMENT VARCHAR(50),
 BRAND VARCHAR(50),
 COMMODITY_DESC VARCHAR(50),
 SUB_COMMODITY_DESC VARCHAR(100),
 CURR_SIZE_OF_PRODUCT VARCHAR(50)
);

DROP TABLE IF EXISTS transaction_data;

CREATE TABLE transaction_data (
household_key INT,
BASKET_ID BIGINT,
DAY INT,
PRODUCT_ID INT,
QUANTITY INT,
SALES_VALUE DECIMAL(10,2),
STORE_ID INT,
RETAIL_DISC DECIMAL(10,2),
TRANS_TIME INT,
WEEK_NO INT,
COUPON_DISC INT,
COUPON_MATCH_DISC INT
);

SET GLOBAL local_infile = 1;
SET autocommit = 0;
SET unique_checks = 0;
SET foreign_key_checks = 0;

LOAD DATA LOCAL INFILE 'C:/Users/hp/Documents/Retail_Transaction_Project/transaction_data.csv' 
INTO TABLE transaction_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
household_key,
BASKET_ID,
DAY,
PRODUCT_ID,
QUANTITY,
SALES_VALUE,
STORE_ID,
RETAIL_DISC,
TRANS_TIME,
WEEK_NO,
COUPON_DISC,
COUPON_MATCH_DISC
);

COMMIT;
SET autocommit = 1;
SET unique_checks = 1;
SET foreign_key_checks = 1;

SELECT * FROM hh_demographic;
SELECT COUNT(*) FROM hh_demographic;

SELECT * FROM product;
SELECT COUNT(*) FROM product;

SELECT * FROM transaction_data;
SELECT COUNT(*) FROM transaction_data;

/* Verify import volume */
SELECT FORMAT(COUNT(*), 0) AS total_transactions
FROM transaction_data;

/*Missing critical values*/
SELECT
SUM(CASE WHEN BASKET_ID IS NULL THEN 1 ELSE 0 END) AS missing_baskets,
SUM(CASE WHEN PRODUCT_ID IS NULL THEN 1 ELSE 0 END) AS missing_products,
SUM(CASE WHEN household_key IS NULL THEN 1 ELSE 0 END) AS missing_households
FROM transaction_data
;

/*Negative or illogical values*/
SELECT 
MIN(SALES_VALUE) AS min_sales,
MAX(SALES_VALUE) AS max_sales,
SUM(CASE WHEN QUANTITY <= 0 THEN 1 ELSE 0 END) AS zero_or_negative_qty
FROM transaction_data;


ALTER TABLE transaction_data ADD COLUMN transaction_date DATE;

SET SQL_SAFE_UPDATES = 0;

UPDATE transaction_data
SET transaction_date = DATE_ADD('2024-01-01', INTERVAL DAY - 1 DAY);

SET SQL_SAFE_UPDATES = 1;

-- Which product departments generate the most revenue across different household income brackets?
SELECT 
d.INCOME_DESC, p.DEPARTMENT,
COUNT(DISTINCT t.BASKET_ID) AS total_baskets,
SUM(t.SALES_VALUE) AS total_revenue
FROM transaction_data t
INNER JOIN hh_demographic d 
ON t.household_key = d.household_key
INNER JOIN product p 
ON t.PRODUCT_ID = P.PRODUCT_ID 
GROUP BY 
d.INCOME_DESC, p.DEPARTMENT
ORDER BY total_revenue DESC
LIMIT 20;


SELECT 
d.HOUSEHOLD_SIZE_DESC AS household_size,
COUNT(DISTINCT t.BASKET_ID) AS total_trips,
SUM(t.SALES_VALUE) / COUNT(DISTINCT t.BASKET_ID) AS avg_spend_per_trip,
SUM(t.QUANTITY) / COUNT(DISTINCT t.BASKET_ID) AS avg_item_per_trip
FROM transaction_data t
INNER JOIN hh_demographic d
ON t.household_key = d.household_key
WHERE t.SALES_VALUE > 0
GROUP BY d.HOUSEHOLD_SIZE_DESC
ORDER BY avg_spend_per_trip DESC;






















