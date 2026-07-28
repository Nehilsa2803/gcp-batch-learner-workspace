WITH final AS
(
    SELECT
        category,
        sub_category,

        DENSE_RANK() OVER
        (
            PARTITION BY category
            ORDER BY sub_cat_sales DESC
        ) AS sub_cat_rank,

        ROUND(
            sub_cat_sales * 100.0 /
            SUM(sub_cat_sales) OVER(PARTITION BY category),
            2
        ) AS sales_contribution_to_category,

        ROUND(
            sub_cat_sales * 100.0 /
            SUM(sub_cat_sales) OVER(),
            2
        ) AS overall_sales_contribution

    FROM
    (
        SELECT
            p.category,
            p.sub_category,
            SUM(t.sales_amount) AS sub_cat_sales
        FROM ex_transactions t
        JOIN ex_products p
            ON t.product_id = p.product_id
        GROUP BY
            p.category,
            p.sub_category
    ) x
)

SELECT *
FROM final
WHERE category = 'Office Supplies'
  AND sub_category = 'Appliances';




  ---2---

 SELECT *
FROM
(
    SELECT
        sub_category,
        ROUND(
            sub_cat_sales * 100.0 /
            SUM(sub_cat_sales) OVER(),
            2
        ) AS overall_sales_contribution
    FROM
    (
        SELECT
            p.sub_category,
            SUM(t.sales_amount) AS sub_cat_sales
        FROM ex_transactions t
        JOIN ex_products p
            ON t.product_id = p.product_id
        GROUP BY p.sub_category
    ) x
) y
WHERE overall_sales_contribution > 7;


--3--
SELECT *
FROM
(
    SELECT
        category,
        sub_category,
        DENSE_RANK() OVER
        (
            PARTITION BY category
            ORDER BY sub_cat_sales DESC
        ) AS sub_cat_rank
    FROM
    (
        SELECT
            p.category,
            p.sub_category,
            SUM(t.sales_amount) AS sub_cat_sales
        FROM ex_transactions t
        JOIN ex_products p
            ON t.product_id = p.product_id
        GROUP BY
            p.category,
            p.sub_category
    ) x
) y
WHERE sub_category = 'Machines';