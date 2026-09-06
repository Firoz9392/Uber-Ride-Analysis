CREATE INDEX IF NOT EXISTS idx_rides_customer_id ON rides(customer_id);
CREATE INDEX IF NOT EXISTS idx_rides_driver_id ON rides(driver_id);
CREATE INDEX IF NOT EXISTS idx_rides_booking_time ON rides(booking_time);
CREATE INDEX IF NOT EXISTS idx_rides_status ON rides(ride_status);
CREATE INDEX IF NOT EXISTS idx_rides_pickup_location ON rides(pickup_location);
CREATE INDEX IF NOT EXISTS idx_rides_pickup_location_id ON rides(pickup_location_id);
CREATE INDEX IF NOT EXISTS idx_rides_dropoff_location_id ON rides(dropoff_location_id);
CREATE INDEX IF NOT EXISTS idx_payments_status ON payments(payment_status);
CREATE INDEX IF NOT EXISTS idx_drivers_availability ON drivers(availability_status)
WHERE is_active = TRUE;
CREATE INDEX IF NOT EXISTS idx_ratings_driver_id ON ratings(driver_id);
CREATE INDEX IF NOT EXISTS idx_ratings_customer_id ON ratings(customer_id);
