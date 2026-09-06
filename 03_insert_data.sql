-- Starter dataset for development and demonstrations.

INSERT INTO customers (full_name, phone, email, signup_date) VALUES
('Aisha Khan', '555-0101', 'aisha@example.com', '2025-01-12'),
('Daniel Lee', '555-0102', 'daniel@example.com', '2025-02-20'),
('Maria Garcia', '555-0103', 'maria@example.com', '2025-03-05'),
('Sam Wilson', '555-0104', 'sam@example.com', '2025-03-25');

INSERT INTO drivers (full_name, phone, license_number, driver_rating, joined_date) VALUES
('Jordan Smith', '555-0201', 'LIC-1001', 4.85, '2024-11-01'),
('Priya Patel', '555-0202', 'LIC-1002', 4.72, '2024-12-15'),
('Michael Brown', '555-0203', 'LIC-1003', 4.60, '2025-01-18');

UPDATE drivers
SET availability_status = CASE driver_id
    WHEN 1 THEN 'Available'
    WHEN 2 THEN 'On Trip'
    ELSE 'Offline'
END;

INSERT INTO vehicles (driver_id, vehicle_type, make_model, registration_number, manufacture_year) VALUES
(1, 'Sedan', 'Toyota Camry', 'UR-1001', 2022),
(2, 'SUV', 'Honda CR-V', 'UR-1002', 2023),
(3, 'Hatchback', 'Hyundai i20', 'UR-1003', 2021);

INSERT INTO locations (location_name, zone_name, latitude, longitude) VALUES
('Downtown', 'Central', 40.712800, -74.006000),
('Airport', 'East', 40.641300, -73.778100),
('Midtown', 'Central', 40.754900, -73.984000),
('Central Station', 'Central', 40.752700, -73.977200),
('University', 'West', 40.729500, -73.996500),
('Riverside', 'West', 40.800700, -73.970700);

INSERT INTO rides (customer_id, driver_id, vehicle_id, pickup_location_id, dropoff_location_id, booking_time, pickup_time, dropoff_time, pickup_location, dropoff_location, ride_status, distance_km, fare_amount, customer_rating, driver_rating) VALUES
(1, 1, 1, 1, 2, '2025-04-01 08:00+00', '2025-04-01 08:08+00', '2025-04-01 08:34+00', 'Downtown', 'Airport', 'Completed', 18.40, 32.50, 5.00, 4.80),
(2, 2, 2, 3, 4, '2025-04-01 09:20+00', '2025-04-01 09:28+00', '2025-04-01 09:52+00', 'Midtown', 'Central Station', 'Completed', 11.20, 21.75, 4.50, 5.00),
(1, 3, 3, 2, 1, '2025-04-02 18:10+00', NULL, NULL, 'Airport', 'Downtown', 'Cancelled', NULL, 0.00, NULL, NULL),
(3, 1, 1, 5, 6, '2025-04-03 12:15+00', '2025-04-03 12:21+00', '2025-04-03 12:44+00', 'University', 'Riverside', 'Completed', 9.80, 18.25, 4.00, 4.50),
(4, 2, 2, 6, 3, '2025-04-04 21:00+00', NULL, NULL, 'Riverside', 'Midtown', 'Cancelled', NULL, 0.00, NULL, NULL);

UPDATE rides
SET cancellation_reason = CASE ride_id
    WHEN 3 THEN 'Driver unavailable'
    WHEN 5 THEN 'Customer changed plans'
END
WHERE ride_status = 'Cancelled';

INSERT INTO payments (ride_id, payment_method, payment_status, transaction_reference, paid_at, amount) VALUES
(1, 'Card', 'Paid', 'TXN-10001', '2025-04-01 08:35+00', 32.50),
(2, 'UPI', 'Paid', 'TXN-10002', '2025-04-01 09:53+00', 21.75),
(4, 'Wallet', 'Paid', 'TXN-10003', '2025-04-03 12:45+00', 18.25);

INSERT INTO ratings (ride_id, customer_id, driver_id, rated_by, rating_value, review_text) VALUES
(1, 1, 1, 'Customer', 5.00, 'Smooth airport ride'),
(1, 1, 1, 'Driver', 4.80, 'Reliable passenger'),
(2, 2, 2, 'Customer', 4.50, 'Quick pickup'),
(2, 2, 2, 'Driver', 5.00, 'Good passenger'),
(4, 3, 1, 'Customer', 4.00, 'Comfortable ride'),
(4, 3, 1, 'Driver', 4.50, 'Easy pickup');
