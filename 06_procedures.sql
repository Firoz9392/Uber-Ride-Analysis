CREATE OR REPLACE PROCEDURE cancel_ride(
    p_ride_id BIGINT,
    p_reason VARCHAR(200)
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE rides
    SET ride_status = 'Cancelled',
        cancellation_reason = p_reason,
        fare_amount = 0
    WHERE ride_id = p_ride_id
      AND ride_status IN ('Requested', 'In Progress');

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Ride % cannot be cancelled in its current state', p_ride_id;
    END IF;
END;
$$;

-- Example: CALL cancel_ride(5, 'Customer changed plans');
