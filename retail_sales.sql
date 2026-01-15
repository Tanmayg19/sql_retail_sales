--- Table Creation ---
create table retail_sales (
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(20),
	quantiy INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale INT
)

select count(*) from retail_sales
select count(distinct customer_id) from retail_sales
select distinct category from retail_sales

--- Finding rows with null values ---
select * from retail_sales 
where
	sale_date is null
	OR
	sale_time is null
	OR
	customer_id is null
	OR
	gender is null
	OR
	age is null
	OR
	category is null
	OR 
	quantiy is null
	OR
	price_per_unit is null
	OR
	cogs is null
	OR
	total_sale is null

--- Deleting rows with null values as there are just 13 rows with null values ----

Delete from retail_sales 
where
	sale_date is null
	OR
	sale_time is null
	OR
	customer_id is null
	OR
	gender is null
	OR
	age is null
	OR
	category is null
	OR 
	quantiy is null
	OR
	price_per_unit is null
	OR
	cogs is null
	OR
	total_sale is null

-- DATA ANALYSIS AND FINDINGS ---
--- Write a SQL query to retrieve all columns for sales made on '2022-11-05: ---

select * from retail_sales
where sale_date = '2022-11-05'

--- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022: ---

select * from retail_sales
where 
	category = 'Clothing'
	AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND
	quantiy >= 4 

--- Write a SQL query to calculate the total sales (total_sale) for each category.: ---
select 
	category, 
	sum(total_sale) as total_sales,
	count(transactions_id) as total_orders
from retail_sales
group by category

--- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.: ---
select 
	ROUND(AVG(age), 2) as avg_age
from retail_sales
where category = 'Beauty'

--- Write a SQL query to find all transactions where the total_sale is greater than 1000.: ---

select * from retail_sales
where total_sale > 1000

--- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.: ---

select category, gender, count(transactions_id) as trans_count 
from retail_sales
group by category, gender
order by 1

--- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year: ---

select years, sale_month, avg_sale 
from (
		select extract(year from sale_date) as years,
		TO_CHAR (sale_date, 'MONTH') as sale_month,
		round(avg(total_sale), 2) as avg_sale,
		rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as ranks
		from retail_sales
		group by  1, 2) as t1
where ranks = 1

---Write a SQL query to find the top 5 customers based on the highest total sales ---

select customer_id, Total_Sales 
from
	(select customer_id, sum(total_sale) as Total_Sales,
		rank() over(order by sum(total_sale) desc) as ranks
	from retail_sales
	group by customer_id) as t2
where ranks <= 5

--- Write a SQL query to find the number of unique customers who purchased items from each category.: ---

select category, count(distinct customer_id) as no_of_cs
from retail_sales
group by category

--- Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17): ---

With hourly_sales as
	(select *,
		case when extract (hour from sale_time) > 12 then 'Morning'
		when extract (hour from sale_time) between 12 and 17 then  'Afternoon'
		else 'Evening' end as shift
	from retail_sales)
select shift, count(*) as no_of_orders
from hourly_sales
group by shift