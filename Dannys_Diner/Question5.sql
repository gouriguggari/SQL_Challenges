--Which item was the most popular for each customer?
WITH most_ordered AS (
	SELECT s.customer_id,
		   me.product_name,
		   s.product_id, 
	       COUNT(s.product_id) AS total_count,
	       DENSE_RANK() OVER (PARTITION BY s.customer_id ORDER BY COUNT(s.product_id) DESC ) AS rank_orders
	FROM dannys_diner.sales s 
	LEFT JOIN dannys_diner.menu me 
	ON ( s.product_id = me.product_id )
	GROUP BY s.customer_id, s.product_id,me.product_name
)

SELECT mo.customer_id, 
	   mo.total_count
FROM most_ordered mo 
WHERE mo.rank_orders= 1
ORDER BY mo.customer_id

