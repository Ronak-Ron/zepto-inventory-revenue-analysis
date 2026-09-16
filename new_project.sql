drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
Category VARCHAR (120),
name varchar(150) not null, 
mrp numeric(8,2),
discountPercent numeric(5,2),
availableQuantity INTEGER,
discountedSellingPrice Numeric(8,2),
weightInGms Integer,
outOfStock BOOLEAN,
quantity INTEGER
);

----DATA EXPLORATION

---Count of Rows
SELECT COUNT(*) FROM zepto;

---- Sample Data

SELECT * FROM zepto
LIMIT 10;

---- Check Null Values

SELECT * FROM zepto
WHERE name IS NULL
OR
mrp IS NULL
OR
discountpercent IS NULL
OR
availablequantity IS NULL
OR
discountedsellingprice IS NULL
OR
weightingms IS NULL
OR
outofstock IS NULL
OR
quantity IS NULL;

-----Different Product Categories
SELECT DISTINCT category FROM zepto
ORDER BY category;

------Check Products In Stock VS Out of Stock
SELECT outofstock, COUNT(sku_id)
FROM zepto
GROUP BY outofstock;

----Check Product Names Present Multiple Times
SELECT name, COUNT(sku_id) as "Number of SKUs"
FROM zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;

------Data Cleaning

------Products with Price = 0
SELECT * FROM zepto
WHERE mrp = 0 OR discountedsellingprice = 0;

DELETE FROM zepto
WHERE mrp = 0;

------Convert Indian Paise to Indian Rupees
UPDATE zepto
SET mrp = mrp/100.0,
discountedsellingprice = discountedsellingprice/100.0;


SELECT mrp, discountedsellingprice
FROM zepto;

---Q1. Find the top 10 best-value products based on the discount percentage.

SELECT DISTINCT name, mrp, discountpercent
FROM zepto
ORDER BY discountpercent DESC
LIMIT 10;

---Q2. What are the Products with High MRP but Out of Stock.

SELECT DISTINCT name, mrp 
FROM zepto
WHERE outofstock = TRUE AND mrp > 300
ORDER BY mrp DESC;

---Q3. Calculate Estimated Revenue for each Category.

SELECT category, SUM(discountedsellingprice * availablequantity) AS Total_Revenue
FROM zepto
GROUP BY category ORDER BY Total_Revenue;

---Q4. Find all Products where MRP is greater than 500 Rs. and discount is less than 10%.

SELECT DISTINCT name, mrp, discountpercent
FROM zepto
WHERE mrp > 500 AND discountpercent < 10
ORDER BY mrp DESC, discountpercent DESC;

---Q5. Identify the top 5 categories offering the highest average discount percentage.

SELECT category,
ROUND(AVG(discountpercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

---Q6. Find the Price per gram for products above 100g and sort by best value.

SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;


---Q7. Group the products into categories like Low, Medium, Bulk.

SELECT DISTINCT name, weightingms,
CASE WHEN weightingms < 1000 THEN 'Low'
     WHEN weightingms < 5000 THEN 'Medium'
	 ELSE 'Bulk'
	 END AS weight_category
FROM zepto;


---Q8. What is the Total Inventory Weight Per Category.

SELECT category,
SUM(weightingms * availablequantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;


---Q9. Rank products by discount WITHIN each category (window function)
-- Shows the single best-value product per category, not just overall top 10.

SELECT *
FROM (
    SELECT category, name, mrp, discountpercent,
           RANK() OVER (PARTITION BY category ORDER BY discountpercent DESC) AS discount_rank
    FROM zepto
) ranked
WHERE discount_rank <= 3
ORDER BY category, discount_rank;


---Q10. Each category's contribution to TOTAL revenue (window function + CTE)
-- Answers: "which categories actually drive the business" — not just totals in isolation.

WITH category_revenue AS (
    SELECT category,
           SUM(discountedsellingprice * availablequantity) AS category_total
    FROM zepto
    GROUP BY category
)
SELECT category,
       category_total,
       ROUND(100.0 * category_total / SUM(category_total) OVER (), 2) AS pct_of_total_revenue
FROM category_revenue
ORDER BY pct_of_total_revenue DESC;


---Q11. Data-quality anomaly check: discounted price higher than MRP
-- A pricing error check most versions of this project never test for.

SELECT sku_id, name, category, mrp, discountedsellingprice
FROM zepto
WHERE discountedsellingprice > mrp;


---Q12. Top 3 highest-revenue products PER category (window function + CTE)
-- More useful for a business audience than a flat top-10 list.

WITH product_revenue AS (
    SELECT category, name,
           (discountedsellingprice * availablequantity) AS revenue,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY (discountedsellingprice * availablequantity) DESC) AS rn
    FROM zepto
)
SELECT category, name, revenue
FROM product_revenue
WHERE rn <= 3
ORDER BY category, revenue DESC;


---Q13. Cumulative revenue running total across categories (window function)
-- Useful for a "how many categories make up 80% of revenue" (Pareto-style) insight.

WITH category_revenue AS (
    SELECT category,
           SUM(discountedsellingprice * availablequantity) AS category_total
    FROM zepto
    GROUP BY category
)
SELECT category,
       category_total,
       SUM(category_total) OVER (ORDER BY category_total DESC) AS running_total
FROM category_revenue
ORDER BY category_total DESC;

SELECT * FROM zepto ORDER BY sku_id;