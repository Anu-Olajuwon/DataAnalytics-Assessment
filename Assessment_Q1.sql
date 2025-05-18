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
