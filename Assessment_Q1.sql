SELECT * FROM users_customuser;
SELECT * FROM plans_plan;
SELECT * FROM savings_savingsaccount;

SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ' ,last_name) AS name, -- merging first and last name into one full name
    COUNT(DISTINCT s.id) AS savings_count, -- shows number of savings accounts holders
    COUNT(DISTINCT p.id) AS investment_count, -- shows number of investment plan holders
    COALESCE(SUM(s.confirmed_amount), 0) + COALESCE(SUM(p.amount), 0) AS total_deposits -- replace null entries with 0 if found in the column
FROM users_customuser u
JOIN savings_savingsaccount s ON u.id = s.owner_id 
JOIN plans_plan p ON u.id = p.owner_id -- JOIN returns values where conditions are met on all related tables e.g. user must have savingsaccount and plans_plan account
WHERE s.confirmed_amount > 0 AND p.amount > 0 -- ensures that accounts with 0 funds are ignored
GROUP BY u.id, u.name
ORDER BY total_deposits DESC;

