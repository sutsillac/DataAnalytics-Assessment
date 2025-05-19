use adashi_staging;
Select * from users_customuser;
select * from savings_savingsaccount;

/*solution 2*/
-- calculating the monthly transaction count per user
WITH monthly_transactions AS (
    SELECT s.owner_id, 
        DATE_FORMAT(s.transaction_date, '%Y-%m') AS transaction_month, -- extracting the year and month from transaction dates
        COUNT(*) AS transaction_count -- count number of transactions per user in a month
    FROM savings_savingsaccount AS s
    GROUP BY s.owner_id, transaction_month -- group transactions by owners id
),
-- calculate monthly transactions average per user
average_transactions AS (
    SELECT owner_id, 
        AVG(transaction_count) AS avg_transactions_per_month -- customers monthly average
    FROM monthly_transactions
    GROUP BY owner_id
),
-- cte 3: caterorizing customers transaction frequency; High, Medium and low
categorized_customers AS (
    SELECT owner_id, 
        CASE 
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        avg_transactions_per_month
    FROM average_transactions
)
-- aggregating the cte codes to derive count of customers and avg transaction frequency
SELECT frequency_category, COUNT(owner_id) AS customer_count, 
    SUM(avg_transactions_per_month) AS total_avg_transactions
FROM categorized_customers
GROUP BY frequency_category
ORDER BY total_avg_transactions DESC;
