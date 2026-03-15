drop table if exist zepto(

create table zepto(
sku_id SERIAL PRIMARY KEY,
Category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountpercent NUMERIC(5,2),
availablequantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);

--data exploration

--count of rows
SELECT COUNT(*) FROM ZEPTO;

---SAMPLE DATA
SELECT * FROM ZEPTO
LIMIT 10;

--NULL VALUES
SELECT * FROM ZEPTO
WHERE name IS NULL
OR
Category IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL
OR
discountedsellingprice IS NULL
OR
weightingms IS NULL
OR
outofstock IS NULL
OR
quantity IS NULL

--different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

---product in stock vs out of stock
SELECT outofstock, COUNT(sku_id)
FROM zepto
GROUP BY outofstock;

--product names present multiple times
SELECT name, COUNT(sku_id) as "NUMBER OF SKUs"
FROM zepto
GROUP by name 
HAVING count(sku_id) > 1
ORDER by count(sku_id)DESC;

--data cleaning

--product with price = 0 
SELECT * FROM zepto
WHERE mrp = 0 OR discountedsellingprice = 0;

DELETE FROM ZEPTO WHERE mrp = 0;

--convert paise to rupees
UPDATE zepto
SET mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

SELECT mrp, discountedSellingPrice FROM zepto

--find the top 10 best valu product based on the dicount percentage.
SELECT DISTINCT name, mrp, discountpercent
FROM zepto
ORDER BY discountpercent DESC
LIMIT 10;

--what are the product with high mrp but out of stock
SELECT DISTINCT name, mrp 
FROM zepto 
WHERE outOfStock  = TRUE AND MRP > 300
ORDER BY mrp DESC;

--Calculate estimation revenue for each category
SELECT category,
sum(discountedSellingPrice * availablequantity) as Total_revenue
FROM zepto
GROUP BY category
ORDER BY Total_revenue;

--Find all the products where MRP is greater than 500 and dicount is less than 10%
SELECT DISTINCT name, mrp,discountpercent
FROM zepto
WHERE mrp > 500 and c < 10
ORDER BY mrp DESC,discountpercent DESC;

--Identify the top 5 category offering the highest average discount percentage 
SELECT category,
ROUND(AVG(discountpercent),2) AS Avg_discount
FROM zepto
GROUP BY category
ORDER BY Avg_discount DESC
LIMIT 5;

--Find the price per gram for a product 100g and sort by best value
SELECT DISTINCT name, weightInGms,discountedSellingPrice,
discountedSellingPrice/weightInGms as price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY  price_per_gram;

---Group the product into category like low, medium, bulk
SELECT DISTINCT name,weightInGms,
CASE WHEN weightInGms < 1000 THEN 'LOW'
     WHEN weightInGms < 5000 THEN 'MEDIUM'
	 ELSE 'BULK'
	 END AS Weight_category
FROM zepto;

--what is the total inventory weight per category 
SELECT category,
SUM(weightInGms * availablequantity) AS Total_weight
FROM zepto 
GROUP BY category
ORDER BY Total_weight;



