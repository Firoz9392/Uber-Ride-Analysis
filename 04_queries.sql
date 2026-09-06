-- Read-only analysis queries.

-- 1. Overall ride status summary.
SELECT ride_status, COUNT(*) AS ride_count
FROM rides
GROUP BY ride_status
ORDER BY ride_count DESC;

-- 2. Revenue and completed rides by driver.
SELECT d.driver_id, d.full_name,
       COUNT(r.ride_id) FILTER (WHERE r.ride_status = 'Completed') AS completed_rides,
       COALESCE(SUM(r.fare_amount) FILTER (WHERE r.ride_status = 'Completed'), 0) AS total_revenue,
       ROUND(AVG(r.customer_rating) FILTER (WHERE r.ride_status = 'Completed'), 2) AS average_customer_rating
FROM drivers d
LEFT JOIN rides r ON r.driver_id = d.driver_id
GROUP BY d.driver_id, d.full_name
ORDER BY total_revenue DESC;

-- 3. Most-used pickup locations.
SELECT pickup_location, COUNT(*) AS booking_count
FROM rides
GROUP BY pickup_location
ORDER BY booking_count DESC, pickup_location;

-- 4. Customer booking and spending summary.
SELECT c.customer_id, c.full_name,
       COUNT(r.ride_id) AS total_bookings,
       COUNT(r.ride_id) FILTER (WHERE r.ride_status = 'Completed') AS completed_rides,
       COALESCE(SUM(r.fare_amount) FILTER (WHERE r.ride_status = 'Completed'), 0) AS total_spend
FROM customers c
LEFT JOIN rides r ON r.customer_id = c.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY total_spend DESC;

-- 5. Cancellation rate.
SELECT ROUND(100.0 * COUNT(*) FILTER (WHERE ride_status = 'Cancelled') / NULLIF(COUNT(*), 0), 2) AS cancellation_rate_percent
FROM rides;

-- 6. Current driver availability.
SELECT availability_status, COUNT(*) AS driver_count
FROM drivers
WHERE is_active = TRUE
GROUP BY availability_status
ORDER BY availability_status;

-- 7. Drivers currently available for a new ride.
SELECT driver_id, full_name, driver_rating, availability_updated_at
FROM drivers
WHERE is_active = TRUE
    AND availability_status = 'Available'
ORDER BY driver_rating DESC, full_name;

-- 8. Core KPIs.
SELECT COUNT(*) AS total_rides,
             COALESCE(SUM(fare_amount) FILTER (WHERE ride_status = 'Completed'), 0) AS total_revenue,
             ROUND(AVG(fare_amount) FILTER (WHERE ride_status = 'Completed'), 2) AS average_fare,
             ROUND(100.0 * COUNT(*) FILTER (WHERE ride_status = 'Cancelled') / NULLIF(COUNT(*), 0), 2) AS cancellation_rate_percent
FROM rides;

-- 9. Top drivers by completed rides and revenue.
SELECT d.driver_id, d.full_name,
             COUNT(r.ride_id) AS completed_rides,
             SUM(r.fare_amount) AS revenue,
             ROUND(AVG(r.customer_rating), 2) AS average_rating
FROM drivers d
JOIN rides r ON r.driver_id = d.driver_id
WHERE r.ride_status = 'Completed'
GROUP BY d.driver_id, d.full_name
ORDER BY completed_rides DESC, revenue DESC
LIMIT 10;

-- 10. Peak booking hours.
SELECT EXTRACT(HOUR FROM booking_time)::INT AS booking_hour,
             COUNT(*) AS booking_count
FROM rides
GROUP BY booking_hour
ORDER BY booking_count DESC, booking_hour;

-- 11. Daily revenue.
SELECT booking_time::DATE AS ride_date,
             COUNT(*) FILTER (WHERE ride_status = 'Completed') AS completed_rides,
             COALESCE(SUM(fare_amount) FILTER (WHERE ride_status = 'Completed'), 0) AS revenue
FROM rides
GROUP BY ride_date
ORDER BY ride_date;

-- 12. Monthly revenue.
SELECT DATE_TRUNC('month', booking_time)::DATE AS month,
             COUNT(*) FILTER (WHERE ride_status = 'Completed') AS completed_rides,
             COALESCE(SUM(fare_amount) FILTER (WHERE ride_status = 'Completed'), 0) AS revenue
FROM rides
GROUP BY month
ORDER BY month;

-- 13. Most profitable routes.
SELECT pickup_location, dropoff_location,
             COUNT(*) FILTER (WHERE ride_status = 'Completed') AS completed_rides,
             SUM(fare_amount) FILTER (WHERE ride_status = 'Completed') AS route_revenue,
             ROUND(AVG(fare_amount) FILTER (WHERE ride_status = 'Completed'), 2) AS average_fare
FROM rides
GROUP BY pickup_location, dropoff_location
HAVING COUNT(*) FILTER (WHERE ride_status = 'Completed') > 0
ORDER BY route_revenue DESC;

-- 14. Cancellation analysis by reason and route.
SELECT COALESCE(cancellation_reason, 'Not specified') AS cancellation_reason,
             pickup_location,
             dropoff_location,
             COUNT(*) AS cancelled_rides
FROM rides
WHERE ride_status = 'Cancelled'
GROUP BY cancellation_reason, pickup_location, dropoff_location
ORDER BY cancelled_rides DESC;

-- 15. Rating analysis from the normalized ratings table.
SELECT rated_by,
             ROUND(AVG(rating_value), 2) AS average_rating,
             COUNT(*) AS rating_count
FROM ratings
GROUP BY rated_by
ORDER BY rated_by;

-- 16. Customer retention by signup cohort and booking month.
WITH customer_cohorts AS (
        SELECT customer_id,
                     DATE_TRUNC('month', MIN(booking_time))::DATE AS cohort_month
        FROM rides
        GROUP BY customer_id
), activity AS (
        SELECT DISTINCT customer_id, DATE_TRUNC('month', booking_time)::DATE AS activity_month
        FROM rides
)
SELECT c.cohort_month,
             a.activity_month,
             COUNT(DISTINCT a.customer_id) AS active_customers,
             COUNT(DISTINCT a.customer_id)::NUMERIC
                     / NULLIF(COUNT(DISTINCT CASE WHEN a.activity_month = c.cohort_month THEN a.customer_id END), 0) AS retention_ratio
FROM customer_cohorts c
JOIN activity a ON a.customer_id = c.customer_id
GROUP BY c.cohort_month, a.activity_month
ORDER BY c.cohort_month, a.activity_month;
