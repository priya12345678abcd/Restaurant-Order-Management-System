#1. List all restaurants
SELECT *
FROM restaurants;



#2. Restaurants by city
SELECT *
FROM restaurants
ORDER BY city;



#3. Restaurants by cuisine
SELECT *
FROM restaurants
ORDER BY cuisine;



#4. Restaurants with ratings above 4
SELECT restaurant_id, restaurant_name, cuisine, rating
FROM restaurants
WHERE rating > 4;




Intermediate Level
#5. Count orders per restaurant
SELECT 
    r.restaurant_id,
    r.restaurant_name,
    COUNT(o.order_id) AS total_orders
FROM restaurants r
LEFT JOIN orders o
    ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_id, r.restaurant_name;



SELECT 
    r.restaurant_id,
    r.restaurant_name,
    SUM(o.total_amount) AS total_revenue
FROM restaurants r
JOIN orders o
    ON r.restaurant_id = o.restaurant_id
WHERE o.order_status = 'Delivered'
GROUP BY r.restaurant_id, r.restaurant_name
ORDER BY total_revenue DESC;


#7. Calculate average order value per restaurant
SELECT 
    r.restaurant_id,
    r.restaurant_name,
    ROUND(AVG(o.total_amount), 2) AS average_order_value
FROM restaurants r
JOIN orders o
    ON r.restaurant_id = o.restaurant_id
WHERE o.order_status = 'Delivered'
GROUP BY r.restaurant_id, r.restaurant_name;



#8. Find restaurants with more than 50 orders
SELECT 
    r.restaurant_id,
    r.restaurant_name,
    COUNT(o.order_id) AS total_orders
FROM restaurants r
JOIN orders o
    ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_id, r.restaurant_name
HAVING COUNT(o.order_id) > 50;



#9. Rank restaurants by revenue
SELECT 
    r.restaurant_id,
    r.restaurant_name,
    SUM(o.total_amount) AS total_revenue,
    RANK() OVER (
        ORDER BY SUM(o.total_amount) DESC
    ) AS revenue_rank
FROM restaurants r
JOIN orders o
    ON r.restaurant_id = o.restaurant_id
WHERE o.order_status = 'Delivered'
GROUP BY r.restaurant_id, r.restaurant_name;


#10. Find the highest revenue-generating restaurant
SELECT 
    r.restaurant_id,
    r.restaurant_name,
    SUM(o.total_amount) AS total_revenue
FROM restaurants r
JOIN orders o
    ON r.restaurant_id = o.restaurant_id
WHERE o.order_status = 'Delivered'
GROUP BY r.restaurant_id, r.restaurant_name
ORDER BY total_revenue DESC
LIMIT 1;


#11. Find restaurants with high ratings but low orders
SELECT 
    r.restaurant_id,
    r.restaurant_name,
    r.rating,
    COUNT(o.order_id) AS total_orders
FROM restaurants r
LEFT JOIN orders o
    ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_id, r.restaurant_name, r.rating
HAVING r.rating >= 4
   AND COUNT(o.order_id) < 50;


#12. Calculate restaurant revenue contribution percentage
SELECT 
    r.restaurant_id,
    r.restaurant_name,
    SUM(o.total_amount) AS restaurant_revenue,
    ROUND(
        SUM(o.total_amount) * 100.0 /
        (SELECT SUM(total_amount)
         FROM orders
         WHERE order_status = 'Delivered'),
        2
    ) AS revenue_percentage
FROM restaurants r
JOIN orders o
    ON r.restaurant_id = o.restaurant_id
WHERE o.order_status = 'Delivered'
GROUP BY r.restaurant_id, r.restaurant_name
ORDER BY revenue_percentage DESC;