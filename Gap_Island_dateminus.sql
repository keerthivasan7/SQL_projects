-- Problem Statement

-- You are given a login table.

-- Find users who logged in for 3 or more consecutive days.

with cte AS (
select
user_id,
login_date,
login_date - ROW_NUMBER() OVER (PARTITION BY user_id order by login_date)::INT as grp
--"2025-01-01" - 1..2..3..4 etc
FROM user_logins
)

select
user_id,
MIN(login_date) AS streak_start,
MAX(login_date) AS streak_end,
COUNT(*) AS streak_length
FROM cte
group by user_id, grp
having count(*) >=3
order by user_id