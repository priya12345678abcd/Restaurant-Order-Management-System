#BASIC LEVEL
#1. Display all reviews
# Concept: SELECT Statement
# Explanation: The SELECT statement retrieves all records from the reviews table. It displays review details such as review ID, order ID, customer ID, restaurant ID, rating, review text, and review date.
SELECT * FROM reviews;


#2. Find 5-star reviews
# Concept: WHERE Clause
# Explanation: The WHERE clause filters records based on a specified condition. Here, it displays only reviews where the rating is equal to 5, helping identify customers who gave the highest rating.
SELECT *
FROM reviews
WHERE rating = 5;


#3. Find low-rated restaurants
# Concept: JOIN and WHERE Clause
# Explanation: The JOIN operation connects the restaurants and reviews tables using restaurant_id. The WHERE clause filters reviews with a rating of 2 or below. This helps identify restaurants receiving poor customer feedback.
SELECT 
    r.restaurant_id,
    r.restaurant_name,
    rv.rating,
    rv.review_text
FROM restaurants r
JOIN reviews rv
    ON r.restaurant_id = rv.restaurant_id
WHERE rv.rating <= 2;


#4. Display reviews by customer
# Concept: JOIN and ORDER BY Clause
# Explanation: The JOIN operation connects the customers and reviews tables using customer_id. It displays customer names along with their review details. The ORDER BY clause sorts the reviews by customer ID.
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    rv.rating,
    rv.review_text,
    rv.review_date
FROM customers c
JOIN reviews rv
    ON c.customer_id = rv.customer_id
ORDER BY c.customer_id;


#INTERMEDIATE LEVEL
#5. Calculate average restaurant ratings from reviews
# Concept: AVG() Aggregate Function and GROUP BY Clause
# Explanation: The AVG() function calculates the average rating given to each restaurant. The GROUP BY clause groups reviews based on restaurant ID. This helps understand the overall customer satisfaction level of each restaurant.
SELECT 
    r.restaurant_id,
    r.restaurant_name,
    ROUND(AVG(rv.rating), 2) AS average_rating
FROM restaurants r
JOIN reviews rv
    ON r.restaurant_id = rv.restaurant_id
GROUP BY r.restaurant_id, r.restaurant_name;


#6. Count reviews per restaurant
# Concept: COUNT() Aggregate Function and GROUP BY Clause
# Explanation: The COUNT() function calculates the total number of reviews received by each restaurant. The LEFT JOIN ensures that restaurants without any reviews are also displayed with a review count of zero.
SELECT 
    r.restaurant_id,
    r.restaurant_name,
    COUNT(rv.review_id) AS total_reviews
FROM restaurants r
LEFT JOIN reviews rv
    ON r.restaurant_id = rv.restaurant_id
GROUP BY r.restaurant_id, r.restaurant_name;


#7. Find restaurants with more than 3 reviews
# Concept: GROUP BY and HAVING Clause
# Explanation: The GROUP BY clause groups reviews by restaurant. The COUNT() function counts the reviews for each restaurant. The HAVING clause filters grouped results and displays only restaurants that have received more than 3 reviews.
SELECT 
    r.restaurant_id,
    r.restaurant_name,
    COUNT(rv.review_id) AS total_reviews
FROM restaurants r
JOIN reviews rv
    ON r.restaurant_id = rv.restaurant_id
GROUP BY r.restaurant_id, r.restaurant_name
HAVING COUNT(rv.review_id) > 3;


#ADVANCE LEVEL
#8. Rank restaurants by average review rating
# Concept: RANK() Window Function and AVG() Aggregate Function
# Explanation: The AVG() function calculates the average customer rating for each restaurant. The RANK() window function assigns a ranking based on average ratings, with the highest-rated restaurant receiving rank 1. Restaurants with the same average rating receive the same rank.
SELECT 
    restaurant_id,
    restaurant_name,
    average_rating,
    RANK() OVER (
        ORDER BY average_rating DESC
    ) AS restaurant_rank
FROM (
    SELECT 
        r.restaurant_id,
        r.restaurant_name,
        AVG(rv.rating) AS average_rating
    FROM restaurants r
    JOIN reviews rv
        ON r.restaurant_id = rv.restaurant_id
    GROUP BY r.restaurant_id, r.restaurant_name
) AS restaurant_ratings;


#9. Find restaurants with the highest number of negative reviews
# Concept: CASE Statement, SUM() Aggregate Function and GROUP BY Clause
# Explanation: The CASE statement checks whether each review has a rating of 1 or 2. If the condition is true, it counts the review as a negative review; otherwise, it counts zero. The SUM() function calculates the total negative reviews for each restaurant. The results are sorted in descending order to display restaurants with the most negative reviews first.
SELECT 
    r.restaurant_id,
    r.restaurant_name,
    SUM(
        CASE 
            WHEN rv.rating <= 2 THEN 1
            ELSE 0
        END
    ) AS negative_reviews
FROM restaurants r
LEFT JOIN reviews rv
    ON r.restaurant_id = rv.restaurant_id
GROUP BY r.restaurant_id, r.restaurant_name
ORDER BY negative_reviews DESC;


#10. Compare restaurant ratings with order volume
# Concept: Multiple JOINs, AVG(), COUNT() and GROUP BY Clause
# Explanation: This query connects the restaurants, reviews, and orders tables to compare customer ratings with order volume. It calculates the average review rating and the total number of orders for each restaurant.
#To avoid counting orders multiple times when a restaurant has multiple reviews, the query calculates ratings and order counts separately using subqueries and then joins their results.
SELECT 
    r.restaurant_id,
    r.restaurant_name,
    COALESCE(rv.average_rating, 0) AS average_rating,
    COALESCE(ord.total_orders, 0) AS total_orders
FROM restaurants r
LEFT JOIN (
    SELECT 
        restaurant_id,
        AVG(rating) AS average_rating
    FROM reviews
    GROUP BY restaurant_id
) rv
    ON r.restaurant_id = rv.restaurant_id
LEFT JOIN (
    SELECT 
        restaurant_id,
        COUNT(order_id) AS total_orders
    FROM orders
    GROUP BY restaurant_id
) ord
    ON r.restaurant_id = ord.restaurant_id
ORDER BY total_orders DESC;