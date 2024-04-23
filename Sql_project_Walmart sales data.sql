create database if not exists WalmartSales;
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);



----------------------------------------- Feature Engineering

-- time_of_day
SELECT
  time,
  (CASE
    WHEN `time` BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
    WHEN `time` BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
    ELSE 'Evening'
  END) AS Time_of_day
FROM sales;

Alter table sales 
add column Time_of_day varchar(20);


Update sales
set Time_of_day= (CASE
    WHEN `time` BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
    WHEN `time` BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
    ELSE 'Evening'
  END);
  
  

-- day_name

select date, dayname(date) from sales;

Alter table sales
add column day_name varchar(10);

update sales set day_name= dayname(date);

-- month_name
select date, monthname(date) from sales;

Alter table sales
add column month_name varchar(15);

update sales set month_name= monthname(date);

-- How many unique city does the data have

select count(distinct city) as unique_city_count from sales;

-- In which city is each branch located

select distinct(city), branch from sales;

-- How many unique products does the data have

select count(distinct(product_line)) from sales;

-- Most common payment method

select payment, count(payment) as cnt from sales group by payment order by cnt desc limit 1;

-- What is the most common selling product line

select product_line, count(product_line) as cnt from sales group by product_line order by cnt desc;

-- What is the total revenue by month

select month_name as month, sum(total) as total_revenue from sales group by month order by total_revenue;

-- Which month has the largest cogs

select month_name, sum(cogs) as Total_cogs from sales group by month_name order by Total_cogs desc limit 1;

-- Which product line has the largest revenue

select product_line, sum(total) as total_revenue from sales group by product_line order by total_revenue desc limit 1 ; 

-- Which the city with the largest revenue

select city, sum(total) as total_revenue from sales group by city order by total_revenue desc limit 1;

-- Which product has the largest VAT

select product_line, avg(tax_pct) as tax from sales group by product_line order by tax desc limit 1;

-- Fetch each product line and add a column to those products showing "Good", "Bad". Good if its greater than average sales.
SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;

SELECT
  product_line,
  (CASE WHEN total > AVG(total) THEN 'Good' ELSE 'Bad' END) AS Quality
FROM
  sales
GROUP BY
  product_line;
