--What is the total items and amount spent for each member before they became a member?
SELECT s.customer_id, 
	   COUNT(s.product_id) AS total_items, 
	   SUM(me.price) AS amount_spent
FROM dannys_diner.sales s 
LEFT JOIN dannys_diner.menu me
ON (s.product_id = me.product_id)
LEFT JOIN dannys_diner.members m
ON (s.customer_id = m.customer_id  )
WHERE s.order_date< m.join_date
GROUP BY s.customer_id
ORDER BY s.customer_id
