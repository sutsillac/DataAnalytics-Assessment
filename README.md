Per- question Explanation

Question 1:
This question aims to find out the total amount invested by users who hold both the savings plan and in the investment plans account in the institution. It excludes those who hold only one account type, thus giving insights on high value clients who operate two account types in the institution. 
Question 2:
This question aims to understand the engagement level of the customers, their behaviors over time and also aid management in developing targeted marketing programs to resuscitate low performing customers and retention programs to encourage high performing customers.
Question 3:
Pursuant to the result in question 2, this code aims to understand those customers who mostly have low performance and have been inactive at least for the past one year depending on the specific account type. Question 2 avoided those who had only one account or plan, but this question looks at all the customer plans and searches for those who have not deposited or operated their account for a given period. This will help identify customers in need of re-engagement.
Question 4:
This quest aimed to identify the life time value of the customers depending on the number of transactions each customer engages with the institution and the value of such engagements. The higher the value shows a higher contribution of the customer to the organization depending on metrics such as profits etc.
Challenges:
1.	The first challenge I encountered was understanding the schema of the data as the column titles of the tables were quite similar but some contained different entries, hence could not be used as keys to model the tables conveniently. I had to manually create a schema on excel using the column titles of all the given tables, the selected a user id entry from the user_customuser tables and cross checked it with the other tables using the code below.
SELECT * 
FROM plans_plan
WHERE owner_id = '01bac3db234043bda56eb8ee396c9f51'
If the result is null, then I try another identifier on the plans_plans table till it corresponds. With this I was able to find the unique key to connect all tables.

2.	Writing question 1 code was challenging. I initially wrote a simple straightforward code [select u.id as owner_id, concat(u.first_name,' ',u.last_name) as name, 
count(s.owner_id)as savings_count,  count(p.owner_id) as investment_count, (sum(s.confirmed_amount) + sum(p.amount)) as total_deposits
from users_customuser as u
inner join savings_savingsaccount as s
on u.id = s.owner_id
inner join plans_plan as p
on u.id = p.owner_id
group by 1
order by 5 desc], but the run time exceeded the dbms cycle time to run a code. I increased the time to 600sec and the code still could not provide a result in that time. I resorted to a sub query, but this was not successful (or maybe my mistake in writing the code). Finally, I had to use CTE to break down the process to achieve my result. Run time was 73 secs which was still long.
Thus, for the subsequent problems, I employed multiple CTE codes to achieve my desired results. This solution was arrived at through extensive research.
