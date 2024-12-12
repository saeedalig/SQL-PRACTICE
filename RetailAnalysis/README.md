# Retail Data Analysis with SQL

This repository contains a comprehensive analysis of retail data using SQL. The goal is to extract meaningful insights from the dataset, such as sales performance, customer behavior, and trends over time.

## Dataset
The dataset used in this analysis is a CSV file named `retail.csv` containing the following columns:

- **transaction_id**: Unique identifier for each transaction
- **sale_date**: Date of the transaction
- **sale_time**: Time of the transaction
- **customer_id**: Unique identifier for customers
- **gender**: Gender of the customer
- **age**: Age of the customer
- **category**: Product category
- **quantity**: Number of items purchased
- **price_per_unit**: Price per item
- **cogs**: Cost of goods sold
- **total_sale**: Total sale value

### Basic Table Creation and Data Loading
- Create the `retail` table.
    ```sql
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

    ```
- Load data from `retail.csv` using the `COPY` command.
    ```sql
        COPY 
        FROM 'file_path'
        DELIMITER ',' 
        CSV HEADER;
    ```
- Validate data integrity by checking for null values and removing incomplete records.
    ```sql
    -- Check Null values in columns like
    SELECT *
    FROM retail
    WHERE transaction_id IS NULL;
    ```

## Analysis
The analysis includes a variety of SQL queries to answer business-related questions and provide insights. Below is an outline of the analysis:


###  Query Highlights
#### Sales Insights:
- **Total number of sales:** 
    ```sql
    SELECT 
        COUNT(*) 
    FROM retail;
    ```
- **Sales on a specific date:** Retrieve all columns for sales made on `'2022-11-05'.`
    ```sql
    SELECT *
    FROM retail
    WHERE sale_date = '2022-11-05';
    ```
- **Best-selling month in each year:** Use CTE or subqueries to identify the top-performing months based on total sales.
    ```sql
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
    ```
    ```sql
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
    ```

#### Customer Behavior:
- **Top 5 customers by total sales:** Identify the highest spenders.
    ```sql
    SELECT 
        customer_id,
        SUM(total_sale) AS total_sales
    FROM retail
    GROUP BY customer_id
    ORDER BY total_sales DESC
    LIMIT 5;
    ```
- **Unique customers per category:** Count unique customers who made purchase in each product category.
    ```sql
    SELECT 
        category,
        COUNT(DISTINCT(customer_id)) AS UniqueCustomer
    FROM retail
    GROUP BY 1;
    ```
- **Sales by gender in each category:** Find the totol transaction made by each gender in each product category.
```sql
SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail
GROUP BY category, gender
ORDER BY 1;
```

#### Product Performance:
- **Total sales per category:** Calculate the sum of `total_sale` for each category.
    ```sql
    SELECT 
        category,
        SUM(total_sale) AS total_sales
    FROM retail
    GROUP BY category 
    ORDER BY total_sales DESC ;
    ```
- **Orders per category:** Count total transactions made in each category.
    ```sql
    SELECT 
        category,
        COUNT(*) AS total_orders
    FROM retail
    GROUP BY category;
    ```

#### Time-Based Analysis:
- **Sales shift analysis:** Classify transactions into Morning, Afternoon, and Evening shifts based on `sale_time`.
    ```sql

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
		
    ```