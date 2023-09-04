WITH dates AS (
  SELECT 
    customer_id, 
    join_date, 
    join_date + 6 AS valid_date, 
    DATE_TRUNC(
      'month', '2021-01-31'::DATE)
      + interval '1 month' 
      - interval '1 day' AS last_date
  FROM dannys_diner.members
)

SELECT s.customer_id,
	   SUM(CASE
		   WHEN m.product_id= 1 THEN m.price * 10 * 2
		   WHEN s.order_date>=d.join_date AND s.order_date<= d.valid_date THEN m.price * 10 * 2
		   ELSE m.price * 10 
		   END) AS points_earned
FROM dannys_diner.sales s
JOIN dates d
  ON s.customer_id = d.customer_id
  AND s.order_date <= d.last_date
JOIN dannys_diner.menu m
  ON s.product_id = m.product_id
GROUP BY s.customer_id 