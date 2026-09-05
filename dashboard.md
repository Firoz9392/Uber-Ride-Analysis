# Dashboard

The dashboard in `dashboard/index.html` is a dependency-free visual summary of the starter dataset. It shows:

- Booking, completion, revenue, and cancellation metrics
- Current driver availability
- Popular pickup zones
- Recent ride activity

It is intentionally static so it can be opened directly in a browser. To connect it to a live PostgreSQL database, add an API layer that returns data from `vw_driver_performance`, `vw_availability_summary`, and the ride analysis queries.
