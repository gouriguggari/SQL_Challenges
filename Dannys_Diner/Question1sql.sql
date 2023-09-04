--What is the total amount each customer spent at the restaurant?
SELECT s.customer_id, 
	   SUM(me.price) 
FROM dannys_diner.sales s 
left join dannys_diner.menu me on (s.product_id = me.product_id )
GROUP BY s.customer_id
