# DataAnalytics-Assessment

SELECT 
  u.id AS owner_id,
  u.name,
  COUNT(DISTINCT s.id) AS savings_count,
  COUNT(DISTINCT p.id) AS investment_count,
  SUM(s.balance + p.balance) AS total_deposits
FROM 
  users_customuser u
  JOIN savings_savingsaccount s ON u.id = s.user_id
  JOIN plans_plan p ON u.id = p.user_id
WHERE 
  s.balance > 0 AND p.balance > 0
  AND s.plan_type = 'Savings' AND p.plan_type = 'Investment'
GROUP BY 
  u.id, u.name
HAVING 
  COUNT(DISTINCT s.id) >= 1 AND COUNT(DISTINCT p.id) >= 1
ORDER BY 
  total_deposits DESC;

  WITH transaction_frequency AS (
  SELECT 
    user_id,
    AVG(transaction_count) AS avg_transactions_per_month
  FROM (
    SELECT 
      user_id,
      EXTRACT(MONTH FROM transaction_date) AS month,
      COUNT(*) AS transaction_count
    FROM 
      savings_savingsaccount
    GROUP BY 
      user_id, EXTRACT(MONTH FROM transaction_date)
  ) AS monthly_transactions
  GROUP BY 
    user_id
),
categorized_customers AS (
  SELECT 
    CASE
      WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
      WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
      ELSE 'Low Frequency'
    END AS frequency_category,
    user_id
  FROM 
    transaction_frequency
)
SELECT 
  frequency_category,
  COUNT(DISTINCT user_id) AS customer_count,
  AVG(avg_transactions_per_month) AS avg_transactions_per_month
FROM 
  categorized_customers
  JOIN transaction_frequency USING (user_id)
GROUP BY 
  frequency_category;

WITH last_transactions AS (
  SELECT 
    plan_id,
    MAX(transaction_date) AS last_transaction_date
  FROM 
    savings_savingsaccount
  GROUP BY 
    plan_id
)
SELECT 
  p.plan_id,
  p.owner_id,
  p.type,
  lt.last_transaction_date,
  CURRENT_DATE - lt.last_transaction_date AS inactivity_days
FROM 
  plans_plan p
  JOIN last_transactions lt ON p.plan_id = lt.plan_id
WHERE 
  lt.last_transaction_date < CURRENT_DATE - INTERVAL '365 days'
  AND p.status = 'active';  -- assuming 'active' status for accounts

WITH customer_data AS (
  SELECT 
    u.id AS customer_id,
    u.name,
    TIMESTAMPDIFF(MONTH, u.signup_date, CURRENT_DATE) AS tenure_months,
    COUNT(s.id) AS total_transactions,
    AVG(s.transaction_value * 0.001) AS avg_profit_per_transaction,
    SUM(s.transaction_value * 0.001) AS total_profit
  FROM 
    users_customuser u
  JOIN 
    savings_savingsaccount s ON u.id = s.user_id
  GROUP BY 
    u.id, u.name, u.signup_date
)
SELECT 
  customer_id,
  name,
  tenure_months,
  total_transactions,
  (total_transactions / tenure_months) * 12 * avg_profit_per_transaction AS estimated_clv
FROM 
  customer_data
ORDER BY 
  estimated_clv DESC;


Explanation for question one:
1. Join users_customuser with savings_savingsaccount and plans_plan on user_id.
2. Filter funded accounts (balance > 0) and specific plan types.
3. Group by owner_id and name.
4. Apply HAVING clause to ensure at least one savings and investment plan.
5. Calculate total_deposits by summing balances.
6. Sort results by total_deposits in descending order.


Question two:
Step 1: Calculate Transaction Frequency
We'll calculate the average number of transactions per customer per month. Assuming the savings_savingsaccount table contains transaction data, we'll use SQL to:

1. Count transactions per customer per month.
2. Calculate the average transactions per customer per month.

Step 2: Categorize Customers
We'll categorize customers based on their average transaction frequency:

1. High Frequency: ≥10 transactions/month
2. Medium Frequency: 3-9 transactions/month
3. Low Frequency: ≤2 transactions/month

QUestion three:
Step 1: Find Last Transaction Date
We'll calculate the last transaction date for each account.

Step 2: Calculate Inactivity Days
We'll calculate the number of days since the last transaction.

Step 3: Filter Inactive Accounts
We'll filter accounts with no transactions in the last 365 days.

Question four:
Step 1: Calculate Account Tenure
We'll calculate the account tenure in months since signup.

Step 2: Calculate Total Transactions
We'll calculate the total number of transactions for each customer.

Step 3: Calculate Average Profit per Transaction
We'll calculate the average profit per transaction, assuming 0.1% of the transaction value.

Step 4: Calculate Estimated CLV
We'll calculate the estimated CLV using the formula: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction
