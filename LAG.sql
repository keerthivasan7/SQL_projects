-- Problem Statement

-- A customer can have multiple status updates over time.

-- Find:

-- only the rows where the status changed compared to previous record
-- and identify the latest status for each customer

-- This is a very common CDC/event-stream style problem.

with cte as (
select 
*,
LAG(status) over(partition by customer_id order by update_time asc) as prev_status
from customer_status
)

select customer_id,
MAX(update_time) as update_time,
status
from
(
SELECT 
    *,
    CASE 
        WHEN prev_status IS NULL THEN 'NM'
        WHEN status != prev_status THEN 'NM' 
        ELSE 'M' 
    END AS compare_check,
	row_number() over(partition by customer_id order by update_time desc) as rn
FROM cte
) 
where rn=1 and compare_check='NM'
group  by customer_id, status

