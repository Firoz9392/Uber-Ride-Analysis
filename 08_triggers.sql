CREATE OR REPLACE FUNCTION set_completed_ride_fare()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.ride_status = 'Completed' AND NEW.fare_amount IS NULL THEN
        NEW.fare_amount := calculate_fare(NEW.distance_km);
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_set_completed_ride_fare ON rides;
CREATE TRIGGER trg_set_completed_ride_fare
BEFORE INSERT OR UPDATE ON rides
FOR EACH ROW
EXECUTE FUNCTION set_completed_ride_fare();
