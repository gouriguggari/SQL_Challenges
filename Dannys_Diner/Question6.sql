--Which item was purchased first by the customer after they became a member?
WITH ranking AS (
	SELECT s.customer_id,
		   s.order_date, 
		   me.product_name,
		   DENSE_RANK() OVER( PARTITION BY s.customer_id ORDER BY s.order_date) AS ranking
	FROM dannys_diner.sales s
	LEFT JOIN dannys_diner.members m 
	ON (s.customer_id= m.customer_id)
	LEFT JOIN dannys_diner.menu me
	ON (s.product_id=me.product_id)
	WHERE s.order_date> m.join_date
	GROUP BY s.customer_id, s.order_date, me.product_name	
)

SELECT r.customer_id,r.product_name
FROM ranking r
WHERE r.ranking=1
ORDER BY r.customer_id



