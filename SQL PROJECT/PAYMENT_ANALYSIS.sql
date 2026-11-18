#1. Display all payments
# Concept: SELECT Statement

# Explanation: The SELECT statement retrieves all records from the payments table. It displays payment details such as payment ID, order ID, payment date, payment method, amount, payment status, and transaction reference.
SELECT *
FROM payments;

#2. Find UPI payments
# Concept: WHERE Clause

# Explanation: The WHERE clause filters records based on a specified condition. Here, it displays only payments made using the UPI payment method. This helps identify customers who prefer UPI transactions.
SELECT *
FROM payments
WHERE payment_method = 'UPI';

#3. Find credit card payments
# Concept: WHERE Clause

# Explanation: The WHERE clause filters payment records where the payment method is 'Credit Card'. It helps analyze how many customers use credit cards for their restaurant orders.
SELECT *
FROM payments
WHERE payment_method = 'Credit Card';

#4. Find pending payments
# Concept: WHERE Clause

# Explanation: The WHERE clause retrieves payments whose payment status is 'Pending'. These transactions have not yet been marked as successfully paid or refunded. Businesses can use this information to identify transactions that need attention.
SELECT *
FROM payments
WHERE payment_status = 'Pending';

#5. Count transactions by payment method
# Concept: COUNT() Aggregate Function and GROUP BY Clause

# Explanation: The COUNT() function calculates the total number of transactions for each payment method. The GROUP BY clause groups payment records based on payment method. This helps understand which payment methods customers use most frequently.
SELECT 
    payment_method,
    COUNT(payment_id) AS total_transactions
FROM payments
GROUP BY payment_method
ORDER BY total_transactions DESC;

#6. Calculate revenue by payment method
# Concept: SUM() Aggregate Function and GROUP BY Clause

# Explanation: The SUM() function calculates the total successful payment amount for each payment method. The WHERE clause considers only payments with a 'Paid' status. The GROUP BY clause groups transactions by payment method. This helps identify which payment methods generate the highest successful payment value.
SELECT 
    payment_method,
    SUM(amount) AS total_revenue
FROM payments
WHERE payment_status = 'Paid'
GROUP BY payment_method
ORDER BY total_revenue DESC;

#7. Find refunded payments
# Concept: WHERE Clause

# Explanation: The WHERE clause filters payment records based on payment status. Here, it displays transactions whose status is 'Refunded'. This helps businesses track returned payments and understand refund activity.
SELECT *
FROM payments
WHERE payment_status = 'Refunded';

#8. Identify the most preferred payment method
# Concept: COUNT(), GROUP BY, ORDER BY and LIMIT Clauses

# Explanation: The COUNT() function calculates the number of transactions for each payment method. The GROUP BY clause groups transactions by payment method. The ORDER BY clause sorts the results in descending order, and LIMIT 1 displays the payment method with the highest transaction count.
SELECT 
    payment_method,
    COUNT(payment_id) AS total_transactions
FROM payments
GROUP BY payment_method
ORDER BY total_transactions DESC
LIMIT 1;

#9. Calculate payment success percentage
# Concept: COUNT(), Subquery and Percentage Calculation

# Explanation: This query calculates the percentage of successful payments compared with all payment transactions. The COUNT() function counts payments with a 'Paid' status, while the subquery calculates the total number of payment transactions. Multiplying the result by 100 gives the payment success percentage.
SELECT 
    ROUND(
        (SELECT COUNT(*)
         FROM payments
         WHERE payment_status = 'Paid') * 100.0
        /
        NULLIF(
            (SELECT COUNT(*)
             FROM payments), 0
        ),
        2
    ) AS payment_success_percentage;

#10. Compare payment methods by transaction value
# Concept: SUM(), AVG(), COUNT() Aggregate Functions and GROUP BY Clause

# Explanation: This query compares payment methods based on transaction value. The COUNT() function calculates the number of transactions, the SUM() function calculates the total transaction amount, and the AVG() function calculates the average transaction value for each payment method.

Only successfully paid transactions are considered so that the comparison reflects completed payment values.
SELECT 
    payment_method,
    COUNT(payment_id) AS total_transactions,
    SUM(amount) AS total_transaction_value,
    ROUND(AVG(amount), 2) AS average_transaction_value
FROM payments
WHERE payment_status = 'Paid'
GROUP BY payment_method
ORDER BY total_transaction_value DESC;