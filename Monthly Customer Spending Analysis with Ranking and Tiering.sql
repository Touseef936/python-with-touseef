 -- calculate total spend per customer per month
WITH monthly_spending AS (
    SELECT
        customer_name,
        region,
        DATE_FORMAT(order_date, '%Y-%m') AS order_month,  -- e.g., '2024-01'
        SUM(order_amount) AS total_monthly_spend
    FROM orders
    GROUP BY customer_name, region, DATE_FORMAT(order_date, '%Y-%m')
),

-- ranking, lag, and NTILE per region
ranked_customers AS (
    SELECT
        customer_name,
        region,
        order_month,
        total_monthly_spend,

        -- Rank within the month by spend
        RANK() OVER (
            PARTITION BY order_month ORDER BY total_monthly_spend DESC
        ) AS monthly_rank,

        -- Previos month spend per customer
        LAG(total_monthly_spend) OVER (
            PARTITION BY customer_name ORDER BY order_month
        ) AS previous_month_spend,

        NTILE(3) OVER (
            PARTITION BY region, order_month ORDER BY total_monthly_spend DESC
        ) AS spend_tier  -- 1 = top tier, 3 = lowest
)

-- output
SELECT *
FROM ranked_customers
ORDER BY order_month, region, monthly_rank;
