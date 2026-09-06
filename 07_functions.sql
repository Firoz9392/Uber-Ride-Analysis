CREATE OR REPLACE FUNCTION calculate_fare(
    p_distance_km NUMERIC,
    p_base_fare NUMERIC DEFAULT 3.00,
    p_rate_per_km NUMERIC DEFAULT 1.50
)
RETURNS NUMERIC(10, 2)
LANGUAGE SQL
IMMUTABLE
AS $$
    SELECT ROUND(p_base_fare + (GREATEST(p_distance_km, 0) * p_rate_per_km), 2);
$$;

CREATE OR REPLACE FUNCTION get_customer_total_spend(p_customer_id BIGINT)
RETURNS NUMERIC(10, 2)
LANGUAGE SQL
STABLE
AS $$
    SELECT COALESCE(SUM(fare_amount), 0)::NUMERIC(10, 2)
    FROM rides
    WHERE customer_id = p_customer_id
      AND ride_status = 'Completed';
$$;
