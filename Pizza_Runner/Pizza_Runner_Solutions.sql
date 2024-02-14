-- Active: 1707383489818@@127.0.0.1@5432@8weekchallenge@pizza_runner
-- replace nulls with blank for customer_orders
CREATE TEMP TABLE customer_orders_temp AS(
    SELECT order_id, 
           customer_id, 
           pizza_id,
           CASE 
            WHEN exclusions= 'null' THEN ''  
            ELSE exclusions  
           END as exclusions,
           CASE 
            WHEN extras= 'null' OR extras ISNULL THEN ''  
            ELSE  extras
           END as extras,
           order_time from customer_orders
)

-- replace nulls with blank for runner_orders
CREATE TEMP TABLE runner_orders_temp AS(
    SELECT order_id,
           runner_id,
           pickup_time,
           CASE 
            WHEN distance LIKE 'null' THEN ''  
            WHEN distance LIKE '%km' THEN trim( 'km' FROM distance)
            ELSE  distance
           END as distance,
           CASE 
            WHEN duration ISNULl THEN ''
            WHEN duration like 'null'  THEN ''
            WHEN duration like '%minute%' THEN trim('minutes' FROM duration)
            WHEN duration like '%mins' THEN trim('mins' FROM duration) 
            else duration
           END as duration,
           CASE 
            WHEN cancellation = 'null' or cancellation ISNULL THEN ''  
            ELSE cancellation 
           END  as cancellation from runner_orders
)

-- number of pizza ordered
SELECT concat('Pizzas ordered: ', count(order_id)) from customer_orders_temp

--unique customers
select concat('unique customers: ', count(DISTINCT customer_id)) from customer_orders_temp

-- successful deliveries by runners
SELECT concat('successfull orders for ',runner_id, ': ',count(order_id)) from runner_orders_temp WHERE cancellation = '' group by runner_id

-- how many pizza types delivered
select concat(piz.pizza_name,' Pizza: ',count(cus.pizza_id))from customer_orders_temp as cus 
left join runner_orders_temp  as run ON cus.order_id = run.order_id 
left join pizza_names as piz on cus.pizza_id= piz.pizza_id
WHERE run.cancellation =''
group by piz.pizza_name


--pizza type ordered by each customer
SELECT concat('customer ', cus.customer_id, ' ordered ', count(cus.order_id), ' ',piz.pizza_name,' pizza')
from customer_orders_temp as cus left join pizza_names as piz on cus.pizza_id = piz.pizza_id
group by cus.customer_id, piz.pizza_name
order by cus.customer_id


-- maximum number of pizza in one order

with  max_pizza as (
    select cus.order_id, count(cus.order_id) as count, ROW_NUMBER() over ( order by count(cus.order_id) desc) as ranking FROM customer_orders_temp cus left join runner_orders_temp run on cus.order_id = run.order_id
    WHERE  run.cancellation = ''
    group BY cus.order_id
)
SELECT concat('order id ',max_pizza.order_id, ' ordered ', max_pizza.count, ' pizzas') from max_pizza WHERE ranking=1

--number of pizzas delivered with atleast 1 change and no change
SELECT sum(CASE 
    WHEN cus.extras <> '' or cus.exclusions <> '' THEN  1
    ELSE  0
END) as at_least_1_change,
       sum(CASE 
        WHEN cus.extras = '' and cus.exclusions = '' THEN  1
        ELSE  0
       END) as no_change
       from customer_orders_temp as cus left join runner_orders_temp as run on cus.order_id= run.order_id
       WHERE run.distance <> ''

--number of pizzas delivered with both changes
SELECT sum(CASE 
    WHEN cus.extras <> '' and cus.exclusions <> '' THEN  1
    ELSE  0
END) as both_requested
       from customer_orders_temp as cus left join runner_orders_temp as run on cus.order_id= run.order_id
       WHERE run.distance <> ''


--total volume of pizzas delivered in an hour per DAY
select  extract(hour from order_time) as hour, count(order_id)as pizzas_ordered
 from customer_orders_temp group by  extract(hour from order_time) 
 ORDER BY extract(hour from order_time), count(order_id) desc