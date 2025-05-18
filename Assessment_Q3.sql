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
