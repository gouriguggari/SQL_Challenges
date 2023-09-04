--What was the first item from the menu purchased by each customer?

WITH firstdish AS (
	SELECT s.customer_id,s.order_date,s.product_id,me.product_name,
	DENSE_RANK() OVER (PARTITION BY s.customer_id ORDER BY s.order_date) AS Rank_by_date
	FROM dannys_diner.sales s 
	LEFT JOIN dannys_diner.menu me 
	ON (s.product_id= me.product_id)
)
SELECT fd.customer_id, 
       fd.product_name
FROM firstdish fd
WHERE fd.rank_by_date = 1
GROUP BY fd.customer_id, 
         fd.product_name
ORDER BY fd.customer_id
 
 
