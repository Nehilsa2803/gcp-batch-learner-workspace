-- scenario6

with cte as (
	select p.category, p.sub_category, round(sum(t.sales_amount),2) as sales
	from ex_transactions t
	join ex_products p
	on t.product_id = p.product_id
	group by p.category, p.sub_category
)
select category, sub_category, sales,
	   round(sum(sales) over (partition by category), 2) as tot_cat_sales,
	   round(sum(sales) over (partition by category order by  sub_Category), 2) as cumm_sales,
	   concat(round(sales * 100.0 / sum(sales) over (partition by category), 2),'%') as contrib_1,
	   concat(round(sum(sales) over (partition by category order by sub_category) * 100.0 / sum(sales) over (partition by category), 2),'%') as contrib_2
from cte
order by category, sub_category;	   