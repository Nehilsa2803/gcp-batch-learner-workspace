WITH temp AS (
	SELECT
		p.category,
		p.sub_category,
		SUM(t.sales_amount) AS ind_sub_cat_sales
	FROM
		ex_orders o LEFT JOIN ex_transactions t ON o.order_id = t.order_id
		LEFT JOIN ex_products p ON t.product_id = p.product_id
	WHERE
		o.order_status NOT IN ('canceled', 'unavailable')
	GROUP BY
		p.category, p.sub_category
),
new AS (
	SELECT
		category,
		sub_category,
		ROUND(SUM(ind_sub_cat_sales) OVER(PARTITION BY sub_category), 2) AS sub_cat_sales,
		RANK() OVER(PARTITION BY category ORDER BY ind_sub_cat_sales DESC) AS sub_cat_rank,
		ROUND(
			SUM(ind_sub_cat_sales) OVER(PARTITION BY sub_category) * 100.0 
			/ SUM(ind_sub_cat_sales) OVER(PARTITION BY category) * 1.0 
		, 2) AS sales_contribution_to_category,
		ROUND(
			SUM(ind_sub_cat_sales) OVER(PARTITION BY sub_category) * 100.0
			/ SUM(ind_sub_cat_sales) OVER()
			, 2) AS overall_sales_contribution
	FROM
		temp
)
SELECT 
	*
FROM
	new
WHERE
	overall_sales_contribution > 7.00
ORDER BY
		category,
		sub_category;
	

