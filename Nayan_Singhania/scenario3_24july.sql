select 
  c.customer_name, 
  count(o.order_id) as tot_orders, 
  count(r.order_id) as tot_returns, 
  round(cast(sum(t.sales_amount) as numeric),2) as order_value, 
  round(cast(sum(t.quantity) / count(o.order_id) as numeric),2) as avg_basket_size, 
  round(cast(sum(t.sales_amount) / count(o.order_id) as numeric),2) as avg_basket_value, 
  extract(day from (max(o.order_purchase_date) - min(o.order_purchase_date))) as length_of_stay_days,
  round(cast(extract(day from (max(o.order_purchase_date) - min(o.order_purchase_date))) / count(o.order_id) as numeric),2) as order_purchase_frequency,
  extract(day from ('2018-09-01' - max(o.order_purchase_date))) as recency_days,
  case 
    when extract(day from ('2018-09-01' - max(o.order_purchase_date))) <= 18 then 'High'
    when extract(day from ('2018-09-01' - max(o.order_purchase_date))) <= 31 then 'Medium'
    else 'Low'
  end as recency_segment,
  case 
    when extract(day from (max(o.order_purchase_date) - min(o.order_purchase_date))) / count(o.order_id) <= 30 then 'High'
    when extract(day from (max(o.order_purchase_date) - min(o.order_purchase_date))) / count(o.order_id) <= 38 then 'Medium'
    else 'Low'
  end as frequency_segment, 
  case 
    when sum(t.sales_amount) > 6900 then 'High'
    when sum(t.sales_amount) >= 4300 then 'Medium'
    else 'Low'
  end as monetary_segment
from dbo.ex_customers c 
join dbo.ex_orders o 
on c.customer_id = o.customer_id
join dbo.ex_transactions t 
on o.order_id = t.order_id
left join dbo.ex_returns r 
on o.order_id = r.order_id
where o.order_status = 'delivered'
group by c.customer_id, c.customer_name;  