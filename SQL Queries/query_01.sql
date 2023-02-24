use sales;
show tables;

select * from customers;
select * from date;
select * from markets;
select * from products;
select * from transactions;

# customer table:
select count(*) from customers; # 38
select count(distinct customer_code) from customers; # 38
select count(distinct custmer_name) from customers; # 38

# markets table:
select count(*) from markets; # 17
select count(distinct markets_code) from markets; # 17
select count(distinct markets_name) from markets; # 16

# products table:
select count(*) from products; # 279
select count(distinct product_code) from products; # 278
select count(distinct product_type) from products; # 2

# transaction table:
select count(*) from transactions; # 1,48,395

# Queries:-------------------------------------------------------------------

# 1. what is maximum sales quantity.
select max(sales_qty) as maximum_sales_quantity from transactions;

# 2. what is total sales amount.
select sum(sales_amount) as Total_Sales from transactions;

# 3. what is total maximum sales amount.

select d.year, max(sales_amount) as maximum_sales_amount from transactions;
select d.year, max(t.sales_amount) as maximum_sales_amount from transactions as t
inner join date as d
on d.date = t.order_date group by d.year;

# 4. which market products are sales (distinct markets code).
select distinct markets_code from markets;

# 5. what is maximum profit margin percentage.
select max(profit_margin_percentage) as max_profit_percentage from transactions;

# 6. what is total profit margin.
select max(profit_margin) as max_profit_margin from transactions;

# 7. Find the distinct currency.
select distinct currency from transactions;

# 8. If currency is different then convert the sales amount.
select *, 
case when currency='USD' then sales_amount*71 else sales_amount end as new_sales_amount
from transactions;

select *, 
case when currency='USD' then sales_amount*71 else sales_amount end as new_sales_amount
from transactions where currency="USD";

# 9. Find the total sales in 2017, 2018, 2019, 2020.
select d.year, sum(t.sales_amount) as Total_Sales from transactions as t
inner join date as d
on t.order_date = d.date group by d.year order by d.year asc;


# 10. Find the total sales in month March & April for every year (2017, 2018, 2019, 2020).
select d.year,d.month_name, sum(t.sales_amount) as Total_Sales from transactions as t
inner join date as d
on t.order_date = d.date group by d.year, d.month_name order by d.year asc;

# 11. In which date sales is high.
select order_date, max(sales_amount) as max_sales from transactions;

# 12. In which date profit margin is high.
select order_date, max(profit_margin) as high_margin from transactions;
select order_date from transactions having max(profit_margin);

# 13. Find the total profit margin for every market.
select m.markets_code, m.markets_name, round(sum(t.profit_margin),2) as Total_Profit_Margin from markets as m
inner join transactions as t
on m.markets_code = t.market_code
group by m.markets_code, m.markets_name;

# 14. Write a query and extract the info Month wise.
select d.month_name,d.year, t.* from transactions as t
inner join date as d
on t.order_date = d.date
group by d.month_name, d.year;

# 15. Give the Sales percentage year wise: 2017, 2018, 2019, 2020.
with 
total_sales as
	(select sum(sales_amount) as total_sales from transactions),
sales_2017 as
	(select d.year as year, sum(t.sales_amount) as sales_amount from transactions as t inner join date as d on d.date=t.order_date where d.year=2017),
sales_2018 as
	(select d.year as year, sum(t.sales_amount) as sales_amount from transactions as t inner join date as d on d.date=t.order_date where d.year=2018),
sales_2019 as
	(select d.year as year, sum(t.sales_amount) as sales_amount from transactions as t inner join date as d on d.date=t.order_date where d.year=2019),
sales_2020 as
	(select d.year as year, sum(t.sales_amount) as sales_amount from transactions as t inner join date as d on d.date=t.order_date where d.year=2020)   

select year, round((sales_amount/(select total_sales from total_sales))*100, 0) as percentage  from sales_2017
union 
select year, round((sales_amount/(select total_sales from total_sales))*100, 0) as percentage  from sales_2018
union
select year, round((sales_amount/(select total_sales from total_sales))*100, 0) as percentage  from sales_2019
union 
select year, round((sales_amount/(select total_sales from total_sales))*100, 0) as percentage  from sales_2020;


# 16. Give top 10 selling products.
select p.product_code, t.sales_amount from products as p
inner join transactions as t
on p.product_code = t.product_code
order by t.sales_amount desc limit 10;


# 17. Give the top 5 profitable products market wise and provide the rank order.
with
cte1 as 
	(select m.markets_name, t.product_code, t.profit_margin, 
	 dense_rank() over(partition by t.market_code order by t.profit_margin desc) as rank_order
	 from transactions as t
     inner join markets as m
     on t.market_code = m.markets_code
	)
select * from cte1 where rank_order <=5;


/**
	18. What is the percentage of sales increase in 2017, 2018, 2019, 2020? The final output contains these fields,

	sales_increase_2017
	sales_increase_2018
	sales_increase_2019
	sales_increase_2020
	percentage_chg(19_20)
    
**/


/**
	19. What is the percentage of profit increase 2019 and 2020. The final output contains these fields:

	profit_increase_2019
	profit_increase_2020
	percentage_chg
**/
with
profit_increase_2020 as 
	(select year(order_date) as Year, sum(profit_margin) as profit_margin from transactions where year(order_date)=2020),
profit_increase_2019 as 
	(select year(order_date) as Year, sum(profit_margin) as profit_margin from transactions where year(order_date)=2019)

select round(((p20.profit_margin - p19.profit_margin)/p19.profit_margin)*100, 1) as percentage 
from profit_increase_2020 as p20, profit_increase_2019 as p19;


# 20. List top 10 customer name who get more profit_margin_percentage.
select distinct c.custmer_name, t.profit_margin_percentage from customers as c
inner join transactions as t
on t.customer_code = c.customer_code
order by t.profit_margin_percentage desc limit 10;


# 21. Which customer ordered more (list top 10) in year wise: 2017, 2018, 2019, 2020.
with
cte1 as 
	(select distinct c.custmer_name, t.sales_qty, d.year,
	 dense_rank() over(partition by d.year order by t.sales_qty desc) as rank_order
	 from customers as c
	 inner join transactions as t
	 on t.customer_code = c.customer_code
	 inner join date as d
	 on t.order_date = d.date
	)
select * from cte1 where rank_order <=10;


/**
	22. Create a Stored Procedure and extract the total_revenue, total_profit, market & year wise. 
    (send the input as market_name, year and get the output as market_name, year, total_revenue, total_profit).

**/
delimiter &&
create procedure extract_info(in market_name varchar(30), year int)
begin
	select m.markets_name, year(t.order_date) as year, round(sum(t.sales_amount),2) as Total_Revenue, 
    round(sum(profit_margin),2) as Total_Profit
    from transactions as t
    inner join markets as m on m.markets_code = t.market_code
    where m.markets_name = market_name and year(t.order_date) = year;

end &&
delimiter ;

call extract_info("Mumbai", 2020);
-- drop procedure extract_info;







