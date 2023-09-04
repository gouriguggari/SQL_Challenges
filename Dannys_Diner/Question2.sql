--How many days has each customer visited the restaurant?
SELECT s.customer_id, 
	   COUNT(DISTINCT s.order_date) 
FROM dannys_diner.sales s 
GROUP BY 
	   s.customer_id
ORDER BY 
	   COUNT(DISTINCT s.order_date) DESC