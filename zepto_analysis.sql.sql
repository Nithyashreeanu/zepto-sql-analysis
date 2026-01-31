CREATE TABLE zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent Numeric(5,2),
availableQuantity Integer,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);

--sample data
SELECT * From zepto
LIMIT 10;

--count of rows
SELECT COUNT(*) From zepto;

--null values
SELECT * FROM zepto
WHERE
name IS NULL
OR 
category IS NULL
OR 
mrp IS NULL
OR
discountPercent IS NULL
OR
discountedSellingPrice IS NULL
OR
weightInGms IS NULL
OR
availableQuantity IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL;

--Different product categories 
SELECT DISTINCT category 
FROM zepto
ORDER BY category;

--products in stock vs out of stock
SELECT outOfStock, COUNT(sku_id)
FROM zepto
GROUP BY outOfStock;

--product names present multiple times
SELECT name, COUNT(sku_id) AS "Number_of_Skus"
FROM zepto
GROUP BY name
HAVING count(sku_id) > 1
ORDER BY count(sku_id) DESC;

--DATA CLEANING

--products with price = 0;
SELECT * FROM zepto
WHERE mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM zepto
WHERE mrp = 0;

--convert paise to rupees
UPDATE zepto
SET mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

SELECT mrp, discountedSellingPrice FROM zepto;

--Q1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

--Q2. what are the products with high mrp but out of stock
SELECT DISTINCT name, mrp
FROM zepto
WHERE outOfStock = TRUE and mrp > 300
ORDER BY mrp DESC;

--Q3. Calculaate the estimated revenue for each category
SELECT category, SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

--Q4. Find all products where MRP is greater than 500 rupees and discount is less than 100
SELECT * FROM zepto
WHERE mrp > 500 AND discountPercent < 100
ORDER BY mrp DESC, discountPercent DESC;

--Q5. Identity the top 5 categories offering the hightest average discount percentage
SELECT category , ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC;

--Q6 Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;

--Q7 Group the products into categories like Low, Medium, Bluk
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'LOW'
     WHEN weightInGms < 5000 THEN 'MEDIUM'
	 ELSE 'BULK'
	 END AS weight_category
FROM zepto;
	
--Q8 what is the total inventory weight per category
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;