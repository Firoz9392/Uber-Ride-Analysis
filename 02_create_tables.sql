-- Run this script after connecting to uber_ride_analysis.

DROP TABLE IF EXISTS payments, ratings, rides, vehicles, locations, drivers, customers CASCADE;

CREATE TABLE customers (
    customer_id BIGSERIAL PRIMARY KEY,
    full_name VARCHAR(120) NOT NULL,
    phone VARCHAR(30) UNIQUE,
    email VARCHAR(160) UNIQUE,
    signup_date DATE NOT NULL DEFAULT CURRENT_DATE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE drivers (
    driver_id BIGSERIAL PRIMARY KEY,
    full_name VARCHAR(120) NOT NULL,
    phone VARCHAR(30) UNIQUE,
    license_number VARCHAR(60) NOT NULL UNIQUE,
    driver_rating NUMERIC(3, 2) CHECK (driver_rating BETWEEN 0 AND 5),
    joined_date DATE NOT NULL DEFAULT CURRENT_DATE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    availability_status VARCHAR(20) NOT NULL DEFAULT 'Offline'
        CHECK (availability_status IN ('Available', 'On Trip', 'Offline')),
    availability_updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE vehicles (
    vehicle_id BIGSERIAL PRIMARY KEY,
    driver_id BIGINT NOT NULL REFERENCES drivers(driver_id),
    vehicle_type VARCHAR(30) NOT NULL CHECK (vehicle_type IN ('Sedan', 'SUV', 'Hatchback', 'Auto', 'Bike')),
    make_model VARCHAR(100) NOT NULL,
    registration_number VARCHAR(30) NOT NULL UNIQUE,
    manufacture_year INT CHECK (manufacture_year BETWEEN 1980 AND EXTRACT(YEAR FROM CURRENT_DATE)::INT),
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE locations (
    location_id BIGSERIAL PRIMARY KEY,
    location_name VARCHAR(160) NOT NULL UNIQUE,
    zone_name VARCHAR(100) NOT NULL,
    latitude NUMERIC(9, 6),
    longitude NUMERIC(9, 6),
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE rides (
    ride_id BIGSERIAL PRIMARY KEY,
    customer_id BIGINT NOT NULL REFERENCES customers(customer_id),
    driver_id BIGINT REFERENCES drivers(driver_id),
    vehicle_id BIGINT REFERENCES vehicles(vehicle_id),
    pickup_location_id BIGINT REFERENCES locations(location_id),
    dropoff_location_id BIGINT REFERENCES locations(location_id),
    booking_time TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    pickup_time TIMESTAMPTZ,
    dropoff_time TIMESTAMPTZ,
    pickup_location VARCHAR(160) NOT NULL,
    dropoff_location VARCHAR(160) NOT NULL,
    ride_status VARCHAR(20) NOT NULL CHECK (ride_status IN ('Completed', 'Cancelled', 'In Progress', 'Requested')),
    cancellation_reason VARCHAR(200),
    distance_km NUMERIC(8, 2) CHECK (distance_km >= 0),
    fare_amount NUMERIC(10, 2) CHECK (fare_amount >= 0),
    customer_rating NUMERIC(3, 2) CHECK (customer_rating BETWEEN 0 AND 5),
    driver_rating NUMERIC(3, 2) CHECK (driver_rating BETWEEN 0 AND 5),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CHECK (dropoff_time IS NULL OR pickup_time IS NULL OR dropoff_time >= pickup_time)
);

CREATE TABLE ratings (
    rating_id BIGSERIAL PRIMARY KEY,
    ride_id BIGINT NOT NULL REFERENCES rides(ride_id),
    customer_id BIGINT NOT NULL REFERENCES customers(customer_id),
    driver_id BIGINT NOT NULL REFERENCES drivers(driver_id),
    rated_by VARCHAR(20) NOT NULL CHECK (rated_by IN ('Customer', 'Driver')),
    rating_value NUMERIC(3, 2) NOT NULL CHECK (rating_value BETWEEN 0 AND 5),
    review_text VARCHAR(500),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (ride_id, rated_by)
);

CREATE TABLE payments (
    payment_id BIGSERIAL PRIMARY KEY,
    ride_id BIGINT NOT NULL UNIQUE REFERENCES rides(ride_id),
    payment_method VARCHAR(20) NOT NULL CHECK (payment_method IN ('Cash', 'Card', 'Wallet', 'UPI')),
    payment_status VARCHAR(20) NOT NULL CHECK (payment_status IN ('Pending', 'Paid', 'Refunded', 'Failed')),
    transaction_reference VARCHAR(100) UNIQUE,
    paid_at TIMESTAMPTZ,
    amount NUMERIC(10, 2) NOT NULL CHECK (amount >= 0)
);
