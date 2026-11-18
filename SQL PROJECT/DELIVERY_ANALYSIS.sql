#Basic Level
#1. Display all deliveries
SELECT *
FROM deliveries;


# Concept: SELECT

# Explanation: Displays all delivery records, including delivery ID, order ID, partner ID, assigned time, pickup time, delivered time, delivery status, delivery distance, and delivery time.
#2. Find delivered orders
SELECT
    delivery_id,
    order_id,
    partner_id,
    delivery_status,
    delivered_at,
    delivery_time_min
FROM deliveries
WHERE delivery_status = 'Delivered';


# Concept: SELECT, WHERE, Comparison Operator

# Explanation: Displays all successfully completed deliveries by filtering the delivery status as 'Delivered'.
#3. Find failed deliveries
SELECT
    delivery_id,
    order_id,
    partner_id,
    delivery_status,
    delivery_distance_km
FROM deliveries
WHERE delivery_status = 'Failed';


# Concept: SELECT, WHERE

# Explanation: Identifies deliveries that failed to reach customers successfully. This analysis helps understand delivery issues and operational problems.
#4. Display delivery partners
SELECT *
FROM delivery_partners;


# Concept: SELECT

# Explanation: Displays all delivery partner details, including partner ID, partner name, phone number, vehicle type, city, partner status, and joining date.

Intermediate Level
#5. Count deliveries per partner
SELECT
    dp.partner_id,
    dp.partner_name,
    COUNT(d.delivery_id) AS total_deliveries
FROM delivery_partners dp
LEFT JOIN deliveries d
    ON dp.partner_id = d.partner_id
GROUP BY
    dp.partner_id,
    dp.partner_name
ORDER BY total_deliveries DESC;


# Concept: LEFT JOIN, COUNT(), GROUP BY, ORDER BY

# Explanation:
- LEFT JOIN connects delivery partners with deliveries.
- COUNT() calculates the total deliveries assigned to each partner.
- GROUP BY groups the results partner-wise.
- ORDER BY displays partners with the highest delivery counts first.
- LEFT JOIN also includes partners who have not received any deliveries.
#6. Calculate average delivery time
SELECT
    ROUND(AVG(delivery_time_min), 2) AS average_delivery_time
FROM deliveries
WHERE delivery_status = 'Delivered'
AND delivery_time_min IS NOT NULL;


# Concept: AVG(), ROUND(), WHERE, IS NOT NULL

# Explanation:
- AVG() calculates the average delivery time.
- ROUND() rounds the result to two decimal places.
- Only successfully delivered orders are considered.
- IS NOT NULL excludes deliveries where the delivery time is missing.
#7. Find average delivery distance
SELECT
    ROUND(AVG(delivery_distance_km), 2) AS average_delivery_distance
FROM deliveries;


# Concept: AVG(), ROUND(), Aggregate Function

# Explanation: Calculates the average distance travelled across all delivery records in kilometres.
#8. Identify delivery partners with the most deliveries
SELECT
    dp.partner_id,
    dp.partner_name,
    COUNT(d.delivery_id) AS total_deliveries
FROM delivery_partners dp
JOIN deliveries d
    ON dp.partner_id = d.partner_id
GROUP BY
    dp.partner_id,
    dp.partner_name
ORDER BY total_deliveries DESC
LIMIT 10;


# Concept: JOIN, COUNT(), GROUP BY, ORDER BY, LIMIT

# Explanation:
- JOIN connects delivery partners and deliveries.
- COUNT() calculates the number of deliveries handled by each partner.
- ORDER BY sorts partners based on delivery count.
- LIMIT 10 displays the top 10 delivery partners with the most deliveries.

Advanced Level
#9. Rank delivery partners by completed deliveries
SELECT
    dp.partner_id,
    dp.partner_name,
    COUNT(d.delivery_id) AS completed_deliveries,
    RANK() OVER (
        ORDER BY COUNT(d.delivery_id) DESC
    ) AS delivery_rank
FROM delivery_partners dp
LEFT JOIN deliveries d
    ON dp.partner_id = d.partner_id
    AND d.delivery_status = 'Delivered'
GROUP BY
    dp.partner_id,
    dp.partner_name;


# Concept: LEFT JOIN, COUNT(), GROUP BY, RANK(), Window Function

# Explanation:
- LEFT JOIN connects delivery partners with their delivery records.
- The Delivered condition ensures only completed deliveries are counted.
- COUNT() calculates completed deliveries per partner.
- RANK() assigns rankings based on completed deliveries.
- The highest number of completed deliveries receives rank 1.
- Partners with no completed deliveries are also displayed with rank values.
#10. Find partners with the lowest average delivery time
SELECT
    dp.partner_id,
    dp.partner_name,
    ROUND(AVG(d.delivery_time_min), 2) AS average_delivery_time
FROM delivery_partners dp
JOIN deliveries d
    ON dp.partner_id = d.partner_id
WHERE d.delivery_status = 'Delivered'
AND d.delivery_time_min IS NOT NULL
GROUP BY
    dp.partner_id,
    dp.partner_name
ORDER BY average_delivery_time ASC
LIMIT 10;


# Concept: JOIN, AVG(), ROUND(), GROUP BY, ORDER BY, LIMIT

# Explanation:
- JOIN connects delivery partners with their deliveries.
- AVG() calculates the average delivery time for each partner.
- Only completed deliveries with recorded delivery times are considered.
- ASC sorts partners from lowest average delivery time to highest.
- LIMIT 10 displays the 10 fastest delivery partners by average delivery time.
#11. Analyse delivery performance by status
SELECT
    delivery_status,
    COUNT(delivery_id) AS total_deliveries,
    ROUND(AVG(delivery_time_min), 2) AS average_delivery_time,
    ROUND(AVG(delivery_distance_km), 2) AS average_distance
FROM deliveries
GROUP BY delivery_status
ORDER BY total_deliveries DESC;


# Concept: COUNT(), AVG(), ROUND(), GROUP BY, ORDER BY

# Explanation:
- GROUP BY separates deliveries based on their status.
- COUNT() calculates the total deliveries under each status.
- AVG() calculates the average delivery time and distance for each status.
- This analysis helps understand delivery performance across Delivered, Failed, Assigned, and Out for Delivery categories.
#12. Compare delivery time across distance ranges
SELECT
    CASE
        WHEN delivery_distance_km <= 3
            THEN 'Short Distance'
        WHEN delivery_distance_km <= 7
            THEN 'Medium Distance'
        ELSE 'Long Distance'
    END AS distance_category,
    COUNT(delivery_id) AS total_deliveries,
    ROUND(AVG(delivery_time_min), 2) AS average_delivery_time
FROM deliveries
WHERE delivery_status = 'Delivered'
AND delivery_time_min IS NOT NULL
GROUP BY
    CASE
        WHEN delivery_distance_km <= 3
            THEN 'Short Distance'
        WHEN delivery_distance_km <= 7
            THEN 'Medium Distance'
        ELSE 'Long Distance'
    END
ORDER BY average_delivery_time ASC;


# Concept: CASE, COUNT(), AVG(), ROUND(), GROUP BY, ORDER BY

# Explanation:
- CASE divides deliveries into three distance categories.
- Short Distance: 3 km or less.
- Medium Distance: Above 3 km and up to 7 km.
- Long Distance: Above 7 km.
- COUNT() calculates the number of deliveries in each category.
- AVG() calculates the average delivery time for each distance category.
- This helps identify how delivery distance affects delivery time.