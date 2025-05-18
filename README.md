# DataAnalytics-Assessment

Question one:
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
