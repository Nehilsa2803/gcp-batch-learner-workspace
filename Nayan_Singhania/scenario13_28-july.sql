-- scneario 13

-- q1

with sales_table as (
	select l.region, l.state, l.city, t.sales_amount
	from ex_locations l 
	join ex_customers c
	on l.postal_code = c.postal_code
	join ex_orders o
	on c.customer_id = o.customer_id
	join ex_transactions t
	on o.order_id = t.order_id
)
select region, state, city, round(sum(sales_amount),2) as total_sales
from sales_table
group by rollup(region, state, city);


-- q2

with sales_table as (
	select l.region, l.state, l.city, t.sales_amount
	from ex_locations l 
	join ex_customers c
	on l.postal_code = c.postal_code
	join ex_orders o
	on c.customer_id = o.customer_id
	join ex_transactions t
	on o.order_id = t.order_id
)
select region, state, city, round(sum(sales_amount),2) as total_sales
from sales_table
group by cube(region, state, city);


-- q3

with sales_table as (
	select l.region, l.state, l.city, t.sales_amount
	from ex_locations l 
	join ex_customers c
	on l.postal_code = c.postal_code
	join ex_orders o
	on c.customer_id = o.customer_id
	join ex_transactions t
	on o.order_id = t.order_id
)
select region, state, city, round(sum(sales_amount),2) as total_sales
from sales_table
group by grouping sets(
	(region, state, city),
	(region, state),
	(region),
	()
);