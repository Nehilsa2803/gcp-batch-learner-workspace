-- scenario5

-- q1

select l.region as Region, cast(o.order_purchase_date as date) as "Order Date", year(o.order_purchase_date) as Year, datename(month, o.order_purchase_date) as "Month Name",
round(t.sales_amount,2) as Sales, round(sum(t.sales_amount) over(partition by l.region, year(o.order_purchase_date), month(o.order_purchase_date) order by cast(o.order_purchase_date as date)),2) as MTD, 
round(sum(t.sales_amount) over(partition by l.region, year(o.order_purchase_date) order by cast(o.order_purchase_date as date)),2) as YTD
from ex_locations l
join ex_customers c
on l.postal_code = c.postal_code
join ex_orders o
on c.customer_id = o.customer_id
join ex_transactions t
on o.order_id = t.order_id;


-- q2 (tables - ex_campaigns, ex_campaign_metrics, ex_channel)

select concat('CMP', cmp.campaign_id) as "Campaign ID", ch.channel_name as "Channel Name", sum(cmpm.impressions) as Impressions, sum(cmpm.clicks) as Clicks, sum(cmpm.conversions) as Conversions
from ex_campaigns cmp
join ex_channel ch
on cmp.channel_id = ch.channel_id
join ex_campaign_metrics cmpm
on cmp.campaign_id = cmpm.campaign_id
group by cmp.campaign_id, ch.channel_name
order by cmp.campaign_id;


-- q3 

select l.region as Region, concat('CMP', cmp.campaign_id) as "Campaign ID", count(c.customer_id) as "Customers Acquired", round(sum(t.sales_amount),2) as "Total Revenue"
from ex_locations l
join ex_customers c
on l.postal_code = c.postal_code
join ex_orders o
on c.customer_id = o.customer_id
join ex_transactions t
on o.order_id = t.order_id
join ex_campaigns cmp
on t.product_id = cmp.product_id
group by l.region, cmp.campaign_id
order by l.region, cmp.campaign_id;