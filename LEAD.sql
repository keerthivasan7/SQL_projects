-- Problem Statement

-- You are given an orders table.

-- Find customers who:

-- Placed orders on 3 consecutive days
-- Total order amount across those 3 days is greater than 500
with cte AS
(
select *,
LEAD(order_date, 1) over( PARTITION BY customer_id order by order_date) as next_day1,
LEAD(order_date, 2) over( PARTITION BY customer_id order by order_date) as next_day2,
LEAD(amount, 1) over( PARTITION BY customer_id order by order_date) as amt1,
LEAD(amount, 2) over( PARTITION BY customer_id order by order_date) as amt2
from customer_orders
)

select
*,
amount+amt1+amt2 AS total_amount
from cte
WHERE next_day1 = order_date + INTERVAL '1 day'
AND next_day2 = order_date + INTERVAL '2 day'
AND (amount+amt1+amt2) > 500
