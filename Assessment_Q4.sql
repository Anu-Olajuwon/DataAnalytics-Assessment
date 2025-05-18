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
