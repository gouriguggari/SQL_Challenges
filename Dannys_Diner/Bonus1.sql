CREATE VIEW  dannys_diner.are_members AS (
	SELECT s.customer_id,
		   s.order_date,
		   me.product_name,
		   me.price,
		   CASE WHEN s.order_date>= m.join_date THEN 'Y'
		   ELSE 'N'
		   END AS "member"
	FROM dannys_diner.sales s 
	FULL OUTER JOIN dannys_diner.members m 
	ON (s.customer_id= m.customer_id)
	LEFT JOIN dannys_diner.menu me 
	ON (me.product_id= s.product_id)
	ORDER BY s.customer_id,s.order_date
)

