DROP TABLE IF EXISTS zepto;

-- Table Creation and importing data using PG Admin in CSV format

CREATE TABLE zepto (
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,	
quantity INTEGER
);
---------------------------------------------------------------------------

-- Data Exploration

-- Count of Rows

SELECT count(*) FROM zepto;

-- Sample Data

SELECT * FROM zepto LIMIT 10;

-- Null Values

SELECT *
FROM zepto
WHERE
    name IS NULL OR
    category IS NULL OR
    mrp IS NULL OR
    discountedsellingprice IS NULL OR
    discountPercent IS NULL OR
    weightingms IS NULL OR
    availableQuantity IS NULL OR
    outOfStock IS NULL OR
    quantity IS NULL;

-- Different Product Categories

SELECT DISTINCT category
FROM zepto
ORDER BY category;

-- Product in stock vs out of stock

SELECT outOfStock, count(sku_id)
FROM zepto
GROUP BY outofstock;

-- Product names present multiple times

SELECT name, count(sku_id) as "Number of SKUs"
FROM zepto
GROUP BY name
HAVING count(sku_id) > 1
ORDER BY count(sku_id) DESC;

---------------------------------------------------------------------------

-- Data Cleaning

-- Products with price = 0

SELECT *
FROM zepto
WHERE mrp = 0 OR discountedsellingprice = 0;

DELETE
FROM zepto
WHERE mrp = 0;

-- Convert paisa to rupees

UPDATE zepto
SET
mrp = mrp/100.0,
discountedsellingprice = discountedSellingPrice/100.0;

SELECT mrp, discountedSellingPrice
FROM zepto;

---------------------------------------------------------------------------

-- Data Analysis, Real Business Questions

-- Q1. Find the top 10 best-value products based on the discount percentage.

SELECT DISTINCT name, mrp, discountpercent
FROM zepto
ORDER BY discountpercent DESC
LIMIT 10;

--Q2.What are the Products with High MRP but Out of Stock

SELECT DISTINCT name, mrp, outofstock
FROM zepto
WHERE outofstock = TRUE and mrp > 300
ORDER BY mrp DESC;

--Q3.Calculate Estimated Revenue for each category

SELECT category,
sum(discountedsellingprice * availablequantity) as total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue DESC;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.

SELECT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 and discountpercent < 10
ORDER BY mrp DESC;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.

SELECT category,
ROUND(AVG(discountpercent),2) as avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.

SELECT name,
ROUND(SUM(discountedsellingprice/weightingms),2) as price_per_gram
FROM zepto
WHERE weightingms >= 100
GROUP BY name
ORDER BY price_per_gram;

SELECT DISTINCT name, weightingms, discountedsellingprice,
ROUND(discountedsellingprice/weightingms,2) as price_per_gram
FROM zepto
WHERE weightingms >= 100
ORDER BY price_per_gram;

--Q7.Group the products into categories like Low, Medium, Bulk.

SELECT DISTINCT name, weightingms,
CASE WHEN weightingms < 1000 THEN 'Low'
     WHEN weightingms < 5000 THEN 'Medium'
     ELSE 'Bulk'
     END as weight_category
FROM zepto
ORDER BY weightingms DESC;

--Q8.What is the Total Inventory Weight Per Category 

SELECT category, sum(weightInGms) as inventory_weight
FROM zepto
GROUP BY category
ORDER BY inventory_weight DESC;

SELECT category, sum(weightInGms * availablequantity) as total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight DESC;

---------------------------------------------------------------------------