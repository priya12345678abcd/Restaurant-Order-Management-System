# Basic Level
#1. Display all customers
SELECT *
FROM customers;


# Concept: SELECT

# Explanation: Displays all customer records, including customer ID, name, email, phone number, city, area, signup date, loyalty points, and customer status.
#2. Find customers by city
SELECT
    customer_id,
    first_name,
    last_name,
    city
FROM customers
ORDER BY city;


# Concept: SELECT, ORDER BY

# Explanation: Displays customer details and sorts the customers alphabetically based on their city.
#3. Find active and inactive customers
SELECT
    customer_id,
    first_name,
    last_name,
    customer_status
FROM customers
WHERE customer_status = 'Active';


# Concept: WHERE, Comparison Operator

# Explanation: Displays only customers whose status is Active.

To find inactive customers:
SELECT
    customer_id,
    first_name,
    last_name,
    customer_status
FROM customers
WHERE customer_status = 'Inactive';


#4. Find customers with more than 1,000 loyalty points
SELECT
    customer_id,
    first_name,
    last_name,
    loyalty_points
FROM customers
WHERE loyalty_points > 1000
ORDER BY loyalty_points DESC;


# Concept: WHERE, Comparison Operator, ORDER BY

# Explanation: Identifies customers who have earned more than 1,000 loyalty points and displays the highest-point customers first.

Intermediate Level
#5. Count orders per customer
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_orders DESC;


# Concept: LEFT JOIN, COUNT(), GROUP BY, ORDER BY

# Explanation: Counts the total number of orders placed by each customer.

LEFT JOIN ensures that customers who have never placed an order are also displayed with a count of zero.
#6. Calculate total customer spending
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(o.total_amount) AS total_spending
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_spending DESC;


# Concept: JOIN, SUM(), GROUP BY, ORDER BY, WHERE

# Explanation: Calculates how much money each customer has spent on successfully delivered orders.

Cancelled and undelivered orders are excluded from the spending calculation.
#7. Find customers who placed more than 5 orders
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
HAVING COUNT(o.order_id) > 5
ORDER BY total_orders DESC;


# Concept: JOIN, COUNT(), GROUP BY, HAVING

# Explanation: Identifies customers who have placed more than five orders.

HAVING is used because we are filtering the results of an aggregate function (COUNT).
#8. Calculate average spending per customer
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    ROUND(AVG(o.total_amount), 2) AS average_spending
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY average_spending DESC;


# Concept: JOIN, AVG(), ROUND(), GROUP BY, ORDER BY

# Explanation: Calculates the average amount spent per delivered order by each customer.

For example, if a customer has three delivered orders worth ₹500, ₹700, and ₹800, their average spending is ₹666.67.

Advanced Level
#9. Identify top 10 highest-spending customers
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(o.total_amount) AS total_spending
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_spending DESC
LIMIT 10;


# Concept: JOIN, SUM(), GROUP BY, ORDER BY, LIMIT

# Explanation: Identifies the top 10 customers who have spent the most money on delivered orders.

LIMIT 10 restricts the output to the first 10 highest-spending customers.
#10. Find customers who never ordered
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.city,
    c.phone
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


# Concept: LEFT JOIN, IS NULL

# Explanation: Identifies customers who have registered but never placed an order.
- LEFT JOIN displays all customers.
- IS NULL checks whether a matching order exists.
- If order_id is NULL, the customer has never ordered.
#11. Segment customers into High, Medium and Low spenders
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COALESCE(SUM(
        CASE
            WHEN o.order_status = 'Delivered'
            THEN o.total_amount
            ELSE 0
        END
    ), 0) AS total_spending,
    CASE
        WHEN COALESCE(SUM(
            CASE
                WHEN o.order_status = 'Delivered'
                THEN o.total_amount
                ELSE 0
            END
        ), 0) >= 10000
        THEN 'High Spender'

        WHEN COALESCE(SUM(
            CASE
                WHEN o.order_status = 'Delivered'
                THEN o.total_amount
                ELSE 0
            END
        ), 0) >= 5000
        THEN 'Medium Spender'

        ELSE 'Low Spender'
    END AS customer_segment
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_spending DESC;


# Concept: LEFT JOIN, CASE, SUM(), COALESCE(), GROUP BY

# Explanation: Divides customers into three spending categories based on their total delivered-order spending.
Spending amount	Customer segment
₹10,000 and above	High Spender
₹5,000–₹9,999.99	Medium Spender
Below ₹5,000	Low Spender

- CASE evaluates the spending conditions.
- COALESCE converts NULL spending values into zero.
- LEFT JOIN includes customers who have never ordered.
Note: These spending thresholds are sample business rules and can be adjusted.
#12. Identify repeat customers
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
HAVING COUNT(o.order_id) > 1
ORDER BY total_orders DESC;


# Concept: JOIN, COUNT(), GROUP BY, HAVING

# Explanation: Identifies customers who have placed more than one order.

These customers are considered repeat customers because they have purchased from the restaurant platform multiple times.
#13. Rank customers based on total spending
SELECT
    customer_id,
    first_name,
    last_name,
    total_spending,
    RANK() OVER (
        ORDER BY total_spending DESC
    ) AS spending_rank
FROM (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        COALESCE(SUM(
            CASE
                WHEN o.order_status = 'Delivered'
                THEN o.total_amount
                ELSE 0
            END
        ), 0) AS total_spending
    FROM customers c
    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name
) AS customer_spending;


# Concept: Subquery, LEFT JOIN, CASE, SUM(), COALESCE(), GROUP BY, RANK(), Window Function

# Explanation:
#- The inner query calculates the total spending of every customer.
#- The outer query uses RANK() to assign a rank based on total spending.
#- ORDER BY total_spending DESC places the highest spender at rank 1.
#- Customers with equal spending receive the same rank.
#- Customers who have never ordered are also included with zero spending.