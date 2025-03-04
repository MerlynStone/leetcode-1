# Write your MySQL query statement below
WITH
    T AS (
        SELECT
            count(DISTINCT session_id) AS sessions
        FROM Activity
        WHERE activity_date <= '2019-07-27' AND datediff('2019-07-27', activity_date) < 30
        GROUP BY user_id
    )
SELECT ifnull(round(avg(sessions), 2), 0) AS average_sessions_per_user
FROM T;
