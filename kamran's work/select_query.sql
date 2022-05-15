WITH
	left_table AS (
		SELECT
			* 
		FROM (
			SELECT 
				product_sales_product_id,
				SUM(product_sales_quantity) AS quantity_sold,
				COUNT(DISTINCT product_sales_day) AS days_with_sales 
			FROM (
				SELECT * 
				FROM 
					product_sales
				WHERE 
					product_sales.product_sales_day >= NOW() - interval '60' day
				) 
			AS 
				foo 
			GROUP BY 
				foo.product_sales_product_id)
		AS 
			bar 
		WHERE 
			bar.days_with_sales >=30),
	right_table AS (
		SELECT 
			* 
		FROM 
			product_sales 
		WHERE 
			product_sales.product_sales_day >= NOW() - interval '7' day
		)

SELECT 
	*
FROM 
	left_table
LEFT JOIN 
	right_table
ON 
	left_table.product_sales_product_id = right_table.product_sales_product_id
WHERE 
	right_table.product_sales_product_id IS NULL;
