-- Create table 
DROP TABLE IF EXISTS retail;
CREATE TABLE retail (
    transaction_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

-- Load bulk data into the retail table from a CSV file
COPY retail (transaction_id, sale_date, sale_time, customer_id, gender, age, category, quantity, price_per_unit, cogs, total_sale)
FROM 'file_path'
DELIMITER ',' 
CSV HEADER;


SELECT * FROM retail;

SELECT *
FROM retail
LIMIT 10;


SELECT *
FROM retail
WHERE transaction_id IS NULL;


-- Row that contain NULL values
SELECT * FROM retail
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;


-- How many sales we have? No of Sales
SELECT COUNT(*) AS total_count
FROM retail;

-- Delete rows that contain null values
DELETE
FROM retail
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;

SELECT * FROM retail;


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT *
FROM retail
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
SELECT *
FROM retail
WHERE category = 'Clothing' 
	AND quantity >= 4
	AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11';

/*
TO_CHAR(value, format)

value: The value to format. This can be a date, time, timestamp, or numeric value.
format: A string that specifies the format in which the value should be returned.

*/

-- Q.3 Write a SQL query to calculate the total sales for each category.
SELECT 
	category,
	SUM(total_sale) AS total_sales
FROM retail
GROUP BY category 
ORDER BY total_sales DESC ;

-- Q.3 Write a SQL query to find the total order palced in each category.
SELECT 
	category,
	COUNT(*) AS total_orders
FROM retail
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail
WHERE category = 'Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select 
	*
from retail
where retail.total_sale > 1000;


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail
GROUP BY category, gender
ORDER BY 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

-- With GROUP BY
SELECT 
	EXTRACT(YEAR FROM sale_date) AS year,
	TO_CHAR(sale_date, 'Month') AS month,
	SUM(total_Sale) AS total_sale
FROM retail
GROUP BY EXTRACT(YEAR FROM sale_date), TO_CHAR(sale_date, 'Month')
ORDER BY year, total_sale DESC;


-- With CTE
WITH monthly_sales AS (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        TO_CHAR(sale_date, 'Month') AS month,
        AVG(total_sale) AS total_sales,
        RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS sales_rank
    FROM retail
    GROUP BY EXTRACT(YEAR FROM sale_date), TO_CHAR(sale_date, 'Month')
)
SELECT year, month, total_sales
FROM monthly_sales
WHERE sales_rank = 1;


-- With Subquery
SELECT  *
FROM 
(
	SELECT
		EXTRACT(YEAR FROM sale_date) AS year,
		EXTRACT(MONTH FROM sale_date) AS month,
		AVG(total_sale) AS avg_sales,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS ranked_sales
	FROM retail
	GROUP BY 1,2
) AS t WHERE ranked_sales = 1;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT 
	customer_id,
	SUM(total_sale) AS total_sales
FROM retail
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
	category,
	COUNT(DISTINCT(customer_id)) AS UniqueCustomer
FROM retail
GROUP BY 1;

-- Q.10 Write a SQL query to create shift and number of orders placed (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


SELECT 
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) <12 THEN 'Morning'
		--WHEN EXTRACT(HOUR FROM sale_time) > 12 AND EXTRACT(HOUR FROM sale_time) < 17 THEN 'Afternoon'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift,
	COUNT(*) as total_orders
FROM retail
GROUP BY shift;
		


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)













