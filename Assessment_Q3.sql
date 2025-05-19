/*question 3*/
select * from plans_plan;

-- cte to identify last transactions per owner and the plan type
WITH last_transactions AS (
    -- investment plan analysis
    SELECT owner_id, 
        MIN(id) AS plan_id,  -- Ensures a single ID per owner
        'Investment' AS type, 
        MAX(created_on) AS last_transaction_date -- last activity date
    FROM plans_plan
    GROUP BY owner_id -- groups customers by unique inestment plans

    UNION ALL -- this will ensure duplicate owner_id across plans is preserved
    
	-- savings plan analysis
    SELECT 
        owner_id, 
        MIN(id) AS plan_id,  -- Ensures a single ID per owner
        'Savings' AS type, 
        MAX(created_on) AS last_transaction_date
    FROM savings_savingsaccount
    GROUP BY owner_id -- groups customer by unique savings plans
)
-- query to calculate inactivity
SELECT plan_id, owner_id, 
    type, -- investment /savings plan type
    last_transaction_date, --  most recent activity date
    DATEDIFF(CURDATE(), last_transaction_date) AS inactivity_days -- days since last activity
FROM last_transactions
WHERE last_transaction_date <= DATE_SUB(CURDATE(), INTERVAL 365 DAY) -- filter inactivity by 1 year
ORDER BY inactivity_days DESC;



