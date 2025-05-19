/*question 4*/
select * from users_customuser;
select * from savings_savingsaccount;

-- Define a common table expression (CTE) to summarize transactions data
WITH transaction_summary AS (
    SELECT owner_id, 
        COUNT(*) AS total_transactions, -- count of total trasaction per user
        SUM(confirmed_amount) AS total_transaction_value -- sum of confirmed deposits
    FROM savings_savingsaccount
    GROUP BY owner_id
),
-- creating another cte to calculate customer tenure
customer_tenure AS (
    SELECT id AS customer_id, 
        CONCAT(first_name, ' ', last_name) AS name, -- combining first and last name into full name
        TIMESTAMPDIFF(MONTH, date_joined, CURDATE()) AS tenure_months -- calculating the months since accounts was created
    FROM users_customuser
)
-- combining cte querry results
SELECT c.customer_id, c.name, c.tenure_months, 
    COALESCE(t.total_transactions, 0) AS total_transactions, -- convert null values in customer transactions to zero (0)
    COALESCE((t.total_transactions / c.tenure_months) * 12 * (t.total_transaction_value), 0) AS estimated_clv -- calculating clv
FROM customer_tenure AS c
LEFT JOIN transaction_summary AS t ON c.customer_id = t.owner_id -- include all customers, even those without transactions
ORDER BY estimated_clv DESC; -- order by most valuable customer

