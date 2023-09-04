--What is the most purchased item on the menu and how many times was it purchased by all customers

SELECT me.product_name, 
	   COUNT(s.product_id) AS total_orders
FROM dannys_diner.sales s 
LEFT JOIN dannys_diner.menu me
ON (s.product_id=me.product_id )
GROUP BY me.product_name
ORDER BY total_orders DESC
LIMIT 1
		