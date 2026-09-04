# 🚕 Uber/Ride Analysis

A PostgreSQL project for analyzing ride bookings, customers, drivers, vehicles, payments, and ride performance.

## Project Structure

```text
database/
├── 01_create_database.sql
├── 02_create_tables.sql
├── 03_insert_data.sql
├── 04_queries.sql
├── 05_views.sql
├── 06_procedures.sql
├── 07_functions.sql
├── 08_triggers.sql
└── 09_indexes.sql

documentation/
├── requirements.md
├── database-design.md
└── er-diagram.md

dashboard/
├── index.html
└── styles.css
```

## Requirements

- PostgreSQL 14 or newer
- A PostgreSQL client such as `psql`, pgAdmin, or DBeaver

## Setup

Run the scripts in numerical order from a PostgreSQL client:

```text
01_create_database.sql
02_create_tables.sql
03_insert_data.sql
04_queries.sql
05_views.sql
06_procedures.sql
07_functions.sql
08_triggers.sql
09_indexes.sql
```

The first script creates the `uber_ride_analysis` database. Connect to that database before running scripts `02` through `09`.

Using `psql`:

```bash
psql -U postgres -f database/01_create_database.sql
psql -U postgres -d uber_ride_analysis -f database/02_create_tables.sql
psql -U postgres -d uber_ride_analysis -f database/03_insert_data.sql
psql -U postgres -d uber_ride_analysis -f database/05_views.sql
psql -U postgres -d uber_ride_analysis -f database/06_procedures.sql
psql -U postgres -d uber_ride_analysis -f database/07_functions.sql
psql -U postgres -d uber_ride_analysis -f database/08_triggers.sql
psql -U postgres -d uber_ride_analysis -f database/09_indexes.sql
psql -U postgres -d uber_ride_analysis -f database/04_queries.sql
```

`04_queries.sql` contains read-only analysis examples and can be run whenever the schema, data, views, routines, and indexes are available.

## Analysis Areas

- Booking volume and booking status
- Revenue and payment methods
- Driver and vehicle performance
- Customer activity and repeat usage
- Cancellation patterns
- Pickup and drop-off demand
- Rating and ride-duration trends
- Current driver availability
- KPI, retention, cancellation, route, and time-series reporting

## Dashboard

Open [dashboard/index.html](dashboard/index.html) directly in a browser to view a lightweight project dashboard based on the starter dataset. It requires no build step or external dependencies.

See [documentation/requirements.md](documentation/requirements.md) for the full project scope.
