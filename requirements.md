# Requirements

## Project Title

🚕 Uber/Ride Analysis

## Objective

Build a PostgreSQL database that stores ride operations and supports business analysis for customers, drivers, vehicles, payments, cancellations, distance, fares, and ratings.

## Core Entities

- Customers who request rides
- Drivers who fulfill rides
- Vehicles assigned to drivers
- Rides connecting customers, drivers, and vehicles
- Payments associated with completed or chargeable rides
- Locations used as pickup and drop-off points
- Ratings submitted by customers and drivers

## Functional Requirements

1. Store unique customer, driver, vehicle, ride, and payment records.
2. Track ride status from request through completion or cancellation.
3. Record pickup and drop-off locations and timestamps.
4. Record distance, fare, and customer and driver ratings.
5. Support revenue, booking-volume, cancellation, rating, and location analysis.
6. Provide reusable views for completed rides and driver performance.
7. Provide a procedure for cancelling eligible rides.
8. Provide functions for fare calculation and customer spending.
9. Automatically calculate a missing fare when a ride is marked completed.
10. Add indexes for common joins, filters, and time-based analysis.
11. Report total rides, revenue, average fare, and cancellation rate.
12. Report top drivers, top pickup locations, peak booking hours, and daily/monthly revenue.
13. Report customer spending, driver performance, profitable routes, cancellation reasons, and retention.

## Non-Functional Requirements

- Use relational constraints to protect data quality.
- Keep scripts numbered by dependency order.
- Use PostgreSQL-compatible SQL.
- Keep analysis queries read-only.
- Make the sample data small enough for local development and demonstrations.
