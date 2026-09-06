CREATE OR REPLACE VIEW vw_completed_ride_summary AS
SELECT r.ride_id,
       r.booking_time::DATE AS ride_date,
       c.full_name AS customer_name,
       d.full_name AS driver_name,
       v.vehicle_type,
       r.pickup_location,
       r.dropoff_location,
       r.distance_km,
       r.fare_amount,
       r.customer_rating,
       EXTRACT(EPOCH FROM (r.dropoff_time - r.pickup_time)) / 60 AS ride_duration_minutes
FROM rides r
JOIN customers c ON c.customer_id = r.customer_id
JOIN drivers d ON d.driver_id = r.driver_id
JOIN vehicles v ON v.vehicle_id = r.vehicle_id
WHERE r.ride_status = 'Completed';

CREATE OR REPLACE VIEW vw_driver_performance AS
SELECT d.driver_id,
       d.full_name AS driver_name,
       COUNT(r.ride_id) FILTER (WHERE r.ride_status = 'Completed') AS completed_rides,
       COUNT(r.ride_id) FILTER (WHERE r.ride_status = 'Cancelled') AS cancelled_rides,
       COALESCE(SUM(r.fare_amount) FILTER (WHERE r.ride_status = 'Completed'), 0) AS total_revenue,
    ROUND(AVG(r.customer_rating) FILTER (WHERE r.ride_status = 'Completed'), 2) AS average_rating,
    d.availability_status
FROM drivers d
LEFT JOIN rides r ON r.driver_id = d.driver_id
GROUP BY d.driver_id, d.full_name, d.availability_status;

CREATE OR REPLACE VIEW vw_availability_summary AS
SELECT availability_status,
    COUNT(*) AS driver_count,
    ROUND(100.0 * COUNT(*) / NULLIF(SUM(COUNT(*)) OVER (), 0), 2) AS percentage_of_active_drivers
FROM drivers
WHERE is_active = TRUE
GROUP BY availability_status;

CREATE OR REPLACE VIEW vw_monthly_revenue AS
SELECT DATE_TRUNC('month', booking_time)::DATE AS revenue_month,
       COUNT(*) FILTER (WHERE ride_status = 'Completed') AS completed_rides,
       COALESCE(SUM(fare_amount) FILTER (WHERE ride_status = 'Completed'), 0) AS total_revenue,
       ROUND(AVG(fare_amount) FILTER (WHERE ride_status = 'Completed'), 2) AS average_fare
FROM rides
GROUP BY revenue_month;

CREATE OR REPLACE VIEW vw_profitable_routes AS
SELECT pickup_location,
       dropoff_location,
       COUNT(*) AS completed_rides,
       SUM(fare_amount) AS total_revenue,
       ROUND(AVG(fare_amount), 2) AS average_fare
FROM rides
WHERE ride_status = 'Completed'
GROUP BY pickup_location, dropoff_location;
