SELECT
	category,
	sub_category,
	COUNT(product_id) AS product_count
FROM
	ex_products
GROUP BY
	CUBE(
	(category, sub_category)
);

