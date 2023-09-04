CREATE VIEW dannys_diner.ranking AS (
	SELECT am.customer_id,
		   am.order_date,
		   am.product_name,
		   am.price,
		   am.member,
		   CASE WHEN am.member= 'Y' 
			    THEN  RANK() OVER (PARTITION BY am.customer_id, am.member ORDER BY am.order_date)
		   ELSE NULL
		   END AS ranking
	FROM dannys_diner.are_members AS am	   
)