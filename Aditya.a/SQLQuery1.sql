select category,sub_category,count(product_id) as product_count
from ex_products
group  by grouping sets(category,sub_category);


select category,sub_category,count(product_id) as product_count
from ex_products
group  by cube(category,sub_category);


select category,sub_category,count(product_id) as product_count
from ex_products
group  by rollup(category,sub_category);

select region,state,city,sum(sales_amount) as total_sales
from ex_locations l join ex_customers c
on l.postal_code=c.postal_code
join ex_orders o 
on c.customer_id=o.customer_id
join ex_transactions t
on o.order_id=t.order_id
where order_status='delivered'
group  by rollup(region,state,city);




select region,state,city,sum(sales_amount) as total_sales
from ex_locations l join ex_customers c
on l.postal_code=c.postal_code
join ex_orders o 
on c.customer_id=o.customer_id
join ex_transactions t
on o.order_id=t.order_id
where order_status='delivered'
group  by cube(region,state,city);


select region,state,city,sum(sales_amount) as total_sales
from ex_locations l join ex_customers c
on l.postal_code=c.postal_code
join ex_orders o 
on c.customer_id=o.customer_id
join ex_transactions t
on o.order_id=t.order_id
where order_status='delivered'
group  by grouping sets(
                         (region,state,city),
                         (region,state),
                         (region),
                         ()
                                               );

select
    category,
    sub_category,
    total_sales,
    round(
        total_sales * 100.0 /
        SUM(total_sales) OVER(PARTITION BY category),
        2
    ) AS sales_percentage
FROM (select category,sub_category,sum(sales_amount)as total_sales
from ex_transactions t join ex_products p
on t.product_id=p.product_id
group by rollup(category,sub_category))as sales;

SELECT
    category,
    sub_category,

    DENSE_RANK() OVER (
        PARTITION BY category
        ORDER BY sub_cat_sales DESC
    ) AS sub_cat_rank,

    ROUND(
        sub_cat_sales * 100.0 /
        SUM(sub_cat_sales) OVER (PARTITION BY category),
        2
    ) AS sales_contribution_to_category,

    ROUND(
        sub_cat_sales * 100.0 /
        SUM(sub_cat_sales) OVER (),
        2
    ) AS overall_sales_contribution

FROM (
    SELECT
        p.category,
        p.sub_category,
        SUM(t.sales_amount) AS sub_cat_sales
    FROM ex_transactions t
    JOIN ex_products p
        ON t.product_id = p.product_id
    JOIN ex_orders o
        ON t.order_id = o.order_id
    WHERE order_status NOT IN ('cancelled', 'unavailable')
    GROUP BY
        p.category,
        p.sub_category
) x;

