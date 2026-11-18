#1. Display all food items
SELECT *
FROM menu_items;


# Concept: SELECT

# Explanation: Displays all food items along with their restaurant ID, category ID, item name, price, vegetarian status, preparation time, and availability status.

#2. Find vegetarian and non-vegetarian items
SELECT
    item_id,
    item_name,
    is_veg,
    price
FROM menu_items
WHERE is_veg = TRUE;


# Concept: WHERE, Boolean Data Type

# Explanation: Displays only vegetarian food items. The is_veg column stores Boolean values:
#- TRUE (1) – Vegetarian
#- FALSE (0) – Non-vegetarian
#To display non-vegetarian items:
SELECT
    item_id,
    item_name,
    is_veg,
    price
FROM menu_items
WHERE is_veg = FALSE;


#3. Find the most expensive food items
SELECT
    item_id,
    item_name,
    price
FROM menu_items
WHERE price = (
    SELECT MAX(price)
    FROM menu_items
);


# Concept: Subquery, MAX() Aggregate Function

# Explanation: The inner query finds the highest food price using MAX(). The outer query displays the food item or items having that highest price.

#4. Find food items below ₹200
SELECT
    item_id,
    item_name,
    price
FROM menu_items
WHERE price < 200
ORDER BY price ASC;


# Concept: WHERE, Comparison Operator, ORDER BY

# Explanation: Displays food items priced below ₹200 and sorts them from lowest price to highest price.

Intermediate Level
#5. Count food items by category
SELECT
    c.category_id,
    c.category_name,
    COUNT(m.item_id) AS total_items
FROM categories c
LEFT JOIN menu_items m
    ON c.category_id = m.category_id
GROUP BY c.category_id, c.category_name;


# Concept: LEFT JOIN, COUNT(), GROUP BY

# Explanation: Counts the number of food items available in each category. LEFT JOIN also displays categories that do not have any food items.
#6. Calculate average price by category
SELECT
    c.category_name,
    ROUND(AVG(m.price), 2) AS average_price
FROM categories c
JOIN menu_items m
    ON c.category_id = m.category_id
GROUP BY c.category_id, c.category_name
ORDER BY average_price DESC;


# Concept: JOIN, AVG(), ROUND(), GROUP BY, ORDER BY

# Explanation: Calculates the average price of food items in each category and displays the categories from highest average price to lowest.
#7. Find the most ordered food items
SELECT
    m.item_id,
    m.item_name,
    SUM(oi.quantity) AS total_quantity_ordered
FROM menu_items m
JOIN order_items oi
    ON m.item_id = oi.item_id
GROUP BY m.item_id, m.item_name
ORDER BY total_quantity_ordered DESC;


# Concept: JOIN, SUM(), GROUP BY, ORDER BY

# Explanation: Calculates how many units of each food item have been ordered. The most ordered food items appear first.
#8. Calculate food item sales quantity
SELECT
    m.item_id,
    m.item_name,
    SUM(oi.quantity) AS total_sales_quantity
FROM menu_items m
JOIN order_items oi
    ON m.item_id = oi.item_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY m.item_id, m.item_name
ORDER BY total_sales_quantity DESC;


# Concept: Multiple JOINs, SUM(), GROUP BY, WHERE

# Explanation: Calculates the total quantity of each food item sold through successfully delivered orders. Cancelled and other undelivered orders are excluded.

Advanced Level
#9. Find the top 5 best-selling food items
SELECT
    m.item_id,
    m.item_name,
    SUM(oi.quantity) AS total_quantity_sold
FROM menu_items m
JOIN order_items oi
    ON m.item_id = oi.item_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY m.item_id, m.item_name
ORDER BY total_quantity_sold DESC
LIMIT 5;


# Concept: JOIN, SUM(), GROUP BY, ORDER BY, LIMIT

# Explanation: Identifies the top five food items with the highest sales quantity based on delivered orders.
#10. Find the least-selling food items
SELECT
    m.item_id,
    m.item_name,
    COALESCE(SUM(
        CASE
            WHEN o.order_status = 'Delivered'
            THEN oi.quantity
            ELSE 0
        END
    ), 0) AS total_quantity_sold
FROM menu_items m
LEFT JOIN order_items oi
    ON m.item_id = oi.item_id
LEFT JOIN orders o
    ON oi.order_id = o.order_id
GROUP BY m.item_id, m.item_name
ORDER BY total_quantity_sold ASC;


# Concept: LEFT JOIN, CASE, SUM(), COALESCE(), GROUP BY, ORDER BY

# Explanation: Identifies food items with the lowest sales quantity. It also includes food items that have never been sold, displaying their sales quantity as zero.
#11. Rank food items within each restaurant
SELECT
    restaurant_id,
    item_id,
    item_name,
    total_quantity_sold,
    RANK() OVER (
        PARTITION BY restaurant_id
        ORDER BY total_quantity_sold DESC
    ) AS item_rank
FROM (
    SELECT
        m.restaurant_id,
        m.item_id,
        m.item_name,
        COALESCE(SUM(
            CASE
                WHEN o.order_status = 'Delivered'
                THEN oi.quantity
                ELSE 0
            END
        ), 0) AS total_quantity_sold
    FROM menu_items m
    LEFT JOIN order_items oi
        ON m.item_id = oi.item_id
    LEFT JOIN orders o
        ON oi.order_id = o.order_id
    GROUP BY m.restaurant_id, m.item_id, m.item_name
) AS food_sales;


# Concept: Subquery, LEFT JOIN, CASE, SUM(), COALESCE(), GROUP BY, RANK(), PARTITION BY

# Explanation:
- The inner query calculates the total sales quantity of each food item.
- The outer query uses RANK() to assign ranks.
- PARTITION BY restaurant_id restarts the ranking for each restaurant.
- The highest-selling food item in each restaurant gets rank 1.
#12. Calculate each food item's percentage contribution to total sales
SELECT
    m.item_id,
    m.item_name,
    SUM(oi.quantity * oi.unit_price) AS item_revenue,
    ROUND(
        SUM(oi.quantity * oi.unit_price) * 100.0 /
        (
            SELECT SUM(oi2.quantity * oi2.unit_price)
            FROM order_items oi2
            JOIN orders o2
                ON oi2.order_id = o2.order_id
            WHERE o2.order_status = 'Delivered'
        ),
        2
    ) AS sales_contribution_percentage
FROM menu_items m
JOIN order_items oi
    ON m.item_id = oi.item_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY m.item_id, m.item_name
ORDER BY sales_contribution_percentage DESC;


# Concept: JOIN, SUM(), Subquery, GROUP BY, ROUND(), Percentage Calculation
# Explanation:
#- Calculates the revenue generated by each food item using quantity multiplied by unit price.
#- The subquery calculates the total food-item revenue across all delivered orders.
#- Calculates each item's percentage contribution to total food-item revenue.
#- Displays the highest revenue-contributing food items first.
 #Example:
#If total food-item revenue is ₹1,00,000 and Pizza generates ₹20,000:
#Sales contribution = 20%.

