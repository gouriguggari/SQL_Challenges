--If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
SELECT s.customer_id,
	   SUM(CASE WHEN s.product_id = 1 THEN (m.price * 20)
	   ELSE (m.price * 10)
	   END) AS points_earned
FROM dannys_diner.sales s 
LEFT JOIN dannys_diner.menu m
ON (s.product_id=m.product_id)
GROUP BY s.customer_id		 
ORDER BY s.customer_id