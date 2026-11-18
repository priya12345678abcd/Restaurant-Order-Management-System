#BASIC LEVEL
#1. Display all coupons
# Concept: SELECT Statement

# Explanation: The SELECT statement retrieves all records from the coupons table. It displays coupon details such as coupon ID, coupon code, discount type, discount value, minimum order value, maximum discount, validity dates, and coupon status.
SELECT *
FROM coupons;


#2. Find active coupons
# Concept: WHERE Clause

# Explanation: The WHERE clause filters records based on a specified condition. Here, it displays only coupons whose coupon_status is 'Active'. This helps identify coupons that are marked as active in the database.
SELECT *
FROM coupons
WHERE coupon_status = 'Active';


#3. Display coupon discount values
# Concept: SELECT Statement and ORDER BY Clause

# Explanation: The SELECT statement retrieves coupon codes, discount types, and discount values. The ORDER BY clause sorts coupons based on their discount values in descending order, displaying higher discount values first.
SELECT 
    coupon_id,
    coupon_code,
    discount_type,
    discount_value,
    max_discount
FROM coupons
ORDER BY discount_value DESC;


#INTERMEDIATE LEVEL
#4. Count coupon usage
# Concept: COUNT() Aggregate Function and GROUP BY Clause

# Explanation: The COUNT() function calculates how many times each coupon has been used. The LEFT JOIN connects the coupons and coupon_usage tables using coupon_id. It also includes coupons that have never been used, showing zero usage for them.
SELECT 
    c.coupon_id,
    c.coupon_code,
    COUNT(cu.usage_id) AS total_usage
FROM coupons c
LEFT JOIN coupon_usage cu
    ON c.coupon_id = cu.coupon_id
GROUP BY c.coupon_id, c.coupon_code
ORDER BY total_usage DESC;


#5. Calculate total discount given
# Concept: SUM() Aggregate Function

# Explanation: The SUM() function calculates the total discount amount provided to customers through coupon usage. The discount_amount column in the coupon_usage table stores the actual discount given for each coupon transaction.
SELECT 
    SUM(discount_amount) AS total_discount_given
FROM coupon_usage;


#6. Find customers using coupons
# Concept: Multiple JOINs

# Explanation: The JOIN operation connects the customers, coupon_usage, and coupons tables using their common IDs. It displays customer details along with the coupon codes they have used and the discount amounts received.
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    cp.coupon_code,
    cu.discount_amount,
    cu.used_at
FROM customers c
JOIN coupon_usage cu
    ON c.customer_id = cu.customer_id
JOIN coupons cp
    ON cu.coupon_id = cp.coupon_id
ORDER BY cu.used_at DESC;


#ADVANCE LEVEL
#7. Identify the most-used coupon
# Concept: COUNT(), GROUP BY, ORDER BY and LIMIT Clauses

# Explanation: The COUNT() function calculates the number of times each coupon has been used. The GROUP BY clause groups usage records by coupon. The ORDER BY clause sorts the results in descending order, and LIMIT 1 displays the coupon with the highest usage.
SELECT 
    cp.coupon_id,
    cp.coupon_code,
    COUNT(cu.usage_id) AS total_usage
FROM coupons cp
JOIN coupon_usage cu
    ON cp.coupon_id = cu.coupon_id
GROUP BY cp.coupon_id, cp.coupon_code
ORDER BY total_usage DESC
LIMIT 1;


#8. Calculate coupon usage percentage
# Concept: COUNT(), Subquery and Percentage Calculation

# Explanation: This query calculates the percentage of orders that used coupons compared with the total number of orders. The COUNT() function counts orders in the coupon_usage table, while the subquery calculates the total orders from the orders table. Multiplying the result by 100 gives the coupon usage percentage.
SELECT 
    ROUND(
        (SELECT COUNT(DISTINCT order_id)
         FROM coupon_usage) * 100.0
        /
        NULLIF(
            (SELECT COUNT(order_id)
             FROM orders), 0
        ),
        2
    ) AS coupon_usage_percentage;


#9. Compare order values with and without coupons
# Concept: CASE Statement, SUM(), COUNT(), AVG() and GROUP BY Clause

# Explanation: The CASE statement categorizes orders into two groups: orders with coupons and orders without coupons. The coupon_usage table is connected to the orders table using order_id.

#The COUNT() function calculates the number of orders in each group, while the AVG() function calculates the average order value. This comparison helps understand whether coupon users spend more or less than customers who do not use coupons.
SELECT 
    CASE 
        WHEN cu.order_id IS NOT NULL THEN 'With Coupon'
        ELSE 'Without Coupon'
    END AS coupon_category,
    COUNT(o.order_id) AS total_orders,
    ROUND(AVG(o.total_amount), 2) AS average_order_value
FROM orders o
LEFT JOIN coupon_usage cu
    ON o.order_id = cu.order_id
GROUP BY coupon_category;