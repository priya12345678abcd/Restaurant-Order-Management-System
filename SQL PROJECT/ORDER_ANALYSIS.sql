#Basic Level
#1. Display all orders
SELECT *
FROM orders;


# Concept: SELECT

# Explanation: Displays all order records, including order ID, customer ID, restaurant ID, order date, order status, subtotal, delivery fee, discount, tax, total amount, and delivery address.
#2. Find delivered orders
SELECT *
FROM orders
WHERE order_status = 'Delivered';


# Concept: SELECT, WHERE, Comparison Operator

# Explanation: Displays only successfully delivered orders by filtering the order_status column using the value 'Delivered'.
#3. Find cancelled orders
SELECT *
FROM orders
WHERE order_status = 'Cancelled';


# Concept: SELECT, WHERE

# Explanation: Identifies all orders that have been cancelled by customers or the restaurant.
#4. Find orders above ₹1,000
SELECT
    order_id,
    customer_id,
    restaurant_id,
    order_date,
    total_amount
FROM orders
WHERE total_amount > 1000
ORDER BY total_amount DESC;


# Concept: WHERE, Comparison Operator, ORDER BY

# Explanation: Displays orders with a total amount greater than ₹1,000 and sorts them from highest order value to lowest.

Intermediate Level
#5. Count orders by status
SELECT
    order_status,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;


# Concept: COUNT(), GROUP BY, ORDER BY

# Explanation: Counts the total number of orders under each status, such as Delivered, Cancelled, Preparing, and Out for Delivery.
#6. Calculate average order value
SELECT
    ROUND(AVG(total_amount), 2) AS average_order_value
FROM orders
WHERE order_status = 'Delivered';


# Concept: AVG(), ROUND(), WHERE

# Explanation: Calculates the average value of successfully delivered orders.

For example, if three delivered orders are ₹500, ₹700, and ₹800:

Average order value = ₹666.67.
#7. Find daily order counts
SELECT
    DATE(order_date) AS order_day,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY DATE(order_date)
ORDER BY order_day;


# Concept: DATE(), COUNT(), GROUP BY, ORDER BY

# Explanation: Calculates how many orders were placed on each day.

The DATE() function extracts only the date from the DATETIME column, removing the time portion.
#8. Find restaurant-wise order counts
SELECT
    r.restaurant_id,
    r.restaurant_name,
    COUNT(o.order_id) AS total_orders
FROM restaurants r
LEFT JOIN orders o
    ON r.restaurant_id = o.restaurant_id
GROUP BY
    r.restaurant_id,
    r.restaurant_name
ORDER BY total_orders DESC;


# Concept: LEFT JOIN, COUNT(), GROUP BY, ORDER BY

# Explanation: Calculates the total number of orders received by each restaurant.

LEFT JOIN also includes restaurants that have not received any orders.

Advanced Level
#9. Calculate monthly order growth
WITH monthly_orders AS (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS order_month,
        COUNT(order_id) AS total_orders
    FROM orders
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
)
SELECT
    order_month,
    total_orders,
    LAG(total_orders) OVER (
        ORDER BY order_month
    ) AS previous_month_orders,
    total_orders - LAG(total_orders) OVER (
        ORDER BY order_month
    ) AS order_growth,
    ROUND(
        (total_orders - LAG(total_orders) OVER (
            ORDER BY order_month
        )) * 100.0 /
        NULLIF(
            LAG(total_orders) OVER (
                ORDER BY order_month
            ), 0
        ),
        2
    ) AS growth_percentage
FROM monthly_orders
ORDER BY order_month;


# Concept: CTE, DATE_FORMAT(), COUNT(), LAG(), Window Function, NULLIF(), Percentage Calculation

# Explanation:
#- The CTE calculates the total number of orders placed in each month.
#- LAG() retrieves the previous month's order count.
#- Order growth calculates the difference between the current and previous month's orders.
#- Growth percentage calculates the percentage increase or decrease compared with the previous month.
#- NULLIF() prevents division by zero when the previous month's order count is zero.
#Example:
#Month	Orders	Previous month	Growth
#January	100	NULL	NULL
#February	120	100	20%
#March	150	120	25%

#10. Identify peak ordering hours
SELECT
    HOUR(order_date) AS order_hour,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY HOUR(order_date)
ORDER BY total_orders DESC;


# Concept: HOUR(), COUNT(), GROUP BY, ORDER BY

# Explanation: Identifies the hours during which customers place the most orders.

For example:
- 08:00 – Morning orders
- 13:00 – Afternoon orders
- 19:00 – Evening orders
- 21:00 – Night orders
The hour with the highest order count represents the peak ordering hour.
#11. Calculate order cancellation percentage
SELECT
    COUNT(order_id) AS total_orders,
    SUM(
        CASE
            WHEN order_status = 'Cancelled'
            THEN 1
            ELSE 0
        END
    ) AS cancelled_orders,
    ROUND(
        SUM(
            CASE
                WHEN order_status = 'Cancelled'
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(order_id),
        2
    ) AS cancellation_percentage
FROM orders;


# Concept: COUNT(), SUM(), CASE, ROUND(), Percentage Calculation

# Explanation:
- COUNT() calculates the total number of orders.
- CASE identifies cancelled orders.
- SUM() counts the cancelled orders.
- The percentage calculation identifies what proportion of all orders were cancelled.
Example:

If there are 1,000 total orders and 100 cancelled orders:

Cancellation percentage = 10%.
#12. Compare delivered and cancelled orders by restaurant
SELECT
    r.restaurant_id,
    r.restaurant_name,
    SUM(
        CASE
            WHEN o.order_status = 'Delivered'
            THEN 1
            ELSE 0
        END
    ) AS delivered_orders,
    SUM(
        CASE
            WHEN o.order_status = 'Cancelled'
            THEN 1
            ELSE 0
        END
    ) AS cancelled_orders
FROM restaurants r
LEFT JOIN orders o
    ON r.restaurant_id = o.restaurant_id
GROUP BY
    r.restaurant_id,
    r.restaurant_name
ORDER BY delivered_orders DESC;


# Concept: LEFT JOIN, CASE, SUM(), GROUP BY, ORDER BY

# Explanation:
- LEFT JOIN connects restaurants with their orders.
- CASE identifies delivered and cancelled orders separately.
- SUM() counts each order category.
- GROUP BY groups the results restaurant-wise.
- The output helps compare restaurant performance based on successful and cancelled orders.