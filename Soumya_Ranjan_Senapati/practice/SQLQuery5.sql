SELECT 
    l.region AS Region,
    cmp.campaign_id AS [Campaign ID],
    COUNT(DISTINCT c.customer_id) AS [Customers Acquired],
    ROUND(SUM(t.sales_amount), 2) AS [Total Revenue]
FROM ex_campaigns cmp
JOIN ex_transactions t ON cmp.product_id = t.product_id
JOIN ex_orders o ON t.order_id = o.order_id 
    AND CAST(o.order_purchase_date AS DATE) >= cmp.start_date 
    AND CAST(o.order_purchase_date AS DATE) <= cmp.end_date
JOIN ex_customers c ON o.customer_id = c.customer_id
JOIN locations_01 l ON c.postal_code = l.postal_code
GROUP BY 
    l.region, 
    cmp.campaign_id
ORDER BY 
    Region, 
    [Campaign ID];