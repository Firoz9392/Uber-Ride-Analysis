-- Run this script while connected to the default PostgreSQL database.
-- PostgreSQL does not allow CREATE DATABASE inside a transaction.

SELECT 'CREATE DATABASE uber_ride_analysis'
WHERE NOT EXISTS (
    SELECT FROM pg_database WHERE datname = 'uber_ride_analysis'
)\gexec
