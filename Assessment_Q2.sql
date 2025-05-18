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
